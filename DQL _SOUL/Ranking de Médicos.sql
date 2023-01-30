SELECT cd_prestador,
       nm_prestador,
       dt_nascimento,
       ds_endereco,
       telefone,
       celular,
       ds_email,
       qtd,
       Rank() OVER(ORDER BY qtd DESC ) AS "RANK"
  FROM (SELECT UNIQUE prestador.cd_prestador,
       prestador.nm_prestador,
       To_Char(prestador.dt_nascimento,'dd/mm/yyyy') dt_nascimento,
       prestador.ds_endereco,
       prestador_tip_comun.ds_tip_comun_prest telefone,
       tip_comum.ds_tip_comun_prest celular,
       prestador.ds_email,
       Count(atendime.dt_atendimento) qtd
  FROM dbamv.prestador,
       dbamv.atendime,
       dbamv.prestador_tip_comun,
       dbamv.prestador_tip_comun tip_comum
 WHERE atendime.cd_prestador = prestador.cd_prestador
   AND prestador_tip_comun.cd_prestador = prestador.cd_prestador
   AND tip_comum.cd_prestador = prestador_tip_comun.cd_prestador
   AND prestador_tip_comun.cd_tip_comun = 1
   AND tip_comum.cd_tip_comun = 3
   AND prestador.cd_prestador NOT IN (1)
   AND atendime.dt_atendimento BETWEEN '01/01/2019' AND '31/10/2020'
GROUP BY prestador.cd_prestador,
         prestador.nm_prestador,
         prestador.ds_endereco,
         prestador_tip_comun.ds_tip_comun_prest,
         tip_comum.ds_tip_comun_prest,
         prestador.ds_email,
         To_Char(prestador.dt_nascimento,'dd/mm/yyyy')

ORDER BY 1 ASC)

WHERE qtd >= 100

ORDER BY 8 DESC

