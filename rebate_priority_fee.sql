select eth.blocks.blocknumber, eth.blocks.dttimestamp, (avg(effectivegasprice*1e-9-basefeepergas*1e-9)) as "Rebate Priority Fee"
--avg(maxpriorityfeepergas*1e-9), avg(maxfeepergas*1e-9)
from eth.transactions
inner join eth.blocks on eth.transactions.blocknumber = eth.blocks.blocknumber
where eth.blocks.blocknumber >= 12965000
and eth.blocks.blocknumber >= (
    select max(eth.blocks.blocknumber) - 2000
    from eth.blocks)
group by eth.blocks.blocknumber, eth.blocks.dttimestamp
order by eth.blocks.blocknumber desc
