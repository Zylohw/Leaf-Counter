BEGIN;

CREATE TABLE roles 
(
    id      SERIAL PRIMARY KEY,
    rol     VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users 
(
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    correo      VARCHAR(150) NOT NULL UNIQUE,
    rol_id      INTEGER NOT NULL REFERENCES roles(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_users_rol_id ON users(rol_id);

CREATE TABLE contrasenas 
(
    id          SERIAL PRIMARY KEY,
    contrasena  VARCHAR(255) NOT NULL,  -- guardar siempre como hash, nunca en texto plano
    user_id     INTEGER NOT NULL UNIQUE REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE usuarios 
(
    id  INTEGER PRIMARY KEY REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE admins 
(
    id  INTEGER PRIMARY KEY REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE mantenimientos 
(
    id      INTEGER PRIMARY KEY REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    sector  VARCHAR(100)
);

CREATE TABLE casas 
(
    id          SERIAL PRIMARY KEY,
    numero      VARCHAR(20) NOT NULL,
    sector      VARCHAR(100),
    usuario_id  INTEGER UNIQUE REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE pdfs 
(
    id          SERIAL PRIMARY KEY,
    fecha       TIMESTAMP NOT NULL DEFAULT now(),
    contenido   TEXT  -- ruta/URL del archivo
);

CREATE TABLE reportes 
(
    id          SERIAL PRIMARY KEY,
    titulo      VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha       TIMESTAMP NOT NULL DEFAULT now(),

    --Realiza
    admin_id    INTEGER NOT NULL REFERENCES admins(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    pendiente   BOOLEAN NOT NULL DEFAULT TRUE,          

    --Reciben
    casa_id     INTEGER NOT NULL REFERENCES casas(id) ON UPDATE CASCADE ON DELETE CASCADE,
    recibido    BOOLEAN NOT NULL DEFAULT FALSE,         

    --Incluye
    pdf_id      INTEGER REFERENCES pdfs(id) ON UPDATE CASCADE ON DELETE SET NULL  
);

CREATE INDEX idx_reportes_admin_id ON reportes(admin_id);
CREATE INDEX idx_reportes_casa_id  ON reportes(casa_id);
CREATE INDEX idx_reportes_pdf_id   ON reportes(pdf_id);

CREATE TABLE datos 
(
    id                  SERIAL PRIMARY KEY,
    fecha               TIMESTAMP NOT NULL DEFAULT now(),
    contenido           TEXT,
    foto                TEXT,  -- ruta/URL de la foto

    --Contiene
    reporte_id          INTEGER REFERENCES reportes(id) ON UPDATE CASCADE ON DELETE SET NULL,  
    
    --Toma
    casa_id             INTEGER NOT NULL REFERENCES casas(id) ON UPDATE CASCADE ON DELETE CASCADE,          
    mantenimiento_id    INTEGER NOT NULL REFERENCES mantenimientos(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    medicion_tomada     BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_datos_reporte_id       ON datos(reporte_id);
CREATE INDEX idx_datos_casa_id          ON datos(casa_id);
CREATE INDEX idx_datos_mantenimiento_id ON datos(mantenimiento_id);

CREATE TABLE notificaciones 
(
    id          SERIAL PRIMARY KEY,
    fecha       TIMESTAMP NOT NULL DEFAULT now(),
    descripcion TEXT,
    reporte_id  INTEGER NOT NULL REFERENCES reportes(id) ON UPDATE CASCADE ON DELETE CASCADE,
    leida       BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_notificaciones_reporte_id ON notificaciones(reporte_id);

COMMIT;