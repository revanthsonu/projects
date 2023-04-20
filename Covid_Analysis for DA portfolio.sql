select * from PortfolioProject..Covid_Deaths
where location like '%states%'
order by 3,4

--select *
--From PortfolioProject..Covid_Vaccinations$
--order by 3,4

select Location, Date, Total_cases, New_cases, Total_deaths, Population 
From PortfolioProject..Covid_Deaths
where location like '%states%'
order by 1,2

-- Looking at total_cases vs Total_Deaths
select Location, Date, Population, Total_cases,  (total_deaths/Total_cases)*100 as DeathPercentage
From PortfolioProject..Covid_Deaths
where location like '%states%'
order by 1,2

--Looking at countries with Highest Infection Rates compared to total population	

select Location, Population, MAX(Total_cases) as HighestInfCount,  MAX(Total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
--where location like '%states%'
Group by Location,Population
order by PercentPopulationInfected desc 

--showing  Countries with Highest Death Count per Population

select Location, MAX(cast(Total_cases as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
where continent is not NULL
Group by Location
order by TotalDeathCount asc

-- Lets break things down by continent

select continent, MAX(cast(Total_cases as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
where continent is not NULL
Group by continent
order by continent ASC

-- GLOBAL NUMBERS
select SUM(new_cases) as TotalCases , sum(cast(new_deaths as int))as TotalDeaths, 
	sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage -- Total_cases,  (total_deaths/Total_cases)*100 as DeathPercentage 
From PortfolioProject..Covid_Deaths
where continent is not null
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1, 2 ,3

select * from PortfolioProject..Covid_Vaccinations

-- Looking at Total Populations vs Vaccinations:
Create View PercentPopulationVaccinated1 as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(convert(int,vac.new_vaccinations)) over 
		(partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..Covid_Deaths dea 
Join PortfolioProject..Covid_Vaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
 where dea.continent is not null
--order by 2,3

select * From PercentPopulationVaccinated

