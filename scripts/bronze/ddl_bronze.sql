/*
Create Table inside the 'bronze' Schema.
*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_cust_info ;
END;
create table bronze.crm_cust_info 
(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_material_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date Date 
);
Select * from bronze.crm_cust_info;

go 


IF OBJECT_ID('bronze.prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.prd_info ;
END;
create table bronze.prd_info 
(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost Int,
	prd_line nvarchar(50),
	prd_start_dt Date,
	prd_end_dt Date 
);

Select * from bronze.prd_info;

go

if object_id('bronze.sales_details','U') is not null 
BEGIN 
 drop table bronze.sales_details;
END;
Create table bronze.sales_details 
(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id Int,
	sls_order_dt Int,
	sls_ship_dt Int,
	sls_due_dt	Int,
	sls_sales Int,
	sls_quantity Int,
	sls_price Int
);

Select * from bronze.sales_details;


/*
==================
Table Creation for the ERP.
==================
*/
if object_id('bronze.erp_loc_a101','U') is not null
BEGIN
	drop table bronze.erp_loc_a101;
END;
Create table bronze.erp_loc_a101
(
	cid nvarchar(50),
	cntry nvarchar(50),
);
go
Select * from bronze.erp_loc_a101;

if Object_id('bronze.erp_cust_az12','U') is not null
BEGIN
	drop table bronze.erp_cust_az12;
END;
Create table bronze.erp_cust_az12
(
	cid nvarchar(50),
	bdate Date,
	gen varchar(50)
);
go
Select *  from bronze.erp_cust_az12 ; 

if Object_id('bronze.erp_px_cat_g1v2','U') is not null 
BEGIN
	drop table bronze.erp_px_cat_g1v2
END;
Create table bronze.erp_px_cat_g1v2
(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
);
go
Select * from bronze.erp_px_cat_g1v2 ;
