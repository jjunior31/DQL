SELECT cd_atendimento
      ,cd_set_exa
      ,cd_tip_presc
      ,ds_tip_presc
      ,CASE WHEN cd_set_exa = 1 AND cd_tip_presc NOT IN (32893,346334,34452,32885,34843,32912,354002) THEN 'OUTROS EXAMES'
            WHEN cd_set_exa = 1 AND cd_tip_presc IN (34452,32885,34843,32912,354002) THEN 'DOR TORACICA'
            WHEN cd_set_exa = 1 AND cd_tip_presc IN (32893,346334) THEN 'SEPSE'
            WHEN cd_set_exa = 6 AND cd_tip_presc = 35038 THEN 'ECOGRAFIA' 
            WHEN cd_set_exa = 4 THEN 'TOMOGRAFIA'
            WHEN cd_set_exa = 2 THEN 'RADIOLOGIA'END setor
      ,hr_pre_med
      ,hr_pre_med dt_atendimento
      ,dt_realizado
      ,temp_realizado
FROM (
SELECT UNIQUE atendime.cd_atendimento
      ,set_exa.cd_set_exa
      ,tip_presc.cd_tip_presc
      ,tip_presc.ds_tip_presc 
      ,pre_med.hr_pre_med
      ,itped_rx.dt_realizado
      ,Round(To_Number((itped_rx.dt_realizado - pre_med.hr_pre_med)*86400)) temp_realizado 

FROM dbamv.atendime
JOIN dbamv.sacr_tempo_processo ON atendime.cd_atendimento = sacr_tempo_processo.cd_atendimento
JOIN dbamv.pre_med ON atendime.cd_atendimento = pre_med.cd_atendimento
JOIN dbamv.itpre_med ON pre_med.cd_pre_med = itpre_med.cd_pre_med
JOIN dbamv.set_exa ON set_exa.cd_set_exa = itpre_med.cd_set_exa
JOIN dbamv.tip_presc ON tip_presc.cd_tip_presc = itpre_med.cd_tip_presc
JOIN dbamv.tip_esq ON itpre_med.cd_tip_esq = tip_esq.cd_tip_esq
left JOIN dbamv.itped_rx  ON itpre_med.cd_itpre_med = itped_rx.cd_itpre_med

WHERE atendime.tp_atendimento = 'U' AND set_exa.cd_set_exa = 6 AND tip_presc.cd_tip_presc = 35038 
AND atendime.dt_atendimento BETWEEN :ini AND To_Date(:fin) + 86399/86400 

UNION 

SELECT UNIQUE atendime.cd_atendimento
      ,set_exa.cd_set_exa
      ,tip_presc.cd_tip_presc
      ,tip_presc.ds_tip_presc exame
      ,pre_med.hr_pre_med
      ,Nvl(itped_rx.dt_realizado,itped_lab.dt_assinado) dt_realizado
      ,Round(To_Number((Nvl(itped_lab.dt_assinado,itped_rx.dt_realizado) - pre_med.hr_pre_med)*86400)) temp_realizado 

FROM dbamv.atendime
JOIN dbamv.sacr_tempo_processo ON atendime.cd_atendimento = sacr_tempo_processo.cd_atendimento
JOIN dbamv.pre_med ON atendime.cd_atendimento = pre_med.cd_atendimento
JOIN dbamv.itpre_med ON pre_med.cd_pre_med = itpre_med.cd_pre_med
JOIN dbamv.set_exa ON set_exa.cd_set_exa = itpre_med.cd_set_exa
JOIN dbamv.tip_presc ON tip_presc.cd_tip_presc = itpre_med.cd_tip_presc
JOIN dbamv.tip_esq ON itpre_med.cd_tip_esq = tip_esq.cd_tip_esq
left JOIN dbamv.itped_lab ON itpre_med.cd_itpre_med = itped_lab.cd_itpre_med
left JOIN dbamv.itped_rx  ON itpre_med.cd_itpre_med = itped_rx.cd_itpre_med

WHERE atendime.tp_atendimento = 'U' AND set_exa.cd_set_exa IN (1,2,4)  
AND atendime.dt_atendimento BETWEEN :ini AND To_Date(:fin) + 86399/86400 

)
