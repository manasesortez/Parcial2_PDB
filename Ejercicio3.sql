/**
  La tabla PRODUCTO contiene informacion general de los
  productos y la tabla PEDIDO contiene la informacion del
  pedido que se realiza de un cierto producto, llenar las
  tablas con informacion.
 */
CREATE DATABASE Bodega;

USE Bodega;

CREATE TABLE producto(
    idprod char(7) PRIMARY KEY,
    descripcion VARCHAR(25),
    existencias INT,
    precio_costo DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    ganancia as precio_venta - precio_costo,
    CHECK(precio_venta>producto.precio_costo)
);

CREATE TABLE pedido(
  idpedido CHAR(7),
  idprod CHAR(7),
  cantidad INT,
  PRIMARY KEY (idpedido),
  CONSTRAINT FK_ID_PED FOREIGN KEY (idprod) REFERENCES producto(idprod) ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT * FROM pedido;
SELECT * FROM producto;

INSERT INTO producto VALUES ('0123-9', 'Coca-Cola 3L', 100, 2.80, 3);
INSERT INTO producto VALUES ('0123-1', 'Coca-Cola Vidrio 1.25L', 200, 1.20, 1.60);

INSERT INTO pedido VALUES('0233-9', '0123-9', 50);

/**
(30 %) Crear un procedimiento almacenado que ingrese los
valores en la tabla PRODUCTOS, y deber´a verificar que el
codigo y nombre del producto no exista para poder
insertarlo, en caso que el c´odigo o el nombre del
producto ya exista enviar un mensaje que diga “ESTE
PRODUCTO YA HA SIDO INGRESADO”.

 */

 CREATE PROCEDURE addNewProduct @idprod char(7), @descripcion VARCHAR(25), @existencias INT, @precio_costo DECIMAL(10,2), @precio_venta DECIMAL(10,2)
 AS
     IF EXISTS(
         SELECT *
         FROM producto
         WHERE idprod = @idprod AND descripcion = @descripcion)
     BEGIN
         PRINT('EL PRODUCTO ' + @descripcion + ' YA HA SIDO INGRESADO')
     END;
     ELSE
         BEGIN
             INSERT INTO producto(idprod,descripcion,existencias,precio_costo, precio_venta)
             VALUES
             (@idprod, @descripcion, @existencias, @precio_costo, @precio_venta)
         END;


EXEC addNewProduct '0121-3', 'Jabon Bex ', 50, 3, 3.25