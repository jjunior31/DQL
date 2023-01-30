SELECT Sum(taxa_IAM)taxa_IAM
      ,Sum(taxa_AVC)taxa_AVC
      ,Sum(taxa_IC) taxa_IC
  FROM (
SELECT (Sum(obito)/Sum(total))*100 taxa_IAM
       ,NULL taxa_AVC
       ,NULL taxa_IC
  FROM (
SELECT Count(*)total,NULL obito,d.data
  FROM dbamv.atendime
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE trunc(atendime.dt_atendimento) = d.data
   AND atendime.cd_cid IN ('I21','I210','I211','I212','I213','I214','I219','I22','I221','I228','I229')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
GROUP BY d.data
UNION ALL
SELECT NULL total,Count(*)obito,d.data
  FROM dbamv.atendime
      ,dbamv.mot_alt
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE mot_alt.cd_mot_alt = atendime.cd_mot_alt
   AND Trunc(atendime.dt_alta) = d.data
   AND atendime.cd_cid IN ('I21','I210','I211','I212','I213','I214','I219','I22','I221','I228','I229')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
   AND atendime.cd_multi_empresa = 2
    AND atendime.dt_alta IS NOT NULL
   AND atendime.tp_atendimento = 'I'
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47
GROUP BY d.data)

UNION ALL

SELECT NULL taxa_IAM
      ,(Sum(obito)/Sum(total))*100  taxa_AVC
      ,NULL taxa_IC
  FROM (
SELECT Count(*)total,NULL obito,d.data
  FROM dbamv.atendime
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE trunc(atendime.dt_atendimento) = d.data
   AND atendime.cd_cid IN ('G45','G458','G49','I64')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
GROUP BY d.data
UNION ALL
SELECT NULL total,Count(*)obito,d.data
  FROM dbamv.atendime
      ,dbamv.mot_alt
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE mot_alt.cd_mot_alt = atendime.cd_mot_alt
   AND Trunc(atendime.dt_alta) = d.data
   AND atendime.cd_cid IN ('G45','G458','G49','I64')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
   AND atendime.cd_multi_empresa = 2
    AND atendime.dt_alta IS NOT NULL
   AND atendime.tp_atendimento = 'I'
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47
GROUP BY d.data)

UNION  ALL

SELECT  NULL taxa_IAM
       ,NULL taxa_AVC
       ,(Sum(obito)/Sum(total))*100  taxa_IC
  FROM (
SELECT Count(*)total,NULL obito,d.data
  FROM dbamv.atendime
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE trunc(atendime.dt_atendimento) = d.data
   AND atendime.cd_cid IN ('I50','I500','I501','I509')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
GROUP BY d.data
UNION ALL
SELECT NULL total,Count(*)obito,d.data
  FROM dbamv.atendime
      ,dbamv.mot_alt
      ,(SELECT(To_Date('01/01/2010','dd/mm/yyyy')-1)+ROWNUM data FROM cid)d
 WHERE mot_alt.cd_mot_alt = atendime.cd_mot_alt
   AND Trunc(atendime.dt_alta) = d.data
   AND atendime.cd_cid IN ('I50','I500','I501','I509')
   AND data BETWEEN '01/06/2021' AND '30/06/2021'
   AND atendime.cd_multi_empresa = 2
    AND atendime.dt_alta IS NOT NULL
   AND atendime.tp_atendimento = 'I'
   AND mot_alt.tp_mot_alta = 'O'
   AND mot_alt.cd_mot_alt = 47
GROUP BY d.data)
)





