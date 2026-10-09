  --=========================================
-----IMPLEMENENTATION FOR FINAL TABLE------
--=========================================
/*
	===========================================================================
	Description:
	This view combines sales transaction data with product and customer
	dimension tables to create a centralized fact view for sales analysis
	and reporting in the Gold layer.
	===========================================================================
*/

IF OBJECT_ID('gold.dim_customers','V') is not null
	DROP VIEW gold.dim_customers;
go
create view gold.dim_customers AS
Select 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS  first_name,
	ci.cst_lastname As last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
		ELSE COALESCE(ca.gen,'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
from silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la 
ON ci.cst_key = la.cid;
go
Select * from gold.dim_customers;

----------------------------------------
Select column_name,data_type from information_schema.columns
where table_schema='silver' and table_name = 'prd_info';
----------------------------------------
IF OBJECT_ID('gold.dim_products','V') is not null
	DROP VIEW gold.dim_products;
go
create view gold.dim_products AS
(
Select 
ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pn.prd_cost AS cost,
pn.prd_line AS product_line,
pc.maintenance AS  maintenance,
pn.prd_start_dt AS start_date
from silver.prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2  pc
ON pn.cat_id = pc.id
where prd_end_dt is null
);
go
Select * from gold.dim_products;--Filter out all historical data.

----------------------------------------------------
	--Fact Sales Details Table
	--------------------------
IF OBJECT_ID('gold.fact_sales') is not null
	drop view gold.fact_sales;
go
create view gold.fact_sales as
Select 
sd.sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt As shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales As sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price
from silver.sales_details sd
LEFT JOIN
gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN
gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;
go
Select * from gold.fact_sales order by order_number;
