Select
distinct ci.cst_gndr,
ca.gen,
CASE
	WHEN ci.cst_gndr!='n/a' THEN ci.cst_gndr
	ELSE COALESCE(ca.gen,'n/a')
END AS new_gen 
from silver.crm_cust_info ci
LEFT JOIN 
silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN
silver.erp_loc_a101 la 
ON ci.cst_key = la.cid;

-- foreign key integrity dimesions ...
SELECT *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS pr
    ON pr.product_key = f.product_key
WHERE c.customer_key IS NULL;
-- There don't have any customer_key null . 
