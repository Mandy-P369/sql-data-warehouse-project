/*
	Insert all the data into the Tables.
	Using Bulk Insert, We can load all the data into the Tables at once.
*/
create or alter procedure bronze.load_bronze as
BEGIN
	DECLARE @start_time datetime , @end_time datetime;
	BEGIN TRY
		Print '===============================';
		print 'Loading Bronze Layer';
		print '===============================';

		print '===============================';
		print 'Loading CRM Files';
		print '===============================';

		/*Bronze.crm_cust_info Table*/
		SET @start_time = GETDATE();

		print '>> Truncating Table  bronze.crm_cust_info';
		Truncate Table bronze.crm_cust_info;

		print '>> Inserting Data into: bronze.crm_cust_info';
		Bulk insert bronze.crm_cust_info 
		from 'C:\sql-data-warehouse-projects\datasets\source_crm\cust_info.csv' 
		with (
			firstrow = 2,
			fieldterminator = ',',
			Tablock
		);

		SET @end_time = GETDATE();
		PRINT CONCAT('Load Duration : ',DATEDIFF(SECOND, @Start_time, @End_time),'seconds');
		print '-----------------------------';
		Select top 10 * from bronze.crm_cust_info;

		/*Bronze.prd_info Table*/
		print '>> Truncating Table bronze.prd_info';
		Truncate Table bronze.prd_info;
		print '>> Inserting Data into: bronze.prd_info';
		Bulk insert  bronze.prd_info
		from 'C:\sql-data-warehouse-projects\datasets\source_crm\prd_info.csv'
		with
		(
			firstrow = 2,
			fieldterminator = ',',
			Tablock
		);
		print '-----------------------------';

		
		/*bronze.sales_details Table*/
		print '>> Truncating Table bronze.sales_details'; 
		Truncate Table bronze.sales_details;
		print '>> Inserting Data into : bronze.sales_details';
		Bulk insert bronze.sales_details
		from 'C:\sql-data-warehouse-projects\datasets\source_crm\sales_details.csv'
		with 
		(
			firstrow = 2,
			fieldterminator = ',',
			Tablock 
		);
		print '---------------------';

	END TRY
	BEGIN CATCH
		PRINT '=========================================';
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + Error_message();
		PRINT 'Error Number'+ Cast(Error_Number() as nvarchar);
		PRINT 'Error State'+ Cast(Error_State() as nvarchar);
		PRINT '=========================================';
	END CATCH 
END;
