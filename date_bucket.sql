/*
 let's understand this: 
 DATE_BUCKET returns a "sequence" of date/time values

 let's define sequence:
 a sequence is an ordered collection of elements

 Prototype:
 DATE_BUCKET(datepart, number, date [, origin])

 a sequence, is of type: "the first parameter: datepart" 

 datepart could be: day,month,week,quarter,year,hour,minute,second

 this sequence, also has a frequency 
 simply put: how often do you want the date/time value to increment
 this is the second parameter: number

 the third parameter is the actual date.  when we read that date/time value
 this function will determine, what BUCKET, that date belongs in

*/
--drop table #sample_date
create table #sample_date
(
	event_date date
)

insert into #sample_date(event_date)
values
('2023-01-10'),('2023-01-10'),('2023-01-12'),('2023-01-20'),
('2023-02-03'),('2023-02-24'),
('2023-03-07'),('2023-03-19'),('2023-03-22'),('2023-03-26'),('2023-03-31')

 --Prototype:
 --DATE_BUCKET(datepart, number, date [, origin])

select DATE_BUCKET(Month,1,event_date) as bucket,
		count(*) daysInMonth
from #sample_date
GROUP BY
  DATE_BUCKET(Month,1,event_date)
ORDER BY
  bucket;

select DATE_BUCKET(Month,1,event_date,cast('2080-04-18' as date)) as bucket,
		count(*) daysInMonth
from #sample_date
GROUP BY
  DATE_BUCKET(Month,1,event_date,cast('2080-04-18' as date))
ORDER BY
  bucket;





use AdventureWorks2019;

select 
		OrderDate, 
		TotalDue
from [Purchasing].[PurchaseOrderHeader]
where OrderDate >= '2012-01-01 00:00:00'
and OrderDate  < '2013-01-01 00:00:00';


select 
		cast(OrderDate as date) OrderDate, 
		TotalDue
from [Purchasing].[PurchaseOrderHeader]
where cast(OrderDate as date) >= '2012-01-01'
and   cast(OrderDate as date) <  '2013-01-01';


--1900-01-01 00:00:00
declare @origin date = '2000-01-12';
select
	date_bucket(month, 1, cast(poh.orderDate as date),@origin),
	cast(poh.orderDate as date) as OrderDate,
	poh.TotalDue
from [Purchasing].PurchaseOrderHeader poh
where cast(poh.OrderDate as date) >='2012-01-01'
and cast(poh.OrderDate as date) <'2013-01-01'


declare @origin date = '2000-01-12';
select
	date_bucket(
		year,1,
		cast(poh.orderDate as date),
		@origin
		),
	cast(poh.orderDate as date) as OrderDate,
	poh.TotalDue
from [Purchasing].PurchaseOrderHeader poh
where cast(poh.OrderDate as date) >='2012-01-01'
and cast(poh.OrderDate as date) <'2013-01-01'



declare @origin date = '2012-01-05';
select
	date_bucket(
		quarter,1,
		cast(poh.orderDate as date),
		@origin),
	sum(poh.TotalDue) WeeklyTotalDue
from [Purchasing].PurchaseOrderHeader poh
where cast(poh.OrderDate as date) >='2012-01-01'
and cast(poh.OrderDate as date) <'2013-01-01'
group by date_bucket(
		quarter,1,
		cast(poh.orderDate as date),
		@origin)

