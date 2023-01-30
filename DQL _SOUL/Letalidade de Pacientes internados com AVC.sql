SELECT (Sum(obito)/Sum(ate))*100 taxa_AVC
  FROM (
SELECT Count(*)ate,NULL obito
  FROM dbamv.atendime
 WHERE trunc(atendime.dt_atendimento) BETWEEN '01/06/2021' AND '30/06/2021'
   AND atendime.cd_cid IN ('G45','G458','G49','I64')
UNION ALL
SELECT NULL ate,Count(*)obito --obito AVC
  FROM dbamv.atendime
      ,dbamv.mot_alt
 WHERE mot_alt.cd_mot_alt = atendime.cd_mot_alt
   AND Trunc(atendime.dt_alta) BETWEEN '01/06/2021' AND To_Date('30/06/2021') + 86399 /86400
   AND atendime.cd_cid IN ('G45','G458','G49','I64')
   AND atendime.cd_multi_empresa = 2
    AND atendime.dt_alta IS NOT NULL
   AND atendime.tp_atendimento = 'I'
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47)