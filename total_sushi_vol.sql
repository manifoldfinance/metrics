WITH arb_traders AS
  (SELECT t1.tx_from
   FROM dex.trades t1
   INNER JOIN dex.trades t2 ON t1.tx_hash = t2.tx_hash
   WHERE t1.block_time >= date_trunc('day', now() - interval '180 days')
     AND t1.token_a_address = t2.token_b_address
     AND t1.token_b_address = t2.token_a_address
     AND t1.evt_index != t2.evt_index
     AND ((t1.project = 'Uniswap'
           AND t2.project = 'Bancor Network')
          OR (t1.project = 'Uniswap'
              AND t2.project = 'Balancer')
          OR (t1.project = 'Uniswap'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Uniswap'
              AND t2.project = 'Kyber')
          OR (t1.project = 'Uniswap'
              AND t2.project = 'Curve')
          OR (t1.project = 'Uniswap'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Bancor Network'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Bancor Network'
              AND t2.project = 'Balancer')
          OR (t1.project = 'Bancor Network'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Bancor Network'
              AND t2.project = 'Kyber')
          OR (t1.project = 'Bancor Network'
              AND t2.project = 'Curve')
          OR (t1.project = 'Balancer'
              AND t2.project = 'Kyber')
          OR (t1.project = 'Balancer'
              AND t2.project = 'Bancor Network')
          OR (t1.project = 'Balancer'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Balancer'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Balancer'
              AND t2.project = 'Curve')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Kyber')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Bancor Network')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Balancer')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Curve')
          OR (t1.project = 'Sushiswap'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Kyber'
              AND t2.project = 'Bancor Network')
          OR (t1.project = 'Kyber'
              AND t2.project = 'Balancer')
          OR (t1.project = 'Kyber'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Kyber'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Kyber'
              AND t2.project = 'Curve')
          OR (t1.project = 'Curve'
              AND t2.project = 'Bancor Network')
          OR (t1.project = 'Curve'
              AND t2.project = 'Balancer')
          OR (t1.project = 'Curve'
              AND t2.project = 'Sushiswap')
          OR (t1.project = 'Curve'
              AND t2.project = 'Uniswap')
          OR (t1.project = 'Curve'
              AND t2.project = 'Curve')
          OR (t1.project = 'Curve'
              AND t2.project = 'Kyber'))
   GROUP BY t1.tx_from
   UNION
   SELECT
        '\x000002Cba8DfB0a86A47a415592835E17fac080a' as tx_from
   FROM dex.trades t3
      UNION
   SELECT
        '\x4ef377462b03b650d52140c482394a6703d0d338' as tx_from
   FROM dex.trades t3
   )
SELECT date_trunc('days', block_time),
       SUM(usd_amount) AS "Sushiswap Total Volume",
       SUM(CASE
               WHEN t.tx_from IN
                      (SELECT DISTINCT tx_from
                       FROM arb_traders) THEN usd_amount
               ELSE 0
           END) AS "Sushiswap Arb Bot Volume",
       SUM(CASE
               WHEN t.tx_from IN
                      (SELECT DISTINCT tx_from
                       FROM arb_traders) THEN 0
               ELSE usd_amount
           END) AS "Sushiswap Organic Volume"
FROM dex."trades" t
WHERE block_time > now() - interval '180 days'
  AND project = 'Sushiswap'
  --AND (token_a_symbol = 'LINK' or token_b_symbol = 'LINK')
GROUP BY 1 ;
