/*
	write a SQL Statement to will produce the following output pattern

	* 
	* * 
	* * * 
	* * * *
	* * * * *
	* * * * * *

	GitHub 
	https://github.com/softwareNuggets/SQL_Server_examples/
	draw_the_triangle.sql

	Question from 
	https://www.hackerrank.com/challenges/draw-the-triangle-2/problem?isFullScreen=true
*/



select top 21 number,*
from Master.dbo.spt_values
WHERE Type = 'P'


DECLARE @num INT = 20;

SELECT REPLICATE('* ', Number) AS Pattern
FROM master.dbo.spt_values
WHERE Type = 'P' 
    AND Number BETWEEN 1 AND @num;



SELECT
    TOP 20
	REPLICATE('* ', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)))
FROM master.dbo.spt_values;












DECLARE @num INT = 20;

WITH NumberSequenceCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumberSequenceCTE
    WHERE Number < @num
)
SELECT REPLICATE('* ', Number) AS Pattern
FROM NumberSequenceCTE;
