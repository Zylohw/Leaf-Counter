const pool = require('../config/db');
const PDFDocument = require('pdfkit');

const fs = require('fs/promises');
const path = require('path');
const crypto = require('crypto');

const REPORTES_DIR = path.join(__dirname, '../../private/reportes');

async function emitirReporte(req, res)
{
    const { id } = req.params;

    if (!/^[1-9]\d*$/.test(id))
    {
        return res.status(400).json({
            mensaje: 'ID de reporte inválido'
        });
    }

    let archivoTemporal = null;

    try
    {
        const resultado = await pool.query(
            `SELECT
                r.id,
                r.titulo,
                r.descripcion,
                r.fecha,
                r.pdf,

                c.sector,
                c.numero,

                d.medida_tomada,
                d.contenido,
                d.fecha AS fecha_lectura

             FROM reporte r

             INNER JOIN reciben rc
                ON rc.reporte_id = r.id

             INNER JOIN casa c
                ON c.id = rc.casa_id

             INNER JOIN LATERAL (
                SELECT
                    medida_tomada,
                    contenido,
                    fecha
                FROM datos
                WHERE reporte_id = r.id
                AND estado = TRUE
                ORDER BY fecha DESC, id DESC
                LIMIT 1
             ) d ON TRUE

             WHERE r.id = $1
             AND r.usuario_id = $2
             AND r.estado = TRUE`,
            [
                id,
                req.usuario.id
            ]
        );

        if (resultado.rows.length === 0)
        {
            return res.status(404).json({
                mensaje: 'Reporte no encontrado o sin lectura registrada'
            });
        }

        const reporte = resultado.rows[0];

        if (reporte.pdf)
        {
            return res.status(409).json({
                mensaje: 'El reporte ya fue emitido'
            });
        }

        const documento = new PDFDocument({
            size: 'A4',
            margin: 50
        });

        const partes = [];

        documento.on('data', parte => {
            partes.push(parte);
        });

        const pdfGenerado = new Promise((resolve, reject) => {
            documento.on('end', () => {
                resolve(Buffer.concat(partes));
            });

            documento.on('error', reject);
        });

        documento
            .fontSize(25)
            .text('LEAF', {
                align: 'center'
            });

        documento.moveDown();

        documento
            .fontSize(18)
            .text('Reporte de lectura de contador de agua', {
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

        documento.text(
            `Fecha de lectura: ${new Date(reporte.fecha_lectura).toLocaleString('es-GT', {
                timeZone: 'America/Guatemala'
            })}`
        );

        documento.moveDown();

        documento
            .fontSize(16)
            .text('Medición registrada');

        documento.moveDown();

        documento
            .fontSize(20)
            .text(`${reporte.medida_tomada} m³`);

        documento.moveDown(2);

        documento
            .fontSize(13)
            .text('Observaciones:');

        documento.moveDown();

        documento.text(
            reporte.contenido || 'Sin observaciones adicionales'
        );

        documento.moveDown(3);

        documento
            .fontSize(10)
            .text('Documento generado mediante Leaf.', {
                align: 'center'
            });

        documento.end();

        const pdfBuffer = await pdfGenerado;

        await fs.mkdir(REPORTES_DIR, {
            recursive: true
        });

        const nombreArchivo = `reporte-${reporte.id}.pdf`;

        const rutaArchivo = path.join(
            REPORTES_DIR,
            nombreArchivo
        );

        archivoTemporal = path.join(
            REPORTES_DIR,
            `${crypto.randomUUID()}.tmp`
        );

        await fs.writeFile(
            archivoTemporal,
            pdfBuffer
        );

        await fs.rename(
            archivoTemporal,
            rutaArchivo
        );

        archivoTemporal = null;

        const actualizado = await pool.query(
            `UPDATE reporte
             SET pdf = $1
             WHERE id = $2
             AND usuario_id = $3
             AND estado = TRUE
             AND pdf IS NULL
             RETURNING id, titulo, pdf, fecha`,
            [
                nombreArchivo,
                reporte.id,
                req.usuario.id
            ]
        );

        if (actualizado.rows.length === 0)
        {
            return res.status(409).json({
                mensaje: 'El reporte ya fue emitido o cambió de estado'
            });
        }

        return res.json({
            mensaje: 'Reporte PDF generado correctamente',
            reporte: actualizado.rows[0]
        });
    }
    catch (error)
    {
        console.error('Error en emitirReporte:', error);

        return res.status(500).json({
            mensaje: 'Error al generar el reporte PDF'
        });
    }
    finally
    {
        if (archivoTemporal)
        {
            await fs.rm(archivoTemporal, {
                force: true
            }).catch(() => {});
        }
    }
}

module.exports = {
    emitirReporte
};