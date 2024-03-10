
/* where Statement  =,<>,<,>, and ,or null,not null,in,like */




SELECT * FROM EmployeeDemographics where FirstName = 'Nasgath'
SELECT * FROM EmployeeDemographics where FirstName <> 'Nasgath' ---except nasgath all datas will be shown

select * from EmployeeDemographics where Age > 35 --use >,<,>=,<=


SELECT * FROM EmployeeDemographics where FirstName like'%ji%'

select *  from EmployeeDemographics where FirstName is Not Null

