SELECT
    DATE_TRUNC('DAY', block_timestamp) AS date,
    COUNT(DISTINCT transaction_hash) AS mev_transactions,
    SUM(gross_profit_usd) AS mev_gross_profits,
    COUNT(DISTINCT miner_address) AS mev_miners,
    SUM(miner_payment_usd) AS mev_miner_revenue
FROM `flashbots`.`mev_summary`
GROUP BY date
ORDER BY date
