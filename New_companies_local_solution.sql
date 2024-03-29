select distinct c.company_code, c.founder,
	count(DISTINCT lm.lead_manager_code) as lead_manager_count,
	COUNT(DISTINCT sm.senior_manager_code) AS senior_managers_count,
	COUNT(DISTINCT m.manager_code) AS managers_count,
	COUNT(DISTINCT e.employee_code) AS employees_count
from ##company c
left join ##lead_manager lm 
	on(lm.company_code = c.company_code)
left join ##senior_manager sm
    on(sm.lead_manager_code = lm.lead_manager_code
      and sm.company_code = c.company_code)
left join ##manager m
    on (m.senior_manager_code = sm.senior_manager_code
       and m.lead_manager_code = lm.lead_manager_code
       and m.company_code = c.company_code)
left join ##employee e
    on (e.manager_code = m.manager_code
       and e.senior_manager_code = sm.senior_manager_code
       and e.lead_manager_code = lm.lead_manager_code
       and e.company_code = c.company_code)
group by c.company_code, c.founder
order by c.company_code asc