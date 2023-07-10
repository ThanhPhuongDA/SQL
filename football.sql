

----During the year 2022-2023 in Premier League, the home club has got their net shaken the least and how many goals did their opposing team scored?

SELECT top(1) m.home_team as team,
	SUM(m.ftag) as goals_against
FROM dbo.match as m
JOIN division as d
ON d.code = m.division
WHERE m.season = '2022-2023' 
	AND d.name = 'Premier League'
GROUP BY m.home_team
ORDER BY sum(m.ftag) asc
;
----During the year 2021-2022 in Premier League, the away club has scored most goals and how many goals did they score?

SELECT TOP(1) m.away_team as team,
	SUM(m.ftag) as goals_no
FROM dbo.match as m
JOIN division as d
ON d.code = m.division
WHERE m.season = '2021-2022' 
	AND d.name = 'Premier League'
GROUP BY m.away_team
ORDER BY SUM(m.ftag) DESC
;

--- Liverpool won most of the matches as an away_team with which referee and how many times did they win when that referee was in charge?

SELECT top(1)referee, 
	SUM(CASE WHEN ftr ='A' THEN 1 ELSE 0 END)as winning_matches,
	COUNT(id) AS no_matches_played,
	ROUND(SUM(CASE WHEN ftr ='A' THEN 1 ELSE 0 END)*1.0/COUNT(id),2) as win_rate
FROM dbo.match 
WHERE away_team ='Liverpool'
GROUP BY referee
HAVING COUNT(id) >10
ORDER BY win_rate desc
;

---In Premier League 2021-2022, which home team fouled the most?
SELECT TOP(5) m.home_team,
	SUM(CASE WHEN m.hf IS NULL THEN 0 ELSE m.hf END)as fouls
FROM dbo.match m
JOIN division as d
ON d.code = m.division
WHERE m.season = '2021-2022' 
	AND d.name = 'Premier League'
GROUP BY m.home_team
ORDER BY sum(CASE WHEN m.hf IS NULL THEN 0 ELSE m.hf END) DESC;

---In Premier League 2021-2022, which team has mostly won back after scoring more in the second half?
SELECT top(1) m.away_team,
	COUNT(m.id)as no_matches
FROM dbo.match m
JOIN division as d
ON d.code = m.division
WHERE m.season = '2021-2022' 
	AND d.name = 'Premier League'
	and( ftr = 'A'and htr='H')
GROUP BY m.away_team
ORDER BY no_matches DESC;

---- Total football matches in La Liga history?

SELECT 
COUNT(m.id)as no_matches
FROM dbo.match m
JOIN division as d
ON d.code = m.division
WHERE d.name = 'La Liga'


--- The 3 away teams that scored most goals in a match?
SELECT TOP(3)away_team, 
	MAX(ftag) as max_away_goals
FROM dbo.match
GROUP BY away_team
ORDER BY max_away_goals DESC;

---- The match that has the least number of audiences watching it and how many audiences are there?
SELECT TOP(1)home_team, 
	away_team, 
	attendance as no_audience
FROM dbo.match
WHERE attendance = (SELECT MIN(attendance) FROM dbo.match)
;

---Man City club scored how many goals in season 2017-2018 as a home team?
SELECT home_team, SUM(CASE WHEN fthg IS NULL THEN 0 ELSE fthg END) as no_goals
FROM dbo.match
WHERE home_team='Man City'
AND season ='2017-2018'
GROUP BY home_team

----Which referee has given the highest no. of yellow cards in a match for a home_team and in which match?
SELECT  referee, home_team, 
	MAX(hy) as no_yellow_card
FROM dbo.match
WHERE hy =(SELECT MAX(hy) from dbo.match)
GROUP BY home_team, referee;

---Which team football won the most matches as a home_team ?
WITH r as(
SELECT home_team, 
	COUNT(id) as win_matches
FROM dbo.match
WHERE fthg > ftag
GROUP BY home_team)

SELECT home_team,
	win_matches
FROM r
WHERE win_matches = (SELECT max(win_matches)FROM r)


----The football matches that had the average total number of goals was the highest?
WITH temp_table AS(
SELECT division,
	COUNT(id) as total_match,
	ROUND(AVG((fthg+ftag)*1.0),2) as avg_goals
FROM dbo.match 
GROUP BY division
) 
SELECT  d.name, 
	MAX(t.avg_goals)
FROM temp_table t ,division d
WHERE t.division=d.code
AND t.avg_goals = (SELECT MAX(avg_goals)FROM temp_table)
GROUP BY d.name
;

--- Referee Graham Barber has worked in how many matches?
SELECT referee, 
	COUNT(id) as no_appearance
FROM dbo.match
WHERE referee ='Graham Barber'
GROUP BY referee

----Man United has scored and was scored how many goals as a home_team in season 2020-2021?

SELECT home_team,
	SUM(fthg) as goals_for,
	SUM(ftag) as goals_against,
	SUM(fthg) - SUM(ftag) as goal_gap
FROM dbo.match
WHERE season='2020-2021'
AND home_team='Man United'
GROUP BY home_team

---The leagues that have highest no.goals each match?
 
SELECT TOP(3) d.name, 
	d.code,
	ROUND(AVG((m.fthg+m.ftag)*1.0),2) as avg_goal_per_match
FROM dbo.match m
JOIN division d
ON m.division=d.code
GROUP BY d.name,d.code
ORDER BY avg_goal_per_match DESC
;

----The match that has the highest no. of audiences in Old Trafford, home stadium of Man United in season 2020-2021?
SELECT home_team,
	(MAX(attendance)*1.0/74310)*100 AS attend_capa
FROM dbo.match
WHERE season='2020-2021' 
	AND home_team ='Man United' 
	AND attendance IS NOT NULL
GROUP BY home_team
;

---Whether Man City is among top 3 away teams that scored the highest no. of goals season 2021-2022 in Premier League?
SELECT top(3)away_team, 
	ROUND(AVG(ftag)*1.00,2) as avg_goal
FROM dbo.match
WHERE   season ='2021-2022'
	AND division ='E0' 
GROUP BY away_team
ORDER BY avg_goal DESC;

