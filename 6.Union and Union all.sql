/* Union and Union all*/

select * from EmployeeDemographics 

full outer join WareHouseEmployeeDemographics

on EmployeeDemographics.EmployeeID =WareHouseEmployeeDemographics.EmployeeID

select * from EmployeeDemographics 
union --union/union all
select * from WareHouseEmployeeDemographics
order by EmployeeID


select EmployeeID,FirstName,Age
from EmployeeDemographics 
union
select EmployeeID,JobTitle,Salary from EmployeeSalary
order by EmployeeID