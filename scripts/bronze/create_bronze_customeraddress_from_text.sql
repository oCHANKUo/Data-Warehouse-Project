/*
===============================================================
    Script Name  : create_bronze_customeraddress_from_text.sql
    Purpose      : Create and load the CustomerAddress table in the bronze schema.
    Description  :
        - Creates the [bronze].[CustomerAddress] table for staging customer
          address data from external text files.
        - Performs BULK INSERT from CustomerAddress.txt into the table,
          handling tab-delimited data while skipping the header row.
        - Selects a sample of the loaded data for verification.
===============================================================
*/

CREATE TABLE [bronze].[CustomerAddress] (
    CustomerID INT NOT NULL,
    AddressType NVARCHAR(50) NULL,
    AddressLine1 NVARCHAR(255) NULL,
    AddressLine2 NVARCHAR(255) NULL,
    City NVARCHAR(100) NULL,
    StateProvinceName NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    CountryRegionName NVARCHAR(100) NULL
);

BULK INSERT [bronze].[CustomerAddress]
FROM 'C:\Users\chanu\Downloads\BITZIFY practical resources 1\BITZIFY practical resources\CustomerAddress.txt'
WITH (
    FIRSTROW = 2,             -- Skip header row
    FIELDTERMINATOR = '\t',   -- Tab separated
    KEEPNULLS,
    TABLOCK
);

SELECT TOP 100 * FROM [bronze].[CustomerAddress];

