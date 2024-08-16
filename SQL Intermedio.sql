-- 1.	¿Cuántas filas hay dentro de la tabla personas?
SELECT COUNT(*) AS TotalFilas
FROM Person.Person;

-- 2.	Indicar la cantidad de empleados cuyos apellidos empiecen con una letra inferior a “D”
SELECT COUNT(*) AS CantidadEmpleados
FROM Person.Person
WHERE LastName LIKE '[A-D]%';

-- 3.	¿Cuál es el promedio de StandardCost para cada producto donde StandardCost es mayor a $0? (Production.Product)
SELECT 
	ProductID, 
	AVG(StandardCost) AS PromedioCosto
FROM Production.Product
WHERE StandardCost > 0
GROUP BY ProductID;

-- 4.	En la tabla personas ¿cuántas personas están asociadas con cada tipo de persona (PersonType)?
SELECT 
	PersonType, 
	COUNT(*) AS CantidadPersonas
FROM Person.Person
GROUP BY PersonType;

-- 5.	¿Cuántos productos en Production.Product hay que son rojos (red) y cuántos que son negros (black)?
SELECT 
	Color, 
	COUNT(*) AS CantidadProductos
FROM Production.Product
WHERE Color IN ('Red', 'Black')
GROUP BY Color;

-- 6.	¿Cuáles son las ventas por territorio para todas las filas de Sales.SalesOrderHeader? 
-- Traer sólo los territorios que se pasen de $10 millones en ventas históricas, traer el total de las ventas y el TerritoryID.
SELECT 
	TerritoryID, 
	SUM(TotalDue) AS TotalVentas
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING SUM(TotalDue) > 10000000;

-- 7.	Usando la query anterior, hacer un join hacia Sales.SalesTerritory y reemplazar el TerritoryID con el nombre del territorio. 
SELECT 
	territorio.Name, 
	SUM(TotalDue) AS TotalVentas
FROM Sales.SalesOrderHeader ventas
LEFT JOIN Sales.SalesTerritory territorio
ON ventas.TerritoryID = territorio.TerritoryID
GROUP BY territorio.Name
HAVING SUM(TotalDue) > 10000000;

-- 8.	¿Cuántas filas en Person.Person no tienen NULL en MiddleName?
SELECT COUNT(*) AS FilasSinMiddleName
FROM Person.Person
WHERE MiddleName IS NOT NULL;

-- 9.	Usando Production.Product encontrar cuántos productos están asociados con cada color. 
-- Ignorar las filas donde el color no tenga datos (NULL). Luego de agruparlos, devolver sólo los colores que tienen al menos 20 productos en ese color.
SELECT 
	Color, 
	COUNT(*) AS CantidadProductos
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
HAVING COUNT(*) >= 20;

-- 10.	Hacer un join entre Production.Product y Production.ProductInventory sólo cuando los productos aparecen en ambas tablas. 
-- Hacerlo sobre el ProductID. Production.ProductInventory tiene la cantidad de cada producto, si se vende cada producto con un ListPrice mayor a cero, 
-- ¿cuánto fue el total facturado? 
SELECT 
	SUM(producto.ListPrice * inventario.Quantity) AS TotalFacturado
FROM Production.Product AS producto
INNER JOIN Production.ProductInventory AS inventario 
ON producto.ProductID = inventario.ProductID
WHERE producto.ListPrice > 0;

-- 11.	Traer FirstName y LastName de Person.Person. Crear una tercera columna donde se lea “Promo 1” si el EmailPromotion es 0, 
-- “Promo 2” si el valor es 1 o “Promo 3” si es 2
SELECT 
	FirstName, 
	LastName,
	CASE 
		WHEN EmailPromotion = 0 THEN 'Promo 1'
		WHEN EmailPromotion = 1 THEN 'Promo 2'
		WHEN EmailPromotion = 2 THEN 'Promo 3'
		ELSE 'Otro'
	END AS PromotionType
FROM Person.Person;

-- 12.	Traer el BusinessEntityID y SalesYTD de Sales.SalesPerson, juntarla con Sales.SalesTerritory de tal manera que Sales.SalesPerson 
-- devuelva valores aunque no tenga asignado un territorio. Traes el nombre de Sales.SalesTerritory.
SELECT 
	SP.BusinessEntityID, 
	SP.SalesYTD, 
	ST.Name AS TerritoryName
FROM Sales.SalesPerson AS SP
LEFT JOIN Sales.SalesTerritory AS ST 
ON SP.TerritoryID = ST.TerritoryID;

-- 13.	Usando el ejemplo anterior, vamos a hacerlo un poco más complejo. Unir Person.Person para traer también el nombre y apellido. 
-- Sólo traer las filas cuyo territorio sea “Northeast” o “Central”.
SELECT 
	P.FirstName, 
	P.LastName, 
	SP.BusinessEntityID, 
	SP.SalesYTD, 
	ST.Name AS TerritoryName
FROM Person.Person AS P
LEFT JOIN Sales.SalesPerson AS SP 
ON P.BusinessEntityID = SP.BusinessEntityID
LEFT JOIN Sales.SalesTerritory AS ST 
ON SP.TerritoryID = ST.TerritoryID
WHERE ST.Name IN ('Northeast', 'Central');

-- 14.	Usando Person.Person y Person.Password hacer un INNER JOIN trayendo FirstName, LastName y PasswordHash.
SELECT 
	P.FirstName, 
	P.LastName, 
	PP.PasswordHash
FROM Person.Person AS P
INNER JOIN Person.Password AS PP 
ON P.BusinessEntityID = PP.BusinessEntityID;

-- 15.	Traer el título de Person.Person. Si es NULL devolver “No hay título”.
SELECT 
	FirstName, 
	LastName,
	CASE
		WHEN Title IS NULL THEN 'No hay titulo' 
		Else Title 
	END AS Title
FROM Person.Person;
-- O
SELECT 
	FirstName, 
	LastName,
	ISNULL(Title, 'No hay titulo') AS Title -- notar que no me permite agregar más de 8 caracteres de esta forma por las caracteristicas de la columna
FROM Person.Person;

-- 16.	Si MiddleName es NULL devolver FirstName y LastName concatenados, con un espacio de por medio. 
-- Si MiddeName no es NULL devolver FirstName, MiddleName y LastName concatenados, con espacios de por medio.
SELECT 
	FirstName, 
	MiddleName,
	LastName,
    CASE 
        WHEN MiddleName IS NULL THEN CONCAT(FirstName, ' ', LastName)
        ELSE CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
    END AS FullName
FROM Person.Person;

-- 17.	Usando Production.Product si las columnas MakeFlag y FinishedGoodsFlag son iguales, que devuelva NULL. 
-- En caso contrario devolver ambos valores concatenados.
SELECT 
    CASE
        WHEN MakeFlag = FinishedGoodsFlag THEN NULL
        ELSE CONCAT(MakeFlag,' ', FinishedGoodsFlag)
    END AS Result
FROM Production.Product;

-- 18.	Usando Production.Product si el valor en color es NULL devolver “Sin color”. Si el color sí está, devolver el color. Se puede hacer de por lo menos dos maneras, desarrollar ambas (buscar funciones ISNULL y COALESCE).
-- Usando CASE
SELECT 
    CASE
        WHEN Color IS NULL THEN 'Sin Color'
        ELSE Color
    END AS Result
FROM Production.Product;
-- Usando ISNULL
SELECT ISNULL(Color, 'Sin color') AS Color
FROM Production.Product;

-- Usando COALESCE
SELECT COALESCE(Color, 'Sin color') AS Color
FROM Production.Product;