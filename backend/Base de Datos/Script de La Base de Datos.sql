CREATE TABLE rol 
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    estado BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE usuarios 
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    rol_id INTEGER NOT NULL REFERENCES rol (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE casa 
(
    id SERIAL PRIMARY KEY,
    sector VARCHAR(50) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE tiene 
(
    usuario_id INTEGER NOT NULL REFERENCES usuarios (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    casa_id INTEGER NOT NULL REFERENCES casa (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    habita BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (usuario_id, casa_id)
);

CREATE TABLE reporte 
(
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    pdf VARCHAR(255),
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    usuario_id INTEGER NOT NULL REFERENCES usuarios (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE reciben 
(
    casa_id INTEGER NOT NULL REFERENCES casa (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    reporte_id INTEGER NOT NULL REFERENCES reporte (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    recibido BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (casa_id, reporte_id)
);

CREATE TABLE datos 
(
    id SERIAL PRIMARY KEY,
    medida_tomada NUMERIC(10,2) NOT NULL,
    contenido TEXT,
    foto VARCHAR(255),
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    reporte_id INTEGER NOT NULL REFERENCES reporte (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE notificaciones 
(
    id SERIAL PRIMARY KEY,
    descripcion TEXT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    reporte_id INTEGER REFERENCES reporte (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    rol_destinatario INTEGER NOT NULL REFERENCES rol (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO rol (id, nombre) VALUES (1, 'Comun'), (2, 'Mantenimiento'), (3, 'Administrador');

SELECT setval('rol_id_seq', (SELECT MAX(id) FROM rol));

CREATE ROLE leaf_visitante NOLOGIN;
CREATE ROLE leaf_usuario NOLOGIN;
CREATE ROLE leaf_mantenimiento NOLOGIN;
CREATE ROLE leaf_admin NOLOGIN;

GRANT CONNECT ON DATABASE leaf_app TO leaf_visitante, leaf_usuario, leaf_mantenimiento, leaf_admin;
GRANT USAGE ON SCHEMA public TO leaf_visitante, leaf_usuario, leaf_mantenimiento, leaf_admin;

GRANT SELECT ON rol TO leaf_visitante;

GRANT SELECT ON casa, datos, notificaciones, reciben, reporte, rol, tiene TO leaf_usuario;

GRANT SELECT ON casa, notificaciones, reporte, rol, tiene TO leaf_mantenimiento;
GRANT SELECT, INSERT, UPDATE ON datos TO leaf_mantenimiento;

GRANT SELECT ON rol TO leaf_admin;
GRANT SELECT, INSERT, UPDATE ON casa, datos, notificaciones, reciben, reporte, tiene TO leaf_admin;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO leaf_mantenimiento, leaf_admin;

GRANT SELECT (id, nombre, correo, contrasena, estado, rol_id) ON usuarios TO leaf_visitante;

GRANT SELECT (id, nombre, correo, estado, rol_id) ON usuarios TO leaf_usuario, leaf_mantenimiento;
GRANT UPDATE (nombre, correo, contrasena) ON usuarios TO leaf_usuario, leaf_mantenimiento;

GRANT UPDATE (recibido) ON reciben TO leaf_usuario;

GRANT SELECT (id, nombre, correo, estado, rol_id), INSERT, UPDATE ON usuarios TO leaf_admin;

CREATE ROLE app_admin WITH LOGIN PASSWORD 'CAMBIAR' IN ROLE leaf_admin;
CREATE ROLE app_mantenimiento WITH LOGIN PASSWORD 'CAMBIAR' IN ROLE leaf_mantenimiento;
CREATE ROLE app_usuario WITH LOGIN PASSWORD 'CAMBIAR' IN ROLE leaf_usuario;
CREATE ROLE app_visitante WITH LOGIN PASSWORD 'CAMBIAR' IN ROLE leaf_visitante;

CREATE INDEX idx_usuarios_rol_id ON usuarios(rol_id);
CREATE INDEX idx_reporte_usuario_id ON reporte(usuario_id);
CREATE INDEX idx_datos_reporte_id ON datos(reporte_id);
CREATE INDEX idx_notificaciones_reporte_id ON notificaciones(reporte_id);
CREATE INDEX idx_tiene_casa_id ON tiene(casa_id);
CREATE INDEX idx_reciben_reporte_id ON reciben(reporte_id);

COMMIT;