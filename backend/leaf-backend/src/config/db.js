const { Pool } = require('pg');
require('dotenv').config();

// Pool de conexiones a PostgreSQL. Se reutiliza en toda la app
// en vez de abrir una conexion nueva por cada consulta.
const pool = new Pool(
{
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
});

pool.on('error', (err) =>
{
    console.error('Error inesperado en el pool de PostgreSQL:', err);
});

module.exports = pool;
