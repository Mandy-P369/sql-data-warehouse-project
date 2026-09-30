/*
====================================
Create database and schemas 
====================================
Script purpose :
	This script creates a new database named 'DataWarehouse' after checking 
	if it already exists,it is dropped and recreated.Additionally,the script is
	set up three schemas within the databases:
		1. bronze
		2. silver
		3. gold

	Warning:
	Running this script will drop the entire 'DataWarehouse' database if exists.
	All data in the database will be permanently deleted.Proceed with caution
	and ensure you have proper backups before running this script.
*/

if exists (Select 1 from sys.databases where name= 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with Rollback immediate;
	drop database DataWarehouse
end;
go

create database DataWarehouse;
go

use DataWarehouse ; 
go 

create schema bronze;
go

create schema silver;
go

create schema gold;
go
