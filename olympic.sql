### Take a glance at the table###
SELECT DISTINCT
    Medal
FROM
    olympic.olympic_history
LIMIT 10;

### 1.How many olympics games have been held ###
SELECT 
    COUNT(DISTINCT Games) AS no_olympic_game
FROM
    olympic.olympic_history
;

### 2.List down all Olympics games held so far###
SELECT DISTINCT Games as no_olympic_game,
		Year, Season, City,
		DENSE_RANK() OVER(ORDER BY Games) as list_no
FROM olympic.olympic_history
;
### 3.Mention the total no of nations who participated in each olympics game###
SELECT DISTINCT Games as no_olympic_game,
		COUNT(DISTINCT NOC) as no_nation
FROM olympic.olympic_history
GROUP BY Games;

### 4.Which year saw the highest and lowest no of countries participating in Olympics###
WITH temp AS(
	SELECT games,COUNT(DISTINCT region) AS count_country
FROM olympic.olympic_history oh
JOIN olympic.region nr ON nr.noc=oh.noc
GROUP BY games)

SELECT DISTINCT
CONCAT(FIRST_VALUE(games) OVER(ORDER BY count_country DESC),'-',
FIRST_VALUE(count_country) OVER(ORDER BY count_country DESC)) AS highest_country,
CONCAT(FIRST_VALUE(games) OVER(ORDER BY count_country),'-',
FIRST_VALUE(count_country) OVER(ORDER BY count_country)) AS lowest_country
FROM temp
;
### 5. Which nation has participated in all of the olympic games###
SELECT 
    r.region AS country, COUNT(DISTINCT (Games)) AS Total_games
FROM
    olympic.olympic_history oh,
    olympic.region r
WHERE
    oh.noc = r.noc
GROUP BY country
HAVING Total_games = (SELECT 
        COUNT(DISTINCT (Games))
    FROM
        olympic.olympic_history)
ORDER BY Total_games DESC;

### 6. Identify the sport which was played in all summer olympics###
SELECT 
    Sport, COUNT(DISTINCT (Games)) AS Total_games
FROM
    olympic.olympic_history
WHERE
    Season = 'Summer'
GROUP BY Sport
HAVING Total_games = (SELECT 
        COUNT(DISTINCT (Games))
    FROM
        olympic.olympic_history
    WHERE
        Season = 'Summer')
ORDER BY Total_games DESC;

### 7. Which Sports were just played only once in the olympics###
SELECT 
    Sport, COUNT(DISTINCT (Games)) AS Total_games
FROM
    olympic.olympic_history
GROUP BY Sport
HAVING Total_games = 1
;
### 8. Fetch the total no of sports played in each olympic games###
SELECT 
    Games, COUNT(DISTINCT (Sport)) AS Total_sport
FROM
    olympic.olympic_history
GROUP BY Games
;

### 9. Fetch oldest athletes to win a gold medal###
SELECT 
    Name AS athlete, Medal, Age
FROM
    olympic.olympic_history
WHERE
    Medal = 'Gold'
        AND Age = (SELECT 
            MAX(Age)
        FROM
            olympic.olympic_history
        WHERE
            Medal = 'Gold')
; 

### 10.Find the Ratio of male and female athletes participated in all olympic games###
SELECT 
    SUM(IF(sex = 'M', 1, 0)) / SUM(IF(sex = 'F', 1, 0)) AS ratio_male_female
FROM
    olympic.olympic_history
;
### 11. Fetch the top 5 athletes who have won the most gold medals##
SELECT * 
FROM
(SELECT *, DENSE_RANK() OVER (ORDER BY win_gold desc) as rnk
FROM (SELECT Name, Team, Sport, COUNT(*) as win_gold
FROM olympic.olympic_history
WHERE Medal= "gold"
GROUP BY Name,Team,Sport
ORDER BY win_gold desc)as x) as y
WHERE rnk<=5;

###/*12.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)###
SELECT * 
FROM
(SELECT *, DENSE_RANK() OVER (ORDER BY win_medal desc) as rnk
FROM (SELECT Name, Team, Sport, COUNT(*) as win_medal
FROM olympic.olympic_history
WHERE Medal <> 'NA'
GROUP BY Name,Team,Sport
ORDER BY win_medal desc)as x) as y
WHERE rnk<=5;

###13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won###
SELECT * 
FROM
(SELECT *, DENSE_RANK() OVER (ORDER BY no_medal desc) as rnk
FROM (SELECT region, COUNT(*) as no_medal
FROM olympic.olympic_history oh , olympic.region r
WHERE Medal <> 'NA' and oh.noc= r.noc
GROUP BY region
ORDER BY no_medal desc)as x) as y
WHERE rnk<=5;

###14. List down total gold, silver and bronze medals won by each country ###
SELECT 
    r.region AS country,
    COUNT(CASE
        WHEN oh.medal = 'gold' THEN 'gold'
    END) AS Gold_medal,
    COUNT(CASE
        WHEN oh.medal = 'silver' THEN 'silver'
    END) AS silver_medal,
    COUNT(CASE
        WHEN oh.medal = 'bronze' THEN 'bronze'
    END) AS bronze_medal
FROM
    olympic.olympic_history oh,
    olympic.region r
WHERE
    oh.noc = r.noc
GROUP BY r.region
ORDER BY 2 DESC
;


### 15.List down total gold, silver and bronze medals won by each country corresponding to each olympic games.###
SELECT 
    r.region AS country,
    Games,
    COUNT(CASE
        WHEN oh.medal = 'gold' THEN 'gold'
    END) AS Gold_medal,
    COUNT(CASE
        WHEN oh.medal = 'silver' THEN 'silver'
    END) AS silver_medal,
    COUNT(CASE
        WHEN oh.medal = 'bronze' THEN 'bronze'
    END) AS bronze_medal
FROM
    olympic.olympic_history oh,
    olympic.region r
WHERE
    oh.noc = r.noc
GROUP BY r.region , Games
ORDER BY 1
;

###/*16.Write SQL query to display for each Olympic Games, which country won the highest gold, silver and bronze medals.*/
SELECT 
    games,
    region AS country,
    COUNT(CASE
        WHEN medal = 'gold' THEN 'gold'
    END) AS max_Gold_medal,
    COUNT(CASE
        WHEN medal = 'silver' THEN 'silver'
    END) AS max_silver_medal,
    COUNT(CASE
        WHEN medal = 'bronze' THEN 'bronze'
    END) AS max_bronze_medal
FROM
    olympic.olympic_history AS o,
    olympic.region AS r
WHERE
    o.noc = r.noc
GROUP BY games , region
ORDER BY region;

SELECT 
    *
FROM
    olympics
LIMIT 10;
SELECT 
    *
FROM
    REGIONS
LIMIT 10;

### 18.Which countries have never won gold medal but have won silver/bronze medals###
SELECT 
    region AS country,
    COUNT(CASE
        WHEN medal = 'gold' THEN 'gold'
    END) AS Gold_medal,
    COUNT(CASE
        WHEN medal = 'silver' THEN 'silver'
    END) AS silver_medal,
    COUNT(CASE
        WHEN medal = 'bronze' THEN 'bronze'
    END) AS bronze_medal
FROM
    olympic.olympic_history oh,
    olympic.region r
WHERE
    oh.noc = r.noc
GROUP BY country
HAVING Gold_medal = 0
    AND (bronze_medal <> 0 OR silver_medal <> 0)
ORDER BY country;


### 19. In which Sport/event, India has won highest medals###
SELECT 
    Sport, MAX(total_medal) AS total_medals
FROM
    (SELECT 
        Sport, COUNT(medal) AS total_medal
    FROM
        olympic.olympic_history oh, olympic.region r
    WHERE
        oh.noc = r.noc AND r.region = 'India'
    GROUP BY Sport) AS cte
GROUP BY Sport
ORDER BY total_medals DESC
LIMIT 1
;

###20.Write an SQL Query to fetch details of all Olympic Games where India won medal(s) in hockey###
SELECT 
    Games,
    Year,
    Season,
    COUNT(IF(Medal <> 'NA', 1, 0)) AS no_medal
FROM
    olympic.olympic_history oh,
    olympic.region r
WHERE
    oh.noc = r.noc AND region = 'India'
        AND Sport = 'Hockey'
GROUP BY Games , Year , Season
ORDER BY Year
;
