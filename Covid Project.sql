SELECT *  
from 
  covidDeaths
where continent is not null
order by 3,4
  
SELECT *  
from 
  CovidVaccinations
order by 3,4

-- select data that we are going to be using

SELECT 
  location , date , total_cases , new_cases , total_deaths , population 
FROM
  CovidDeaths
where continent is not null
order by 1,2

--loking at Total Cases VS Total Deaths


SELECT 
  location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
FROM
  CovidDeaths
where continent is not null
order by 1,2

SELECT 
  location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
FROM
  CovidDeaths
where 
  location like '%states%'
and continent is not null
order by 1,2

-- looking at Total Cases VS population 
-- Shows What Percentage of population get Covid


SELECT 
  location , date , population , total_cases ,  (total_cases/population)*100 as DeathPercentage
FROM
  CovidDeaths
where 
  location like '%states%'
and continent is not null
order by 1,2


-- looking at Countries with Higest infection Rate compared to Population

SELECT 
  location ,  population , max(total_cases) as HigestInfectionCount  ,  max(total_cases/population)*100 as PercentagePopulationInfected
FROM
  CovidDeaths
--where location like '%states%'
where continent is not null
group by location ,  population
order by PercentagePopulationInfected DESC

--Showing Countries With Highest Death count per Population

SELECT 
  location , max(total_deaths) as TotalDeathCount 
FROM
  CovidDeaths
--where location like '%states%'
where continent is not null
group by location 
order by TotalDeathCount DESC

-- Let's Break Thing Down By Continent
-- Shwing continent with the highest death count per Population

select 
  continent ,max(total_deaths) as TotalDeathsCount 
FROM
  CovidDeaths
--where location like '%states%'
where 
  continent is NOT null
group by continent 
order by TotalDeathsCount desc


--Global Numbers

select 
   sum(new_cases) as total_cases , sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
FROM
  CovidDeaths
--wherelocation like '%States%'
where 
  continent is not null
--Group by date
order by 1,2


-- looking at Pouplotion VS Vaccinations

SELECT
  CD.continent , CD.location , CD.date , CD.population , CV.new_vaccinations ,
SUM(CONVERT(int,new_vaccinations)) over (partition by CD.location order by cd.location , CD.date) as RollingPeopleVaccinated
from 
  CovidDeaths CD 
JOIN CovidVaccinations CV
on 
  CD.location = CV.location
and 
  CD.date = cv.date
where 
  CD.continent is not NULL
order by 2,3


-- Creating View to store data for later visulizations 

create VIEW PercentPopulationVaccinated as 
SELECT
  CD.continent , CD.location , CD.date , CD.population , CV.new_vaccinations ,
SUM(CONVERT(int,new_vaccinations)) over (partition by CD.location order by cd.location , CD.date) as RollingPeopleVaccinated
from 
  CovidDeaths CD 
JOIN CovidVaccinations CV
on 
  CD.location = CV.location
and 
  CD.date = cv.date
where 
  CD.continent is not NULL
--order by 2,3

SELECT * 
from PercentPopulationVaccinated