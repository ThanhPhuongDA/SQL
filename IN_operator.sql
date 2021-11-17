SELECT 
    title, release_year, rental_duration
FROM
    film
WHERE
    rental_duration IN (3 , 6)
LIMIT 7
;