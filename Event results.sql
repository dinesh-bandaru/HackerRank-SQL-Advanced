select * from (
SELECT DISTINCT event_id, rks, STRING_AGG(c.participant_name, ',') WITHIN GROUP ( ORDER BY participant_Name ASC)  AS part
FROM (
    SELECT b.*, 
           CASE
               WHEN b.rk = 1 THEN 'first'
               WHEN b.rk = 2 THEN 'second'
               WHEN b.rk = 3 THEN 'third'
               ELSE 'other'
           END AS rks
    FROM (
        SELECT a.*,
               DENSE_RANK() OVER (PARTITION BY event_ID ORDER BY a.score DESC) AS rk
        FROM (
            SELECT DISTINCT event_id, participant_name, MAX(score) AS score 
            FROM scoretable
            GROUP BY event_id, participant_name
        ) a
    ) b
) AS c
GROUP BY event_id, rks) as sourcetable
pivot(max(part)
     for rks in ([first],[second],[third])) as pvt
