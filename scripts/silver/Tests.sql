
-- ProductSubCategory table
SELECT TOP 1000 * FROM bronze.ProductSubCategory;
-- Check for Nulls or Duplicates of the Primary Key
-- ProductSubCategory Table
SELECT ProductSubCategoryID, COUNT(*) AS DuplicateCount
FROM bronze.ProductSubCategory
GROUP BY ProductSubCategoryID
HAVING COUNT(*) > 1 OR ProductSubcategoryID IS NULL;

SELECT COUNT(*) AS NullCount
FROM bronze.ProductSubCategory
WHERE ProductSubCategoryID IS NULL;

-- Check for Unwanted Spaces
SELECT name FROM bronze.ProductSubCategory
WHERE name != TRIM(name);
-- =================================


-- CustomerAddress Table
SELECT TOP 1000 * FROM bronze.CustomerAddress;
-- Checking for duplicates and null values
SELECT COUNT(*) 
FROM bronze.CustomerAddress 
WHERE AddressLine2 = 'NULL'; --Change this to actual Null values
-- ===============================


-- IndividualCustomer Table
SELECT TOP 1000 * FROM bronze.IndividualCustomer

--Check for NULL values
-- Standarize Title, MiddleName, Gender
SELECT COUNT(*) 
FROM bronze.IndividualCustomer 
WHERE Title IS NULL;

SELECT COUNT(*) 
FROM bronze.IndividualCustomer 
WHERE MiddleName IS NULL;

SELECT COUNT(*) 
FROM bronze.IndividualCustomer 
WHERE Gender IS NULL;

-- Distinct Values
SELECT DISTINCT Gender 
FROM bronze.IndividualCustomer;
-- =================================



-- Product Table
SELECT * FROM bronze.Product;
-- Check distinct Color values
SELECT DISTINCT Color FROM bronze.Product;

-- Check distinct WeightUnitMeasureCode values
SELECT DISTINCT ProductSubcategoryID FROM bronze.Product;
-- =======================================================


-- ProductCategory Table
SELECT * FROM bronze.ProductCategory;
-- Change DATETIME to Date
-- ==================================


-- SalesOrderDetail Table
SELECT * FROM bronze.SalesOrderDetail;
-- Check NULL
SELECT COUNT(*) AS NullCount
FROM bronze.SalesOrderDetail
WHERE CarrierTrackingNumber IS NULL;

-- Handle Modified Datetime to date
-- Check if the LineTotal is correct
SELECT *,
       (UnitPrice - UnitPriceDiscount) * OrderQty AS ExpectedLineTotal
FROM bronze.SalesOrderDetail    
WHERE ABS(LineTotal - ((UnitPrice - UnitPriceDiscount) * OrderQty)) > 0.01;



-- Sales Order Header Table
SELECT * FROM bronze.SalesOrderHeader;



-- Sales Person Table
SELECT * FROM bronze.SalesPerson
-- Check NULL
SELECT COUNT(*) AS NullCount
FROM bronze.SalesPerson
WHERE SalesLastYear IS NULL;
