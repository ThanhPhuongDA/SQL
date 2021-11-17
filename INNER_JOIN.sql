SELECT country, count(city)
FROM country a
INNER JOIN city b ON
a.country_id = b.country_id
group by country;
