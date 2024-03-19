
/* Alaising */

select firstname + ' ' + lastname as FullName


from EmployeeDemographics
-----
select demo.EmployeeID, demo.FirstName + ' '+ demo.LastName as  Fullname , sal.jobtitle, ware.age

from EmployeeDemographics demo

left join employeesalary  sal

on demo.EmployeeID = sal.EmployeeID

left join warehouseemployeedemographics ware

on demo.EmployeeID = ware.EmployeeID