select *
from master..CovidDeaths
WHERE continent is not null
order by 3,4

-- select *
-- from master..CovidVaccinations
-- order by 3,4

-- select data that we are going to use

select location, date, total_cases, total_deaths, population
from master..CovidDeaths
order by 1,2

-- looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
from master..CovidDeaths
where location like '%states%'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as CovidRate
from master..CovidDeaths
where location like '%states%'
order by 1,2

-- what countries have highest infection rates

select location, population, MAX(total_cases) as HighestInfectionCount,
 MAX((total_cases/population))*100 as DeathRate
from master..CovidDeaths
-- where location like '%states%'
group by Location, Population
order by DeathRate desc

--showing countries with highest death rate per population

select location,  MAX(total_deaths) as TotalDeathCount
from master..CovidDeaths
-- where location like '%states%'
where continent is not NULL
group by Location
order by TotalDeathCount desc

-- LETS BREAK THINGS DOWN BY CONTINENT
select continent,  MAX(total_deaths) as TotalDeathCount
from master..CovidDeaths
-- where location like '%states%'
where continent is not NULL
group by continent
order by TotalDeathCount desc

select continent,  MAX(total_deaths) as TotalDeathCount
from master..CovidDeaths
-- where location like '%states%'
where continent is not NULL
group by continent
order by TotalDeathCount desc

-- showing the continent with the highest death count

select continent,  MAX(total_deaths) as TotalDeathCount
from master..CovidDeaths
-- where location like '%states%'
where continent is not NULL
group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from master..CovidDeaths
where continent is not NULL
--Group by date
order by 1,2

--looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.location order by dea.location, dea.date)
FROM master..CovidDeaths dea
JOIN master..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is NOT NULL
    order by 2,3

--use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVax)
as
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVax
FROM master..CovidDeaths dea
JOIN master..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is NOT NULL
--order by 2,3
)

select *, (RollingPeopleVax/Population)*100
from PopvsVac

--creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM master..CovidDeaths dea
JOIN master..CovidVaccinations vac 
    on dea.[location] = vac.[location]
    and dea.[date] = vac.[date]
where dea.continent is not null