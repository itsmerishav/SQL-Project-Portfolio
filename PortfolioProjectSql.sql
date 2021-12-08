
SELECT *
From PortfolioProject.. CovidDeaths


SELECT *
From PortfolioProject.. CovidVaccines

SELECT Location, date,total_cases, new_cases, total_deaths, population
From PortfolioProject.. CovidDeaths
order by 1,2



SELECT Location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.. CovidDeaths
Where location like '%india%'
order by 1,2


SELECT Location, date,total_cases, Population, (total_cases/population)*100 as PercentOfPopulationInfected
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
order by 1,2



SELECT Location, Population,MAX (total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentOfPopulationInfected
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
Group BY Location, Population
order by PercentOfPopulationInfected desc



SELECT Location, MAX(CAST( total_deaths as numeric)) AS HighestDeathCount
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
where continent is not null
Group BY Location
order by HighestDeathCount desc



SELECT continent, MAX(CAST( total_deaths as int)) AS HighestDeathCount
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
where continent is not null
Group BY continent
order by HighestDeathCount desc





SELECT date,SUM(new_cases)AS total_cases,SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
where continent is not null
Group By date
order by 1,2


SELECT SUM(new_cases)AS total_cases,SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.. CovidDeaths
--Where location like '%india%'
where continent is not null
order by 1,2



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccines vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3




with PopvsVac(Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.Location ORDER BY dea.location
, dea.date) as RollingPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccines vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * , (RollingPeopleVaccinated/Population*100)
From PopvsVac
Where location like '%india%'




Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as numeric)) OVER(Partition by dea.Location ORDER BY dea.location
, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccines vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population*100)
From #PercentPopulationVaccinated






Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as numeric)) OVER(Partition by dea.Location ORDER BY dea.location
, dea.Date) as RollingPeopleVaccinated
From PortfolioProject.. CovidDeaths dea
Join PortfolioProject.. CovidVaccines vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

SELECT *
FROM PercentPopulationVaccinated
