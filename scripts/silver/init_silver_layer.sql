/*
===============================================================
    Script Name  : init_silver_layer.sql
    Purpose      : Create the Silver layer tables for RetailSourceDB.
    Description  :
        - Drops existing Silver layer tables if they exist.
        - Creates cleaned and structured Silver layer tables:
            * CustomerAddress
            * IndividualCustomer
            * Product
            * ProductCategory
            * ProductSubCategory
            * SalesOrderDetail
            * SalesOrderHeader
            * SalesPerson
            * SalesTerritory

    Usage        :
        - Execute after creating and loading Bronze layer tables.
        - Run before inserting transformed data into the Silver layer.
===============================================================
*/



-- CustomerAddress
IF OBJECT_ID('silver.CustomerAddress', 'U') IS NOT NULL
    DROP TABLE silver.CustomerAddress;

CREATE TABLE silver.CustomerAddress (
    CustomerID INT NOT NULL,
    AddressType NVARCHAR(50),
    AddressLine1 NVARCHAR(255),
    AddressLine2 NVARCHAR(255),
    City NVARCHAR(100),
    StateProvinceName NVARCHAR(100),
    PostalCode NVARCHAR(20),
    CountryRegionName NVARCHAR(100)
);

-- IndividualCustomer
IF OBJECT_ID('silver.IndividualCustomer', 'U') IS NOT NULL
    DROP TABLE silver.IndividualCustomer;

CREATE TABLE silver.IndividualCustomer (
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50),
    MiddleName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(10),
    PhoneNumber NVARCHAR(20),
    PhoneNumberType NVARCHAR(20),
    EmailAddress NVARCHAR(100),
    EmailPromotion INT
);

-- Product
IF OBJECT_ID('silver.Product', 'U') IS NOT NULL
    DROP TABLE silver.Product;

CREATE TABLE silver.Product (
    ProductID INT NOT NULL,
    Name NVARCHAR(100),
    ProductNumber NVARCHAR(50),
    MakeFlag BIT,
    FinishedGoodsFlag BIT,
    Color NVARCHAR(50),
    SafetyStockLevel INT,
    ReorderPoint INT,
    StandardCost DECIMAL(18,2),
    ListPrice DECIMAL(18,2),
    Size NVARCHAR(20),
    SizeUnitMeasureCode NVARCHAR(10),
    Weight DECIMAL(18,2),
    WeightUnitMeasureCode NVARCHAR(10),
    ProductSubCategoryID INT
);

-- ProductCategory
IF OBJECT_ID('silver.ProductCategory', 'U') IS NOT NULL
    DROP TABLE silver.ProductCategory;

CREATE TABLE silver.ProductCategory (
    ProductCategoryID INT NOT NULL,
    Name NVARCHAR(100),
    ModifiedDate DATETIME
);

-- ProductSubCategory
IF OBJECT_ID('silver.ProductSubCategory', 'U') IS NOT NULL
    DROP TABLE silver.ProductSubCategory;

CREATE TABLE silver.ProductSubCategory (
    ProductSubCategoryID INT NOT NULL,
    ProductCategoryID INT,
    Name NVARCHAR(100),
    ModifiedDate DATETIME
);

-- SalesOrderDetail
IF OBJECT_ID('silver.SalesOrderDetail', 'U') IS NOT NULL
    DROP TABLE silver.SalesOrderDetail;

CREATE TABLE silver.SalesOrderDetail (
    SalesOrderDetailID INT NOT NULL,
    SalesOrderID INT,
    CarrierTrackingNumber NVARCHAR(50),
    OrderQTY INT,
    ProductID INT,
    UnitPriceDiscount DECIMAL(18,2),
    LineTotal DECIMAL(18,2),
    ModdifiedDate DATETIME
);

-- SalesOrderHeader
IF OBJECT_ID('silver.SalesOrderHeader', 'U') IS NOT NULL
    DROP TABLE silver.SalesOrderHeader;

CREATE TABLE silver.SalesOrderHeader (
    SalesOrderID INT NOT NULL,
    OrderDate DATETIME,
    DueDate DATETIME,
    ShipDate DATETIME,
    SalesOrderNumber NVARCHAR(50),
    PurchaseOrderNumber NVARCHAR(50),
    AccountNumber NVARCHAR(50),
    CustomerID INT,
    SalesPersonID INT,
    TerritoryID INT,
    SubTotal DECIMAL(18,2),
    TaxAmt DECIMAL(18,2),
    Freight DECIMAL(18,2),
    TotalDue DECIMAL(18,2),
    ModifiedDate DATETIME
);

-- SalesPerson
IF OBJECT_ID('silver.SalesPerson', 'U') IS NOT NULL
    DROP TABLE silver.SalesPerson;

CREATE TABLE silver.SalesPerson (
    BusinessEntityID INT NOT NULL,
    TerritoryID INT,
    SalesQuota DECIMAL(18,2),
    Bonus DECIMAL(18,2),
    CommissionPct DECIMAL(5,4),
    SalesYTD DECIMAL(18,2),
    SalesLastYear DECIMAL(18,2)
);

-- SalesTerritory
IF OBJECT_ID('silver.SalesTerritory', 'U') IS NOT NULL
    DROP TABLE silver.SalesTerritory;

CREATE TABLE silver.SalesTerritory (
    TerritoryID INT NOT NULL,
    Name NVARCHAR(100),
    CountryRegionCode NVARCHAR(10),
    RegionGroup NVARCHAR(50)
);
