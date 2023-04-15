-- Looking at Total Cases vs Total Deaths (whole world) 
SELECT Location, date, total_cases, total_deaths, (CAST(total_deaths as float)/ CAST(total_cases as float))*100 as DeathPercentages
FROM dbo.CovidDeath
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths(Japan)
SELECT Location, date, total_cases, total_deaths, (CAST(total_deaths as float)/ CAST(total_cases as float))*100 as DeathPercentages
FROM dbo.CovidDeath
WHERE location LIKE '%Japan%' AND total_deaths IS NOT NULL AND total_cases IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Population, shows what percentage og population got covid
SELECT Location, date, total_cases, Population, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeath
-- WHERE location LIKE '%Japan%' AND total_deaths IS NOT NULL AND total_cases IS NOT NULL
ORDER BY 1,2


-- Looking at Country with Highest Infection Rate compared to Populaiton
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as PercentPopulationInfected
FROM dbo.CovidDeath
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc


-- Showing Countries with Highest Death Count Per Population
SELECT Location, MAX(Total_deaths) as TotalDeathCount
FROM dbo.CovidDeath
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Looking at area which continent IS NULL
SELECT DISTINCT location, continent,iso_code
FROM dbo.CovidDeath
WHERE continent IS NULL


-- Break things down by continent & area
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM dbo.CovidDeath
WHERE continent IS NULL AND iso_code LIKE '%OWID%'
GROUP BY location
ORDER BY TotalDeathCount desc


-- Looking at DeathCount by income
SELECT location,MAX(total_deaths) as TotalDeathCount
FROM dbo.CovidDeath
WHERE location LIKE '%income%'
GROUP BY location 
ORDER BY TotalDeathCount desc


-- JOIN CovidDeathTable and CovidVaccinations table by date and location
SELECT *
FROM dbo.CovidDeath AS dea
JOIN dbo.CovidVaccinations AS vac
    ON dea.date = vac.date
    AND dea.location = vac.location


-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM dbo.CovidDeath AS dea
JOIN dbo.CovidVaccinations AS vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL    
ORDER BY 1,2,3    


-- Looking at Vaccinations by date and location
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated 
FROM dbo.CovidDeath AS dea
JOIN dbo.CovidVaccinations AS vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL    
ORDER BY 1,2,3  


-- Use CTE to calculate the percentage between population and vaccinations
WITH PopvsVAC (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
-- the number of columns should be the same with selected table columns  
as 
(
SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location,dea.date)AS RollingPeopleVaccinated
FROM dbo.CovidDeath as dea
JOIN dbo.CovidVaccinations as vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL    
)

SELECT *, (RollingPeopleVaccinated/population) * 100
FROM PopvsVAC


-- temp table
DROP Table if EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent NVARCHAR(225),
location NVARCHAR(225),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC    
) 

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(float,new_vaccinations)) OVER(Partition BY dea.location ORDER BY dea.location,dea.date)as RollingPeopleVaccinated
FROM dbo.CovidDeath AS dea
JOIN dbo.CovidVaccinations AS vac
    ON dea.date = vac.date
    AND dea.location = vac.location
WHERE dea.location IS NOT NULL
-- ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)* 100
FROM #PercentPopulationVaccinated


-- Create View for visialize later
Create VIEW PercentPopulationVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(float,new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeath AS dea
JOIN dbo.CovidVaccinations AS vac
    ON dea.date = vac.date
    AND dea.location = vac.location
WHERE dea.location IS NOT NULL
-- ORDER BY 2,3    

SELECT *
FROM PercentPopulationVaccinated
