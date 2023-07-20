SELECT * FROM [dbo].[coviddeaths]
SELECT * FROM [dbo].[Covidvaccination]


--SELECT DATA THAT WE ARE GOING TO USING
SELECT LOCATION,DATE,[total_cases],[new_cases],[total_deaths],[population]
FROM [dbo].[coviddeaths]
ORDER BY 1,2

--LOOKING AT THE TOTAL CASES AND TOTAL DEATHS
SELECT [location],[date],[total_cases],[total_deaths],(total_deaths/[total_cases])*100 AS DEATH_PERCENTAGE
FROM [dbo].[coviddeaths]
WHERE location LIKE'%STATES%'


--LOOKING AT TOTAL CASES VS POPULATION
SELECT [location],[date],[total_cases],population,(total_cases/population)*100 AS AFFECTED_PERCENTAGE
FROM [dbo].[coviddeaths]
--WHERE location LIKE'%STATES%'
ORDER BY 1,2

--LOOKING AT COUNTRY WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT [location],population,(MAX([total_cases]),MAX(total_cases/population)*100 AS AFFECTED_PERCENTAGE
FROM [dbo].[coviddeaths]
GROUP BY [location],[population]
ORDER BY AFFECTED_PERCENTAGE DESC

--SHOWING THE COUNTRY WITH HIGHEST DEATHCOUNT PER PERCENTAAGE
SELECT LOCATION,MAX(CAST([total_deaths] AS INT))AS TOTAL_DEATHS
FROM [dbo].[coviddeaths]
WHERE [continent] IS NOT NULL
GROUP BY location
ORDER BY TOTAL_DEATHS DESC


--LET'S BREAK THINGS BY LOCATION

SELECT location,MAX(CAST([total_deaths] AS INT))AS TOTAL_DEATHS
FROM [dbo].[coviddeaths]
WHERE [continent] IS  NULL
GROUP BY location
ORDER BY TOTAL_DEATHS DESC

   
--LET'S BREAK THINGS BY CONTINENT
SELECT [continent],MAX(CAST([total_deaths] AS INT))AS TOTAL_DEATHS
FROM [dbo].[coviddeaths]
WHERE [continent] IS NOT NULL
GROUP BY [continent]
ORDER BY TOTAL_DEATHS DESC

--SHOWING THE CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATOIN

SELECT [continent],MAX(CAST([total_deaths] AS INT))AS TOTAL_DEATHS
FROM [dbo].[coviddeaths]
WHERE [continent] IS NOT NULL
GROUP BY [continent]
ORDER BY TOTAL_DEATHS DESC



--BREAKING GLOBAL NUMBERS

SELECT DATE,SUM([new_cases])[SUM OF NEW CASES],SUM(CAST([new_deaths] AS INT))[SUM OF DEATHS],
sum(cast([new_deaths] as int))/sum([new_cases])*100 as death_percentage
FROM [dbo].[coviddeaths]
WHERE continent IS NOT NULL
GROUP BY [date]
order by 1,2


SELECT SUM([new_cases])[SUM OF NEW CASES],SUM(CAST([new_deaths] AS INT))[SUM OF DEATHS],
sum(cast([new_deaths] as int))/sum([new_cases])*100 as death_percentage
FROM [dbo].[coviddeaths]
WHERE continent IS NOT NULL
--GROUP BY [date]
order by 1,2


select* from [dbo].[Covidvaccination]

SELECT *FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location
AND A.date=B.date


--LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT A.[continent], A.[location],A.[date],A.[population],B.[new_vaccinations]
FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location 
AND A.date=B.date
WHERE A.continent IS NOT NULL
ORDER BY 1,2,3


SELECT A.[continent], A.[location],A.[date],A.[population],B.[new_vaccinations],
SUM(CAST(B.[new_vaccinations]AS INT))OVER(PARTITION BY A.LOCATION ORDER BY A.LOCATION,A.DATE)
FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location 
AND A.date=B.date
WHERE A.continent IS NOT NULL
ORDER BY 1,2,3


--USE CTE
WITH POPVSVAC(CONTINENT,LOCATION,DATE,POPULATION,[new_vaccinations],ROLLINGVAC)
AS
(
SELECT A.[continent], A.[location],A.[date],A.[population],B.[new_vaccinations],
SUM(CAST(B.[new_vaccinations]AS INT))OVER(PARTITION BY A.LOCATION ORDER BY A.LOCATION,A.DATE)AS ROLLINGVAC
FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location 
AND A.date=B.date
WHERE A.continent IS NOT NULL
--ORDER BY 1,2,3
)
SELECT *,(ROLLINGVAC/POPULATION)*100 FROM POPVSVAC



--TEMP TABLE
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC
)
DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED

INSERT INTO #PERCENTPOPULATIONVACCINATED
SELECT A.[continent], A.[location],A.[date],A.[population],B.[new_vaccinations],
SUM(CAST(B.[new_vaccinations]AS INT))OVER(PARTITION BY A.LOCATION ORDER BY A.LOCATION,A.DATE)AS ROLLINGVAC
FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location 
AND A.date=B.date
--WHERE A.continent IS NOT NULL


SELECT *,(ROLLINGPEOPLEVACCINATED/POPULATION)*100 FROM #PERCENTPOPULATIONVACCINATED

--CREATE VIEW TON STORE DATA 
CREATE VIEW PERCENTPOPULATIONVACCINATED AS

SELECT A.[continent], A.[location],A.[date],A.[population],B.[new_vaccinations],
SUM(CAST(B.[new_vaccinations]AS INT))OVER(PARTITION BY A.LOCATION ORDER BY A.LOCATION,A.DATE)AS ROLLINGVAC
FROM [dbo].[coviddeaths] A
JOIN [dbo].[Covidvaccination] B
ON A.location=B.location 
AND A.date=B.date
WHERE A.continent IS NOT NULL
--ORDER BY 1,2,3


SELECT * FROM [dbo].[PERCENTPOPULATIONVACCINATED]



















