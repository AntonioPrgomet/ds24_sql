-- Window functions

USE DatabasBok;
GO

-- PARTITION BY

SELECT
    CategoryID,
    ProductName,
    Price,
    AVG(Price) OVER 
        (PARTITION BY CategoryID) AS AvgPricePerCategory
FROM
    Products;

-- ORDER BY
-- By default, if ORDER BY is supplied then the frame consists of 
-- all rows from the start of the partition up through the current row, 
-- plus any following rows that are equal to the current row according to the ORDER BY clause.

SELECT
    CategoryID,
    ProductName,
    Price,
    AVG(Price) 
        OVER 
            (   
                PARTITION BY CategoryID 
                ORDER BY Price
            ) 
        AS CumulativeAvgPricePerCategory
FROM
    Products;

SELECT((499+699)/2)

SELECT((499+699+699)/3)

-- ROWS delar upp ytterligare utifrån rader

SELECT
    CategoryID,
    ProductName,
    Price,
    AVG(Price) 
        OVER 
            (   
                PARTITION BY CategoryID 
                ORDER BY Price
                ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
            ) 
        AS CumulativeAvgPricePerCategory
FROM
    Products;

-- RANGE delar upp på värden. Läs mer på https://learnsql.com/blog/range-clause/

-- RANK() kan också användas med OVER()

SELECT
    CategoryID,
    ProductName,
    Price,
    RANK() 
        OVER 
            (   
                PARTITION BY CategoryID 
                ORDER BY Price DESC
            ) 
        AS PriceRankInCategory
FROM
    Products;

-- Exempel från min egna kunskapskontroll

USE AdventureWorks2022;
GO

SELECT DISTINCT A.BusinessEntityID
    ,A.Gender
    ,A.JobTitle
    ,C.Department
    ,MAX(D.Rate)
        OVER(   PARTITION BY   A.BusinessEntityID
                ORDER BY       D.Rate DESC
            ) EmployeeRate
    ,AVG(D.Rate)
        OVER (PARTITION BY C.Department) DeptAvgRate
FROM HumanResources.Employee A
INNER JOIN HumanResources.vEmployeeDepartment C
    ON A.BusinessEntityID = C.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory D
    ON A.BusinessEntityID = D.BusinessEntityID
GROUP BY A.BusinessEntityID, Department, Rate, Gender, A.JobTitle
ORDER BY DeptAvgRate DESC, EmployeeRate DESC