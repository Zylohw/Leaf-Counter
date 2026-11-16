const { Pool } = require('pg');
require('dotenv').config();

// Pool de conexiones a PostgreSQL. Se reutiliza en toda la app
// en vez de abrir una conexion nueva por cada consulta.
function crearPool(usuario, contrasena)
{
    const nuevoPool = new Pool(
    {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        database: process.env.DB_NAME,
        user: usuario,
        password: contrasena,
    });

    nuevoPool.on('error', (err) =>
    {
        console.error(`Error inesperado en el pool de ${usuario}:`, err);
    });

    return nuevoPool;
}

const pool = crearPool(process.env.DB_USER, process.env.DB_PASSWORD);

const pools =
{
    usuario: crearPool(process.env.DB_USER_USUARIO, process.env.DB_PASSWORD_USUARIO),
    mantenimiento: crearPool(process.env.DB_USER_MANTENIMIENTO, process.env.DB_PASSWORD_MANTENIMIENTO),
    admin: crearPool(process.env.DB_USER_ADMIN, process.env.DB_PASSWORD_ADMIN),
};

const ROL_A_POOL =
{
    'Comun': pools.usuario,
    'Mantenimiento': pools.mantenimiento,
    'Administrador': pools.admin,
};

function poolPorRol(rol)
{
    return ROL_A_POOL[rol] || pool;
}

module.exports = pool;
module.exports.pools = pools;
module.exports.poolPorRol = poolPorRol;