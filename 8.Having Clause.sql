
/* Having clausse */

select JobTitle,avg(Salary)  from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

group by JobTitle
having avg(Salary) > 45000

order by avg(Salary)

--

select EmployeeDemographics.EmployeeID,avg(Age) from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

group by  EmployeeDemographics.EmployeeID
having avg(age) > 30
order by AVG(Age)




