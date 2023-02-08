WITH class_conduta AS (
SELECT atendime.cd_atendimento
      ,paciente.nm_paciente
      ,atendime.dt_atendimento
      ,To_Char(atendime.dt_atendimento ,'day') semana
      ,hsv_turno.faixa
      ,ori_ate.ds_ori_ate
      ,triagem_atendimento.ds_senha senha
      ,CASE WHEN triagem_atendimento.ds_senha LIKE '%AC%' OR triagem_atendimento.ds_senha LIKE '%PAC%' OR triagem_atendimento.ds_senha LIKE '%POAC%' THEN 'P.A. Clinico'
            WHEN triagem_atendimento.ds_senha LIKE '%OR%' OR triagem_atendimento.ds_senha LIKE '%POR%' OR triagem_atendimento.ds_senha LIKE '%POOR%' THEN 'P.A. Ortopedia'
            WHEN triagem_atendimento.ds_senha LIKE '%RS%' OR triagem_atendimento.ds_senha LIKE '%PRS%' OR triagem_atendimento.ds_senha LIKE '%PORS%' THEN 'P.A. Respiratorio'
            WHEN triagem_atendimento.ds_senha LIKE '%PDP%' OR triagem_atendimento.ds_senha LIKE '%PODP%' THEN 'P.A. Dor no Peito' END tp_senha
      ,CASE WHEN To_Char (atendime.hr_atendimento,'hh24:mm:ss') BETWEEN '06:59:00' AND '13:00:00' THEN 'Manhã'
            WHEN To_Char (atendime.hr_atendimento,'hh24:mm:ss') BETWEEN '13:01:00' AND '19:00:00' THEN 'Tarde' ELSE 'Noite' END periodo
      ,Nvl(sacr_classificacao.ds_tipo_risco,'Não Classificado') classificacao
      ,sacr_protocolo.qt_minuto_classificacao meta_recepcao
      ,sacr_protocolo.qt_minuto_classificacao meta_triagem
      ,Nvl(sacr_classificacao.qt_minuto_atendimento,'0') meta_classificacao
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 20 THEN sacr_tempo_processo.dh_processo END) retirada_senha
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 21 THEN sacr_tempo_processo.dh_processo END) ini_atendime
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 22 THEN sacr_tempo_processo.dh_processo END) fim_atendime
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 11 THEN sacr_tempo_processo.dh_processo END) ini_triagem
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 12 THEN sacr_tempo_processo.dh_processo END) fim_triagem
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 30 THEN sacr_tempo_processo.dh_processo END) chamada_medico
      ,Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 31 THEN sacr_tempo_processo.dh_processo END) ini_medico
      ,(SELECT Sum(Nvl(pa.temp_realizado,'0')) FROM hsv_tempo_exame_pa pa WHERE pa.cd_atendimento = atendime.cd_atendimento AND pa.codigo = 1) Labotario
      ,(SELECT Sum(Nvl(pa.temp_realizado,'0')) FROM hsv_tempo_exame_pa pa WHERE pa.cd_atendimento = atendime.cd_atendimento AND pa.codigo = 2) RaioX
      ,(SELECT Sum(Nvl(pa.temp_realizado,'0')) FROM hsv_tempo_exame_pa pa WHERE pa.cd_atendimento = atendime.cd_atendimento AND pa.codigo = 4) Tomografia
      ,(SELECT Sum(Nvl(pa.temp_realizado,'0')) FROM hsv_tempo_exame_pa pa WHERE pa.cd_atendimento = atendime.cd_atendimento AND pa.codigo = 6) Ecografia
      ,atendime.hr_alta alta
      ,CASE WHEN triagem_atendimento.ds_observacao_removido LIKE 'DESISTÊNCIA DE TRATAMENTO%'OR triagem_atendimento.ds_observacao_removido LIKE '%PACIENTE COM ATENDIMENTO REMOVIDO%'THEN 'DESISTÊNCIA DE ATENDIMENTO' END tip_res
      ,tip_res.cd_tip_res
      ,tip_res.ds_tip_res


  FROM dbamv.atendime
  JOIN dbamv.sacr_tempo_processo ON atendime.cd_atendimento = sacr_tempo_processo.cd_atendimento
  left JOIN dbamv.triagem_atendimento ON sacr_tempo_processo.cd_triagem_atendimento = triagem_atendimento.cd_triagem_atendimento
  left JOIN dbamv.sacr_classificacao  ON triagem_atendimento.cd_classificacao = sacr_classificacao.cd_classificacao
  JOIN sacr_protocolo ON sacr_classificacao.cd_protocolo = sacr_protocolo.cd_protocolo
  left JOIN hsv_tempo_exame_pa pa ON atendime.cd_atendimento = pa.cd_atendimento
  JOIN hsv_turno ON atendime.cd_atendimento = hsv_turno.cd_atendimento
  JOIN paciente ON atendime.cd_paciente = paciente.cd_paciente
  JOIN ori_ate  ON atendime.cd_ori_ate = ori_ate.cd_ori_ate
  JOIN tip_res ON atendime.cd_tip_res = tip_res.cd_tip_res

WHERE Trunc(atendime.dt_atendimento) BETWEEN '01/01/2023' AND To_Date('13/01/2023') + 86399/86400
  AND atendime.cd_ori_ate IN (3,41) AND atendime.tp_atendimento = 'U'

GROUP BY atendime.cd_atendimento
        ,paciente.nm_paciente
        ,atendime.dt_atendimento
        ,hsv_turno.faixa
        ,triagem_atendimento.ds_senha
        ,CASE WHEN triagem_atendimento.ds_senha LIKE '%AC%' OR triagem_atendimento.ds_senha LIKE '%PAC%' OR triagem_atendimento.ds_senha LIKE '%POAC%' THEN 'P.A.Clinico'
              WHEN triagem_atendimento.ds_senha LIKE '%OR%' OR triagem_atendimento.ds_senha LIKE '%POR%' OR triagem_atendimento.ds_senha LIKE '%POOR%' THEN 'P.A.Ortopedia'
              WHEN triagem_atendimento.ds_senha LIKE '%RS%' OR triagem_atendimento.ds_senha LIKE '%PRS%' OR triagem_atendimento.ds_senha LIKE '%PORS%' THEN 'P.A. Respiratorio'
              WHEN triagem_atendimento.ds_senha LIKE '%PDP%' OR triagem_atendimento.ds_senha LIKE '%PODP%' THEN 'P.A. Dor no Peito' END
        ,CASE WHEN triagem_atendimento.ds_observacao_removido LIKE 'DESISTÊNCIA DE TRATAMENTO%'OR triagem_atendimento.ds_observacao_removido LIKE '%PACIENTE COM ATENDIMENTO REMOVIDO%'
              THEN 'DESISTÊNCIA DE ATENDIMENTO' END
        ,CASE WHEN To_Char (atendime.hr_atendimento,'hh24:mm:ss') BETWEEN '06:59:00' AND '13:00:00' THEN 'Manhã'
              WHEN To_Char (atendime.hr_atendimento,'hh24:mm:ss') BETWEEN '13:01:00' AND '19:00:00' THEN 'Tarde' ELSE 'Noite' END
        ,sacr_classificacao.qt_minuto_atendimento
        ,sacr_protocolo.qt_minuto_classificacao
        ,sacr_protocolo.qt_minuto_classificacao
        ,sacr_classificacao.ds_tipo_risco
        ,atendime.hr_alta
        ,ori_ate.ds_ori_ate
        ,pa.exame
        ,pa.temp_realizado
        ,tip_res.cd_tip_res
        ,tip_res.ds_tip_res



ORDER BY 1 ASC)

SELECT cd_atendimento
      ,nm_paciente
      ,dt_atendimento
      ,semana
      ,faixa
      ,ds_ori_ate origem
      ,senha
      ,tp_senha
      ,Decode(classificacao,'EMERGENCIA','1.EMERGNCIA','MUITO URGENTE','2.MUITO URENTE','URGENTE',
       '3.URGENTE','POUCO URGENTE','4.POUCO URGENTE','NÃO URGENTE','5.NÃO URGENTE','NÃO CLASSIFICADO','6.NÃO CLASSIFICADO') classificacao
      ,periodo
      ,meta_recepcao*60  meta_recepcao
      ,meta_triagem*60 meta_triagem
      ,meta_classificacao
      ,3600 meta_exa
      ,retirada_senha
      ,ini_atendime
      ,fim_atendime
      ,ini_triagem
      ,fim_triagem
      ,chamada_medico
      ,alta
      ,Nvl(Round(To_Number((ini_atendime - retirada_senha)*86400)),0) Espera_recepcao
      ,Nvl(Round(To_Number((ini_triagem - fim_atendime)*86400)),0) espera_classificacao
      ,Nvl(Round(To_Number((chamada_medico - fim_triagem)*86400)),0)espera_medica
      ,Max(Nvl(Labotario,0)) Labotario
      ,Max(Nvl(RaioX,0)) RaioX
      ,Max(Nvl(Tomografia,0))Tomografia
      ,Max(Nvl(Ecografia,0)) Ecografia
      ,Nvl(Round(To_Number((alta - chamada_medico)*86400)),0) temp_permanencia
      ,CASE WHEN To_Number((ini_atendime - retirada_senha)*86400) < 600 THEN 'Dentro' ELSE 'Fora' END Recepcao
      ,cd_tip_res
      ,Nvl(tip_res,ds_tip_res) altas

FROM class_conduta

GROUP BY cd_atendimento
      ,nm_paciente
      ,dt_atendimento
      ,semana
      ,faixa
      ,ds_ori_ate
      ,senha
      ,tp_senha
      ,Decode(classificacao,'EMERGENCIA','1.EMERGNCIA','MUITO URGENTE','2.MUITO URENTE','URGENTE',
       '3.URGENTE','POUCO URGENTE','4.POUCO URGENTE','NÃO URGENTE','5.NÃO URGENTE','NÃO CLASSIFICADO','6.NÃO CLASSIFICADO')
      ,meta_recepcao
      ,meta_triagem
      ,meta_classificacao
      ,ini_medico
      ,Nvl(Round(To_Number((ini_atendime - retirada_senha)*86400)),0)
      ,Nvl(Round(To_Number((ini_triagem - fim_atendime)*86400)),0)
      ,Nvl(Round(To_Number((chamada_medico - fim_triagem)*86400)),0)
      ,Nvl(Round(To_Number((alta - chamada_medico)*86400)),0)
      ,CASE WHEN To_Number((ini_atendime - retirada_senha)*86400) < 600 THEN 'Dentro' ELSE 'Fora' END
      ,ini_atendime
      ,retirada_senha
      ,fim_atendime
      ,ini_triagem
      ,fim_triagem
      ,chamada_medico
      ,alta
      ,cd_tip_res
      ,Nvl(tip_res,ds_tip_res)
      ,periodo


ORDER BY 1 ASC