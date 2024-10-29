--countries with the highest total medal counts

SELECT country, total
FROM olympics
ORDER BY total DESC
LIMIT 5;

--Total medals won by each region
SELECT region, SUM(total) AS total_medals
FROM olympics
GROUP BY region
ORDER BY total_medals DESC;

--GDP per capita for each country
SELECT country, gdp / population AS gdp_per_capita
FROM olympics
ORDER BY gdp_per_capita DESC;

--Countries with a gold medal count greater than 10
SELECT country, gold
FROM olympics
WHERE gold > 10
ORDER BY gold DESC;

--Top 5 countries by GDP
SELECT country, gdp
FROM olympics
ORDER BY gdp DESC
LIMIT 5;

--Total medals won by each country and sorted by medals per capita
SELECT country, total, population, (total / population) AS medals_per_capita
FROM olympics
ORDER BY medals_per_capita DESC;

--Countries with  population greater than 100 million
SELECT country, population
FROM olympics
WHERE population > 100;

--Countries with GDP greater than the average GDP of all countries
SELECT country, gdp
FROM olympics
WHERE gdp > (SELECT AVG(gdp) FROM olympics)
ORDER BY gdp DESC;

--Countries with more silver than gold medals
SELECT country, gold, silver
FROM olympics
WHERE silver > gold;

--List the top 3 countries with the highest population in each region
SELECT country, region, population
FROM (
    SELECT country, region, population,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY population DESC) AS rank
    FROM olympics
) AS ranked
WHERE rank <= 3;

--Countries with both a GDP over 50,000 and more than 20 total medals
SELECT country, gdp, total
FROM olympics
WHERE gdp > 50000 AND total > 20;

--Countries with a medal count higher than the regional average
SELECT country, region, total
FROM olympics c
WHERE total > (
    SELECT AVG(total)
    FROM olympics
    WHERE region = c.region
)
ORDER BY region, total DESC;

--Countries with GDP per capita between $10,000 and $50,000
SELECT country, gdp, population, (gdp / population) AS gdp_per_capita
FROM olympics
WHERE (gdp / population) BETWEEN 10000 AND 50000
ORDER BY gdp_per_capita DESC;

--Calculate the percentage of medals by type for each country
SELECT country, 
       (gold * 100.0 / total) AS gold_percentage,
       (silver * 100.0 / total) AS silver_percentage,
       (bronze * 100.0 / total) AS bronze_percentage
FROM olympics
WHERE total > 0
ORDER BY country;

--Top 3 countries by total medals for each continent
SELECT country, region, total
FROM (
    SELECT country, region, total,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY total DESC) AS rank
    FROM olympics
) AS ranked
WHERE rank <= 3;

--Regions with the highest average gold medals per country
SELECT region, AVG(gold) AS avg_gold_medals
FROM olympics
GROUP BY region
ORDER BY avg_gold_medals DESC;

--Find the country with the highest population in each region
SELECT country, region, population
FROM olympics c1
WHERE population = (SELECT MAX(population) FROM olympics c2 WHERE c1.region = c2.region);

--Countries that have won at least one medal
SELECT country, gold, silver, bronze
FROM olympics
WHERE gold > 0 AND silver > 0 AND bronze > 0
ORDER BY total DESC;


--Top 5 countries by medals per capita, grouped by region
SELECT country, region, total, population, (total / population) AS medals_per_capita
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY (total / population) DESC) AS rank
    FROM olympics
) AS ranked
WHERE rank <= 5
ORDER BY region, medals_per_capita DESC;

--The percentage of total medals by region
SELECT region, SUM(total) AS region_medals,
       (SUM(total) * 100.0 / (SELECT SUM(total) FROM olympics)) AS percentage_of_total_medals
FROM olympics
GROUP BY region
ORDER BY percentage_of_total_medals DESC;

--Regions with the most balanced distribution of medals (based on average deviation from median medals)
SELECT region, AVG(total) AS median_medal
FROM (
    SELECT region, total,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY total) AS row_num,
           COUNT(*) OVER (PARTITION BY region) AS total_count
    FROM olympics
) AS ranked
WHERE row_num = (total_count + 1) / 2  -- middle row for odd counts
   OR (total_count % 2 = 0 AND row_num IN (total_count / 2, total_count / 2 + 1))  
GROUP BY region;

--Countries that are outliers in terms of GDP per capita
SELECT country, gdp, population, (gdp / population) AS gdp_per_capita
FROM olympics
WHERE (gdp / population) > (SELECT AVG(gdp / population) + 2 * STDDEV(gdp / population) FROM olympics)
   OR (gdp / population) < (SELECT AVG(gdp / population) - 2 * STDDEV(gdp / population) FROM olympics)
ORDER BY gdp_per_capita DESC;



























