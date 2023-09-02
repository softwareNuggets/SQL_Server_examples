--GitHub
--https://github.com/softwareNuggets/SQL_Server_examples
--   sql_return_2_record_sets.sql


-- Executing the stored procedure and retrieving record sets
DECLARE @orderId INT = 1;
EXEC GetOrderAndDetails @orderId;




CREATE TABLE shopping_cart_orders (
    order_id		INT PRIMARY KEY,
    customer_id		INT,
    order_date		DATE,
    total_amount	DECIMAL(10, 2)
);

CREATE TABLE cart_order_details (
    detail_id		INT PRIMARY KEY,
    order_id		INT,
    product_name	NVARCHAR(100),
    quantity		INT,
    price			DECIMAL(8, 2)
);










INSERT INTO shopping_cart_orders (order_id, customer_id, order_date, total_amount)
VALUES
    (1, 101, '2023-08-31', 150.00),
    (2, 102, '2023-08-31', 220.50),
    (3, 103, '2023-08-30', 75.20);




INSERT INTO cart_order_details (detail_id, order_id, product_name, quantity, price)
VALUES
    (1, 1, 'Widget A', 3, 50.00),
    (2, 1, 'Gadget B', 1, 100.00),
    (3, 2, 'Widget X', 2, 110.25),
    (4, 3, 'Thing Y', 5, 15.04);











--drop procedure GetOrderAndDetails
CREATE PROCEDURE GetOrderAndDetails(@orderId INT)
AS
/*
	-- test for order not available
	DECLARE @orderId INT = 1;
	EXEC GetOrderAndDetails @orderId;
*/
BEGIN

	IF EXISTS (SELECT 'x' FROM shopping_cart_orders WHERE order_id = @orderId)
	BEGIN
		-- First record set: Order details
		SELECT	order_id,
				customer_id,
				order_date,
				total_amount
		FROM shopping_cart_orders 
		WHERE order_id = @orderId;

		-- Second record set: Order item details
		SELECT	detail_id,
				order_id,	
				product_name,
				quantity,	
				price		
		FROM cart_order_details 
		WHERE order_id = @orderId;
	END
	ELSE
	BEGIN
		DECLARE @Message VARCHAR(200);
		SET @Message = 'The requested order with Order ID [ ' + CAST(@orderId AS VARCHAR) + ' ] is not available.';
        SELECT @Message AS Message;
	END
END;






-- Executing the stored procedure and retrieving record sets
DECLARE @orderId INT = 1;
EXEC GetOrderAndDetails @orderId;