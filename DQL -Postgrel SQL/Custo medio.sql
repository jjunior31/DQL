SELECT SUM(cost) / COUNT(*) AS average_cost
FROM your_table;

Substitua your_table pelo nome da sua tabela e cost pelo nome da coluna que contém os custos. 
Esta consulta usa a função SUM para somar todos os custos na tabela e a função COUNT para contar o número de linhas na tabela.
Finalmente, divide-se a soma dos custos pelo número de linhas para obter o custo médio.