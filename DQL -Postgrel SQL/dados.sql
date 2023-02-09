SELECT ROW_NUMBER() OVER (ORDER BY coluna_de_ordenação) AS id, coluna1, coluna2, ...
FROM nome_da_tabela;

SELECT ROW_NUMBER() OVER (ORDER BY coluna_de_ordenação) + 999 AS id, coluna1, coluna2, ...
FROM nome_da_tabela;

SELECT coluna_hora, coluna_hora - LAG(coluna_hora) OVER (ORDER BY outra_coluna) AS "Diferença"
FROM sua_tabela;

WITH cte AS (
  SELECT id,
         ROW_NUMBER() OVER (ORDER BY outra_coluna) AS seq
  FROM sua_tabela
)
SELECT cte.id,
       cte.seq,
       cte.id - LAG(cte.id) OVER (ORDER BY cte.seq) AS "Diferença"
FROM cte;