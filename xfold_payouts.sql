-- xFold payout for period 2022-01-15 (inclusive) to 2021-02-15 (exclusive)
-- Calculates a TWAP for Xfold staked with hourly granularity. Outputs ratio of staking reward per address
-- 
-- TODO: 
-- 1. include total_xfold_hours as part of the query, instead of out-of-band (it's calculated using the same query but without the `group by address` all the way at the end)
-- 2. possibly do granularity by minute instead of hour
-- 3. Dune parameters

-- SELECT
--     SUM(ratio) -- check adds up to 1. CHECK (0.9999999999998469 due to rounding)
-- FROM (
    SELECT 
      *, 
      xfold_hours/total_xfold_hours as ratio, -- ratio of staking rewards that should go to this address
      300000 as payout_total_in_USD,
      300000 * (xfold_hours/total_xfold_hours) as payout_address_in_USD, 
      35 as fold_in_usd_during_payout,
      (300000 / 35) * (xfold_hours/total_xfold_hours) as payout_address_in_FOLD
    FROM (
        SELECT 
            address, 
            233207682.94454342 as total_xfold_hours, -- The total xfold staked over all addresses, cumulated over all hours in the staking period. TODO: should include in SQL. For now remove the outer `group by address` to arrive at this number
            sum(balance) xfold_hours, -- The total xfold staked by this address, cumulated over all hours in the staking period.
            avg(balance) xfold_twap -- Time weighted moving average of staked fold
        FROM(
            SELECT
                bucket,
                address,
                -- extremely convoluted way to get last value of balance (also see SUM(CASE WHEN balance IS NULL THEN 0 ELSE 1 END) below to get to last_value. 
                -- Needed bc Postgres doesn't support an EXCLUDE NULLS option for window functions. Better yet would be TimescaleDB's rather beautiful last(balance, bucket). Hope Dune will support Timescale in the future
                -- https://stackoverflow.com/questions/18987791/how-do-i-efficiently-select-the-previous-non-null-value
                (COALESCE(SUM(balance) OVER(PARTITION BY address, partition), 0) / 10^18) balance
            FROM (
                WITH 
                time_buckets as ( -- Generate time buckets of 1 minute granularity for the appropriate time range. Crossproduct with address. Hack for lack of LEFT JOIN LATERAL in Dune. End result is a row per <time,address>-combi
                    SELECT 
                        bucket, 
                        address
                    -- NOTE: Start at 2021-12-15Z (start staking) irrespective of time range we're calculating ratio over. 
                    FROM generate_series(timestamp with time zone '2021-12-15Z', timestamp with time zone '2022-02-14T23:59Z', interval  '1 hour') t(bucket) 
                    CROSS JOIN ( 
                        
                        SELECT DISTINCT address FROM (
                            SELECT "to" as address FROM erc20."ERC20_evt_Transfer" WHERE contract_address = '\x454BD9E2B29EB5963048cC1A8BD6fD44e89899Cb'
                            UNION 
                            SELECT "from" as address FROM erc20."ERC20_evt_Transfer" WHERE contract_address = '\x454BD9E2B29EB5963048cC1A8BD6fD44e89899Cb'
                        ) as x
                        WHERE TRUE
                            AND address != '\x0000000000000000000000000000000000000000'
                            -- AND address = '\xa56e492835ee37a108609608340bd6ed08fbfc77'
                    ) as x 
                ),
                balances as ( -- Show 1 row per time-bucket (minute granularity) where a balance change occurs 
                    SELECT *
                    FROM (
                        -- Get all the transactions relating to xFold. 
                        -- This includes mint, burn and transfers of xFold
                        -- Exclude the burn-address
                        -- Take the running total ( = balance at point-in-time) of xFold per address
                        -- Distinct + Desc ordering -> only keep the latest row ( = balance) for this timebucket. (Solves edge-case when for an address more than 1 trades where done within 1 timebucket)
                        WITH transactions as (
                            SELECT * FROM 
                            (
                                SELECT 
                                    evt_block_time AS block_time,
                                    "to" as address, -- address that minted xFold or received xFold from another address
                                    value AS amount
                               FROM erc20."ERC20_evt_Transfer"
                               WHERE TRUE
                               AND contract_address = '\x454BD9E2B29EB5963048cC1A8BD6fD44e89899Cb'
                               
                               UNION ALL
                            
                               SELECT 
                                    evt_block_time AS block_time,
                                    "from" as address, -- address that burned xFold or sent xFold to another address
                                    -value AS amount
                               FROM erc20."ERC20_evt_Transfer"
                               WHERE TRUE
                               AND contract_address = '\x454BD9E2B29EB5963048cC1A8BD6fD44e89899Cb'
                            ) x 
                            WHERE TRUE 
                            AND address != '\x0000000000000000000000000000000000000000'
                            ORDER BY block_time ASC 
                        )
                        SELECT DISTINCT ON(bucket, address)
                         date_trunc('hour', block_time) as bucket, 
                         address, 
                         SUM(amount) over (partition by address order by block_time asc) balance -- sum all tx until now, i.e.: balance is a running total over all transactions
                        FROM transactions
                        WHERE TRUE 
                        ORDER BY bucket DESC -- DESC because we're doing a DISTINCT ON which grabs the first entry per distinct-bucket, which when ordering DESC is the last one chronologically, which is correct 
                    ) as x
                    ORDER BY bucket ASC
                )
                SELECT
                    time_buckets.bucket, 
                    time_buckets.address, 
                    balance,
                    SUM(CASE WHEN balance IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY time_buckets.address ORDER BY time_buckets.bucket) AS partition -- create partitions used to to a last_value calc above
                FROM time_buckets
                LEFT JOIN balances ON time_buckets.bucket = balances.bucket AND time_buckets.address = balances.address
                ORDER BY bucket, address
            ) as x 
        ) as x
        WHERE TRUE 
        AND bucket >= '2022-01-15Z'
        GROUP BY address
        ORDER BY address
    ) as x 
-- ) as x
