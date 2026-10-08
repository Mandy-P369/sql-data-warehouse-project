/*====================================
-------------SILVER LAYER------------
======================================*/
IF OBJECT_ID('silver.crm_cust_info','U') is not null
	DROP TABLE silver.crm_cust_info;
create table silver.crm_cust_info(
	cst_id  int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

/*
Create Table inside the 'silver' Schema.
*/
go 

IF OBJECT_ID('silver.prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.prd_info ;
END;
create table silver.prd_info 
(
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost Int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_dt datetime2 default Getdate()
);

Select * from silver.prd_info;
go

IF OBJECT_ID('silver.sales_details','U') is not null 
BEGIN 
 drop table silver.sales_details;
END;
Create table silver.sales_details 
(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id Int,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt	DATE,
	sls_sales Int,
	sls_quantity Int,
	sls_price Int,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

Select * from silver.sales_details;

/*
==================
Table Creation for the ERP.
==================
*/
if object_id('silver.erp_loc_a101','U') is not null
BEGIN
	drop table silver.erp_loc_a101;
END;
Create table silver.erp_loc_a101
(
	cid nvarchar(50),
	cntry nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
go
Select * from silver.erp_loc_a101;

if Object_id('silver.erp_cust_az12','U') is not null
BEGIN
	drop table silver.erp_cust_az12;
END;
Create table silver.erp_cust_az12
(
	cid nvarchar(50),
	bdate Date,
	gen varchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
go
Select *  from silver.erp_cust_az12 ; 

if Object_id('silver.erp_px_cat_g1v2','U') is not null 
BEGIN
	drop table silver.erp_px_cat_g1v2
END;
Create table silver.erp_px_cat_g1v2
(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
go
Select * from silver.erp_px_cat_g1v2 ;
