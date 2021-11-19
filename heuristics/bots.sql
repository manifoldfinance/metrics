SELECT
(SELECT
	now() - interval '24 hours'
),
(SELECT 
    SUM(usd_amount) AS "Bots volume"
FROM 
    dex.trades
WHERE 
    project = 'Sushiswap'
AND
    block_time > now() - interval '24 hours'
AND 
(   trader_a = '\x0000000000007f150bd6f54c40a34d7c3d5e9f56' OR
    trader_a = '\x00000000003b3cc22af3ae1eac0440bcee416b40' OR
    trader_a = '\x000000005736775feb0c8568e7dee77222a26880' OR
    trader_a = '\x4d246be90c2f36730bb853ad41d0a189061192d3' OR
    trader_a = '\x911605012f87a3017322c81fcb4c90ada7c09116' OR
    trader_a = '\xa57bd00134b2850b2a1c55860c9e9ea100fdd6cf' OR
    trader_a = '\x00000000000080c886232e9b7ebbfb942b5987aa' OR
    trader_a = '\x661c650c8bfcde6d842f465b3d69ed008638d614' OR
    trader_a = '\x3d71d79c224998e608d03c5ec9b405e7a38505f0' OR
    trader_a = '\x6cdc900324c935a2807ecc308f8ead1fcd62fe35' OR
    trader_a = '\x00000000000017c75025d397b91d284bbe8fc7f2' OR
    trader_a = '\x000000000000006f6502b7f2bbac8c30a3f67e9a' OR
    trader_a = '\x3144d9885e57e6931cf51a2cac6a70dad6b805b2' OR
    trader_a = '\x78a55b9b3bbeffb36a43d9905f654d2769dc55e8' OR
    trader_a = '\x860bd2dba9cd475a61e6d1b45e16c365f6d78f66' OR
    trader_a = '\xfe7f0897239ce9cc6645d9323e6fe428591b821c' OR
    trader_a = '\x000000000035b5e5ad9019092c665357240f594e' OR
    trader_a = '\x57813ed84148f8109d49aad27c5877ecf8e62b37' OR
    trader_a =  '\xb958a8f59ac6145851729f73c7a6968311d8b633' OR
	trader_a =  '\x000000000025d4386f7fb58984cbe110aee3a4c4' OR
	trader_a =  '\x7ee8ab2a8d890c000acc87bf6e22e2ad383e23ce' OR
	trader_a =  '\x6780846518290724038e86c98a1e903888338875'
)
),
(SELECT 
    SUM(usd_amount) AS "Volume"
FROM 
    dex.trades
WHERE 
    project = 'Sushiswap'
AND
    block_time > now() - interval '24 hours'
AND 
(   trader_a != '\x0000000000007f150bd6f54c40a34d7c3d5e9f56' OR
    trader_a != '\x00000000003b3cc22af3ae1eac0440bcee416b40' OR
    trader_a != '\x000000005736775feb0c8568e7dee77222a26880' OR
    trader_a != '\x4d246be90c2f36730bb853ad41d0a189061192d3' OR
    trader_a != '\x911605012f87a3017322c81fcb4c90ada7c09116' OR
    trader_a != '\xa57bd00134b2850b2a1c55860c9e9ea100fdd6cf' OR
    trader_a != '\x00000000000080c886232e9b7ebbfb942b5987aa' OR
    trader_a != '\x661c650c8bfcde6d842f465b3d69ed008638d614' OR
    trader_a != '\x3d71d79c224998e608d03c5ec9b405e7a38505f0' OR
    trader_a != '\x6cdc900324c935a2807ecc308f8ead1fcd62fe35' OR
    trader_a != '\x00000000000017c75025d397b91d284bbe8fc7f2' OR
    trader_a != '\x000000000000006f6502b7f2bbac8c30a3f67e9a' OR
    trader_a != '\x3144d9885e57e6931cf51a2cac6a70dad6b805b2' OR
    trader_a != '\x78a55b9b3bbeffb36a43d9905f654d2769dc55e8' OR
    trader_a != '\x860bd2dba9cd475a61e6d1b45e16c365f6d78f66' OR
    trader_a != '\xfe7f0897239ce9cc6645d9323e6fe428591b821c' OR
    trader_a != '\x000000000035b5e5ad9019092c665357240f594e' OR
    trader_a != '\x57813ed84148f8109d49aad27c5877ecf8e62b37' OR
    trader_a !=  '\xb958a8f59ac6145851729f73c7a6968311d8b633' OR
	trader_a !=  '\x000000000025d4386f7fb58984cbe110aee3a4c4' OR
	trader_a !=  '\x7ee8ab2a8d890c000acc87bf6e22e2ad383e23ce' OR
	trader_a !=  '\x6780846518290724038e86c98a1e903888338875'
)
)
