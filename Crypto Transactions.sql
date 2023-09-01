SELECT *
FROM (
    SELECT b.algorithm, a.volume,
           CASE
               WHEN MONTH(a.dt) IN (1, 2, 3) THEN 'transactions_Q1'
               WHEN MONTH(a.dt) IN (4, 5, 6) THEN 'transactions_Q2'
               WHEN MONTH(a.dt) IN (7, 8, 9) THEN 'transactions_Q3'
               ELSE 'transactions_Q4'
           END AS quarter
    FROM transactions a
    LEFT JOIN coins b ON a.coin_code = b.code
    where year(a.dt) = 2020
) AS Sourcetable
PIVOT (
    SUM(volume)
    FOR quarter IN ([transactions_Q1], [transactions_Q2], [transactions_Q3], [transactions_Q4])
) AS pivottable;
