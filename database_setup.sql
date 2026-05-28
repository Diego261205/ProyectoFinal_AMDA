-- Script de base de datos para AMDA
-- Puerto por defecto en MySQL/MariaDB (XAMPP): 306

CREATE DATABASE IF NOT EXISTS amda_db;
USE amda_db;

-- 1. Tabla de usuarios para login
CREATE TABLE IF NOT EXISTS usuarios (
    id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL
);

-- 2. Tabla de dueños (propietarios de vehículos)
CREATE TABLE IF NOT EXISTS duenos (
    id_dueno INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    edad INT,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    domicilio VARCHAR(255)
);

-- 3. Tabla de servicios/trámites
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    tipo_movimiento VARCHAR(50),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    vin VARCHAR(50),
    tipo_placa VARCHAR(50),
    fecha_tramite DATE,
    importe DECIMAL(10,2),
    cliente_nombre VARCHAR(100), -- Nombre de la Agencia / Cliente
    id_dueno INT,
    pagado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_dueno) REFERENCES duenos(id_dueno) ON DELETE CASCADE
);

-- Insertar usuario por defecto para iniciar sesión
-- Usuario: admin
-- Contraseña: admin
INSERT INTO usuarios (id, password) VALUES ('admin', 'admin') ON DUPLICATE KEY UPDATE id=id;
