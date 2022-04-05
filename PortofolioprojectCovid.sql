use project;

select *
from deathcov;

select 
	location,
    date,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 as Percentagedeath
from
	deathcov
    order by 1, 2;
    
select
	location,
    population,
    MAX(total_cases) as HighestInfection,
    MAX(total_cases/population)*100	as percentpopulationinfected
from
	deathcov
group by location, population
order by percentpopulationinfected desc;

select
	continent,
    MAX(total_deaths) as Deathcount
from
	deathcov
where continent is not null
group by continent
order by Deathcount desc;

select 
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    SUM(new_deaths)/SUM(new_cases)*100 as deathpercentage
from
	deathcov
where continent is not null
order by 1, 2;

select *
from deathcov dea
join covidvaccination vac
	on dea.location = vac.location
    and dea.date = vac.date;
    
 USE CTE;

with PopvsVac (Continent, Location, Date, Population, New_vactinations, PeopleVaccinated)
as
(select 
	dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
from deathcov dea
join covidvaccination vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2, 3)
select *, (Peoplevaccinated/population)*100 as totalpercentagevaccinated
from PopvsVac;



DROP Table if Exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
select 
	dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
from deathcov dea
join covidvaccination vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2, 3;

SELECT 
    *,
    (Peoplevaccinated / population) * 100 AS totalpercentagevaccinated
FROM
    PercentPopulationVaccinated;


Create View PercentVaccinated as
select 
	dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as Peoplevaccinated
from deathcov dea
join covidvaccination vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2, 3;

Select *
From PercentVaccinated