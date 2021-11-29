--
-- Average salary of the male and female employees over the years per department
--

SELECT 
    d.dept_name,
    e.gender,
    ROUND(AVG(s.salary), 0) AS average_salary,
    YEAR(s.from_date) AS calendar_year
FROM
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY 1 , 2
HAVING calendar_year <=2002;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- Male vs Female Ratio by Department
--

SELECT 
    d.dept_name, e.gender, COUNT(e.emp_no) AS no_of_employees
FROM
    employees e
        LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
    
GROUP BY 1 , 2;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- Overall Gender Distribution
--

SELECT 
    e.gender, COUNT(e.gender) AS no_of_managers
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'manager'
GROUP BY 1;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- No. of employees per department
--

SELECT DISTINCT
    d.dept_name, COUNT(e.emp_no) AS no_of_employees
FROM
    employees e
        LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY 1;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- Managers average salary by department
--

SELECT 
    d.dept_name,
    t.title,
    COUNT(DISTINCT t.emp_no) AS no_of_managers,
    ROUND(AVG(s.salary), 0) AS average_salary
FROM
    titles t
        JOIN
    employees e ON t.emp_no = e.emp_no
        JOIN
    salaries s ON t.emp_no = s.emp_no
        JOIN
    dept_emp de ON t.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    t.title = 'Manager'
GROUP BY 1 , 2;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- No. of Employees
--

SELECT 
    COUNT(DISTINCT emp_no) as no_of_employees
FROM
    employees;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- Employees agegroups
--

SELECT 
    s.salary_group, COUNT(*) AS count
FROM
    (SELECT 
        CASE
                WHEN salary < 50000 THEN '< 50,000'
                WHEN salary BETWEEN 50000 AND 70000 THEN '50,000 to 70,000'
                WHEN salary BETWEEN 70000 AND 90000 THEN '70,000 to 90,000'
                WHEN salary BETWEEN 90000 AND 110000 THEN '90,000 to 110,000'
                ELSE 'more than 110,000'
            END AS salary_group
    FROM
        salaries) s
GROUP BY s.salary_group
order by s.salary_group;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
-- Salary scales by title and department
--

SELECT 
    d.dept_name,
    t.title,
    MAX(s.salary) AS max_salary,
    MIN(s.salary) AS min_salary,
    (MAX(s.salary) - MIN(s.salary)) AS difference
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
        JOIN
    salaries s ON e.emp_no = s.emp_no
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
GROUP BY 1,2
ORDER BY 2 DESC;
