
/* Partition by */

select dem.EmployeeID,LastName,Gender,Salary,

count(gender) over (partition by gender)



from EmployeeDemographics as dem

join EmployeeSalary as sal

on dem.EmployeeID = Sal.EmployeeID
---

select LastName,Gender,Salary,count(gender) 

from EmployeeDemographics as dem

join EmployeeSalary as sal

on dem.EmployeeID = Sal.EmployeeID

group by dem.EmployeeID,LastName,Gender,Salary


