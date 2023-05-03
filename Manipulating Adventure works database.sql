-- Basic Queries showing the Top N percent and using basic clauses

SELECT CustomerKey as CustomerID, Sum(SalesAmount) as SalesAmount
From FactInternetSales
WHERE YEAR(OrderDate) >2010
Group by CustomerKey
HAVING Sum(SalesAmount) > 10000
ORDER BY SalesAmount DESC

-- for top N 
SELECT Top(10) PERCENT
SalesOrderNumber, 
YEAR(OrderDate) as SalesOrderDate,
sum(SalesAmount) as Sales, 
sum(Freight) as FreightCharge, 
sum(TaxAmt)as TaxAmount,
sum(OrderQuantity) as TotalQuantity,
sum(Freight)+sum(TaxAmt)+sum(SalesAmount) * sum(OrderQuantity) As TotalAmount
FROM FactInternetSales
WHERE SalesTerritoryKey = 6
GROUP BY SalesOrderNumber, OrderDate
HAVING sum(SalesAmount) > 1000
ORDER By TotalAmount Desc


-- using Offset fetch Filter to pick specific rows
SELECT 
SalesOrderNumber, 
YEAR(OrderDate) as SalesOrderDate,
sum(SalesAmount) as Sales, 
sum(Freight) as FreightCharge, 
sum(TaxAmt)as TaxAmount,
sum(OrderQuantity) as TotalQuantity,
sum(Freight)+sum(TaxAmt)+sum(SalesAmount) * sum(OrderQuantity) As TotalAmount
FROM FactInternetSales
WHERE SalesTerritoryKey = 6
--WHERE SalesOrderNumber = 'SO52537'
GROUP BY SalesOrderNumber, OrderDate
HAVING sum(SalesAmount) > 1000
ORDER By TotalAmount Desc
-- Must use order by clause to use the offset fetch
-- offset is best to use compared to top N because it will work in other data bases
OFFSET 2 ROWS FETCH NEXT 100 ROWS ONLY

-- this is to check for duplicates in a data set

Select OrderDate,Productkey ,count (ProductKey) as ProductkeyCount
from FactInternetSales
Group by OrderDate, ProductKey
Having count(ProductKey) > 1


-- to Select Distinct
SELECT DISTINCT CustomerKey
FROM FactInternetSales
ORDER BY CustomerKey

-- Note that the orderby clause can only select from the columns in the distinct column

---- Query to return invoice numbers greaterthan 2000
SELECT SalesOrderNumber,  Sum(TotalProductCost)
FROM FactInternetSales
GROUP BY SalesOrderNumber
HAVING Sum(TotalProductCost) > 2000


--Aggregate Fucntions
SELECT 
Count(*),
 Avg(YearlyIncome), 
 sum(TotalChildren)
From DimCustomer


--using Numeric Functions

SELECT 
SalesOrderNumber, 
YEAR(OrderDate) as SalesOrderDate,
sum(SalesAmount) as Sales, 
sum(Freight) as FreightCharge, 
sum(TaxAmt)as TaxAmount,
Floor(sum(TaxAmt))as TaxAmounts,
--Floor function is used to return the largest interger value that is <= to anumber
-- i.e it returns the interger value without rounding it to the nearest whole number
sum(OrderQuantity) as TotalQuantity,
sum(Freight)+sum(TaxAmt)+sum(SalesAmount) * sum(OrderQuantity) As TotalAmount,
Round(sum(Freight)+sum(TaxAmt)+sum(SalesAmount) * sum(OrderQuantity),1) As TotalAmounts

FROM FactInternetSales

WHERE SalesTerritoryKey = 6
--WHERE SalesOrderNumber = 'SO52537'
GROUP BY SalesOrderNumber, OrderDate
HAVING sum(SalesAmount) > 1000
ORDER By TotalAmount Desc


--Boolean operation
select *
from DimProduct
where FinishedGoodsFlag = 1

-- Query to Filter currency keys
Select SalesOrderNumber, SalesOrderLineNumber, SalesAmount
from FactInternetSales
WHERE CurrencyKey = 100

-- Manipilating date funtions
Select GETDATE() AS DateTimeStamp,
--Getdate ( used for database time stamp
DueDate,
 ShipDate,
 DATEDIFF(Day, ShipDate,DueDate )As daysbtwShipduedate,
  DATEDIFF(hour, ShipDate,DueDate )As hourbtwShipduedate,
  DATEADD(day, 10,DueDate) As DueDateplustendays
  --dateadd function can be used to check for due invoices
 FROM
FactInternetSales


--manipulating specific dates
SELECT
MONTH('20230221') As Monthnumeric
-- setting language
SET LANGUAGE British
SELECT
DATENAME(month,'02/12/2023')


-- query to check serve description 
Select Convert (varchar(256),SERVERPROPERTY('Collation'))
-- CI means the data base is case insenstive
Select *
from DimProduct
where color = 'silver'
Select *
from DimProduct
where color = 'Silver'


-- query using len, upper, lower and upper case
SELECT
EnglishProductName As ProductName,
EnglishDescription As ProductDescription,
CONCAT(EnglishProductName,'-',EnglishDescription),
LEN(EnglishDescription) As LengthOfdescription,
UPPER(EnglishProductName) As UpperEnglishProductName,
LOWER(EnglishProductName) As LowerPRoductName,
REPLACE(EnglishDescription,'Front','Ultra Durable Front') As EnglishProductNamereplaced

 FROM DimProduct
 WHERE ProductKey = 555


-- manipulating data using replace, left, right
SELECT
ProductKey,
productAlternateKey,
EnglishProductName As ProductName,
EnglishDescription As ProductDescription,
CONCAT(EnglishProductName,'-',EnglishDescription),
LEN(EnglishDescription) As LengthOfdescription,
UPPER(EnglishProductName) As UpperEnglishProductName,
LOWER(EnglishProductName) As LowerPRoductName,
REPLACE(EnglishDescription,'Front','Ultra Durable Front') As EnglishProductNamereplaced,
LEFT(ProductAlternateKey,2),
RIGHT(ProductAlternateKey,LEN(ProductAlternateKey)-3)
 FROM DimProduct
 WHERE ProductKey = 555

-- manipulating data using IS NULL
 SELECT *
FROM DimProduct
WHERE Class <> 'H' OR class IS NULL

-- using logical operators with IS NOT Null
SELECT 
EnglishProductName,
EnglishDescription,
Color,
[Status],
Class
FROM DimProduct
WHERE (Class <> 'H' OR class IS NULL) AND [Status] IS NOT NULL
--Logical operators also work like BODMAS, put operators u want evaluated first in brackets

SELECT SalesOrderNumber,
Sum(TotalProductcost) As ProductCost
FROM FactInternetSales
GROUP BY SalesOrderNumber
Having Sum(TotalProductcost) > 2000

SELECT
SalesOrderNumber As InvoiceNumber, 
SalesOrderLineNumber As InvoiceLineNumber,
SalesAmount
FROM FactInternetSales
WHERE CurrencyKey = 100

SELECT Distinct 
SalesterritoryKey
 FROM FactInternetSales
 ORDER BY SalesTerritoryKey ASC

SELECT distinct Finishedgoodsflag from DimProduct
 
 SELECT GETDATE() as datetimestamp,

 DueDate, 
 ShipDate,
 DATEDIFF(day,ShipDate, DueDate ) as DaysBtwShippedAndDue,
 DATEDIFF(YYYY, DueDate,GETDATE() ) as DaysBtwTimestampAndDue
 FROM FactInternetSales

Select Month('2023-03-28')

Select DATEName(Month, 2023/02/28)

SELECT 
ProductAlternateKey,
 EnglishProductName as productName,
EnglishDescription As ProductDescription,
CONCAT(EnglishProductName, '_' , EnglishDescription ) as PRoductNameAndDescription,
LEN(EnglishDescription) as EnglishDescriptionLEngth,
UPPER(EnglishProductName) as productNameUpper,
LOWER(EnglishDescription) as Englishdeslower,
Replace( EnglishProductName , 'Front' , 'Ultar-Modern Front') as EnglishProductNameReplaced,
LEFT (ProductAlternateKey,2) as ProductKeyShort,
RIGHT(ProductAlternateKey,LEN(ProductAlternateKey)-3) as productKeyRight
FROM DimProduct
--where ProductKey = 555

--Using IFF, CASE, LIKE statements
SELECT  
    FirstName,
    MiddleName,
    IIF(MiddleName Is Null, 'UNKNOWN', MiddleName ),
    ISNULL(MiddleName, 'Unknown'),
    Coalesce(MiddleName, 'Unknown'),
    EmailAddress,
    BirthDate,
    YearlyIncome,
    IIF(YearlyIncome> 50000, 'Above Average', 'Below average') as IncomeCategory, 
    DATEDIFF(YYYY, BirthDate,GETDATE()) As Age,CASE 
    WHEN NumberChildrenAtHome = 0 THEN '0'
    WHEN NumberChildrenAtHome = 1 THEN '1'
    WHEN NumberChildrenAtHome BETWEEN 2 AND 4 THEN '2-4'
    WHEN NumberChildrenAtHome >= 5 THEN '5+'
    ELSE 'UNKW'
END As NumberChildrenCategory,
    NumberChildrenAtHome
From DimCustomer
--Where FirstName Like 'R%'

Where IIF(YearlyIncome> 50000, 'Above Average', 'Below average')= 'Above Average'


SELECT
SalesAmount,
Cast(SalesAmount AS INT) As SalesAmountCast,
OrderDate,
CAST (OrderDate As date)As OrderDateCAst
FROM 
FactInternetSales

---Cast function Allows us convert one datatype to another*/
Select 
EnglishProductName,
ReOrderPoint,
SafetyStockLevel,
Cast(ReOrderPoint as decimal(8,4)) / Cast(SafetyStockLevel as Decimal (8,4)) as PercentofReorderpointstocklevel
From DimProduct
where [Status] ='Current'

-- using datename 
SELECT
SalesOrderNumber,
SalesOrderLineNumber,
SalesAmount,
TaxAmt,
OrderDate
From 
FactInternetSales
WHERE DATENAME(MM, OrderDate) ='December' AND SalesTerritoryKey = 1


-- runnning simple CASEWHEN query to filter data
SELECT
firstName,
LastName,
EmailAddress,
NumberCarsOwned,
CASE 
WHEN NumberCarsOwned = 1 THEN '1'  
WHEN NumberCarsOwned Between 2  And 3 THEN '2-3' 
WHEN NumberCarsOwned >= 4 Then '4+' 
Else 'Unkw'
END As  NumberCarsOwnedCategory
From DimCustomer
WHERE NumberCarsOwned > 1

-- joining multiple tables using inner join
select 
Top (100)
Concat(Dc.FirstName, ' ', Dc.LastName) As CustomerName,
Dc.EmailAddress as EmailAddress,
Sum(fs.SalesAmount) as AmountSpent,
DCY.CurrencyName As currency

    from FactInternetSales as fs
    inner join DimCustomer as Dc 
    ON fs.CustomerKey = Dc.CustomerKey
    inner join DimCurrency as DCY 
    ON fs.CurrencyKey = DCY.CurrencyKey

Group by Dc.FirstName, Dc.LastName, Dc.EmailAddress, DCY.CurrencyName
Having DCY.CurrencyName = 'US Dollar'
ORDER By AmountSpent DESC

--marketing team has requested to see products with or without sales with status that is current
select 
Dp.EnglishProductName,
isnull(Dp.color, 0),
IsNULL (Dp.Size,0) as Size,
ISNULL(sum(Fs.SalesAmount),0) as salesamount
/*from FactInternetSales as Fs
Right Join DimProduct as Dp 
On Fs.ProductKey = Dp.ProductKey*/
from DimProduct as Dp 
left JOIN FactInternetSales as Fs
 on Fs.ProductKey = Dp.ProductKey
where [status]  = 'Current'
GROUP by
 Dp.EnglishProductName,
Dp.color,
Dp.Size
ORDER by salesamount DESC



