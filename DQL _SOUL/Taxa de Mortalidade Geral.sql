SELECT (Sum(obito)/Sum(saidos))*100 taxa
  FROM(
SELECT Count(*) obito, NULL saidos
  FROM dbamv.atendime a
      ,dbamv.mot_alt
 WHERE mot_alt.cd_mot_alt = a.cd_mot_alt
   AND Trunc(a.dt_alta) BETWEEN '01/06/2021' AND '30/06/2021'
   AND a.dt_alta IS NOT NULL
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt =47
   AND a.tp_atendimento = 'I'
   AND a.cd_multi_empresa = 2
UNION ALL

SELECT NULL obito,(Sum(toda) + Sum(tra)) saidos
  FROM (
SELECT Count (*) toda,
       NULL tra
  FROM dbamv.atendime a
      ,dbamv.mot_alt
 WHERE mot_alt.cd_mot_alt = a.cd_mot_alt
   AND Trunc(a.dt_alta) BETWEEN '01/06/2021' AND '30/06/2021'
   AND a.dt_alta IS NOT NULL
   AND mot_alt.cd_mot_alt NOT IN (46,48)
   AND a.tp_atendimento = 'I'
   AND a.cd_multi_empresa = 2

UNION ALL

SELECT NULL toda,
       Count(*) tra
  FROM dbamv.atendime a
      ,dbamv.mov_int
      ,dbamv.leito l
      ,dbamv.leito
WHERE mov_int.cd_atendimento = a.cd_atendimento
  AND leito.cd_leito = mov_int.cd_leito
  AND mov_int.cd_leito_anterior = l.cd_leito
  AND leito.cd_unid_int <> l.cd_unid_int
  AND a.tp_atendimento IN ('I','U','H')
  AND a.cd_atendimento_pai IS NULL
  AND a.cd_multi_empresa = 2
  AND leito.cd_unid_int NOT IN (25)
  AND mov_int.tp_mov = 'O'
  AND Trunc(mov_int.dt_mov_int) BETWEEN '01/06/2021' AND To_Date('30/06/2021') + 86399/86400
  AND NOT EXISTS (SELECT 'X' FROM  dbamv . mov_int mi
                    WHERE  mi . cd_atendimento = mov_int . cd_atendimento
                      and mi . cd_leito = mov_int . cd_leito and mi . cd_tip_acom <> mov_int.cd_tip_acom
                      and nvl (mi.cd_leito_anterior , mi.cd_leito ) = nvl ( mov_int.cd_leito_anterior , mov_int.cd_leito))
                      )
)