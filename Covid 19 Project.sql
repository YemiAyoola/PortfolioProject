--Select *
--from PortfolioProject..CovidDeaths
--Order by 3,4

--Select *
--From PortfolioProject..CovidVaccination
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
Order by 1,2

---Looking at Total cases vs Total death
--shows the likeihood of dying if you contact covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%state%'
Order by 1,2

--Looking at Total case vs population

Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage_with_covid
from PortfolioProject..CovidDeaths
where location like '%nigeria%'
Order by 1,2

--Loooking at country with highest infection rate

Select Location, population, max(total_cases) as HighestinfectionCount, max((total_cases/population))*100 as Percentage_with_covid
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
Group by Location, Population
Order by Percentage_with_covid desc

--showing the country wit the highest death count

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is null
Group by Location
Order by TotalDeathCount desc

---break things down by continent

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

--showing continent with the hightest death count

--Global numbers

Select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/
sum(new_cases)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
--Group by date
Order by 1,2

--Looking at Total Population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CummulativeVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

order by 2,3


--Using CTE

With PopvsVac (Continent, Location, Date, Population,new_vaccinations, CummulativeVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CummulativeVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

--order by 2,3
)
Select *,(CummulativeVaccinated/Population)*100
From PopvsVac


--Creating view to store data for later visualization

Create view CummulativeVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CummulativeVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Create view DeathPercentage as
Select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/
sum(new_cases)*100  as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
--Group by date
--Order by 1,2

Create view TotalDeathCount as
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
where continent is not null
Group by continent
--Order by TotalDeathCount desc

Create view HighestInfectionCount as
Select Location, population, max(total_cases) as HighestinfectionCount, max((total_cases/population))*100 as Percentage_with_covid
from PortfolioProject..CovidDeaths
--where location like '%nigeria%'
Group by Location, Population
--Order by Percentage_with_covid desc