SELECT block_time,
       block_number,
       min(gas_price) / 10^9 AS min_gas_price,
       avg(gas_price) / 10^9 AS avg_gas_price,
       max(gas_price) / 10^9 AS max_gas_price
FROM ethereum.transactions
GROUP BY block_time, block_number
ORDER BY block_time DESC
LIMIT 2000
