CREATE DATABASE HR;
USE HR;



SELECT *
FROM dbo.hr_data;


SELECT termdate
From hr_data
order by termdate DESC;

update hr_data
set termdate = Format(CONVERT(DATETIME, LEFT(termdate,19),120), 'yyyy-MM-dd'); /* transform the time data*/

ALTER TABLE hr_data
ADD new_termdate DATE;



UPDATE hr_data
set new_termdate = CASE
	when termdate is not null AND ISDATE(termdate) =1 then cast(termdate as DATETIME ) ELSE NULL End;

-- create a new column " AGE"

ALTER TABLE hr_data
ADD Age nvarchar(50);

-- Populate new column with age
UPDATE hr_data
SET Age = DATEDIFF(YEAR, birthdate, GETDATE());

SELECT Age
FROM hr_data

-- Question to answer from the data
-- 1) What is the age distribuition in the company?

select
	Min(Age) as youngest,
	Max (Age) as oldest
from hr_data


-- Age group by gender
select age_group,
gender,
count(*) as count
from
(select case
	when Age <= 21 and Age <= 30 then '21 to 30'
	when Age <= 31 and Age <= 40 then '31 to 40'
	when Age <= 41 and Age <= 50 then '41 to 50'
	Else '50+'
End as age_group,gender
from hr_data
where new_termdate is null) as suquery
	group by age_group,gender
	order by age_group,gender


-- 2) what is the gender breakdown in the company?

select gender, count(gender) 
from hr_data
where new_termdate is not null
group by gender
order by gender ASC;



-- 3) How does the gender vary across departments and job titles?
select department, gender, count(gender) as count
from hr_data
where new_termdate is not null
group by department, gender
order by department, gender ASC;




-- 4) What is the race distribution in the company?
select race, count(*) as Count
from hr_data
where new_termdate is null
group by race
order by count DESC;


-- 5) what is the average length of employment in the company?
select 
AVG(datediff(year, hire_date, new_termdate)) as tenure
from hr_data
where new_termdate is not null and new_termdate <= getdate();





-- 6) which departnemt has the highest turnover rate?
select department, total_count, terminated_count, round(cast(terminated_count as float)/total_count,2)*100 as turnover_rate
from
	(select 
	department,
	count(*) as total_count,
	sum(Case
		when new_termdate is not null and new_termdate <= getdate() then 1 else 0
		end ) as terminated_count
	from hr_data
	group by department) as subquery
	order by turnover_rate DESC;

-- 7) What is the tenure distribution for each department?
select department,
AVG(datediff(year, hire_date, new_termdate)) as tenure
from hr_data
where new_termdate is not null and new_termdate <= getdate()
group by department
order by department 


-- 8) How many employees work remotely for each department?
select location, count(*) as count
from hr_data
where new_termdate is null
group by location

-- 9) What is the distribution of employees across the differnt states?
select location_state, count(*) as count
from hr_data
where new_termdate is null
group by location_state
order by count DESC

-- 10) How are the jobs titles distributed in the company?
select jobtitle, count(*) as count
from hr_data
where new_termdate is null
group by jobtitle
order by count DESC

-- 11) How have the employee hire counts varied over time?
select hire_year, 
		hires, 
		terminations , 
		(hires - terminations) as net_change, 
		round(cast(hires - terminations as float)/ hires,2)*100 as percent_hire_change
	from
(select Year(hire_date) as hire_year, count(*) as hires,
	Sum( Case
		when new_termdate is not null and new_termdate <= getdate() then 1 else 0
		end ) as terminations
from hr_data
group by Year(hire_date)) as subquery
order by percent_hire_change 






select gender,
count(*) as count
from hr_data
where new_termdate is null 
	group by gender
	order by gender