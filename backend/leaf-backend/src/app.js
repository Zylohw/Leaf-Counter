const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/usuarios', userRoutes);

app.get('/', (req, res) =>
{
    res.json({ mensaje: 'API de Leaf App funcionando' });
});

// Manejo de rutas no encontradas
app.use((req, res) =>
{
    res.status(404).json({ mensaje: 'Ruta no encontrada' });
});

module.exports = app;
