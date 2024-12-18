
/*---------------------------------------------------------
In this code exercises we are going to practice 
some T-SQL queries based on the AdventureWorks2022 database. 

Have fun! 
---------------------------------------------------------*/

USE AdventureWorks2022;
GO

/*---------------------------------------------------------
Explain what the code below does.
It is very useful to explore for instance what tables
you can join together when exploring a database. 
---------------------------------------------------------*/

/*---------------------------------------------------------
We can break down the query into smaller pieces to try to understand it better.

The sys-schema contains metadata ("data about data") about the database, such as table and column names, data types and other information.

The SCHEMA_NAME()-function takes a schema id as an argument and returns the name of the schema. This is combined with the name of the table to form the Schema.TableName-format.

The tables sys.columns and sys.tables are joined on the object_id-column and the results are filtered to only show the tables that have a column that contains the string "BusinessEntityID".
---------------------------------------------------------*/

SELECT [name] FROM sys.columns;
SELECT * FROM sys.tables;
SELECT (SCHEMA_NAME(B.schema_id)) + '.' + B.name from sys.tables as B;

SELECT A.name AS ColumnName, 
	(SCHEMA_NAME(B.schema_id) + '.' + B.name) AS 'TableName'
FROM sys.columns AS A 
INNER JOIN sys.tables AS B
	ON A.object_id = B.object_id
WHERE A.name LIKE '%BusinessEntityID%'
ORDER BY TableName, ColumnName;

/*---------------------------------------------------------
1. Inspect the table Sales.SalesOrderHeader.
2. We are going to look at "Top Sales", select the columns
SalesOrderID, ShipDate, TotalDue. 
You want to sort the data so the higest TotalDue comes first. 
What is the higest order amount and when was it shipped?
3. Exactly the same as question 2 but only select the TOP 10 
rows. 
---------------------------------------------------------*/
-- 1 Inspection 
SELECT * FROM Sales.SalesOrderHeader;

-- 2
SELECT 
    SalesOrderID, 
    ShipDate, 
    TotalDue 
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- 3
SELECT TOP 10 
    SalesOrderId,
	ShipDate,
    TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


/*---------------------------------------------------------
1. Inspect the two tables Person.Person and Sales.SalesPerson. 
2. We are going to look at "Seller Statistics"
containing the columns
A.BusinessEntityID, A.FirstName, A.LastName, B.CommissionPCT, 
B.SalesYTD, B.SalesLastYear from the two tables Person.Person (as A)
and Sales.SalesPerson (as B). Order the table so that those who had higest
sales last year are at the top of the table. Keep the ten persons
who sold most. 

- Look up what is meant by SalesYTD. 

Hint: You should use a join to get columns 
from two different tables. 

3. Do the same thing as in question 2, but remove the 
"TOP 10" part and instead use a "WHERE" statement to filter
out the salespeople who sold for less than 5,000,000 and
order it in ascending order by using the column SalesLastYear.
---------------------------------------------------------*/

-- 1 "Inspect" usually means "run a SELECT * FROM".
SELECT * FROM Person.Person;
SELECT * FROM Sales.SalesPerson;

-- 2
SELECT TOP 10
	A.BusinessEntityID,
	A.FirstName,
	A.LastName,
	B.CommissionPct,
	B.SalesYTD,
	B.SalesLastYear
FROM Person.Person AS A
INNER JOIN Sales.SalesPerson AS B ON A.BusinessEntityID = B.BusinessEntityID
ORDER BY B.SalesLastYear DESC
;

-- 3 The 5,000,000 number is admittedly a little strange, as no one has sold for that kind of money. Feel free to change it to something lower, like 1,500,000 or so to see the filtering in action!
SELECT
	A.BusinessEntityID,
	A.FirstName,
	A.LastName,
	B.CommissionPct,
	B.SalesYTD,
	B.SalesLastYear
FROM Person.Person AS A
INNER JOIN Sales.SalesPerson AS B ON A.BusinessEntityID = B.BusinessEntityID
WHERE B.SalesLastYear < 1500000
ORDER BY B.SalesLastYear
;


/*---------------------------------------------------------
1. Inspect the table Sales.SalesTerritory.
2. We are going to look at "Sales by group" that has two columns, 
"Group" and how much you sold in total for that group, call this
column TotalSales.
- Hint: You should use a GROUP BY statement. 
- Note, when refeering to the Group column, write [Group] 
since "Group" is a reserved word in SQL.
---------------------------------------------------------*/
-- 1
SELECT * FROM Sales.SalesTerritory;

-- 2 Learning by doing wrong: this will generate an error as we have to define what to do with the values that are not being grouped by.
SELECT [Group], SalesLastYear AS TotalSales
FROM Sales.SalesTerritory
GROUP BY [Group]
ORDER BY TotalSales DESC
; 

-- Here, we clarify that we wish to SUM() the SalesLastYear column. This is called an aggregation function.
SELECT [Group], SUM(SalesLastYear) AS TotalSales
FROM Sales.SalesTerritory
GROUP BY [Group]
ORDER BY TotalSales DESC
; 

-- Another aggregation function is AVG(), which returns the average over the groups instead of the sum.
SELECT [Group], AVG(SalesLastYear + SalesYTD) AS AvgSales
FROM Sales.SalesTerritory
GROUP BY [Group]
ORDER BY AvgSales DESC
; 

/*---------------------------------------------------------
Below we create a new table "Person.MyPersonPhoneTable",
this is useful if for instance
colleagues in your organization also are interested in some 
data that you are transforming and saving in a table. 

Look at the code, do you understand what it does?

(Also please avoid creating tables that only copies data as this will make the database more difficult to maintain.)
---------------------------------------------------------*/


SELECT * FROM Person.Person;
SELECT * FROM Person.PersonPhone;

SELECT A.FirstName, 
       A.LastName,
       B.PhoneNumber
INTO Person.MyPersonPhoneTable
FROM Person.Person as A
INNER JOIN Person.PersonPhone as B
    ON A.BusinessEntityID = B.BusinessEntityID;

SELECT * FROM Person.MyPersonPhoneTable;

-- I will add a "GO" statement in order to create a batch for the CREATE View statement below.
-- More on the GO statement: https://learn.microsoft.com/en-us/sql/t-sql/language-elements/sql-server-utilities-statements-go?view=sql-server-ver16

GO

/*---------------------------------------------------------
Below we do a similar thing as in the example above, 
but now we create a view instead. What is the difference?

Inspiration: 
https://stackoverflow.com/questions/6015175/difference-between-view-and-table-in-sql 
In short, views are often created so many people can access
it without going into the "core data" that fewer people work 
with. 

This is the preferred way to do this operation as the view will automatically update when a phone number is updated in the Person.PersonPhone table.
---------------------------------------------------------*/

CREATE VIEW Person.VMyPersonPhoneTable3
AS
SELECT A.FirstName, 
       A.LastName,
       B.PhoneNumber
FROM Person.Person as A
INNER JOIN Person.PersonPhone as B
    ON A.BusinessEntityID = B.BusinessEntityID;

-- I will add another GO statement to define the CREATE VIEW batch.

GO

SELECT * FROM Person.VMyPersonPhoneTable3;

/*---------------------------------------------------------
Explain what the two code snippets below does. 
---------------------------------------------------------*/

/* Code snippet 1 */
SELECT * FROM HumanResources.Employee; 
SELECT * FROM HumanResources.EmployeeDepartmentHistory; 
SELECT * FROM HumanResources.Department; 

SELECT A.BusinessEntityID, 
	A.JobTitle, 
	B.DepartmentID, 
	C.Name, 
	C.GroupName,
	B.ShiftID, 
	B.StartDate, 
	B.EndDate
FROM HumanResources.Employee as A INNER JOIN HumanResources.EmployeeDepartmentHistory as B
	ON A.BusinessEntityID = B.BusinessEntityID
LEFT JOIN HumanResources.Department as C
	on B.DepartmentID = C.DepartmentID
ORDER BY A.BusinessEntityID;


/* Code snippet 2 */
--We are using something that is called a "Common Table Expression", CTE.

-- Define the CTE expression name and column list.
WITH NBR_CTE (BusinessEntityID, Nbr)
AS
-- Define the CTE query.
(
    SELECT BusinessEntityID, COUNT(BusinessEntityID) Nbr
    FROM HumanResources.EmployeeDepartmentHistory
    GROUP BY BusinessEntityID
)
-- Define the outer query referencing the CTE name.
SELECT A.BusinessEntityID, 
	A.JobTitle,
	C.GroupName,
	C.Name, 		
	B.ShiftID, 
	D.Nbr as NumberOfShifts,
	B.StartDate, 
	B.EndDate
FROM HumanResources.Employee as A 
INNER JOIN HumanResources.EmployeeDepartmentHistory as B
	ON A.BusinessEntityID = B.BusinessEntityID
LEFT JOIN HumanResources.Department as C
	on B.DepartmentID = C.DepartmentID
LEFT JOIN NBR_CTE as D
	ON A.BusinessEntityID = D.BusinessEntityID
ORDER BY NumberOfShifts DESC, A.BusinessEntityID;

/*---------------------------------------------------------
If you have time, do some exploration of 
the Database AdventureWorks2022 and produce some queries 
that you find are interesting. 

Obviously, you will have to do some explorations before
beeing able to produce some queries. 
---------------------------------------------------------*/





