/*SELECT *
from PortfolioProject..CovidDeaths
where continent is not null
ORDER by 3, 4

SELECT *
from PortfolioProject..CovidVaccinations
ORDER by 3, 4

-- Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
ORDER by 1, 2

--Looking at Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
ORDER by 1, 2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Netherlands%'
where continent is not null
ORDER by 1, 2

--Looking at countries with Highest Infection Rates to Population
Select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Netherlands%'
where continent is not null
Group by population, location
ORDER by PercentPopulationInfected DESC

--Showing the countries with the Highest Death Count per Population
Select location, MAX(total_deaths) as total_death_count
from PortfolioProject..CovidDeaths
--where location like '%Netherlands%'
where continent is not null
Group by location
ORDER by total_death_count DESC

--Let's break things down by Continent
Select continent, MAX(total_deaths) as total_death_count
from PortfolioProject..CovidDeaths
--where location like '%Netherlands%'
where continent is not null
Group by continent
ORDER by total_death_count DESC

--Showing the continents with the Highest Death Count
Select continent, MAX(total_deaths) as total_death_count
from PortfolioProject..CovidDeaths
--where location like '%Netherlands%'
where continent is not null
Group by continent
ORDER by total_death_count DESC

--GLOBAL NUMBERS
Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
ORDER by 1, 2

--Looking at Total Population vs Total Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(new_vaccinations as float)) over (Partition by dea.location order by cast(dea.location as varchar(30)), dea.date) as rolling_people_vaccinated
--, rolling_people_vaccinated/population*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
ORDER by 2, 3

--Use CTE
With pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(new_vaccinations as float)) over (Partition by dea.location order by cast(dea.location as varchar(30)), dea.date) as rolling_people_vaccinated
--, rolling_people_vaccinated/population*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--ORDER by 2, 3
)
Select *, (rolling_people_vaccinated/population)*100
From pop_vs_vac


--Temp table
Drop table if exists #percent_population_vaccinated
Create table #percent_population_vaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)
Insert into #percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(new_vaccinations as float)) over (Partition by dea.location order by cast(dea.location as varchar(30)), dea.date) as rolling_people_vaccinated
--, rolling_people_vaccinated/population*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
--where dea.continent is not null
--ORDER by 2, 3

Select *, (rolling_people_vaccinated/population)*100
From #percent_population_vaccinated

--Creating View to store data for later visualisations
Create View persent_population_vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(new_vaccinations as float)) over (Partition by dea.location order by cast(dea.location as varchar(30)), dea.date) as rolling_people_vaccinated
--, rolling_people_vaccinated/population*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--ORDER by 2, 3*/

Select *
FROM persent_population_vaccinated