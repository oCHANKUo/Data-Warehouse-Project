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



CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        -- Insert cleaned data into the Silver CustomerAddress Table
        TRUNCATE TABLE silver.CustomerAddress;
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
                WHEN AddressLine2 = 'NULL' OR AddressLine2 IS NULL THEN 'N/A'
                ELSE AddressLine2 
            END AS AddressLine2,
            City,
            StateProvinceName,
            PostalCode,
            CountryRegionName
        FROM bronze.CustomerAddress;



        -- Insert Cleaned Data into IndividualCustomer Table
        TRUNCATE TABLE silver.IndividualCustomer;
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
        TRUNCATE TABLE silver.Product;
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
        TRUNCATE TABLE silver.ProductCategory;
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



        -- Insert cleaned data into the Silver ProductSubCategory Table
        TRUNCATE TABLE silver.ProductSubCategory;
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



        -- Insert cleaned data into SalesOrderDetail table
        TRUNCATE TABLE silver.SalesOrderDetail;
        INSERT INTO silver.SalesOrderDetail (
            SalesOrderID,
            SalesOrderDetailID,
            CarrierTrackingNumber,
            OrderQty,
            ProductID,
            UnitPrice,
            UnitPriceDiscount,
            LineTotal,
            ModifiedDate
        )
        SELECT 
            SalesOrderID,
            SalesOrderDetailID,
            COALESCE(TRIM(CarrierTrackingNumber), 'N/A') AS CarrierTrackingNumber,
            OrderQty,
            ProductID,
            UnitPrice,
            UnitPriceDiscount,
            (UnitPrice - UnitPriceDiscount) * OrderQty AS LineTotal,
            CAST(ModifiedDate AS DATE) AS ModifiedDate  
        FROM bronze.SalesOrderDetail;



        --Insert cleaned data into SalesOrderHeader
        TRUNCATE TABLE silver.SalesOrderHeader;
        INSERT INTO silver.SalesOrderHeader (
            SalesOrderID,
            OrderDate,
            DueDate,
            ShipDate,
            SalesOrderNumber,
            PurchaseOrderNumber,
            AccountNumber,
            CustomerID,
            SalesPersonID,
            TerritoryID,
            SubTotal,
            TaxAmt,
            Freight,
            TotalDue,
            ModifiedDate
        )
        SELECT
            SalesOrderId,
            CAST(OrderDate AS DATE) AS OrderDate,
            CAST(DueDate AS DATE) AS DueDate,
            CAST(ShipDate AS DATE) AS ShipDate,
            TRIM(SalesOrderNumber) AS SalesOrderNumber,
            COALESCE(TRIM(PurchaseOrderNumber), 'N/A') AS PurchaseOrderNumber,
            COALESCE(TRIM(AccountNumber), 'N/A') AS AccountNumber,
            CustomerID,
            COALESCE(SalesPersonID, -1) AS SalesPersonID,
            TerritoryID,
            SubTotal,
            TaxAmt,
            Freight,
            SubTotal + TaxAmt + Freight AS TotalDue,       -- recalculate just in case
            CAST(ModifiedDate AS DATE) AS ModifiedDate
        FROM bronze.SalesOrderHeader;



        -- Insert cleaned data into SalesPerson Table
        TRUNCATE TABLE silver.SalesPerson;
        INSERT INTO silver.SalesPerson (
            BusinessEntityID,
            TerritoryID,
            SalesQuota,
            Bonus,
            CommissionPct,
            SalesYTD,
            SalesLastYear
        )   
        SELECT 
            BusinessEntityID,
            COALESCE(TerritoryID, -1) AS TerritoryID,
            COALESCE(SalesQuota, 0.00) AS SalesQuota,
            Bonus,
            CommissionPct,
            SalesYTD,
            SalesLastYear
        FROM bronze.SalesPerson;



        -- Insert cleaned data into SalesTearritory
        TRUNCATE TABLE silver.SalesTerritory;
        INSERT INTO silver.SalesTerritory (
            TerritoryID,
            TerritoryName,
            CountryRegionCode,
            RegionGroup
        )
        SELECT
            TerritoryID,
            TRIM(Name) AS Name,
            TRIM(CountryRegionCode) AS CountryRegionCode,
            TRIM(RegionGroup) AS RegionGroup
        FROM bronze.SalesTerritory;

         PRINT 'silver.load_silver completed successfully.';

    END TRY

    BEGIN CATCH
        PRINT 'Error occurred in silver.load_silver:';
        PRINT ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
    END CATCH

END;

--EXEC silver.load_silver;
