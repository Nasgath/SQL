/* inner join, full,right,left outer join */


select * from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID




--

select * from EmployeeDemographics

left outer join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--

select * from EmployeeDemographics

right outer join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--
select EmployeeSalary.EmployeeID,FirstName,LastName,Salary

from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--
select *

from EmployeeDemographics

full outer join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

---

select EmployeeSalary.EmployeeID,FirstName,LastName,Salary

from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
where FirstName <> 'Nasgath'

order by Salary desc

---


select JobTitle,avg(Salary)

from EmployeeDemographics

inner join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

where JobTitle = 'Salesman'

group by JobTitle

