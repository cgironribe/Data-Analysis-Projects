SELECT * FROM EmployeeRecords 

EXEC sp_rename 'EmployeeRecords.[Full Name]', 'full_name', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Job Title]', 'job_title', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Business Unit]', 'business_unit', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Hire Date]', 'hire_date', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Annual Salary]', 'annual_salary', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Business Unit]', 'business_unit', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Bonus %]', 'bonus_percentage', 'COLUMN';
EXEC sp_rename 'EmployeeRecords.[Exit Date]', 'exit_date', 'COLUMN';


--Create two more columns to interact separately with Name and Last name
ALTER TABLE EmployeeRecords
ADD first_name nvarchar(25);
ALTER TABLE EmployeeRecords
ADD last_name nvarchar(25);

--Verify that we are just taking the name from full_name
SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name + ' ') - 1) AS first_name FROM EmployeeRecords

--Filling first_name column
UPDATE EmployeeRecords 
SET first_name = SUBSTRING(full_name, 1, CHARINDEX(' ', full_name + ' ') - 1)

--Repeat process for last_name column
SELECT SUBSTRING(full_name, CHARINDEX(' ', full_name + ' ') + 1, LEN(full_name)) AS last_name FROM EmployeeRecords

UPDATE EmployeeRecords 
SET last_name = SUBSTRING(full_name, CHARINDEX(' ', full_name + ' ') + 1, LEN(full_name))

--Since exit_date blank values do not appear as nulls I will convert them into nulls for easier navigation
SELECT * FROM employeeRecords WHERE NULLIF(LTRIM(RTRIM(exit_date)), '') IS NULL;

UPDATE EmployeeRecords 
SET exit_date = NULL
WHERE NULLIF(LTRIM(RTRIM(exit_date)), '') IS NULL;




-- DATA EXPLORATION

SELECT COUNT(*) AS total_employees FROM EmployeeRecords WHERE exit_date IS NULL;
SELECT * FROM EmployeeRecords ORDER BY hire_date 


--Employee retention rate
	-- Employees hired per year
SELECT YEAR(hire_date) AS year,
       COUNT(*) AS hired_count
FROM employeerecords
GROUP BY YEAR(hire_date);

	-- Employees that stayed per year
SELECT YEAR(hire_date) AS year,
       COUNT(*) AS stayed_count
FROM employeerecords
WHERE exit_date IS NULL
GROUP BY YEAR(hire_date);

--Company hiring rate
DECLARE @StartYear INT = 1992;
DECLARE @EndYear INT = 2021;

WITH RetentionByYear AS (
    SELECT
        YEAR(hire_date) AS HiringYear,
        COUNT(*) AS InitialEmployees,
        SUM(CASE WHEN exit_date IS NULL OR YEAR(exit_date) >= @EndYear THEN 1 ELSE 0 END) AS FinalEmployees
    FROM
        Employeerecords
    WHERE
        YEAR(hire_date) >= @StartYear AND YEAR(hire_date) <= @EndYear
    GROUP BY
        YEAR(hire_date)
)
SELECT
    HiringYear,
    InitialEmployees,
    FinalEmployees,
	CONCAT(CAST(ROUND(((1.0 * FinalEmployees) / InitialEmployees) * 100, 2) AS DECIMAL(10, 2)), '%') AS RetentionRate
FROM
    RetentionByYear;


--Group by country the departments to see where the department talent comes from
SELECT department, country, COUNT(*) AS head_count
FROM employeerecords 
WHERE exit_date IS NULL
GROUP BY country, department

SELECT country, COUNT(*) as head_count
FROM employeerecords 
WHERE exit_date IS NULL
GROUP BY country
--how many woman and man have leadership positions
SELECT job_title,
	SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS females,
	SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS males
FROM employeerecords 
WHERE job_title LIKE '%manager%' or job_title LIKE '%director%' AND exit_date IS NULL
GROUP BY job_title

--how many diversity per department
SELECT department,
	SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS females,
	SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS males
FROM employeerecords 
WHERE exit_date IS NULL
GROUP BY department


--Gender balance, how much of gender diversity is on the company
SELECT COUNT(*) AS total_per_gender, 
gender 
FROM employeerecords 
WHERE exit_date IS NULL
GROUP BY gender

--Age inclusion, average age of employees and how many are from x ranges
WITH age_groups AS (
    SELECT 
        CASE 
            WHEN age BETWEEN 20 AND 30 THEN '20-30 y/o'
            WHEN age BETWEEN 31 AND 40 THEN '31-40 y/o'
            WHEN age BETWEEN 41 AND 50 THEN '41-50 y/o'
            WHEN age BETWEEN 51 AND 65 THEN '51-65 y/o'
            ELSE 'None' 
        END AS age_group
    FROM employeerecords
	WHERE exit_date IS NULL
)
SELECT age_group, COUNT(*) AS group_count
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

--which year we contracted the most people and the less

SELECT YEAR(hire_date) AS hiring_year, 
	   MONTH(hire_date) AS month_hiring, 
	   COUNT(*) AS total_people_hired,
       SUM(COUNT(*)) OVER (PARTITION BY YEAR(hire_date)) AS total_people_by_year
FROM employeerecords 
GROUP BY YEAR(hire_date), MONTH(hire_date)

--average annual salary per role
SELECT job_title, 
       ROUND(AVG(annual_salary),2) AS average_salary 
FROM employeerecords 
WHERE exit_date IS NULL
GROUP BY job_title 
ORDER BY average_salary DESC

--how many leadership roles vs non leadership to see if there is a balance
SELECT job_title, COUNT(*) AS head_count
FROM employeerecords
WHERE job_title LIKE '%manager%' or job_title LIKE '%director%' AND exit_date IS NULL
GROUP BY job_title;


SELECT job_title, COUNT(*) AS head_count
FROM employeerecords
WHERE job_title NOT LIKE '%manager%' AND NOT job_title LIKE '%director%' AND exit_date IS NULL
GROUP BY job_title;

--how many seniors
SELECT job_title, COUNT(*) AS head_count
FROM employeerecords
WHERE job_title LIKE '%sr.%' AND exit_date IS NULL
GROUP BY job_title;

--different ethnicity groups to see if we haave a diverse team
SELECT ethnicity, 
COUNT(*) AS total_people 
FROM employeeRecords 
WHERE exit_date IS NULL
GROUP BY ethnicity 