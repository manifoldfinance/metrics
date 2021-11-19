with total as (
Select 
   -- sum(_bribe/1e18) as _bribe,
  --  date_trunc('day',call_block_time) as time

    call_block_time as time
from sushi."Router02_call_swapExactETHForTokens"


Select
rebate_priority_fee as bribe
bribe as _bribe
from openmev."rebate_priority_fee"

)

, final as (
Select  
  date_trunc('day',time) as time,
  sum(bribe/1e18) as Bribe_in_ETH
from total
group by 1
)

select *,
    AVG(Bribe_in_ETH) OVER (ORDER BY time ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) AS av
from final
