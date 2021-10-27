/**
  Utilizar la base de datos Northwind (en caso de que no
  la tenga adjunta al SQL SERVER de su equipo, se les
  comparte como recurso para el parcial).
 */

 USE Northwind;

/**(10%) Mostrar el promedio de los precios unitarios
 de las categorías: Produce y Confections. */

SELECT * FROM Categories;
SELECT * FROM Products;

CREATE PROCEDURE getAverageCategories
AS
BEGIN
    SELECT
        AVG(Products.UnitPrice) AS [PROMEDIO DE PRODUCE Y CONFECTIONS]
    FROM Products
    INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
    WHERE Categories.CategoryName IN('Produce', 'Confections')
END

EXEC getAverageCategories;

/**
  Cuantos productos existen por cada categor´ıa.
 */

SELECT * FROM Products;
SELECT * FROM Categories;

CREATE PROCEDURE getProductsxCategories
AS
BEGIN
    SELECT
           Categories.CategoryName AS [CATEGORY NAME],
           COUNT(*) AS [TOTAL PRODUCTS]
    FROM Categories
    INNER JOIN Products on Categories.CategoryID = Products.CategoryID
    GROUP BY Categories.CategoryName
END

EXEC getProductsxCategories;

/**
  (10%) Mostrar todos los productos cuya categoría sea “Beverages”.
 */

SELECT * FROM Products;

CREATE PROCEDURE getFilterBeverages
AS
BEGIN
    SELECT
           Categories.CategoryName AS CATEGOTY,
           Products.ProductName AS [PRODUCT NAME],
           Products.QuantityPerUnit AS QUANTITY,
           Products.UnitPrice AS PRICE
    FROM Categories
    INNER JOIN Products on Categories.CategoryID = Products.CategoryID
    WHERE Categories.CategoryName LIKE 'Beverages%'
END

EXEC getFilterBeverages;