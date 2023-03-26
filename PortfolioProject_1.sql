USE PortfolioProjects;

SELECT  *
FROM 
	CovidDeaths
WHERE 
	continent = ''
ORDER BY 
	3, 4

--SELECT TOP 100 *
--FROM 
--	CovidVaccinations
--ORDER BY 
--	3, 4

-- SELECT the data that we are going to be using

SELECT 
	location
	, date
	, total_cases
	, new_cases
	, total_deaths
	, population
FROM 
	CovidDeaths
ORDER BY 
	location, date

-- Let's look at total cases vs. total deaths

SELECT 
	location
	, date
	, total_cases
	, total_deaths
	, population
	, (total_deaths/total_cases) * 100
FROM 
	CovidDeaths
--WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL
ORDER BY 
	location, date

-- the query above returns error because some of the columns were imported into database with nvarchar data type which does not allow to perform any calculations
-- let's change those columns with numerucal data to be able to perform mathematical operations on them

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [total_cases] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [total_deaths] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [icu_patients] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [hosp_patients] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [weekly_icu_admissions] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [weekly_hosp_admissions] float

ALTER TABLE [dbo].[CovidDeaths]
ALTER COLUMN [date] date

--now we can divide total deaths by total covid cases to get death_rate_percentage

SELECT 
	location
	, date
	, total_cases
	, total_deaths
	, (total_deaths/total_cases) * 100 AS death_rate_percentage
FROM 
	CovidDeaths
ORDER BY 
	location, date

-- Let's look at Total cases vs. Population

SELECT 
	location
	, date
	, population
	, total_cases
	, (total_cases/population) * 100 AS case_rate_percentage
FROM 
	CovidDeaths
ORDER BY 
	location, date

-- Let's find out the country with the highest contamination rate compared to population

SELECT 
	 location
	, population
	, MAX (total_cases) as 'highest_contamination_all_dates_cnt'
	, (MAX (total_cases)/population) * 100 AS max_contamination_rate_percentage
FROM 
	CovidDeaths
GROUP BY 
	location, population
ORDER BY 
	4 DESC

-- Now let's see the list of countries with the highest death count of the population

SELECT 
	 location
	, population
	, MAX (total_deaths) as 'highest_deaths_all_dates_cnt'
--	, (MAX (total_deaths)/population) * 100 AS max_death_rate_percentage
FROM 
	CovidDeaths
WHERE 
	continent <> ''
GROUP BY 
	location, population
ORDER BY 
	3 DESC

-- Let's break data by continent

SELECT 
	 location
	, population as ttl_population
	, MAX (total_deaths) as 'highest_deaths_all_dates_cnt'
	, (MAX (total_deaths)/population) * 100 AS max_death_rate_percentage

FROM 
	CovidDeaths
WHERE 
	continent = ''
	AND location NOT IN ('World', 'High income', 'Upper middle income', 'Lower middle income', 'Low income', 'European Union')
GROUP BY 
	location, population
ORDER BY 
	3 DESC

-- Now we will look at the continents with the highest death count per capita

SELECT 
	 continent
	, MAX (total_deaths) as 'highest_deaths_all_dates_cnt'
FROM 
	CovidDeaths
WHERE 
	continent <> ''
GROUP BY 
	continent
ORDER BY 
	2 DESC

-- Global numbers of total cases and total deatsh by dates, with new_deaths to new_cases ratio

SELECT 
		date
	 , SUM (new_cases ) AS total_cases_sum
	 , SUM (new_deaths) AS total_deaths_sum
	 , CASE WHEN SUM (new_deaths) = 0 THEN 0
		ELSE	SUM (CAST (new_deaths AS int)) / SUM (new_cases) * 100
		END as new_deaths_to_cases_ratio
FROM 
	CovidDeaths
WHERE
	continent <> ''
GROUP BY 
	date
ORDER BY 
	date

--SELECT
--	date
--	, new_cases
--	, new_deaths
--	, coalesce (new_deaths, 0)
--FROM 
--	CovidDeaths
--WHERE 
--	new_deaths IS NULL


-- Now let's look at total population vs new_vaccinations and rolling_sum of new_vaccinations

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [date] date

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_tests] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_tests] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_tests_per_thousand] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_tests_per_thousand] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_tests_smoothed] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_tests_smoothed] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_tests_smoothed_per_thousand] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [positive_rate] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [tests_per_case] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_vaccinations] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [people_vaccinated] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [people_fully_vaccinated] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_boosters] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_vaccinations] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_vaccinations_smoothed] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_vaccinations_per_hundred] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [people_vaccinated_per_hundred] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [people_fully_vaccinated_per_hundred] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [total_boosters_per_hundred] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_vaccinations_smoothed_per_million] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_people_vaccinated_smoothed] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [new_people_vaccinated_smoothed_per_hundred] float

ALTER TABLE [PortfolioProjects]..CovidVaccinations
ALTER COLUMN [stringency_index] float




SELECT 
	d.continent
	, d.location
	, d.date
	, v.new_vaccinations
	, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) as rolling_sum_new_vaccinations
FROM 
	[PortfolioProjects]..CovidDeaths d
	JOIN [PortfolioProjects]..CovidVaccinations v
		ON d.location = v.location AND d.date = v.date	
WHERE 
	d.continent <>''
ORDER BY 
	2, 3

-- Use CTE

WITH pop_vs_vac AS (
	SELECT 
	d.continent
	, d.location
	, d.population
	, d.date
	, v.new_vaccinations
	, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) as rolling_sum_new_vaccinations
FROM 
	[PortfolioProjects]..CovidDeaths d
	JOIN [PortfolioProjects]..CovidVaccinations v
		ON d.location = v.location AND d.date = v.date	
WHERE 
	d.continent <>''
)
SELECT 
	*
	, rolling_sum_new_vaccinations/population*100 as rolling_percentage_vaccinated
FROM 
	pop_vs_vac
ORDER BY 
	2,4

--let's create a TEMP TABLE as an alternative to CTE

DROP TABLE IF EXISTS #temp_PercentPopulationVaccinated
CREATE TABLE #temp_PercentPopulationVaccinated
(
	Continent nvarchar(255)
	, location nvarchar(255)
	, population numeric 
	, date datetime2
	, new_vaccinations numeric
	, rolling_sum_new_vaccinations numeric
) 
INSERT INTO #temp_PercentPopulationVaccinated
	SELECT 
		d.continent
		, d.location
		, d.population
		, d.date
		, v.new_vaccinations
		, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) as rolling_sum_new_vaccinations
	FROM 
		[PortfolioProjects]..CovidDeaths d
		JOIN [PortfolioProjects]..CovidVaccinations v
			ON d.location = v.location AND d.date = v.date	
	WHERE 
		d.continent <>''

SELECT *, rolling_sum_new_vaccinations/population*100 as percentage_population_vaccinated
FROM 
	#temp_PercentPopulationVaccinated
ORDER BY 
	2, 4

-- Now let's create a view to store data for later vizualizations

DROP VIEW IF EXISTS view_PercentPopulationVaccinated;
CREATE VIEW view_PercentPopulationVaccinated
AS
SELECT 
		d.continent
		, d.location
		, d.population
		, d.date
		, v.new_vaccinations
		, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) as rolling_sum_new_vaccinations
	FROM 
		[PortfolioProjects]..CovidDeaths d
		JOIN [PortfolioProjects]..CovidVaccinations v
			ON d.location = v.location AND d.date = v.date	
	WHERE 
		d.continent <>'';

SELECT *
FROM 
	view_PercentPopulationVaccinated
ORDER BY 
	2, 4