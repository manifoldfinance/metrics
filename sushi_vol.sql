with sushiswaps as 
(
select 
sum(usd_amount) as Sushi_volume,
date_trunc('day',block_time) as day
from dex."trades"
where block_time > '2021-05-25 00:00'
and "tx_to" = '\xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F'
and project = 'Sushiswap'
group by 2
)

select u.day, s.SUSHI_volume
from sushiswaps s
on s.day = u.day
