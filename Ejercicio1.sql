CREATE DATABASE bitacora_empresax;

USE bitacora_empresax;

CREATE TABLE empleados(
    id_empleado VARCHAR(12) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    CONSTRAINT PK_ID_EMP PRIMARY KEY(id_empleado)
);

CREATE TABLE maquinas(
    cod_maquina VARCHAR(12) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    CONSTRAINT PK_ID_MAQ PRIMARY KEY (cod_maquina)
);

CREATE TABLE bitacora(
  correlativo INT IDENTITY(1,1) NOT NULL,
  id_empleado VARCHAR(12) NOT NULL,
  cod_maquina VARCHAR(12) NOT NULL,
  tiempo_uso INT NOT NULL,
  lugar VARCHAR(50) NOT NULL,
  CONSTRAINT PK_CORREL PRIMARY KEY (correlativo),
  CONSTRAINT FK_ID_EMPL FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_COD_MAQU FOREIGN KEY (cod_maquina) REFERENCES maquinas(cod_maquina) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO
    dbo.empleados(id_empleado, nombre, apellido, edad, fecha_inicio)
VALUES ('01234567-8', 'CARLOS FIDEL', 'ARGUETA MIRANDA', 45, '2006-08-21'),
       ('12345678-9', 'JUAN FRANCISCO', 'VILLALTA ALVARADO', 32, '2010-02-27'),
       ('78901234-5', 'RAUL ALEJANDRO', 'PONCIO VALLADARES', 32, '2010-02-27'),
       ('89012345-6', 'MIGUEL EDUARDO', 'MORALES CLAROS', 26, '2010-08-21'),
       ('90123456-7', 'FABRICIO DAVID', 'ALAS FLORES', 30, '2008-12-01');

SELECT * FROM dbo.empleados;

INSERT INTO
    dbo.maquinas(cod_maquina, descripcion, marca, modelo, fecha_ingreso)
VALUES ('M00001', 'TALADRO DE ELEMENTOS VARIOS', 'CATERPILLAR', 'EVO2000', '2006-01-31'),
       ('M00002', 'APLANADORA DE SUELOS Y OTROS', 'CATERPILLAR', 'FLU5000', '2006-01-31'),
       ('M00003', 'PULVERIZADORA DE ELEMENTOS', 'CATERPILLAR', 'ASD2001', '2006-01-31'),
       ('M00004', 'CONCRETERA', 'MG', 'EDS', '2006-05-31'),
       ('M00005', 'MAQUINA ESPECIAL PARA PROYECTO 10', 'MG', 'SFD', '2006-05-31'),
       ('M00006', 'MAQUINA ESPECIAL PARA PROYECTO 30', 'MG', 'SFD', '2010-12-01');

SELECT * FROM dbo.maquinas;

INSERT INTO bitacora
    (id_empleado, cod_maquina, tiempo_uso, lugar)
VALUES ('12345678-9', 'M00001', 250, 'SANTIAGO NONUALCO'),
       ('01234567-8', 'M00002', 300, 'SANTIAGO NONUALCO'),
       ('90123456-7', 'M00003', 500, 'ALEGRIA, USULUTAN'),
       ('89012345-6', 'M00004', 300, 'ALEGRIA, USULUTAN'),
       ('90123456-7', 'M00005', 250, 'SANTIAGO NONUALCO'),
       ('01234567-8', 'M00002', 125, 'SANTIAGO NONUALCO'),
       ('12345678-9', 'M00003', 375, 'ALEGRIA, USULUTAN'),
       ('12345678-9', 'M00004', 200, 'ALEGRIA, USULUTAN');

SELECT * FROM dbo.bitacora;

/**
  (10 %) Mostrar los empleados que hayan hecho o esten haciendo uso de una maquina.
  (10 %) Campos a mostrar: Nombres del empleado, Marca, Modelo y Descripcion de la maquina.
**/

CREATE PROCEDURE getMaquinasUsadas
AS
BEGIN
    SELECT
           empleados.id_empleado AS [ID EMPLEADO],
           empleados.nombre AS NOMBRE,
           maquinas.cod_maquina AS [CODIGO MAQUINA],
           maquinas.marca AS MARCA,
           maquinas.modelo AS MODELO,
           maquinas.descripcion AS DESCRIPCION
    FROM bitacora
        INNER JOIN empleados ON bitacora.id_empleado = empleados.id_empleado
        INNER JOIN maquinas ON bitacora.cod_maquina = maquinas.cod_maquina
END

EXEC getMaquinasUsadas;

/**
  (10 %) Mostrar los empleados que todavıa no tienen asignada una maquina.
  Campos a mostrar: Nombres y Apellidos del empleado y Codigo de la maquina.
 */

CREATE PROCEDURE getPersonasNull
AS
BEGIN
    SELECT
           empleados.id_empleado AS [ID EMPLEADO],
           empleados.nombre AS NOMBRE,
           empleados.nombre AS APELLIDO,
           empleados.edad AS EDAD
    FROM empleados
    WHERE NOT EXISTS(SELECT * FROM bitacora WHERE bitacora.id_empleado=empleados.id_empleado)
END

EXEC getPersonasNull;

/**
  (10 %) Mostrar las maquinas que no estan asignadas a un proyecto. Campos a mostrar:
   Nombres y Apellidos del empleado y Descripcion de la maquina.
 */

 CREATE PROCEDURE getMaquinasNull
AS
BEGIN
    SELECT
           maquinas.cod_maquina AS [CODIGO MAQUINA],
           maquinas.descripcion AS DESCRIPCION,
           maquinas.modelo AS MODELO,
           maquinas.marca AS MARCA
    FROM maquinas
    WHERE NOT EXISTS(SELECT * FROM bitacora WHERE bitacora.cod_maquina=maquinas.cod_maquina)
END

EXEC getMaquinasNull;