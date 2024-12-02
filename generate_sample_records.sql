--YouTube->@SoftwareNuggets
--written by->Scott Johnson

-- Drop the table if it exists
IF OBJECT_ID('transaction_logs', 'U') IS NOT NULL
    DROP TABLE transaction_logs;

-- Create the transaction_logs table
CREATE TABLE transaction_logs (
    transaction_id		BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id			INT,
    transaction_date	DATE,
    amount				DECIMAL(10,2),
    transaction_type	VARCHAR(20),
    details				VARCHAR(500) --JSON-like string instead of native JSON
);

-- Generate 1 million rows of sample data
DECLARE @i INT = 1;
DECLARE 
    @random_customer_id INT,
    @random_date		DATE,
    @random_amount		DECIMAL(10,2),
    @random_type		VARCHAR(20),
    @random_source		VARCHAR(20),
    @random_category	VARCHAR(20),
    @random_hash		CHAR(32),
    @details			VARCHAR(500);

WHILE @i <= 1000000
BEGIN
    -- Generate random customer ID between 1 and 10,000
    SET @random_customer_id = FLOOR(RAND() * 10000 + 1);
    
    -- Generate random transaction date between 2020-01-01 and 2024-12-31
    SET @random_date = DATEADD(DAY, FLOOR(RAND() * (365 * 5)), '2020-01-01');
    
    -- Generate random transaction amount between $10 and $5000
    SET @random_amount = ROUND(RAND() * 4990 + 10, 2);
    
    -- Generate random transaction type
    SET @random_type = (
        SELECT TOP 1 tran_type_name 
        FROM (VALUES 
            ('purchase'), 
            ('refund'), 
            ('transfer'), 
            ('payment'), 
            ('deposit'), 
            ('withdrawal')
        ) AS TblTranTypes(tran_type_name)
        ORDER BY NEWID()
    );
    
    -- Generate random source
    SET @random_source = (
        SELECT TOP 1 contact_type 
        FROM (VALUES 
            ('online'), 
            ('mobile'), 
            ('in-store'), 
            ('phone')
        ) AS sources(contact_type)
        ORDER BY NEWID()
    );
    
    -- Generate random category
    SET @random_category = (
        SELECT TOP 1 ctype 
        FROM (VALUES 
            ('clothing'), 
            ('groceries'), 
            ('services')
        ) AS categories(ctype)
        ORDER BY NEWID()
    );
    
    -- Generate transaction hash (using MD5 equivalent in SQL Server)
    SET @random_hash = CONVERT(CHAR(32), HASHBYTES('MD5', 
	CONCAT(@random_amount, @random_date)), 2);
    
    -- Create JSON-like string for details
    SET @details = CONCAT(
        '{"source":"', @random_source, 
        '","category":"', @random_category, 
        '","transaction_hash":"', @random_hash, 
        '"}'
    );
    
    -- Insert the generated transaction
    INSERT INTO transaction_logs 
        (customer_id, transaction_date, amount, transaction_type, details)
    VALUES (
        @random_customer_id,
        @random_date,
        @random_amount,
        @random_type,
        @details
    );
    
    SET @i = @i + 1;
END;

-- Verify row count
SELECT COUNT(*) AS total_rows FROM transaction_logs;
select top 10 * from transaction_logs