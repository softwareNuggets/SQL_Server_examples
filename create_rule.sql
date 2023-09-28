-- https://github.com/softwareNuggets/SQL_Server_examples/
-- create_rule.sql

--drop table emp;
create table emp
(
	emp_id int not null primary key,
	fname nvarchar(30) not null,
	lname nvarchar(40) not null,
	skill_level int not null
);

--drop rule valid_skill_level;
create rule valid_skill_level
as 
@skill_id in(1,2,5);

create rule valid_skill_level
as
@value > 10 and @value < 30;



exec sp_bindrule 'valid_skill_level', 'dbo.emp.skill_level'
EXEC sp_unbindrule 'dbo.emp.skill_level';

insert into emp(emp_id,fname,lname,skill_level)
values(1,'fred','wilson',2);

insert into emp(emp_id,fname,lname,skill_level)
values(2,'nicole','jay',1);

select *
from emp

SELECT * 
FROM sys.objects 
WHERE type_desc = 'RULE'



SELECT 
    OBJECT_NAME(object_id) AS RuleName,
    definition AS RuleDefinition
FROM 
    sys.sql_modules
WHERE 
    object_id = OBJECT_ID('valid_skill_level');


-- It is recommended to use CHECK constraints instead of rules 
-- to validate data in SQL Server. CHECK constraints are more 
-- efficient and easier to manage.