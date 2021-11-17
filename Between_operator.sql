SELECT 
    title, release_year, rental_duration
FROM
    film
WHERE
    rental_duration BETWEEN 3 AND 6
LIMIT 7;
