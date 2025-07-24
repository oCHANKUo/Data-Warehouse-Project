/*
===============================================================
    Procedure Name : gold.load_gold
    Purpose        : Load cleaned and transformed data from the Silver layer
                     into the Gold layer dimensional and fact tables. according to the Star Schema.
                     
    Description    :
        - Truncates and inserts data into Gold layer tables:
          FactSalesOrderDetail, DimCustomer, DimProduct,
          DimSalesPerson, and DimTerritory.
        - Converts dates into integer keys for fact table.
        - Performs necessary joins and data transformations.
        - Includes error handling with TRY-CATCH blocks.
        - Should be run after Gold Layer tables are created
===============================================================
*/



CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY


        -- Insert data into FactSalesOrderDetail table
        TRUNCATE TABLE gold.FactSalesOrderDetail;
        INSERT INTO gold.FactSalesOrderDetail
        SELECT
            sod.SalesOrderDetailID,
            sod.SalesOrderID,
            sod.ProductID,
            soh.CustomerID,
            soh.SalesPersonID,
            soh.TerritoryID,
            CONVERT(INT, FORMAT(soh.OrderDate, 'yyyyMMdd')) AS OrderDateKey,
            CONVERT(INT, FORMAT(soh.DueDate, 'yyyyMMdd')) AS DueDateKey,
            CONVERT(INT, FORMAT(soh.ShipDate, 'yyyyMMdd')) AS ShipDateKey,
            sod.CarrierTrackingNumber,
            sod.OrderQTY,
            sod.UnitPrice,
            sod.UnitPriceDiscount,
            sod.LineTotal,
            soh.Freight,
            soh.TaxAmt,
            soh.TotalDue
        FROM silver.SalesOrderDetail sod
        INNER JOIN silver.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID;
        PRINT 'gold.FactSalesOrderDetail data inserted successfully.';


        -- ============================================



        -- Insert Data to gold.DimCustomer
        TRUNCATE TABLE gold.DimCustomer;
        INSERT INTO gold.DimCustomer 
        SELECT
            ic.CustomerID,
            ic.FirstName,
            ic.LastName,
            ic.Title,
            ic.Gender,
            ic.PhoneNumber,
            ic.EmailAddress,
            ca.AddressType,
            ca.AddressLine1,
            --ca.AddressLine2,
            ca.City,
            ca.StateProvinceName,
            ca.PostalCode,
            ca.CountryRegionName,
            CASE 
                WHEN ic.EmailPromotion = 0 THEN '(0) No Promotion'
                WHEN ic.EmailPromotion = 1 THEN '(1) Promotion'
                WHEN ic.EmailPromotion = 2 THEN '(2) Priority Promotion'
                ELSE 'Unknown'
            END AS EmailPromotionStatus
        FROM silver.IndividualCustomer ic
        LEFT JOIN silver.CustomerAddress ca ON ic.CustomerID = ca.CustomerID;   

        -- Insert data into DimProduct table
        TRUNCATE TABLE gold.DimProduct;
        INSERT INTO gold.DimProduct
        SELECT
            p.ProductID,
            p.ProductName,
            p.ProductNumber,
            p.Color,
            p.Size,
            p.StandardCost,
            p.ListPrice,
            p.Weight,
            pc.ProductCategoryName,
            psc.ProductSubCategoryName
        FROM silver.Product p
        LEFT JOIN silver.ProductSubCategory psc ON p.ProductSubCategoryID = psc.ProductSubCategoryID
        LEFT JOIN silver.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID;
        PRINT 'gold.DimProduct data inserted successfully.';

        -- Insert data into DimSalesPerson table
        TRUNCATE TABLE gold.DimSalesPerson;
        INSERT INTO gold.DimSalesPerson
        SELECT
            BusinessEntityID AS SalesPersonID,
            TerritoryID,
            SalesQuota,
            Bonus,
            CommissionPct,
            SalesYTD,
            SalesLastYear
        FROM silver.SalesPerson;
        PRINT 'gold.DimSalesPerson data inserted successfully.';

        -- Insert data into DimTerritory table
        TRUNCATE TABLE gold.DimTerritory;
        INSERT INTO gold.DimTerritory
        SELECT
            TerritoryID,
            TerritoryName,
            CountryRegionCode,
            RegionGroup
        FROM silver.SalesTerritory;
        PRINT 'gold.DimTerritory data inserted successfully.';

        PRINT 'gold.load_gold completed successfully.';

    END TRY

    BEGIN CATCH
        PRINT 'Error occurred in gold.load_gold:';
        PRINT ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
    END CATCH

END;

--EXEC gold.load_gold;
