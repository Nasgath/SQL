/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeath$
Where continent is not null 
order by 1,2
-----



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT 
    Location,
    Date,
    CAST(Total_Cases AS float) AS Total_Cases,
    CAST(Total_Deaths AS float) AS Total_Deaths,
    (CAST(Total_Deaths AS float) / CAST(Total_Cases AS float)) * 100 AS DeathPercentage
FROM 
    CovidDeath$
WHERE 
    Continent IS NOT NULL
ORDER BY 
    Location, 
    Date;

	---------
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From CovidDeath$
Where continent is not null 
order by 1,2
---------
Select 

	Location,
    Date,
	population,
    CAST(Total_Cases AS float) AS Total_Cases,
    CAST(Total_Deaths AS float) AS Total_Deaths,
    (CAST(Total_Deaths AS float) / CAST(Total_Cases AS float)) * 100 AS DeathPercentage

From CovidDeath$
Where location like '%states%'
and continent is not null 
order by 1,2

-----------


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid



Select 

	Location,
    Date,
	population,
    Total_Cases,
   
    (Total_Cases/ population) * 100 AS PercentPopulationInfected

From CovidDeath$
Where location like '%states%'
and continent is not null 
order by 1,2
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeath$
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population


Select
Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

------

-- Countries with Highest Death Count per Population
Select 
location, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeath$
Where continent is not null
Group by location
order by TotalDeathCount desc

-------

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select 
continent, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeath$
Where continent is not null
Group by continent
order by TotalDeathCount desc

-----------
Select 
location, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeath$
Where continent is null
Group by location
order by TotalDeathCount desc
---

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath$

Where continent is not null 
Group by continent
order by TotalDeathCount desc
---
-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeath$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
----
SELECT
    date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS int)) AS total_deaths,
    CASE
        WHEN SUM(new_cases) <> 0 THEN (SUM(CAST(new_deaths AS int)) / NULLIF(SUM(new_cases), 0)) * 100
        ELSE 0
    END AS DeathPercentage
FROM
    CovidDeath$
WHERE
    continent IS NOT NULL 
GROUP BY
    date
ORDER BY
    1,2;

--------

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast (vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

--(RollingPeopleVaccinated/population)*100
From CovidDeath$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated BIGINT
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM 
    CovidDeath$ dea
JOIN 
   CovidVaccinations$ vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL

SELECT 
    *, 
    (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM 
    #PercentPopulationVaccinated;





-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
WITH VaccinationData AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM 
        CovidDeath$ dea
    JOIN 
        CovidVaccinations$ vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT 
    *,
    (RollingPeopleVaccinated / population) * 100 AS PercentPopulationVaccinated
FROM 
    VaccinationData;

