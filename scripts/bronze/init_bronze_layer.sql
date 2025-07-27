/*
===============================================================
    Script Name   : bronze_table_creation.sql
    Purpose       : Defines and creates all base (bronze layer) 
                    staging tables in the DataWarehouse database.
                    
    Description   :
        - Drops existing bronze tables if they exist.
        - Creates raw, uncleaned staging tables for the following entities:
            • IndividualCustomer
            • Product
            • ProductCategory
            • ProductSubCategory
            • SalesOrderDetail
            • SalesOrderHeader
            • SalesPerson
            • SalesTerritory
            • CustomerAddress
===============================================================
*/


--USE DataWarehouse;
GO

-- Ensure bronze schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

-- ===========================
-- IndividualCustomer
-- ===========================
IF OBJECT_ID('bronze.IndividualCustomer', 'U') IS NOT NULL
    DROP TABLE bronze.IndividualCustomer;

CREATE TABLE bronze.IndividualCustomer (
    CustomerID INT,
    Title NVARCHAR(8),
    FirstName NVARCHAR(50),
    MiddleName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(1),
    PhoneNumber NVARCHAR(25),
    PhoneNumberType NVARCHAR(50),
    EmailAddress NVARCHAR(50),
    EmailPromotion INT
);


-- ===========================
-- Product
-- ===========================
IF OBJECT_ID('bronze.Product', 'U') IS NOT NULL
    DROP TABLE bronze.Product;

CREATE TABLE bronze.Product (
    ProductID INT,
    Name NVARCHAR(50),
    ProductNumber NVARCHAR(25),
    MakeFlag BIT,
    FinishedGoodsFlag BIT,
    Color NVARCHAR(15),
    SafetyStockLevel SMALLINT,
    ReorderPoint SMALLINT,
    StandardCost MONEY,
    ListPrice MONEY,
    Size NVARCHAR(5),
    SizeUnitMeasureCode NCHAR(3),
    Weight DECIMAL(8,2),
    WeightUnitMeasureCode NCHAR(3),
    ProductSubCategoryID INT
);

-- ===========================
-- ProductCategory
-- ===========================
IF OBJECT_ID('bronze.ProductCategory', 'U') IS NOT NULL
    DROP TABLE bronze.ProductCategory;

CREATE TABLE bronze.ProductCategory (
    ProductCategoryID INT,
    Name NVARCHAR(50),
    ModifiedDate DATETIME
);
-- ===========================
-- ProductSubCategory
-- ===========================
IF OBJECT_ID('bronze.ProductSubCategory', 'U') IS NOT NULL
    DROP TABLE bronze.ProductSubCategory;

CREATE TABLE bronze.ProductSubCategory (
    ProductSubCategoryID INT,
    ProductCategoryID INT,
    Name NVARCHAR(50),
    ModifiedDate DATETIME
);

-- ===========================
-- SalesOrderDetail
-- ===========================
IF OBJECT_ID('bronze.SalesOrderDetail', 'U') IS NOT NULL
    DROP TABLE bronze.SalesOrderDetail;

CREATE TABLE bronze.SalesOrderDetail (
    SalesOrderID INT,
    SalesOrderDetailsID INT,
    CarrierTrackingNumber NVARCHAR(25),
    OrderQty INT,
    ProductID INT,
    UnitPrice MONEY,
    UnitPriceDiscount MONEY,
    LineTotal NUMERIC(38,6),
    ModifiedDate DATETIME
);
/*
ETL Suggestions:
- Verify that LineTotal = (UnitPrice - Discount) * Qty.
- Check for negative prices or quantities.
- Ensure foreign key to Product and SalesOrderHeader.
*/

-- ===========================
-- SalesOrderHeader
-- ===========================
IF OBJECT_ID('bronze.SalesOrderHeader', 'U') IS NOT NULL
    DROP TABLE bronze.SalesOrderHeader;

CREATE TABLE bronze.SalesOrderHeader (
    SalesOrderID INT,
    OrderDate DATETIME,
    DueDate DATETIME,
    ShipDate DATETIME,
    SalesOrderNumber NVARCHAR(25),
    PurchaseOrderNumber NVARCHAR(25),
    AccountNumber NVARCHAR(15),
    CustomerID INT,
    SalesPersonID INT,
    TerritoryID INT,
    SubTotal MONEY,
    TaxAmt MONEY,
    Freight MONEY,
    TotalDue MONEY,
    ModifiedDate DATETIME
);
-- ===========================
-- SalesPerson
-- ===========================
IF OBJECT_ID('bronze.SalesPerson', 'U') IS NOT NULL
    DROP TABLE bronze.SalesPerson;

CREATE TABLE bronze.SalesPerson (
    BusinessEntityID INT,
    TerritoryID INT,
    SalesQuota MONEY,
    Bonus MONEY,
    CommissionPct SMALLMONEY,
    SalesYTD MONEY,
    SalesLastYear MONEY
);

-- ===========================
-- SalesTerritory
-- ===========================
IF OBJECT_ID('bronze.SalesTerritory', 'U') IS NOT NULL
    DROP TABLE bronze.SalesTerritory;

CREATE TABLE bronze.SalesTerritory (
    TerritoryID INT,
    Name NVARCHAR(50),
    CountryRegionCode NVARCHAR(3),
    RegionGroup NVARCHAR(50)
);

-- ===========================
-- CustomerAddress
-- ===========================
IF OBJECT_ID('bronze.CustomerAddress', 'U') IS NOT NULL
    DROP TABLE bronze.CustomerAddress;

CREATE TABLE bronze.CustomerAddress (
    CustomerID INT,
    AddressType NVARCHAR(50),
    AddressLine1 NVARCHAR(50),
    AddressLine2 NVARCHAR(50),
    City NVARCHAR(50),
    StateProvinceName NVARCHAR(50),
    PostalCode NVARCHAR(50),
    CountryRegionName NVARCHAR(50)
);
