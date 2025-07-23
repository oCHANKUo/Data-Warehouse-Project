/*
===============================================================
    Script Name  : load_silver.sql
    Purpose      : Load cleaned and transformed data into the Silver layer tables.
    Description  :
        - Inserts cleaned data from Bronze layer tables into corresponding Silver layer tables.
        - Handles basic data transformations and cleansing during insertion.

    Usage        :
        - Run after Bronze layer tables are populated..
===============================================================
*/

-- Insert cleaned data into the Silver ProductSubCategory Table
INSERT INTO silver.ProductSubCategory (
    ProductSubCategoryID, 
    ProductCategoryID, 
    ProductSubCategoryName, 
    ModifiedDate)
SELECT
    ProductSubCategoryID,
    ProductCategoryID,
    name,
    CAST(ModifiedDate AS DATE)
FROM bronze.ProductSubCategory;



-- Insert cleaned data into the Silver CustomerAddress Table
INSERT INTO silver.CustomerAddress (
    CustomerID,
    AddressType,
    AddressLine1,
    AddressLine2,
    City,
    StateProvinceName,
    PostalCode,
    CountryRegionName)
SELECT 
    CustomerID,
    AddressType,
    AddressLine1,
    CASE 
        WHEN AddressLine2 = 'NULL' THEN NULL 
        ELSE AddressLine2 
    END AS AddressLine2,
    City,
    StateProvinceName,
    PostalCode,
    CountryRegionName
FROM bronze.CustomerAddress;


-- Insert Cleaned Data into InddividualCustomer Table
INSERT INTO silver.IndividualCustomer(
    CustomerID,
    Title,
    FirstName,
    MiddleName,
    LastName,
    Gender,
    PhoneNumber,
    PhoneNumberType,
    EmailAddress,
    EmailPromotion)
SELECT 
    CustomerID,
    COALESCE(Title, 'N/A') AS Title,
    FirstName,
    COALESCE(MiddleName, 'N/A') AS MiddleName,
    LastName,
    CASE 
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        WHEN Gender IS NULL THEN 'N/A'
        ELSE Gender 
    END AS Gender,
    PhoneNumber,
    PhoneNumberType,
    EmailAddress,
    EmailPromotion
FROM bronze.IndividualCustomer;

-- Insert cleaned data into Product Table
INSERT INTO silver.Product (
    ProductID,
    ProductName,
    ProductNumber,
    MakeFlag,
    FinishedGoodsFlag,
    Color,
    SafetyStockLevel,
    ReorderPoint,
    StandardCost,
    ListPrice,
    Size,
    SizeUnitMeasureCode,
    Weight,
    WeightUnitMeasureCode,
    ProductSubCategoryID
)
SELECT 
	ProductID,
	Name,
	ProductNumber,
	MakeFlag,
	FinishedGoodsFlag,
    CASE 
        WHEN Color = 'Multi' THEN 'Multicolor'
        WHEN Color IS NULL THEN 'N/A'
        ELSE Color
    END AS Color,
	SafetyStockLevel,
	ReorderPoint,
	StandardCost,
	ListPrice,
	COALESCE(Size, 'N/A') AS Size,
    COALESCE(SizeUnitMeasureCode, 'N/A') AS SizeUnitMeasureCode,
	Weight,
	COALESCE(WeightUnitMeasureCode, 'N/A') AS WeightUnitMeasureCode,
	COALESCE(ProductSubCategoryID, -1) AS ProductSubCategoryID
FROM bronze.Product;

-- Insert Cleaned Data into ProductCategory Table
INSERT INTO silver.ProductCategory (
    ProductCategoryID,
    ProductCategoryName,
    ModifiedDate
)
SELECT
    ProductCategoryID,
    TRIM(Name) AS Name,
    CAST(ModifiedDate AS DATE) AS ModifiedDate
FROM bronze.ProductCategory;
