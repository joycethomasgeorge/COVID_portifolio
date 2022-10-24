select* from
COVID_PORTIFOLIO..Covid_Deaths$
where continent is not null
order by 3,4
select*from
COVID_PORTIFOLIO..Covid_Vaccination$
select Location,date,total_cases,new_cases,total_deaths,population
from COVID_PORTIFOLIO..Covid_Deaths$ where continent is not null
order by 1,2

-- looking at Total Cases vs Total deaths
-- shows likelihood of dy

select Location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as  Death_percentage
from COVID_PORTIFOLIO..Covid_Deaths$

where location like '%states%'
order by 1,2

--looking at total cases vs population

select Location,date,total_cases,new_cases,population,(total_cases/population)*100 as  PercentPopulationInfected
from COVID_PORTIFOLIO..Covid_Deaths$
--where location like '%states%'
order by 1,2

--looking at countries with higher infection rate
select Location,population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population))*100 as 
	PercentPopulationInfected from COVID_PORTIFOLIO..Covid_Deaths$
group by Location,Population
--where location like '%states%'
order by PercentPopulationInfected desc

--countries with highest death rate

select Location,MAX(cast(total_Deaths as int))as TotalDeathCount 
	 from COVID_PORTIFOLIO..Covid_Deaths$ where location like '%India%'
group by Location

-- Lets break things down by continent

select continent,MAX(cast(total_Deaths as int))as TotalDeathCount 
	 from COVID_PORTIFOLIO..Covid_Deaths$ 
	 where continent is not null
group by continent
order by TotalDeathCount  desc

--showing the continent with highest death count per population


select continent,MAX(cast(total_Deaths as int))as TotalDeathCount 
	 from COVID_PORTIFOLIO..Covid_Deaths$ 
	 where continent is not null
group by continent
order by TotalDeathCount  desc

--Breaking Global Numbers

select Location,population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population))*100 as 
	PercentPopulationInfected from COVID_PORTIFOLIO..Covid_Deaths$
group by Location,Population
--where location like '%states%'
order by PercentPopulationInfected desc

select date,SUM(total_cases),SUM(new_cases),population,(total_cases/population)*100 as  PercentPopulationInfected
from COVID_PORTIFOLIO..Covid_Deaths$
where continent is not null
--where location like '%states%'
order by 1,2



select date, SUM(new_cases) new_cases,SUM(cast(new_deaths as int)) new_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as  Death_percentage
from COVID_PORTIFOLIO..Covid_Deaths$

--where location like '%states%'
Where continent is not null
Group by date
order by 1,2
 
select  SUM(new_cases) new_cases,SUM(cast(new_deaths as int)) new_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as  Death_percentage
from COVID_PORTIFOLIO..Covid_Deaths$

--where location like '%states%'
Where continent is not null
--Group by date
order by 1,2
 -- looking at Total population Vs Vacination 
select* 
from COVID_PORTIFOLIO..Covid_Deaths$ dea
join  COVID_PORTIFOLIO..Covid_Vaccination$ vac
on dea.location=vac.location
and dea.date = vac.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,Sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccination
from COVID_PORTIFOLIO..Covid_Deaths$ dea
join  COVID_PORTIFOLIO..Covid_Vaccination$ vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
 

 --USE CTE
 with popvsvac(continent,location, Date, Population,new_vaccinations,RollingPeopleVaccination)
 as 
 (
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,Sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccination
from COVID_PORTIFOLIO..Covid_Deaths$ dea
join  COVID_PORTIFOLIO..Covid_Vaccination$ vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccination/Population)*100
from popvsvac

--TEMP TABLE
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
RollingPeopleVaccination numeric
)

insert into #percentpopulationvaccinated
 
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,Sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccination
from COVID_PORTIFOLIO..Covid_Deaths$ dea
join  COVID_PORTIFOLIO..Covid_Vaccination$ vac
on dea.location=vac.location
and dea.date = vac.date
--where dea.continent is not null
order by 1,2,3

select*,(RollingPeopleVaccination/Population)*100
from #percentpopulationvaccinated