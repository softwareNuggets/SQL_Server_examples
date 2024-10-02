WITH MinCoinCte (powr, age, min_coins) 
AS
(
    SELECT w.[power], wp.age, MIN(w.coins_needed)
    FROM Wands w
        JOIN Wands_Property wp 
            ON (w.code = wp.code)
    WHERE wp.is_evil = 0
    GROUP BY w.[power], wp.age
)
SELECT w.id, wp.age, w.coins_needed, w.[power]
FROM Wands w
    JOIN Wands_Property wp 
        ON (w.code             = wp.code)
    JOIN MinCoinCte cte 
        ON (w.[power]            = cte.powr
            AND wp.age           = cte.age 
            AND w.coins_needed   = cte.min_coins)
WHERE wp.is_evil = 0
ORDER BY w.[power] DESC, wp.age DESC;