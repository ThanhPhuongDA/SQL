(SELECT 
    actor_id, last_name
FROM
    actor) 
UNION 
(SELECT 
    customer_id, last_name
FROM
    customer)
ORDER BY 2,1;	