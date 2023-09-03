--GitHub
--https://github.com/softwareNuggets/SQL_Server_examples
--   concurrency.sql

--drop table cus_account_m
CREATE TABLE cus_account_m (
    customer_id		INT PRIMARY KEY,
    customer_name	nvarchar(60),
	balance			decimal(10,2),
    date_created	DATE,
	rv				rowversion 
);


insert into cus_account_m(customer_id, customer_name, balance, date_created)
values
(1,'some customer',600.00, '1992-01-07')

 
select *, cast(rv as bigint) from cus_account_m

update cus_account_m set balance=600.00 where customer_id = 1;

select *, cast(rv as bigint) from cus_account_m

-- sheet 2
-- at the bank teller window

-- before we use update command, need to get the current value of the rowversion, let's call it @rv
-- use the @rv value with the update statement
-- if @rv has not changed, your update statement will be successful

BEGIN TRANSACTION;

DECLARE @rv rowversion;
DECLARE @balance1 DECIMAL(10, 2);

SELECT 
		@balance1 = balance, 
		@rv = rv
FROM	cus_account_m 
WHERE	customer_id = 1;

select 'before',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'bank_teller_balance'
from cus_account_m

-- Simulate a delay to mimic concurrent operations
WAITFOR DELAY '00:00:15';

select 'after',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'bank_teller_balance'
from cus_account_m

-- Update the balance of customer_id 1
UPDATE	cus_account_m 
SET		balance = @balance1 - 500.00 
WHERE	customer_id = 1
and     rv			= @rv;

-- Commit the transaction
COMMIT;

select 'finish',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'bank_teller_balance'
from cus_account_m



--sheet 3
-- someone at an ATM machine

BEGIN TRANSACTION;

DECLARE @rv rowversion;
DECLARE @balance2 DECIMAL(10, 2);

SELECT 
		@balance2 = balance, 
		@rv = rv
FROM	cus_account_m 
WHERE	customer_id = 1;

select 'before',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'atm_balance'
from cus_account_m

-- Simulate a delay to mimic concurrent operations
WAITFOR DELAY '00:00:05';

select 'after',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'atm_balance' 
from cus_account_m

-- Update the balance of customer_id 1
UPDATE	cus_account_m 
SET		balance = @balance2 - 300.00 
WHERE	customer_id = 1
and     rv			= @rv;

-- Commit the transaction
COMMIT;

select 'finish',rv, cast(rv as bigint),
		@rv var_rv,cast(@rv as bigint) var_rv_as_bigint,
		balance as 'atm_balance'
from cus_account_m







