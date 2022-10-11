select date,count(distinct account) as Users
from (
select date_trunc('day',block_time) as date,trader_a as account
from dex."trades"
union
select date_trunc('day',block_time) as date,trader_b as account
from dex."trades"
 UNION SELECT date_trunc('day', evt_block_time) AS date,
                      minter AS account
         FROM compound_v2."cErc20_evt_Mint"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      borrower AS account
         FROM compound_v2."cErc20_evt_Borrow"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      minter AS account
         FROM compound_v2."cEther_evt_Mint"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      borrower AS account
         FROM compound_v2."cEther_evt_Borrow"
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      _target AS account
         FROM aave."LendingPool_evt_FlashLoan"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      _user AS account
         FROM aave."LendingPool_evt_Borrow"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      _user AS account
         FROM aave."LendingPool_evt_Deposit"
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      account
         FROM synthetix."Synth_evt_Issued"
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      minter AS account
         FROM creamfinance."CErc20Delegate_evt_Mint"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      borrower AS account
         FROM creamfinance."CErc20Delegate_evt_Borrow"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      minter AS account
         FROM creamfinance."CEther_evt_Mint"
         
         UNION SELECT date_trunc('day', evt_block_time) AS date,
                      borrower AS account
         FROM creamfinance."CEther_evt_Borrow"
         
) as a
where date_trunc('day',date) < date_trunc('day',now())
group by 1
order by 1
