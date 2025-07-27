/*
===============================================================
    Procedure Name : load_bronze
    Purpose        : Truncates and reloads all bronze layer 
                     staging tables from the source database 
                     (CustomerDatabase) into the DataWarehouse.
                     
    Description    :
        - Ensures clean reloads by truncating existing data.
        - Loads raw data into bronze tables:
            • IndividualCustomer
            • Product
            • ProductCategory
            • ProductSubCategory
            • SalesOrderDetail
            • SalesOrderHeader
            • SalesPerson
            • SalesTerritory
            • CustomerAddress
        - Includes basic error handling using TRY...CATCH block.

    Usage          : EXEC load_bronze;
===============================================================
*/


--USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- ================================
        -- Truncate and Load: IndividualCustomer
        -- ================================
        TRUNCATE TABLE bronze.IndividualCustomer;

        INSERT INTO bronze.IndividualCustomer
        SELECT * FROM CustomerDatabase.dbo.IndividualCustomer;

        -- ================================
        -- Truncate and Load: Product
        -- ================================
        TRUNCATE TABLE bronze.Product;

        INSERT INTO bronze.Product
        SELECT * FROM CustomerDatabase.dbo.Product;

        -- ================================
        -- Truncate and Load: ProductCategory
        -- ================================
        TRUNCATE TABLE bronze.ProductCategory;

        INSERT INTO bronze.ProductCategory
        SELECT * FROM CustomerDatabase.dbo.ProductCategory;

        -- ================================
        -- Truncate and Load: ProductSubCategory
        -- ================================
        TRUNCATE TABLE bronze.ProductSubCategory;

        INSERT INTO bronze.ProductSubCategory
        SELECT * FROM CustomerDatabase.dbo.ProductSubCategory;

        -- ================================
        -- Truncate and Load: SalesOrderDetail
        -- ================================
        TRUNCATE TABLE bronze.SalesOrderDetail;

        INSERT INTO bronze.SalesOrderDetail
        SELECT * FROM CustomerDatabase.dbo.SalesOrderDetail;

        -- ================================
        -- Truncate and Load: SalesOrderHeader
        -- ================================
        TRUNCATE TABLE bronze.SalesOrderHeader;

        INSERT INTO bronze.SalesOrderHeader
        SELECT * FROM CustomerDatabase.dbo.SalesOrderHeader;

        -- ================================
        -- Truncate and Load: SalesPerson
        -- ================================
        TRUNCATE TABLE bronze.SalesPerson;

        INSERT INTO bronze.SalesPerson
        SELECT * FROM CustomerDatabase.dbo.SalesPerson;

        -- ================================
        -- Truncate and Load: SalesTerritory
        -- ================================
        TRUNCATE TABLE bronze.SalesTerritory;

        INSERT INTO bronze.SalesTerritory
        SELECT * FROM CustomerDatabase.dbo.SalesTerritory;

        -- ================================
        -- Truncate and Load: CustomerAddress
        -- ================================
        TRUNCATE TABLE bronze.CustomerAddress;

        INSERT INTO bronze.CustomerAddress
        SELECT * FROM CustomerDatabase.dbo.CustomerAddress;

        PRINT 'Bronze layer loaded successfully.';

    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while loading bronze layer.';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
    END CATCH
END;
GO


--EXEC load_bronze;
