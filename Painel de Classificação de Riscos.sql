 SELECT cd_atendimento AS "Atendimento"
      ,nm_paciente AS "Paciente"
      ,vl_idade AS "Idade"
      ,ds_senha AS "Senha"
      ,dt_fim_atendime AS "Dt_Atendimento"
      ,dh_removido
      ,fnc_hsv_calc_horas(Round((Nvl(dt_ini_triagem,SYSDATE) - dt_fim_atendime)*86400)*60) AS "Espera_Classificacao"
      ,To_Char(dt_chamada_triagem,'hh24:mi:ss') AS "Chamada_Classificacao"
      ,To_Char(dt_ini_triagem,'hh24:mi:ss') AS "Inicio_Classificacao"
      ,To_Char(dt_fim_triagem,'hh24:mi:ss') AS "Fim_Classificacao"
      ,fnc_hsv_calc_horas(Round((dt_fim_triagem - dt_ini_triagem)*86400)*60)  AS "Duracao_Classificacao"
      ,classificacao_risco AS "Classificacao"
      ,To_Char(dt_chamada_medico,'hh24:mi:ss') AS "Chamada_Medico"
      ,fnc_hsv_calc_horas(Round((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400)*60) AS "Esp_atendime_Medico"
      ,To_Char(dt_ini_medico,'hh24:mi:ss') AS "Inicio_Aten_Med"
      ,To_Char(dt_fim_medico,'hh24:mi:ss') AS "Fim_Aten_Med"
      ,To_Char(dt_alta,'hh24:mi:ss') AS "Alta_Medcia"
/* Minutos dos atendimentos sem parametros*/
      ,Trunc(((Nvl(dt_ini_triagem,SYSDATE) - dt_fim_atendime)*86400)/60/60)||':'||
       Trunc(((Nvl(dt_ini_triagem,SYSDATE) - dt_fim_atendime)*86400)/60)||':'||
       Trunc(mod(Mod((Nvl(dt_ini_triagem,SYSDATE) - dt_fim_atendime)*86400,3600),60)) AS "Tempo_Espra_Classificacao"
      ,Trunc(((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400)/60/60)||':'||
       Trunc(((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400)/60)||':'||
       Trunc(mod(Mod((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400,3600),60)) AS "Tempo_Espera_Atendimento_Med"
      ,(Nvl(dt_ini_triagem,SYSDATE)- dt_fim_atendime)*86400 AS "Tempo_Espra_Class"
      ,(Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400 AS "Tempo_Espera_Med"
/*Metas dos Atendimentos*/
      ,((10)/60)*60||' '||'min' AS "Meta_Ini_Class"
      ,case when classificacao_risco = 'MUITO URGENTE' THEN 5
            WHEN CLASSIFICACAO_RISCO = 'URGENTE' THEN 30
            WHEN CLASSIFICACAO_RISCO = 'POUCO URGENTE' THEN 45
            WHEN CLASSIFICACAO_RISCO = 'NAO URGENTE' THEN 60 END ||' '||'min' AS "Meta_Prazo_Class"
     ,((meta_cla_risco/3)/60)*60 metasteste
/*Atendimentos de Alta Médica*/
      ,CASE WHEN dt_alta IS NULL THEN 1 ELSE 0 END AS "Alt_Med"
/*Atendimentos em espera*/
      ,CASE WHEN dt_ini_triagem IS NULL THEN 1 ELSE 0 END AS "Esp_Class"
      ,CASE WHEN dt_fim_triagem IS NULL THEN 1 ELSE 0 END AS "Aten_Class"
      ,CASE WHEN dt_ini_medico IS NULL THEN 1 ELSE 0 END AS "Aten_medico"
/*Alertas do WeKnow */
      ,CASE WHEN (((Nvl(dt_ini_triagem,SYSDATE)- dt_fim_atendime)*86400)/60)>= ((10)/60)*60 AND dt_ini_triagem IS NULL THEN 1 ELSE 0 END AS "Alerta_Som_Class"
      ,CASE WHEN (((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400)/60) >= (((meta_cla_risco/3)/60)*60) AND Nvl(dt_ini_medico,dt_alta) IS NULL THEN 1 ELSE 0 END AS "Alerta_Som_Med"
      ,CASE WHEN (((Nvl(dt_ini_triagem,SYSDATE)- dt_fim_atendime)*86400)/60)>=  ((10)/60)*60 THEN 1 ELSE 0 END AS "Alerta_Cor_Class"
      ,CASE WHEN (((Nvl(dt_ini_medico,SYSDATE) - dt_fim_triagem)*86400)/60) >= (((meta_cla_risco/3)/60)*60) THEN 1 ELSE 0 END AS "Alerta_Cor_Med"


 FROM (
SELECT sacr_tempo_processo.cd_atendimento,
       triagem_atendimento.nm_paciente,
       Floor(Months_Between(SYSDATE,triagem_atendimento.dt_nascimento)/12) vl_idade,
       triagem_atendimento.dh_pre_atendimento dt_atendimento,
       triagem_atendimento.ds_senha,
       sacr_classificacao.ds_tipo_risco classificacao_risco,
       sacr_cor_referencia.nm_cor cor,
       sacr_classificacao.qt_minuto_atendimento meta_cla_risco,
       triagem_atendimento.dh_removido,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 22 then sacr_tempo_processo.dh_processo END) dt_fim_atendime,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 10 THEN sacr_tempo_processo.dh_processo END) dt_chamada_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 11 THEN sacr_tempo_processo.dh_processo END) dt_ini_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 12 THEN sacr_tempo_processo.dh_processo END) dt_fim_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 30 THEN sacr_tempo_processo.dh_processo END) dt_chamada_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 31 THEN sacr_tempo_processo.dh_processo END) dt_ini_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 32 THEN sacr_tempo_processo.dh_processo END) dt_fim_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 90 THEN sacr_tempo_processo.dh_processo END) dt_alta

  FROM dbamv.sacr_tempo_processo,
       dbamv.sacr_cor_referencia,
       dbamv.triagem_atendimento,
       dbamv.sacr_classificacao

 WHERE trunc(triagem_atendimento.dh_pre_atendimento) = To_Date(SYSDATE)
   and sacr_tempo_processo.cd_triagem_atendimento = triagem_atendimento.cd_triagem_atendimento(+)
   AND triagem_atendimento.cd_cor_referencia = sacr_cor_referencia.cd_cor_referencia(+)
   AND triagem_atendimento.cd_classificacao = sacr_classificacao.cd_classificacao(+)
   and (triagem_atendimento.ds_senha like ('%OR%') or triagem_atendimento.ds_senha like ('%AC%')or triagem_atendimento.ds_senha like ('%PD%'))
   AND triagem_atendimento.ds_senha NOT LIKE ('%E%')
   AND sacr_tempo_processo.cd_atendimento IS NOT NULL
   AND triagem_atendimento.cd_multi_empresa = 2

GROUP BY Floor(Months_Between(SYSDATE,triagem_atendimento.dt_nascimento)/12),
         triagem_atendimento.dh_pre_atendimento,
         sacr_classificacao.qt_minuto_atendimento,
         sacr_tempo_processo.cd_atendimento,
         triagem_atendimento.dh_removido,
         sacr_classificacao.ds_tipo_risco,
         triagem_atendimento.nm_paciente,
         triagem_atendimento.cd_paciente,
         triagem_atendimento.ds_senha,
         sacr_cor_referencia.nm_cor

ORDER BY 6 desc )

WHERE dt_alta IS NULL and dh_removido is null

ORDER BY 12 DESC

