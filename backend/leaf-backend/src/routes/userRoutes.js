const express = require('express');
const router = express.Router();
const { registrarUsuario } = require('../controllers/userController');
const { requireAuth, requireRole } = require('../middleware/auth');

// Registro publico de usuarios (rol Comun por defecto).
// Si prefieres que solo el Administrador pueda crear usuarios,
// descomenta las siguientes dos lineas y borra la de abajo:
// router.post('/registro', requireAuth, requireRole('Administrador'), registrarUsuario);
router.post('/registro', registrarUsuario);

module.exports = router;
