SELECT (Sum(obito)/Sum(saidos))*100 taxa_uti
  FROM(
SELECT Count(*) obito, NULL saidos
  FROM dbamv.atendime a
      ,dbamv.mot_alt
      ,dbamv.leito
 WHERE mot_alt.cd_mot_alt = a.cd_mot_alt
   AND leito.cd_leito = a.cd_leito
   AND Trunc(a.dt_alta) BETWEEN '01/06/2021' AND '30/06/2021'
   AND a.dt_alta IS NOT NULL
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt =47
   AND leito.cd_unid_int = 10
   AND a.tp_atendimento = 'I'
   AND a.cd_multi_empresa = 2
UNION ALL

SELECT NULL obito,(Sum(toda) + Sum(tra)) saidos
  FROM (
SELECT Count (*) toda,
       NULL tra
  FROM dbamv.atendime a
      ,dbamv.mot_alt
      ,dbamv.leito
 WHERE mot_alt.cd_mot_alt = a.cd_mot_alt
   AND leito.cd_leito = a.cd_leito
   AND Trunc(a.dt_alta) BETWEEN '01/06/2021' AND '30/06/2021'
   AND a.dt_alta IS NOT NULL
   AND mot_alt.cd_mot_alt NOT IN (46,48)
   AND leito.cd_unid_int = 10
   AND a.tp_atendimento = 'I'
   AND a.cd_multi_empresa = 2

UNION ALL

SELECT NULL toda,Count(*) tra
  FROM dbamv.atendime a
      ,dbamv.mov_int
      ,dbamv.leito l
      ,dbamv.leito
WHERE l.cd_leito = mov_int.cd_leito
  AND mov_int.cd_leito_anterior = leito.cd_leito
  AND a.cd_atendimento = mov_int.cd_atendimento
  AND leito.cd_unid_int <> l.cd_unid_int
  AND a.tp_atendimento IN ('I','U','H')
  AND a.cd_multi_empresa = 2
  AND leito.cd_unid_int = 10
  AND mov_int.tp_mov = 'O'
  AND Trunc(mov_int.dt_mov_int) BETWEEN '01/06/2021' AND To_Date('30/06/2021') + 86399/86400
  AND NOT EXISTS (select 'X' from dbamv . mov_int mi where mi . cd_atendimento = mov_int . cd_atendimento
                     AND TRUNC ( mi . dt_mov_int ) + ( mi . hr_mov_int - TRUNC ( mi . hr_mov_int ) ) < TRUNC ( mov_int . dt_mov_int ) + ( mov_int . hr_mov_int - TRUNC ( mov_int . hr_mov_int ) )
                     AND mi . cd_leito = mov_int . cd_leito
                     and mi . tp_mov <> 'R'
                     and mi . cd_tip_acom <> mov_int . cd_tip_acom
                     and nvl ( mi . cd_leito_anterior , mi . cd_leito ) = nvl ( mov_int . cd_leito_anterior , mov_int . cd_leito ))



                      )
)