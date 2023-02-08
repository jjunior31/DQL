WITH base AS (
  SELECT 
    data, 
    SUM(quilometragem) AS quilometragem_total
  FROM 
    viagens
  GROUP BY 
    data
)
SELECT 
  data, 
  COALESCE(quilometragem_total - LAG(quilometragem_total) OVER (ORDER BY data), 0) AS diferenca
FROM 
  base
ORDER BY 
  data;
WITH base AS (
  SELECT 
    EXTRACT(YEAR FROM data) AS ano, 
    EXTRACT(MONTH FROM data) AS mes, 
    SUM(quilometragem) AS quilometragem_total
  FROM 
    viagens
  GROUP BY 
    EXTRACT(YEAR FROM data), 
    EXTRACT(MONTH FROM data)
)
SELECT 
  ano, 
  mes, 
  quilometragem_total - COALESCE(LAG(quilometragem_total) OVER (ORDER BY ano, mes), 0) AS diferenca
FROM 
  base
ORDER BY 
  ano, 
  mes;
Este código usa a função EXTRACT() para extrair o ano e o mês da coluna data, e agrupa a quilometragem por mês e ano. A consulta principal, que seleciona a partir da CTE "base", usa a função LAG() para obter o valor da linha anterior do resultado da CTE. O resultado será uma lista de diferenças de quilometragem por mês, com a diferença sendo o quilometragem total do mês atual menos o quilometragem total do mês anterior.




JJ Silva
sem usar o coalesce
Aqui está um exemplo de como o código SQL pode ser escrito para mostrar a diferença de quilômetros rodados por mês, sem usar a função COALESCE():

sql
Copy code
WITH base AS (
  SELECT 
    EXTRACT(YEAR FROM data) AS ano, 
    EXTRACT(MONTH FROM data) AS mes, 
    SUM(quilometragem) AS quilometragem_total
  FROM 
    viagens
  GROUP BY 
    EXTRACT(YEAR FROM data), 
    EXTRACT(MONTH FROM data)
), 
diferenca AS (
  SELECT 
    ano, 
    mes, 
    quilometragem_total,
    quilometragem_total - LAG(quilometragem_total) OVER (ORDER BY ano, mes) AS diferenca
  FROM 
    base
)
SELECT 
  ano, 
  mes, 
  COALESCE(diferenca, 0) AS diferenca
FROM 
  diferenca
UNION ALL
SELECT 
  ano, 
  mes, 
  0 AS diferenca
FROM 
  base
WHERE 
  NOT EXISTS (
    SELECT 1 
    FROM diferenca 
    WHERE 
      base.ano = diferenca.ano AND 
      base.mes = diferenca.mes
  )
ORDER BY 
  ano, 
  mes;
Este código usa uma segunda CTE, chamada "diferenca", que seleciona a partir da CTE "base" e calcula a diferença entre a quilometragem total do mês atual e o quilometragem total do mês anterior. A consulta principal, que seleciona a partir da CTE "diferenca", usa a cláusula UNION ALL para unir as linhas da CTE "diferença" com as linhas da CTE "base" que não estão presentes na CTE "diferença". O resultado será uma lista de diferenças de quilometragem por mês, com a diferença sendo o quilometragem total do mês atual menos o quilometragem total do mês anterior, e 0 sendo retornado para os meses que não têm dados anteriores.




JJ Silva
simplifique o codigo 
Aqui está uma versão simplificada do código SQL que mostra a diferença de quilômetros rodados por mês:

sql
Copy code
WITH base AS (
  SELECT 
    EXTRACT(YEAR FROM data) AS ano, 
    EXTRACT(MONTH FROM data) AS mes, 
    SUM(quilometragem) AS quilometragem_total
  FROM 
    viagens
  GROUP BY 
    EXTRACT(YEAR FROM data), 
    EXTRACT(MONTH FROM data)
)
SELECT 
  ano, 
  mes, 
  COALESCE(quilometragem_total - LAG(quilometragem_total) OVER (ORDER BY ano, mes), 0) AS diferenca
FROM 
  base
ORDER BY 
  ano, 
  mes;
  
WITH base AS (
  SELECT 
    data, 
    SUM(quilometragem) AS quilometragem_total
  FROM 
    viagens
  GROUP BY 
    data
)
SELECT 
  data, 
  COALESCE(quilometragem_total - LAG(quilometragem_total) OVER (ORDER BY data), 0) AS diferenca
FROM 
  base
ORDER BY 
  data;
  
 https://stackoverflow.com




  
  