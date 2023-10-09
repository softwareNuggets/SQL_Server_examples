/*
	LEAST()
	The LEAST() function was released in SQL Server 2022.

	GitHub 
	https://github.com/softwareNuggets/SQL_Server_examples/
	least.sql
*/

--drop table #order_shipper_cost
create table #order_shipper_cost
(
	order_id	int,
	ups_cost	decimal(6,2),
	fedEX_cost	decimal(6,2),
	dhl_cost	decimal(6,2)
)

insert into #order_shipper_cost(order_id,
		ups_cost, fedEX_cost, dhl_cost)
values
(100,	12.36,	13.47,	16.95),
(101,	15.36,	13.47,	22.95),
(102,	7.36,	8.47,	4.95),
(103,	9.36,	11.47,	8.95),
(104,	42.36,	37.47,	44.95),
(105,	21.36,	23.47,	26.95);

SELECT
  order_id,
  LEAST(ups_cost, fedEX_cost,dhl_cost) AS LowestCost
FROM #order_shipper_cost
where order_id in(101)


SELECT
  order_id,
  LEAST(ups_cost, fedEX_cost,dhl_cost) AS LowestCost,
  CASE
		WHEN ups_cost = LEAST(ups_cost, fedEX_cost,dhl_cost) THEN 'UPS'
		WHEN fedEX_cost = LEAST(ups_cost, fedEX_cost,dhl_cost) THEN 'FedEX'
		ELSE 'DHL'
	END AS ColumnUsed
FROM #order_shipper_cost
where order_id in(101)



use AdventureWorks2019;

select totalDue,SubTotal,*
from Sales.SalesOrderHeader
where SalesOrderID in(43659,43660)

SELECT
  SalesOrderID,
  LEAST(TotalDue, Subtotal) AS LowestCost
FROM Sales.SalesOrderHeader
where SalesOrderID in(43659,43660)

SELECT
	SalesOrderID,
	LEAST(TotalDue, Subtotal) AS LowestCost,
	CASE
		WHEN TotalDue = LEAST(TotalDue, Subtotal) THEN 'TotalDue'
		ELSE 'SubTotal'
	END AS ColumnUsed
FROM Sales.SalesOrderHeader
where SalesOrderID in(43659,43660)
