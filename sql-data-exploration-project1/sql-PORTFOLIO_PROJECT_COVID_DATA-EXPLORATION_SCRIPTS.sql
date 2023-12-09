-- Exploring Covid Death Cases
SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Death after contracting covid, percentage by country
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2

-- Looking at total cases vs population
SELECT 
	location, 
	date, 
	population, 
	total_cases, 
	(total_cases/population)*100 AS GettingCovidPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- Countries with highest infection rate compared to population
SELECT 
	location, 
	population, 
	MAX(total_cases) AS HighestInfectionCount, 
	MAX((total_cases/population))*100 AS infected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY infected DESC

-- Countries with highest death count per population
SELECT 
	location, 
	MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Continents with highest death count per population
SELECT 
	continent, 
	MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global numbers
SELECT 
	SUM(total_cases) AS TotalCasesCount,
	SUM(cast(total_deaths as int)) AS TotalDeathCount,
	SUM(cast(new_deaths as int))/SUM(total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY TotalDeathCount DESC;

--Exploring Covid Vaccination cases
SELECT *
FROM PortfolioProject..CovidVaccinations

--Looking at total population vs vaccinations
SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(CONVERT(int, cv.new_vaccinations)) 
		OVER (PARTITION BY cd.location
			ORDER BY cd.location, cd.date) AS TotalVaccinatedATM
FROM PortfolioProject..CovidDeaths cd
INNER JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 1,2,3

--Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT
	cd.continent,
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(CONVERT(int, cv.new_vaccinations)) 
		OVER (PARTITION BY cd.location
			ORDER BY cd.location, cd.date) AS TotalVaccinatedATM
FROM PortfolioProject..CovidDeaths cd
INNER JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL