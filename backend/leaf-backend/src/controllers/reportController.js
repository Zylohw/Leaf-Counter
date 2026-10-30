const pool = require('../config/db');
const PDFDocument = require('pdfkit');

const fs = require('fs/promises');
const path = require('path');
const crypto = require('crypto');

const REPORTES_DIR = path.join(__dirname, '../../private/reportes');
const FOTOS_DIR = path.join(__dirname, '../../private/fotos');

async function leerFoto(nombreFoto)
{
    if (!nombreFoto)
    {
        return null;
    }

    try
    {
        return await fs.readFile(path.join(FOTOS_DIR, path.basename(nombreFoto)));
    }
    catch (error)
    {
        console.error('No se encontró la fotografía de la lectura:', nombreFoto);

        return null;
    }
}

async function emitirReporte(req, res)
{
    const { id } = req.params;

    if (!/^[1-9]\d*$/.test(id))
    {
        return res.status(400).json(
            {
                mensaje: 'ID de reporte inválido'
            });
    }

    let archivoTemporal = null;

    try
    {
        const resultado = await pool.query(`SELECT r.id, r.titulo, r.descripcion, r.fecha, r.pdf,
                                                  c.sector, c.numero,
                                                  d.medida_tomada, d.contenido, d.foto, d.fecha AS fecha_lectura
                                            FROM reporte r, reciben rc, casa c, datos d
                                            WHERE rc.reporte_id = r.id
                                            AND c.id = rc.casa_id
                                            AND d.reporte_id = r.id
                                            AND d.estado = TRUE
                                            AND d.id = (   SELECT d2.id
                                                          FROM datos d2
                                                          WHERE d2.reporte_id = r.id
                                                          AND d2.estado = TRUE
                                                          ORDER BY d2.fecha DESC, d2.id DESC
                                                          LIMIT 1 )
                                            AND r.id = $1
                                            AND r.usuario_id = $2
                                            AND r.estado = TRUE`,
                                            [id, req.usuario.id] );

        if (resultado.rows.length === 0)
        {
            return res.status(404).json(
                {
                    mensaje: 'Reporte no encontrado o sin lectura registrada'
                });
        }

        const reporte = resultado.rows[0];

        if (reporte.pdf)
        {
            return res.status(409).json(
                {
                    mensaje: 'El reporte ya fue emitido'
                });
        }

        const foto = await leerFoto(reporte.foto);

        const documento = new PDFDocument(
            {
                size: 'A4',
                margin: 50
            });

        const partes = [];

        documento.on('data', parte =>
            {
                partes.push(parte);
            });

        const pdfGenerado = new Promise((resolve, reject) =>
            {
                documento.on('end', () =>
                    {
                        resolve(Buffer.concat(partes));
                    });

                documento.on('error', reject);
            });

        documento.fontSize(25).text('LEAF',
            {
                align: 'center'
            });

        documento.moveDown();

        documento.fontSize(18).text('Reporte de lectura de contador de agua',
            {
                align: 'center'
            });

        documento.moveDown(2);

        documento.fontSize(13);

        documento.text(`Reporte No.: ${reporte.id}`);

        documento.moveDown();

        documento.text(`Sector: ${reporte.sector}`);

        documento.moveDown();

        documento.text(`Vivienda: ${reporte.numero}`);

        documento.moveDown();

        documento.text(`Fecha de lectura: ${new Date(reporte.fecha_lectura).toLocaleString('es-GT',
            {
                timeZone: 'America/Guatemala'
            })}`);

        documento.moveDown();

        documento.fontSize(16).text('Medición registrada');

        documento.moveDown();

        documento.fontSize(20).text(`${reporte.medida_tomada} m³`);

        documento.moveDown(2);

        documento.fontSize(13).text('Observaciones:');

        documento.moveDown();

        documento.text(reporte.contenido || 'Sin observaciones adicionales');

        if (foto)
        {
            const altoFoto = 280;

            const anchoDisponible = documento.page.width - documento.page.margins.left - documento.page.margins.right;

            documento.moveDown(2);

            if (documento.y + altoFoto + 40 > documento.page.height - documento.page.margins.bottom)
            {
                documento.addPage();
            }

            documento.fontSize(13).text('Fotografía del contador:');

            documento.moveDown();

            try
            {
                documento.image(foto,
                    {
                        fit: [anchoDisponible, altoFoto],
                        align: 'center'
                    });
            }
            catch (error)
            {
                console.error('No se pudo insertar la fotografía en el PDF:', error);

                documento.text('La fotografía no pudo incluirse en el reporte.');
            }
        }

        documento.moveDown(3);

        documento.fontSize(10).text('Documento generado mediante Leaf.',
            {
                align: 'center'
            });

        documento.end();

        const pdfBuffer = await pdfGenerado;

        await fs.mkdir(REPORTES_DIR,
            {
                recursive: true
            });

        const nombreArchivo = `reporte-${reporte.id}.pdf`;

        const rutaArchivo = path.join(REPORTES_DIR, nombreArchivo);

        archivoTemporal = path.join(REPORTES_DIR, `${crypto.randomUUID()}.tmp`);

        await fs.writeFile(archivoTemporal, pdfBuffer);

        await fs.rename(archivoTemporal, rutaArchivo);

        archivoTemporal = null;

        const actualizado = await pool.query(`UPDATE reporte
                                              SET pdf = $1
                                              WHERE id = $2
                                              AND usuario_id = $3
                                              AND estado = TRUE
                                              AND pdf IS NULL
                                              RETURNING id, titulo, pdf, fecha`,
                                              [nombreArchivo, reporte.id, req.usuario.id] );

        if (actualizado.rows.length === 0)
        {
            return res.status(409).json(
                {
                    mensaje: 'El reporte ya fue emitido o cambió de estado'
                });
        }

        return res.json(
            {
                mensaje: 'Reporte PDF generado correctamente',
                reporte: actualizado.rows[0]
            });
    }
    catch (error)
    {
        console.error('Error en emitirReporte:', error);

        return res.status(500).json(
            {
                mensaje: 'Error al generar el reporte PDF'
            });
    }
    finally
    {
        if (archivoTemporal)
        {
            await fs.rm(archivoTemporal,
                {
                    force: true
                }).catch(() => {});
        }
    }
}

module.exports = { emitirReporte };