/*
		--------Silver Layer-------
			   CRM_CUST_INFO
=================================================
1.Check for null or duplicates in the primary key.
2.Expectations : No result.
=================================================*/
Select 
cst_id,
count(*)
from bronze.crm_cust_info group by cst_id
having count(*)>1 or cst_id is null ;

/*=====================================================
Check for the Unwanted Spacing in the String values 
Expectation : No Results.
======================================================*/
Select cst_firstname from bronze.crm_cust_info where
cst_firstname != trim(cst_firstname);

/*
Data Standardization & Consistency.
*/
Select distinct cst_gndr 
from bronze.crm_cust_info;

Select distinct cst_marital_status from 
bronze.crm_cust_info;

--=====================================
Select cst_id,
	count(*) 
	from silver.crm_cust_info
	group by cst_id
	having count(*)>1 or cst_id is null;

--=====================================
Select cst_lastname from silver.crm_cust_info 
where cst_lastname != trim(cst_lastname);

Select * from silver.crm_cust_info;

-----------CRM_PRD_INFO-------------
Select 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
	SUBSTRING(prd_key,7,len(prd_key)) as prd_key_sub,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.prd_info
where SUBSTRING(prd_key,7,len(prd_key)) not in 
(Select sls_prd_key from bronze.sales_details);

Select * from bronze.sales_details;

--=====================================
-----------CRM_PRD_INFO-------------
Select prd_nm from bronze.prd_info
WHERE prd_nm != trim(prd_nm);

Select prd_cost from bronze.prd_info
WHERE prd_cost= 0  or prd_cost is null;

----------------------------------------
--Check for Invalid date orders 
----------------------------------------
Select * from bronze.prd_info 
where prd_end_dt < prd_start_dt;

------------------------------------
Select prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt ,
DATEADD
	(DAY,
	 -1,
	 LEAD(prd_start_dt) OVER(
		PARTITION BY prd_key
		ORDER BY prd_start_dt ASC)
	) AS prd_end_date
from bronze.prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-AE-HL-U509');

---------------------------------
--Checking Quality of the silver table ...
Select * from bronze.sales_details;

Select * from bronze.sales_details where sls_prd_key in
(Select prd_key from silver.prd_info);

----------------------------------------------
		--SALES TABLE--
--CHANGE THE DATA TYPE OF THE sls_ship_dt,sls_order_dt,sls_due_dt 
--Check for the invalid dates ...
Select 
nullif(sls_order_dt,0) as sls_order_dt
from bronze.sales_details
where sls_order_dt<=0 or LEN(sls_order_dt)!=8 or sls_order_dt>20500101;

--Checking for the boundary...
Select 
nullif(sls_order_dt,0) as sls_order_dt
from bronze.sales_details
where sls_order_dt <=0 or
len(sls_order_dt)!=8 or
sls_order_dt>20500101 or sls_order_dt<19000101;

Select 
nullif(sls_ship_dt,0) as sls_ship_dt
from bronze.sales_details
where sls_ship_dt <=0 or
len(sls_ship_dt)!=8 or
sls_ship_dt>20500101 or sls_ship_dt<19000101;

Select 
nullif(sls_due_dt,0) as sls_due_dt
from bronze.sales_details
where sls_due_dt <=0 or
len(sls_due_dt)!=8 or
sls_due_dt>20500101 or sls_due_dt<19000101;


--Checking for the Invalid Date orders ...
Select * from bronze.sales_details where 
sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


--Checking Data Consistency :Between Sales ,Quantity ans price.
-- -> Sales = Quantity * Price.
-- -> Values must not be null,zero and negative..
Select distinct 
sls_sales as old_sls_sales,
sls_quantity,
sls_price as old_sls_price,
CASE 
	WHEN sls_sales is null or sls_sales<=0 or sls_sales!=abs(sls_price) * sls_quantity
	THEN sls_quantity * abs(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE 
	WHEN sls_price is null  or sls_price<=0
	THEN sls_sales/NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
from bronze.sales_details
where sls_sales!=sls_quantity*sls_price
or sls_sales is null  or sls_quantity  is null 
or sls_price is null or sls_sales <=0 
or sls_quantity<=0 or sls_price <=0;



Select 
CASE
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
    ELSE TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR(8)), 112)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt=0 or LEN(sls_ship_dt)!=8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,											 --sls_ship_dt
CASE 
	WHEN sls_due_dt=0 or LEN(sls_due_dt)!=8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt	
from bronze.sales_details; 


Select * from bronze.sales_details where
sls_sales != abs(sls_sales) ;

--============================================================
Select * from bronze.erp_cust_az12; 
Select * from silver.crm_cust_info ; 
Select * from bronze.erp_cust_az12 where 
cid  like '%00011%';
Select distinct cid from bronze.erp_cust_az12; 

--Actual 
Select 
cid,
case 
	when cid like 'NAS%' then substring (cid,4,len(cid))
	else cid
end as cid,
bdate,
gen
from bronze.erp_cust_az12  
where 
case 
	when cid like 'NAS%' then substring (cid,4,len(cid))
	else cid
end not in  (Select distinct cst_key from silver.crm_cust_info);


--Identify Out of Range Dates 
Select 
distinct bdate from 
bronze.erp_cust_az12 
WHERE bdate<'1924-01-01' or bdate>GETDATE();
Select * from bronze.erp_cust_az12 ; 
-- Date Standardization and Consistency
Select
CASE 
	WHEN cid like 'NAS%' THEN SUBSTRING (cid,4,LEN(cid))
	ELSE cid
END AS cid,
CASE
	WHEN UPPER(TRIM(gen)) in ('M','MALE') THEN 'MALE'
	WHEN UPPER(TRIM(gen)) in ('F','FEMALE') THEN 'FEMALE'
	ELSE 'N/A'
END AS Gender
from bronze.erp_cust_az12;
-----------------------------------
Select * from silver.crm_cust_info;


----------------------------------------------------------
--						ERP_LOC_A101
----------------------------------------------------------
Select cid,REPLACE(cid,'-', '') as cid from bronze.erp_loc_a101 
where REPLACE(cid,'-', '') not in 
(Select cst_key from silver.crm_cust_info); 

Select cst_key from silver.crm_cust_info; 

-- Data Standardization and Consistency ..
Select distinct cntry from bronze.erp_loc_a101 ; 

Select 
distinct cntry as old_cntry,
CASE 
	WHEN TRIM(cntry) in ('DE') THEN 'Germany'
	WHEN TRIM(cntry) in ('US','USA') THEN 'United States'
	WHEN TRIM(cntry) = '' or cntry is NULL THEN 'N/A'
	ELSE TRIM(cntry)
END AS cntry
from bronze.erp_loc_a101 order by cntry ; 



----------------------------------------------------
--					erp_px_cat_g1v2
----------------------------------------------------
Select  * from bronze.erp_px_cat_g1v2;
Select distinct prd_key from bronze.prd_info;

--Check for the unwanted spaces : 
Select * from bronze.erp_px_cat_g1v2
where cat!= TRIM(cat) or subcat!=TRIM(subcat)
or maintenance!=TRIM(maintenance);

exec silver.load_silver;
