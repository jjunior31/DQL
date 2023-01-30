SELECT cd_atendimento,
       cd_paciente, 
       nm_paciente,
       vl_idade,
       dt_atendimento,
       ds_senha,
       classificacao_risco,                                                                           
       cor,
       meta_cla_risco,
       dt_retirada_senha,
       dt_chamada_senha,
       fnc_hsv_calc_horas((((dt_chamada_senha) - dt_retirada_senha)*60)*86400) temp_espera,
       dt_inicio_atendimento,
       dt_fim_atendimento,
       fnc_hsv_calc_horas((((dt_fim_atendimento) - dt_inicio_atendimento)*60)*86400) temp_atendime,
       dt_chamada_triagem,
       dt_inicio_triagem,
       fnc_hsv_calc_horas((((dt_inicio_triagem) - dt_chamada_triagem)*60)*86400) temp_espera_triagem,
       dt_fim_triagem,
       fnc_hsv_calc_horas((((dt_fim_triagem) - dt_inicio_triagem)*60)*86400) temp_atendime_triagem,
       dt_chamada_medico,
       dt_inicio_medico,
       fnc_hsv_calc_horas((((dt_inicio_medico) - dt_chamada_medico)*60)*86400) temp_espera_medica,
       dt_fim_medico,
       fnc_hsv_calc_horas((((dt_fim_medico) - dt_inicio_medico)*60)*86400) temp_atendime_medica,
       dt_alta,
       fnc_hsv_calc_horas((((dt_alta) - dt_inicio_medico)*60)*86400) temp_total_medica,
       fnc_hsv_calc_horas((((dt_alta) - dt_retirada_senha)*60)*86400) temp_total_atendime

FROM(
SELECT sacr_tempo_processo.cd_atendimento,
       triagem_atendimento.cd_paciente,
       triagem_atendimento.nm_paciente,
       Floor(Months_Between(SYSDATE,triagem_atendimento.dt_nascimento)/12) vl_idade,
       To_Char(triagem_atendimento.dh_pre_atendimento,'dd/mm/yyyy') dt_atendimento,
       triagem_atendimento.ds_senha,
       sacr_classificacao.ds_tipo_risco classificacao_risco,
       sacr_cor_referencia.nm_cor cor,
       sacr_classificacao.qt_minuto_atendimento meta_cla_risco,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 1  THEN sacr_tempo_processo.dh_processo END) dt_retirada_senha,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 20 THEN sacr_tempo_processo.dh_processo END) dt_chamada_senha,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 21 THEN sacr_tempo_processo.dh_processo END) dt_inicio_atendimento,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 22 THEN sacr_tempo_processo.dh_processo END) dt_fim_atendimento,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 10 THEN sacr_tempo_processo.dh_processo END) dt_chamada_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 11 THEN sacr_tempo_processo.dh_processo END) dt_inicio_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 12 THEN sacr_tempo_processo.dh_processo END) dt_fim_triagem,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 30 THEN sacr_tempo_processo.dh_processo END) dt_chamada_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 31 THEN sacr_tempo_processo.dh_processo END) dt_inicio_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 32 THEN sacr_tempo_processo.dh_processo END) dt_fim_medico,
       Max(CASE WHEN sacr_tempo_processo.cd_tipo_tempo_processo = 90 THEN sacr_tempo_processo.dh_processo END) dt_alta

  FROM dbamv.sacr_tempo_processo,
       dbamv.sacr_cor_referencia,
       dbamv.triagem_atendimento,
       dbamv.sacr_classificacao

 WHERE Trunc(triagem_atendimento.dh_pre_atendimento) BETWEEN '30/03/2021' AND '30/03/2021'
   AND sacr_tempo_processo.cd_triagem_atendimento = triagem_atendimento.cd_triagem_atendimento(+)
   AND triagem_atendimento.cd_cor_referencia = sacr_cor_referencia.cd_cor_referencia(+)
   AND triagem_atendimento.cd_classificacao = sacr_classificacao.cd_classificacao(+)
   and sacr_classificacao.ds_tipo_risco is not null 
   --AND triagem_atendimento.ds_senha IN ('PAC0007')

GROUP BY Floor(Months_Between(SYSDATE,triagem_atendimento.dt_nascimento)/12),
         To_Char(triagem_atendimento.dh_pre_atendimento,'dd/mm/yyyy'),
         sacr_classificacao.qt_minuto_atendimento,
         sacr_tempo_processo.cd_atendimento,
         sacr_classificacao.ds_tipo_risco,
         triagem_atendimento.nm_paciente,
         triagem_atendimento.cd_paciente,
         triagem_atendimento.ds_senha,
         sacr_cor_referencia.nm_cor)
         
group by cd_atendimento,
         cd_paciente, 
         nm_paciente,
         vl_idade,
         dt_atendimento,
         ds_senha,
         classificacao_risco,
         cor,
         meta_cla_risco, 
         dt_retirada_senha,
         dt_chamada_senha,
         dt_inicio_atendimento,
         dt_fim_atendimento,
         dt_chamada_triagem,
         dt_inicio_triagem,
         dt_fim_triagem,
         dt_chamada_medico,
         dt_inicio_medico,
         dt_fim_medico,
         dt_alta











