use AdventureWorks2019;

select 
	COLUMN_NAME , 
	case lower(c.DATA_TYPE)
		when 'int'		then 'int'
		when 'smallint' then 'smallint'
		when 'tinyint'  then 'tinyint'
		when 'bigint'   then 'bigint'
		when 'numeric'  then c.DATA_TYPE+'('+cast(c.NUMERIC_PRECISION as varchar(5))+','+cast(c.NUMERIC_SCALE as varchar(5)) +')'
		when 'date'		then 'date'
		when 'datetime' then 'datetime'
		when 'datetime2' then c.DATA_TYPE+'('+cast(c.DATETIME_PRECISION as varchar(5))+')'
		when 'money'	then 'money'
		when 'char'		then c.DATA_TYPE+'('+cast(c.CHARACTER_MAXIMUM_LENGTH as varchar(5))+')'
		when 'nchar'	then c.DATA_TYPE+'('+cast(c.CHARACTER_MAXIMUM_LENGTH as varchar(5))+')'
		when 'varchar'  then c.DATA_TYPE+'('+(case c.CHARACTER_MAXIMUM_LENGTH when -1 then 'max' else cast(c.CHARACTER_MAXIMUM_LENGTH as varchar(5)) end)+')'
		when 'nvarchar' then c.DATA_TYPE+'('+(case c.CHARACTER_MAXIMUM_LENGTH when -1 then 'max' else cast(c.CHARACTER_MAXIMUM_LENGTH as varchar(5)) end)+')'
		else c.DATA_TYPE
	end data_type,
	case Upper(c.IS_NULLABLE)
		when 'NO' then 'not null,'
		when 'YES' then 'null,'
	end is_nullable
from INFORMATION_SCHEMA.COLUMns c
where table_name = 'vEmployee'
and TABLE_SCHEMA='HumanResources'


create table something
(
BusinessEntityID	int	not null,
Title	nvarchar(8)	null,
FirstName	nvarchar(50)	not null,
MiddleName	nvarchar(50)	null,
LastName	nvarchar(50)	not null,
Suffix	nvarchar(10)	null,
JobTitle	nvarchar(50)	not null,
PhoneNumber	nvarchar(25)	null,
PhoneNumberType	nvarchar(50)	null,
EmailAddress	nvarchar(50)	null,
EmailPromotion	int	not null,
AddressLine1	nvarchar(60)	not null,
AddressLine2	nvarchar(60)	null,
City	nvarchar(30)	not null,
StateProvinceName	nvarchar(50)	not null,
PostalCode	nvarchar(15)	not null,
CountryRegionName	nvarchar(50)	not null,
AdditionalContactInfo	xml	null
)

--drop table something

select *
from INFORMATION_SCHEMA.TABLEs
where table_name = 'something'

select *
from something

