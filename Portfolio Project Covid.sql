SELECT *
FROM dbo.coviddeaths

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM project_1..coviddeaths
ORDER BY 1,2

--Looking at total cases vs total deaths 
--Shows likliehood of dying in your country if you contract covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM project_1..coviddeaths
WHERE location like '%states%'
ORDER BY 1,2

--total cases vs population 
--Shows what percentage of population got covid

SELECT location, date,population,total_cases,  (total_cases/population)*100 AS CaughtCovid
FROM project_1..coviddeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rates compared to population

SELECT location, population,MAX(total_cases) AS HighestInfectinCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM project_1..coviddeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--Highest deathcount per population

SELECT location,MAX(cast(total_deaths as int)) AS totaldeathcount
FROM project_1..coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount desc

--LETS BREAK THINGS DOWN BY CONTINENT
SELECT continent,MAX(cast(total_deaths as int)) AS totaldeathcount
FROM project_1..coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount desc

--Global numbers
SELECT SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentge
FROM project_1..coviddeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM project_1..coviddeaths dea 
JOIN project_1..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3

--USE CTE 
 WITH POPvsVAC (continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
 AS (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM project_1..coviddeaths dea 
JOIN project_1..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3
)

SELECT*, (RollingPeopleVaccinated/population)*100
FROM POPvsVAC


--TEMP TABLE 
DROP TABLE if EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
( 
continent nvarchar(255),
location nvarchar(255),
DATE datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric, 
)
INSERT INTO #PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM project_1..coviddeaths dea 
JOIN project_1..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--creating view for storing data for later visualization 

CREATE VIEW PercentPopulationVaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM project_1..coviddeaths dea 
JOIN project_1..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2,3


SELECT*
FROM PercentPopulationVaccinated

