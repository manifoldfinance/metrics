WITH raw1 as
(
SELECT 
--date_trunc('day', block_time) as Date,
--sum(value / 1e18) as ETH_to_UUpool
--block_time,
--value / 1e18 as val,
--tx_hash
*
FROM ethereum."traces"
WHERE gas_used = 0
AND "to" = '\xd224ca0c819e8e97ba0136b3b95ceff503b79f53'
AND block_time > '2020-12-18'
),

raw2 as
(
SELECT 
raw1.block_time as block_time,
tx_hash,
CASE
    WHEN tx_index = 0 THEN raw1.value/1e18
    ELSE raw1.value/1e18 + (t.gas_used * 2.2e-7)
END as miner_payment_estimation
FROM raw1
LEFT JOIN ethereum.transactions t ON t.hash = raw1.tx_hash
WHERE t."from" != '\x7d92AD7e1b6Ae22c6a43283aF3856028CD3d856A'
)

SELECT 
date_trunc('day', block_time) as Date,
sum(miner_payment_estimation) as miner_payment_estimation
FROM raw2
GROUP BY 1
ORDER BY 1 DESC
