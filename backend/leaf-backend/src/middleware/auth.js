const { verificarToken } = require('../utils/jwt');

// Middleware que valida el token JWT enviado en el header:
// Authorization: Bearer <token>
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
        req.usuario = datos; // { id, correo, rol }
        next();
    }
    catch (error)
    {
        return res.status(401).json({ mensaje: 'Token invalido o expirado' });
    }
}

// Middleware opcional para restringir por rol, ej: requireRole('Administrador')
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
