drop table #contests;
drop table #colleges;
drop table #challenges;
drop table #view_stats;
drop table #submission_stats;

create table #contests
(
	contest_id int,
	hacker_id int,
	[name] nvarchar(30)
);
create table #colleges
(
	college_id int,
	contest_id int
);
create table #challenges
(
	challenge_id int,
	college_id int
);
create table #view_stats
(
	challenge_id int,
	total_views int,
	total_unique_views int
);
create table #submission_stats
(
	challenge_id int,
	total_submissions int,
	total_accepted_submissions int
);


insert into #contests
values
(66406,17973,'Rose'),
(66556,79153,'Angela'),
(94828,80275,'Frank');

insert into #colleges
values
(11219,66406),
(32473,66556),
(56685,94828);

insert into #challenges
values
(18765,11219),
(47127,11219),
(60292,32473),
(72974,56685);

insert into #view_stats
values
(47127,26,19),
(47127,15,14),
(18765,43,10),
(18765,72,13),
(75516,35,17),
(60292,11,10),
(72974,41,15),
(75516,75,11);

insert into #submission_stats
values
(75516,34,12),
(47127,27,10),
(47127,56,18),
(75516,74,12),
(75516,83,8),
(72974,68,24),
(72974,82,14),
(47127,28,11);

--Write a query 
--to print the contest_id, hacker_id, name, 
--and the sums of total_submissions, total_accepted_submissions, 
--                total_views, and total_unique_views for each contest 
--sorted by contest_id. 


WITH cte_submissions (challenge_id, total_submissions, total_accepted_submissions)
AS
(
    SELECT	challenge_id, 
			SUM(total_submissions) AS total_submissions, 
			SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM #submission_stats
    GROUP BY challenge_id
), cte_views (challenge_id, total_views, total_unique_views)
AS
(
    SELECT	challenge_id, 
			SUM(total_views) AS total_views, 
			SUM(total_unique_views) AS total_unique_views
    FROM #view_stats
    GROUP BY challenge_id
)
SELECT
    t.contest_id,
    t.hacker_id,
    t.[name],
    SUM(ISNULL(s.total_submissions, 0)) AS total_submissions,
    SUM(ISNULL(s.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(ISNULL(v.total_views, 0)) AS total_views,
    SUM(ISNULL(v.total_unique_Views, 0)) AS total_unique_views
FROM #contests t
JOIN #colleges c			ON (c.contest_id = t.contest_id)
JOIN #challenges chals		ON (chal.college_id = c.college_id)
LEFT JOIN cte_submissions s ON (s.challenge_id = chal.challenge_id)
LEFT JOIN cte_views v		ON (v.challenge_id = chal.challenge_id)
GROUP BY t.contest_id, t.hacker_id, t.[name]
HAVING (sum(ISNULL(s.total_submissions,0))+
		sum(ISNULL(s.total_accepted_submissions,0))+
		sum(ISNULL(v.total_views,0))+ 
		sum(ISNULL(v.total_unique_views,0)))>0
ORDER BY t.contest_id;


submit to hackerrank
WITH cte_submissions (challenge_id, total_submissions, total_accepted_submissions)
AS
(
    SELECT    challenge_id, 
            SUM(total_submissions) AS total_submissions, 
            SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM submission_stats
    GROUP BY challenge_id
), cte_views (challenge_id, total_views, total_unique_views)
AS
(
    SELECT    challenge_id, 
            SUM(total_views) AS total_views, 
            SUM(total_unique_views) AS total_unique_views
    FROM view_stats
    GROUP BY challenge_id
)
SELECT
    t.contest_id,
    t.hacker_id,
    t.[name],
    SUM(ISNULL(s.total_submissions, 0)) AS total_submissions,
    SUM(ISNULL(s.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(ISNULL(v.total_views, 0)) AS total_views,
    SUM(ISNULL(v.total_unique_Views, 0)) AS total_unique_views
FROM contests t
JOIN colleges c            ON (c.contest_id = t.contest_id)
JOIN challenges chal        ON (chal.college_id = c.college_id)
LEFT JOIN cte_submissions s ON (s.challenge_id = chal.challenge_id)
LEFT JOIN cte_views v        ON (v.challenge_id = chal.challenge_id)
GROUP BY t.contest_id, t.hacker_id, t.[name]
HAVING (sum(ISNULL(s.total_submissions,0))+
        sum(ISNULL(s.total_accepted_submissions,0))+
        sum(ISNULL(v.total_views,0))+ 
        sum(ISNULL(v.total_unique_views,0)))>0
ORDER BY t.contest_id;