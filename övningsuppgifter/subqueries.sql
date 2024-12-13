/*------------------------------------------------------------------
Här är extra övningsuppgifter i SQL. I en del uppgifter finns det redan queries definierade - de är till för att ge en bakgrund till uppgiften. Kör dem, inspektera resultaten och använd dem som ledtrådar för att komma fram till lösningen.

OBS: Övningsuppgifterna behöver inte lämnas in!
------------------------------------------------------------------*/

USE AdventureWorks2022;
GO

/*------------------------------------------------------------------
SUBQUERIES
Bakgrund: Om vi kollar i Sales.SalesOrderDetail kan vi se att samma produkt kostar olika mycket vid olika tillfällen.

Query 1 nedan listar alla produkter som sålts och hur många unika priser de sålts för.

Query 2 kollar vilka olika priser produkten med id 708 har sålts för.

Uppgift 1: Använd en subquery för att ta fram ProductID, SalesOrderID och en kolumn som heter MaxUnitPrice som innehåller det högsta priset en produkt sålts för.
------------------------------------------------------------------*/
-- 1
SELECT 
    ProductID
    ,COUNT(DISTINCT UnitPrice) AS Prices
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY Prices DESC;

-- 2
SELECT DISTINCT
    ProductID
    ,UnitPrice
FROM Sales.SalesOrderDetail
WHERE ProductID = 708;

/*------------------------------------------------------------------
Uppgift 2: Bygg vidare på uppgift 1. Använd en JOIN för att ta reda på vilket datum produkten kostade som mest. 

Ledtråd: Kolumnen OrderDate finns i tabellen SalesOrderHeader.
------------------------------------------------------------------*/



/*------------------------------------------------------------------
Vi kan köra en subquery inuti en annan subquery.

Uppgift 3a: Använd subqueries för att ta fram för- och efternamn på alla anställda som arbetar som försäljare.

Uppgift 3b: Utför samma query men använd JOINS istället för subqueries.

Hint: Använd tabellerna Person.Person, HumanResources.Employee och Sales.SalesPerson.
------------------------------------------------------------------*/
