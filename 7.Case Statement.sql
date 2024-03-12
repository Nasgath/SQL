/*CASE statement */

select FirstName,LastName,Age,
    CASE 
	when age = 35 then 'Stanley'
	when age >= 30 THEN 'old'
	else 'baby'

    END
from  EmployeeDemographics

where Age is not null

order by Age


----


select FirstName,LastName,JobTitle,Salary,

case

	when JobTitle = 'Salesman' then  Salary+(Salary*0.10)
	when JobTitle = 'Accountant' then Salary+(Salary*0.5)
	when JobTitle = 'HR' then Salary+ (Salary*0.2)
	else Salary+ salary*0.1

end as SalaryAfterRaise

from EmployeeDemographics

join EmployeeSalary

on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID