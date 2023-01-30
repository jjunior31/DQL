SELECT Sum(taxa_geral)taxa_geral
      ,Sum(taxa_Obito24)taxa_Obito24
      ,Sum(taxa_uti)taxa_uti
      ,Sum(taxa_ccir) taxa_ccir
      ,(Sum(taxa_Obito24)-Sum(taxa_ccir)) taxa_cli
  FROM (
SELECT (Sum(obito)/Sum(saidos))*100 taxa_geral, NULL taxa_Obito24,NULL taxa_uti,NULL taxa_ccir
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
) UNION ALL
SELECT NULL taxa_geral,(Sum(obito)/Sum(saidos))*100 taxa_Obito24, NULL taxa_uti,NULL taxa_ccir
  FROM(
SELECT Count(*)obito,NULL saidos
  FROM dbamv.atendime
      ,dbamv.mot_alt
 WHERE mot_alt.cd_mot_alt(+) = atendime.cd_mot_alt
   AND Trunc(atendime.dt_alta) BETWEEN '01/06/2021' AND To_Date('30/06/2021')+86399 /86400
   AND (To_date(To_char(atendime.dt_alta, 'DD/MM/YYYY')|| To_char(atendime.hr_alta, 'HH24:MI'), 'DD/MM/YYYY HH24:MI') -
        To_date(To_char(atendime.dt_atendimento, 'DD/MM/YYYY')|| To_char(atendime.hr_atendimento, 'HH24:MI'), 'DD/MM/YYYY HH24:MI') ) > 1
   AND atendime . cd_atendimento_pai IS NULL
   AND atendime.cd_multi_empresa = 2
   AND atendime.tp_atendimento = 'I'
   AND atendime.dt_alta IS NOT NULL
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47

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
) UNION ALL
SELECT NULL taxa_geral,NULL taxa_obito24,(Sum(obito)/Sum(saidos))*100 taxa_uti, NULL taxa_ccir
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
)UNION ALL
SELECT NULL taxa_geral,NULL taxa_obito24,NULL taxa_uti,(Sum(obito_ccir)/Sum(aviso)) *100 taxa_ccir
  FROM(
SELECT Count(*) aviso,NULL obito_ccir
  FROM aviso_cirurgia,cen_cir
 WHERE aviso_cirurgia.cd_cen_cir = cen_cir.cd_cen_cir
   AND aviso_cirurgia.cd_sal_cir not in ('17')
   AND aviso_cirurgia.dt_realizacao between '01/06/2021' and to_date('30/06/2021') + 86499/86300
   AND cen_cir.cd_cen_cir in (1)
UNION ALL
SELECT NULL aviso,Count(*) obito_ccir
  FROM dbamv.aviso_cirurgia
      ,dbamv.atendime
      ,dbamv.mot_alt
 WHERE mot_alt.cd_mot_alt = atendime.cd_mot_alt
   AND aviso_cirurgia.cd_atendimento = atendime.cd_atendimento
   AND Trunc(atendime.dt_alta) BETWEEN '01/06/2021' AND To_Date('30/06/2021') + 86399 /86400
   AND To_Number(To_Date(atendime.dt_alta) - To_Date(aviso_cirurgia.dt_realizacao)+1)<=7
   AND atendime.dt_alta IS NOT NULL
   AND atendime.cd_multi_empresa = 2
   AND aviso_cirurgia.cd_cen_cir = 1
   AND atendime.tp_atendimento = 'I'
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47 )
)

