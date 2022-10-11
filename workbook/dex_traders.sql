WITH traders AS (

  SELECT project, trader_a AS trader
  FROM dex."trades"
  WHERE block_time > now() - interval '365 days'
  
  UNION 
  
  SELECT project, trader_b AS trader
  FROM dex."trades"
  WHERE block_time > now() - interval '365 days'
  
)

SELECT ROW_NUMBER () OVER (ORDER BY SUM(traders) DESC) AS "Rank", project AS "Project", SUM(traders) AS "Number of Traders" FROM
(
  SELECT project, COUNT(distinct trader) AS traders
  FROM traders
  GROUP BY 1
) users
GROUP BY 2
ORDER BY 1 asc;
