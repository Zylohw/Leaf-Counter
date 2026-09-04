BEGIN;

CREATE TYPE estado_general AS ENUM ('activo', 'inactivo');
CREATE TYPE estado_reporte AS ENUM ('pendiente', 'generado', 'enviado', 'anulado');
CREATE TYPE estado_notificacion AS ENUM ('pendiente', 'enviada', 'leida', 'fallida');

CREATE TABLE rol 
(
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(50) NOT NULL UNIQUE,
    estado  estado_general NOT NULL DEFAULT 'activo'
);

CREATE TABLE usuarios 
(
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    correo      VARCHAR(150) NOT NULL UNIQUE,
    contrasena  VARCHAR(255) NOT NULL,
    estado      estado_general NOT NULL DEFAULT 'activo',

    rol_id      INTEGER NOT NULL REFERENCES rol(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE casa 
(
    id      SERIAL PRIMARY KEY,
    sector  VARCHAR(100) NOT NULL,
    numero  VARCHAR(20) NOT NULL,
    estado  estado_general NOT NULL DEFAULT 'activo',
    UNIQUE (sector, numero)
);

CREATE TABLE tiene 
(
    usuario_id  INTEGER NOT NULL REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE CASCADE,
    casa_id     INTEGER NOT NULL REFERENCES casa(id) ON UPDATE CASCADE ON DELETE CASCADE,

    habita      BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (usuario_id, casa_id)
);

CREATE TABLE reporte 
(
    id           SERIAL PRIMARY KEY,
    descripcion  TEXT,
    pdf          VARCHAR(255),
    fecha        TIMESTAMP NOT NULL DEFAULT NOW(),
    titulo       VARCHAR(150) NOT NULL,
    estado       estado_reporte NOT NULL DEFAULT 'pendiente',

    usuario_id   INTEGER NOT NULL REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE reciben 
(
    casa_id     INTEGER NOT NULL REFERENCES casa(id) ON UPDATE CASCADE ON DELETE CASCADE,
    reporte_id  INTEGER NOT NULL REFERENCES reporte(id) ON UPDATE CASCADE ON DELETE CASCADE,
    recibido    BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (casa_id, reporte_id)
);

CREATE TABLE datos 
(
    id              SERIAL PRIMARY KEY,
    medida_tomada   NUMERIC(10,2) NOT NULL,
    estado          estado_general NOT NULL DEFAULT 'activo',
    fecha           TIMESTAMP NOT NULL DEFAULT NOW(),
    contenido       TEXT,
    foto            VARCHAR(255),

    reporte_id      INTEGER NOT NULL REFERENCES reporte(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE notificaciones 
(
    id           SERIAL PRIMARY KEY,
    descripcion  TEXT NOT NULL,
    fecha        TIMESTAMP NOT NULL DEFAULT NOW(),
    estado       estado_notificacion NOT NULL DEFAULT 'pendiente',

    reporte_id   INTEGER NOT NULL REFERENCES reporte(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX idx_usuarios_rol_id ON usuarios(rol_id);
CREATE INDEX idx_reporte_usuario_id ON reporte(usuario_id);
CREATE INDEX idx_datos_reporte_id ON datos(reporte_id);
CREATE INDEX idx_notificaciones_reporte_id ON notificaciones(reporte_id);
CREATE INDEX idx_tiene_casa_id ON tiene(casa_id);
CREATE INDEX idx_reciben_reporte_id ON reciben(reporte_id);

COMMIT;