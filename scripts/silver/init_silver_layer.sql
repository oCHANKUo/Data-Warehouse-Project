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
    AddressLine1 NVARCHAR(50),
    AddressLine2 NVARCHAR(50),
    City NVARCHAR(50),
    StateProvinceName NVARCHAR(50),
    PostalCode NVARCHAR(50),
    CountryRegionName NVARCHAR(50)
);



-- IndividualCustomer
IF OBJECT_ID('silver.IndividualCustomer', 'U') IS NOT NULL
    DROP TABLE silver.IndividualCustomer;

CREATE TABLE silver.IndividualCustomer (
    CustomerID INT NOT NULL,
    FirstName NVARCHAR(50),
    Title NVARCHAR(50),
    MiddleName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(10),
    PhoneNumber NVARCHAR(25),
    PhoneNumberType NVARCHAR(50),
    EmailAddress NVARCHAR(50),
    EmailPromotion INT
);



-- Product
IF OBJECT_ID('silver.Product', 'U') IS NOT NULL
    DROP TABLE silver.Product;

CREATE TABLE silver.Product (
    ProductID INT NOT NULL,
    ProductName NVARCHAR(50),
    ProductNumber NVARCHAR(25),
    MakeFlag BIT,
    FinishedGoodsFlag BIT,
    Color NVARCHAR(15),
    SafetyStockLevel INT,
    ReorderPoint INT,
    StandardCost MONEY,
    ListPrice MONEY,
    Size NVARCHAR(5),
    SizeUnitMeasureCode NVARCHAR(5),
    Weight DECIMAL(8,2),
    WeightUnitMeasureCode NVARCHAR(3),
    ProductSubCategoryID INT
);



-- ProductCategory
IF OBJECT_ID('silver.ProductCategory', 'U') IS NOT NULL
    DROP TABLE silver.ProductCategory;

CREATE TABLE silver.ProductCategory (
    ProductCategoryID INT NOT NULL,
    ProductCategoryName NVARCHAR(50),
    ModifiedDate DATE
);



-- ProductSubCategory
IF OBJECT_ID('silver.ProductSubCategory', 'U') IS NOT NULL
    DROP TABLE silver.ProductSubCategory;

CREATE TABLE silver.ProductSubCategory (
    ProductSubCategoryID INT NOT NULL,
    ProductCategoryID INT,
    ProductSubCategoryName NVARCHAR(50),
    ModifiedDate DATE
);
GO
--Insert a Uncategorized row to handle uncategorized product items
INSERT INTO silver.ProductSubCategory (
    ProductSubCategoryID,
    ProductCategoryID,
    ProductSubCategoryName,
    ModifiedDate
) VALUES (
    -1,
    -1,
    'Uncategorized',
    GETDATE()
);



-- SalesOrderDetail
IF OBJECT_ID('silver.SalesOrderDetail', 'U') IS NOT NULL
    DROP TABLE silver.SalesOrderDetail;

CREATE TABLE silver.SalesOrderDetail (
    SalesOrderDetailID INT NOT NULL,
    SalesOrderID INT,
    CarrierTrackingNumber NVARCHAR(25),
    OrderQTY INT,
    ProductID INT,
    UnitPrice MONEY,
    UnitPriceDiscount MONEY,
    LineTotal DECIMAL(18,2),
    ModifiedDate DATE
);



-- SalesOrderHeader
IF OBJECT_ID('silver.SalesOrderHeader', 'U') IS NOT NULL
    DROP TABLE silver.SalesOrderHeader;

CREATE TABLE silver.SalesOrderHeader (
    SalesOrderID INT NOT NULL,
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,
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
    ModifiedDate DATE
);



-- SalesPerson
IF OBJECT_ID('silver.SalesPerson', 'U') IS NOT NULL
    DROP TABLE silver.SalesPerson;

CREATE TABLE silver.SalesPerson (
    BusinessEntityID INT NOT NULL,
    TerritoryID INT,
    SalesQuota MONEY,
    Bonus MONEY,
    CommissionPct MONEY,
    SalesYTD MONEY,
    SalesLastYear MONEY
);
GO
-- Insert Unassigned sales person to handle 'salesperson = NULL' sales order records
INSERT INTO silver.SalesPerson (
    BusinessEntityID,
    TerritoryID,
    SalesQuota,
    Bonus,
    CommissionPct,
    SalesYTD,
    SalesLastYear
)   
VALUES (
    -1,         
    -1,       
    0.00,        
    0.00,        
    0.0000,      
    0.00,        
    0.00         
);



-- SalesTerritory
IF OBJECT_ID('silver.SalesTerritory', 'U') IS NOT NULL
    DROP TABLE silver.SalesTerritory;

CREATE TABLE silver.SalesTerritory (
    TerritoryID INT NOT NULL,
    TerritoryName NVARCHAR(50),
    CountryRegionCode NVARCHAR(10),
    RegionGroup NVARCHAR(50)
);
GO
-- Handling Unassigned
INSERT INTO silver.SalesTerritory (TerritoryID, TerritoryName, CountryRegionCode, RegionGroup)
VALUES 
    (-1, 'Unassigned', 'N/A', 'Unassigned');

