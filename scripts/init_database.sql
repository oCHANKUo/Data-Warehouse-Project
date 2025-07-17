/* 
===============================================================
    Script: Create DataWarehouse Database with Layers

    Description:
        - Drops the existing 'DataWarehouse' database if it exists.
        - Recreates the 'DataWarehouse' database.
        - Creates schemas: bronze, silver, gold for Medallion architecture.
    WARNING:
        This script will permanently DELETE the existing DataWarehouse 
        database and all data within it.
===============================================================
*/

USE master;
GO

--Drop and Recreate the DataWarehouse DB
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO