

/* ORDER BY, GROUP BY  */


--SELECT  Gender,COUNT(Gender) as gendercount

--FROM EmployeeDemographics
--where age <= 32

--group by Gender,Age



SELECT  gender, COUNT(Gender) as gendercount
FROM EmployeeDemographics

group by Gender

order by gendercount desc
