 SELECT Count(*) obitos
      ,Count(oi.cd_atendimento) obitos_ins
      ,Count(oc.cd_atendimento) obitos_cir
      ,(Count(oi.cd_atendimento) - Count(oc.cd_atendimento))obitos_cli
      ,Count(ou.cd_atendimento) obitos_uti

  FROM atendime
  left JOIN (SELECT atendime.cd_atendimento FROM atendime WHERE cd_mot_alt = 47 AND atendime.tp_atendimento = 'I' AND (To_date(To_char(atendime.dt_alta, 'DD/MM/YYYY')|| To_char(atendime.hr_alta, 'HH24:MI'), 'DD/MM/YYYY HH24:MI')
                    - To_date(To_char(atendime.dt_atendimento, 'DD/MM/YYYY')|| To_char(atendime.hr_atendimento, 'HH24:MI'), 'DD/MM/YYYY HH24:MI') ) > 1  AND atendime . cd_atendimento_pai IS NULL) oi
                      ON atendime.cd_atendimento = oi.cd_atendimento
  left JOIN (SELECT atendime.cd_atendimento FROM atendime JOIN aviso_cirurgia ON aviso_cirurgia.cd_atendimento = atendime.cd_atendimento
              WHERE To_Number(To_Date(atendime.dt_alta) - To_Date(aviso_cirurgia.dt_realizacao)+1)<=7 AND atendime.cd_mot_alt = 47 AND atendime.tp_atendimento = 'I') oc ON atendime.cd_atendimento = oc.cd_atendimento
  left JOIN (SELECT atendime.cd_atendimento FROM atendime JOIN leito ON leito.cd_leito = atendime.cd_leito JOIN unid_int ON unid_int.cd_unid_int = leito.cd_unid_int WHERE atendime.cd_mot_alt = 47
                AND atendime.tp_atendimento = 'I' AND unid_int.cd_unid_int = 10) ou ON atendime.cd_atendimento = ou.cd_atendimento

WHERE atendime.dt_alta = :ini
  AND atendime.cd_multi_empresa = 2
  AND atendime.tp_atendimento = 'I'
  AND atendime.cd_mot_alt=47
