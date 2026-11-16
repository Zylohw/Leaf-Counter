const { verificarToken } = require('../utils/jwt');
const { poolPorRol } = require('../config/db');

function requireAuth(req, res, next)
{
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer '))
    {
        return res.status(401).json({ mensaje: 'Token no proporcionado' });
    }

    const token = authHeader.split(' ')[1];

    try
    {
        const datos = verificarToken(token);
        req.usuario = datos;
        req.db = poolPorRol(datos.rol);
        next();
    }
    catch (error)
    {
        return res.status(401).json({ mensaje: 'Token invalido o expirado' });
    }
}

function requireRole(...rolesPermitidos)
{
    return (req, res, next) =>
    {
        if (!req.usuario || !rolesPermitidos.includes(req.usuario.rol))
        {
            return res.status(403).json({ mensaje: 'No tienes permisos para esta accion' });
        }
        next();
    };
}

module.exports = { requireAuth, requireRole };