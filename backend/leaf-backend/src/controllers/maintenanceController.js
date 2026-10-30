const pool = require('../config/db');
const multer = require('multer');

const fs = require('fs/promises');
const path = require('path');

const FOTOS_DIR = path.join(__dirname, '../../private/fotos');

const EXTENSIONES_PERMITIDAS = ['.jpg', '.jpeg', '.png'];

const subirFoto = multer(
    {
        storage: multer.memoryStorage(),
        limits:
        {
            fileSize: 8 * 1024 * 1024
        },
        fileFilter: (req, file, cb) =>
        {
            const extension = path.extname(file.originalname || '').toLowerCase();

            if (!EXTENSIONES_PERMITIDAS.includes(extension))
            {
                return cb(new Error('FORMATO_INVALIDO'));
            }

            cb(null, true);
        }
    }).single('foto');

function procesarFoto(req, res)
{
    return new Promise((resolve, reject) =>
        {
            subirFoto(req, res, error =>
                {
                    if (error)
                    {
                        return reject(error);
                    }

                    resolve();
                });
        });
}

async function obtenerCasasMantenimiento(req, res)
{
    try
    {
        const resultado = await pool.query(`SELECT id, sector, numero, estado
                                            FROM casa
                                            WHERE estado = TRUE
                                            ORDER BY sector, numero`);

        return res.json(
            {
                mensaje: 'Viviendas obtenidas correctamente',
                casas: resultado.rows
            });
    }
    catch (error)
    {
        console.error('Error en obtenerCasasMantenimiento:', error);

        return res.status(500).json(
            {
                mensaje: 'Error interno del servidor'
            });
    }
}

async function registrarLectura(req, res)
{
    try
    {
        await procesarFoto(req, res);
    }
    catch (error)
    {
        if (error.message === 'FORMATO_INVALIDO')
        {
            return res.status(400).json(
                {
                    mensaje: 'La fotografía debe ser JPG o PNG'
                });
        }

        if (error.code === 'LIMIT_FILE_SIZE')
        {
            return res.status(400).json(
                {
                    mensaje: 'La fotografía no puede pesar más de 8 MB'
                });
        }

        console.error('Error al recibir la fotografía:', error);

        return res.status(400).json(
            {
                mensaje: 'No se pudo procesar la fotografía'
            });
    }

    const casa_id = Number(req.body.casa_id);
    const medida_tomada = Number(req.body.medida_tomada);
    const contenido = req.body.contenido;

    if (!Number.isSafeInteger(casa_id) || casa_id <= 0)
    {
        return res.status(400).json(
            {
                mensaje: 'ID de vivienda inválido'
            });
    }

    if (!Number.isFinite(medida_tomada) || medida_tomada < 0 || medida_tomada > 99999999.99)
    {
        return res.status(400).json(
            {
                mensaje: 'La medición debe ser un número válido'
            });
    }

    if (contenido !== undefined &&
        (typeof contenido !== 'string' || contenido.length > 5000))
    {
        return res.status(400).json(
            {
                mensaje: 'Las observaciones no son válidas'
            });
    }

    if (!req.file)
    {
        return res.status(400).json(
            {
                mensaje: 'Debe adjuntar la fotografía del contador'
            });
    }

    const cliente = await pool.connect();

    let rutaFotoGuardada = null;

    try
    {
        await cliente.query('BEGIN');

        const vivienda = await cliente.query(`SELECT id, sector, numero
                                              FROM casa
                                              WHERE id = $1
                                              AND estado = TRUE`,
                                              [casa_id] );

        if (vivienda.rows.length === 0)
        {
            await cliente.query('ROLLBACK');

            return res.status(404).json(
                {
                    mensaje: 'Vivienda no encontrada o desactivada'
                });
        }

        const casa = vivienda.rows[0];

        const titulo = `Lectura ${casa.sector} - ${casa.numero}`;

        const reporte = await cliente.query(`INSERT INTO reporte (titulo, descripcion, usuario_id)
                                             VALUES ($1, $2, $3)
                                             RETURNING id, titulo, descripcion, fecha, usuario_id`,
                                             [titulo, 'Reporte de lectura de contador de agua', req.usuario.id] );

        const reporteCreado = reporte.rows[0];

        await cliente.query(`INSERT INTO reciben (casa_id, reporte_id)
                             VALUES ($1, $2)`,
                             [casa_id, reporteCreado.id] );

        const lectura = await cliente.query(`INSERT INTO datos (medida_tomada, contenido, reporte_id)
                                             VALUES ($1, $2, $3)
                                             RETURNING id`,
                                             [medida_tomada, contenido?.trim() || null, reporteCreado.id] );

        const lecturaId = lectura.rows[0].id;

        const extension = path.extname(req.file.originalname).toLowerCase() === '.png' ? '.png' : '.jpg';

        const nombreFoto = `lectura-${lecturaId}${extension}`;

        await fs.mkdir(FOTOS_DIR,
            {
                recursive: true
            });

        rutaFotoGuardada = path.join(FOTOS_DIR, nombreFoto);

        await fs.writeFile(rutaFotoGuardada, req.file.buffer);

        const lecturaFinal = await cliente.query(`UPDATE datos
                                                  SET foto = $1
                                                  WHERE id = $2
                                                  RETURNING id, medida_tomada, contenido, foto, fecha, reporte_id`,
                                                  [nombreFoto, lecturaId] );

        await cliente.query('COMMIT');

        rutaFotoGuardada = null;

        return res.status(201).json(
            {
                mensaje: 'Lectura registrada correctamente',
                casa,
                reporte: reporteCreado,
                lectura: lecturaFinal.rows[0]
            });
    }
    catch (error)
    {
        await cliente.query('ROLLBACK');

        if (rutaFotoGuardada)
        {
            await fs.rm(rutaFotoGuardada,
                {
                    force: true
                }).catch(() => {});
        }

        console.error('Error en registrarLectura:', error);

        return res.status(500).json(
            {
                mensaje: 'Error interno del servidor'
            });
    }
    finally
    {
        cliente.release();
    }
}

async function obtenerReportesMantenimiento(req, res)
{
    try
    {
        const resultado = await pool.query(`SELECT r.id, r.titulo, r.descripcion, r.pdf, r.fecha, r.estado,
                                                   c.id AS casa_id, c.sector, c.numero,

                                                   ( SELECT d.id
                                                     FROM datos d
                                                     WHERE d.reporte_id = r.id
                                                     AND d.estado = TRUE
                                                     ORDER BY d.fecha DESC, d.id DESC
                                                     LIMIT 1 ) AS lectura_id,

                                                   ( SELECT d.medida_tomada
                                                     FROM datos d
                                                     WHERE d.reporte_id = r.id
                                                     AND d.estado = TRUE
                                                     ORDER BY d.fecha DESC, d.id DESC
                                                     LIMIT 1 ) AS medida_tomada,

                                                   ( SELECT d.contenido
                                                     FROM datos d
                                                     WHERE d.reporte_id = r.id
                                                     AND d.estado = TRUE
                                                     ORDER BY d.fecha DESC, d.id DESC
                                                     LIMIT 1 ) AS contenido,

                                                   ( SELECT d.foto
                                                     FROM datos d
                                                     WHERE d.reporte_id = r.id
                                                     AND d.estado = TRUE
                                                     ORDER BY d.fecha DESC, d.id DESC
                                                     LIMIT 1 ) AS foto,

                                                   ( SELECT d.fecha
                                                     FROM datos d
                                                     WHERE d.reporte_id = r.id
                                                     AND d.estado = TRUE
                                                     ORDER BY d.fecha DESC, d.id DESC
                                                     LIMIT 1 ) AS fecha_lectura
                                            FROM reporte r, reciben rc, casa c
                                            WHERE rc.reporte_id = r.id
                                            AND c.id = rc.casa_id
                                            AND r.usuario_id = $1
                                            AND r.estado = TRUE
                                            ORDER BY r.fecha DESC, r.id DESC`,
                                            [req.usuario.id] );

        return res.json(
            {
                mensaje: 'Reportes obtenidos correctamente',
                reportes: resultado.rows
            });
    }
    catch (error)
    {
        console.error('Error en obtenerReportesMantenimiento:', error);

        return res.status(500).json(
            {
                mensaje: 'Error interno del servidor'
            });
    }
}

module.exports = {  obtenerCasasMantenimiento,
                    registrarLectura,
                    obtenerReportesMantenimiento };