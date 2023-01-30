SELECT (Sum(obito_ccir)/Sum(aviso)) *100 taxa_ccir
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










