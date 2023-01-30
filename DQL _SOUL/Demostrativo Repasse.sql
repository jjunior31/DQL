/*Select 1*/
SELECT  repcon.cd_prestador_repasse AS "Grupo de Repasse", 
        repcon.cd_prestador AS "Prestador", 
        prestador.nm_prestador AS "Médico", 
        repcon.dt_lancamento AS "Data", 
        repcon.cd_atendimento AS "Atend", 
        Decode (repcon . cd_reg_fat, 0, repcon . cd_reg_amb,repcon . cd_reg_fat) AS  "Conta", 
        repcon . nm_paciente AS "Paciente", 
        repcon . cd_pro_fat  AS "Procedimento", 
        repcon . ds_ati_med  AS "Atividade", 
        repcon . vl_repasse  AS "Vl. Repassado", 
        repcon . dt_competencia_rep AS "Dt. Repasse", 
        repcon . dt_competencia_fat AS "Compet. Fat.", 
        repcon . cd_repasse_consolidado AS "Codigo", 
        0  AS "ContaConvenio", 
        convenio . nm_convenio AS "Convenio", 
        repcon . cd_remessa  AS "Remessa", 
        repcon . qt_lancamento AS "Quantidade" 

  FROM  dbamv.repasse_consolidado repcon /*Select extrair a quantidade de repasse consilidados*/
       ,dbamv.prestador
       ,dbamv.convenio 
 WHERE  repcon.cd_prestador = prestador.cd_prestador
   AND  repcon.cd_convenio =  convenio.cd_convenio
   AND  convenio.tp_convenio IN ('A','H') 
   AND  repcon.cd_prestador = 399 
   AND  repcon.cd_atendimento = 2214487

--ORDER BY 4 ASC
/* Select 2 */ /*Select relacionaveis aos Convenios*/ 
SELECT dbamv . pkg_repasse . Fnc_fnrm_retorna_grupo_repasse (prestador . cd_prestador,reg_amb . cd_multi_empresa, convenio . cd_convenio,pro_fatcd_gru_pro, 
               pro_fat . cd_pro_fat, atendime . cd_ori_ate, itreg_amb . cd_setor,Decode (atendime . tp_atendimento, 'A', atendime . cd_ser_dis,atendime . cd_servico), 
               itreg_amb . cd_ati_med,atendime . tp_atendimento, reg_amb . dt_lancamento,itreg_amb . hr_lancamento) "Grupo de Repasse", 
       prestador . cd_prestador          "Prestador", 
       prestador . nm_prestador, 
       atendime . dt_atendimento         "Data", 
       atendime . cd_atendimento         "Atend", 
       reg_amb . cd_reg_amb              "Conta", 
       paciente . nm_paciente            "Paciente", 
       itreg_amb . cd_pro_fat            "Procedimento", 
       ati_med . ds_ati_med              "Atividade", 
       To_number (NULL)                  "Vl. Repassado", 
       To_date (NULL)                    "Dt. Repasse", 
       fatura . dt_competencia           "Compet. Fat.", 
       itreg_amb . cd_lancamento         "Codigo", 
       1                                 "ContaConvenio", 
       itreg_amb . cd_convenio           "Convenio", 
       reg_amb . cd_remessa              "Remessa", 
       itreg_amb . qt_lancamento         "Quantidade"
	   
FROM   dbamv . reg_amb, 
       dbamv . itreg_amb, 
       dbamv . prestador, 
       dbamv . atendime, 
       dbamv . paciente, 
       dbamv . ati_med, 
       dbamv . pro_fat, 
       dbamv . convenio, 
       dbamv . empresa_prestador, 
       dbamv . multi_empresas_repasse, 
       dbamv . fatura, 
       dbamv . remessa_fatura /*Select extrai a relação de dados com valores não repassados ambulatoriais*/
	   
WHERE  reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb 
       AND itreg_amb.cd_prestador IS NOT NULL 
       AND Nvl (itreg_amb.vl_total_conta, 0) > 0 /*Valor de conta maior que 0*/
       AND itreg_amb.cd_atendimento = atendime.cd_atendimento 
       AND itreg_amb.cd_ati_med = ati_med.cd_ati_med (+) 
       AND Nvl (itreg_amb.tp_pagamento, 'P') = 'P' 
       AND reg_amb.cd_remessa = remessa_fatura.cd_remessa (+) 
       AND remessa_fatura.cd_fatura = fatura.cd_fatura (+) 
       AND itreg_amb.sn_repassado = 'N' /*Valor repassado igual a não*/
       AND itreg_amb.cd_convenio = convenio.cd_convenio 
       AND itreg_amb.cd_pro_fat = pro_fat.cd_pro_fat 
       AND prestador.cd_prestador = empresa_prestador.cd_prestador 
       AND empresa_prestador.cd_multi_empresa = reg_amb.cd_multi_empresa 
       AND multi_empresas_repasse.cd_multi_empresa_rep = 2
       AND atendime.cd_multi_empresa = multi_empresas_repasse.cd_multi_empresa_fat 
       AND atendime.cd_paciente = paciente.cd_paciente 
       AND itreg_amb.cd_prestador = prestador.cd_prestador 
       AND itreg_amb.vl_base_repassado IS NULL 
       --AND atendime.cd_atendimento = 2214487
       AND itreg_amb.cd_prestador = 399

/* Select 3 */ /*Select relacionaveis aos Convenios*/ 
SELECT dbamv . pkg_repasse . Fnc_fnrm_retorna_grupo_repasse (prestador . cd_prestador,reg_fat . cd_multi_empresa, convenio . cd_convenio, 
               pro_fat . cd_gru_pro,pro_fat . cd_pro_fat, atendime . cd_ori_ate, itreg_fat . cd_setor, 
               atendime . cd_servico, itreg_fat . cd_ati_med,atendime . tp_atendimento, 
               itreg_fat . dt_lancamento, itreg_fat . hr_lancamento)"Grupo de Repasse", 
       prestador . cd_prestador, 
       prestador . nm_prestador, 
       itreg_fat . dt_lancamento, 
       atendime . cd_atendimento, 
       reg_fat . cd_reg_fat, 
       paciente . nm_paciente, 
       itreg_fat . cd_pro_fat, 
       ati_med . ds_ati_med, 
       To_number (NULL) 
       "Vl. Repassado", 
       To_date (NULL) 
       "Dt. Repasse", 
       fatura . dt_competencia 
       "Compet. Fat.", 
       itreg_fat . cd_lancamento "Codigo", 
       2 "ContaConvenio", 
       reg_fat . cd_convenio "Convenio", 
       reg_fat . cd_remessa "Remessa", 
       itreg_fat . qt_lancamento "Quantidade" 

FROM   dbamv . reg_fat, 
       dbamv . itreg_fat, 
       dbamv . prestador, 
       dbamv . atendime, 
       dbamv . paciente, 
       dbamv . ati_med, 
       dbamv . convenio, 
       dbamv . itlan_med, 
       dbamv . pro_fat, 
       dbamv . empresa_prestador, 
       dbamv . multi_empresas_repasse, 
       dbamv . fatura, 
       dbamv . remessa_fatura 
	   
WHERE  reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat 
       AND itreg_fat.cd_prestador IS NOT NULL 
       AND Nvl (itreg_fat.vl_total_conta, 0) > 0 /*Valor de conta maior que 0 */
       AND Nvl (Nvl (itlan_med.tp_pagamento, itreg_fat.tp_pagamento), 'X') <> 'C' 
       AND reg_fat.cd_atendimento = atendime.cd_atendimento 
       AND itlan_med.cd_reg_fat (+) = itreg_fat.cd_reg_fat 
       AND Nvl (Nvl (itlan_med.cd_tipo_vinculo, itreg_fat.cd_tipo_vinculo), 0) NOT IN (6,7, 8, 17,21,23, 29, 40, 44) 
       AND itlan_med.cd_lancamento (+) = itreg_fat.cd_lancamento 
       AND convenio.tp_convenio IN ( 'C', 'P' ) /* Tipo de convenios (convenio e particulares)*/
       AND itreg_fat.cd_ati_med = ati_med.cd_ati_med (+) 
       AND atendime.cd_paciente = paciente.cd_paciente 
       AND itreg_fat.cd_prestador = prestador.cd_prestador 
       AND itreg_fat.vl_base_repassado IS NULL /* valor de base repassado null*/
       AND reg_fat.cd_remessa = remessa_fatura.cd_remessa (+) 
       AND remessa_fatura.cd_fatura = fatura.cd_fatura (+) 
       AND reg_fat.cd_convenio = convenio.cd_convenio 
       AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat 
       AND prestador.cd_prestador = empresa_prestador.cd_prestador 
       AND empresa_prestador.cd_multi_empresa = reg_fat.cd_multi_empresa 
       AND multi_empresas_repasse.cd_multi_empresa_rep = 2 
       AND atendime.cd_multi_empresa = multi_empresas_repasse.cd_multi_empresa_fat 
       AND itreg_fat.cd_prestador = 399 --AND atendime.cd_atendimento = 2214487

/* Select 4 */ /*Select relacionaveis ao SUS*/
SELECT dbamv . pkg_repasse . Fnc_fnrm_retorna_grupo_repasse (Decode (dbamv . pkt_config_ffas . Retorna_campo ('SN_INTEGRA_REPASSE'), 'N', 
               prestador . cd_prestador, Nvl (eve_siasus . cd_prestador_executante,prestador . cd_prestador)) 
               ,eve_siasus . cd_multi_empresa, convenio . cd_convenio, NULL,eve_siasus . cd_ssm, 
               atendime . cd_ori_ate, NULL,Decode (atendime . tp_atendimento, 'A', atendime . cd_ser_dis, 
               atendime . cd_servico), NULL,atendime . tp_atendimento, NULL, NULL) "Grupo de Repasse", 
       prestador . cd_prestador                               "Prestador", 
       prestador . nm_prestador, 
       eve_siasus . dt_eve_siasus                             "Data", 
       eve_siasus . cd_atendimento                            "Atend", 
       eve_siasus . cd_eventos                                "Conta", 
       Nvl (eve_siasus . nm_paciente, paciente . nm_paciente) "Paciente", 
       eve_siasus . cd_ssm                                    "Procedimento", 
       NULL                                                   "Atividade", 
       To_number (NULL)                                       "Vl. Repassado", 
       To_date (NULL)                                         "Dt. Repasse", 
       To_date (NULL)                                         "Compet. Fat.", 
       To_number (NULL)                                       "Codigo", 
       3                                                      "ContaConvenio", 
       eve_siasus . cd_convenio                               "Convenio", 
       To_number (NULL)                                       "Remessa", 
       eve_siasus . qt_lancada                                "Quantidade" 
	   
FROM   dbamv . eve_siasus, 
       dbamv . prestador, 
       dbamv . paciente, 
       dbamv . atendime, 
       dbamv . convenio, 
       dbamv . config_ffcv, 
       dbamv . empresa_prestador 
WHERE  empresa_prestador.cd_multi_empresa = 2
       AND eve_siasus.cd_multi_empresa = empresa_prestador.cd_multi_empresa 
       AND eve_siasus.cd_prestador = empresa_prestador.cd_prestador 
       AND eve_siasus.cd_prestador = prestador.cd_prestador 
       AND eve_siasus.cd_convenio = convenio.cd_convenio 
       AND eve_siasus.cd_atendimento = atendime.cd_atendimento (+) 
       AND eve_siasus.cd_paciente = paciente.cd_paciente (+) 
       AND Nvl (prestador.tp_vinculo, 'X') != 'U' 
       AND eve_siasus.qt_lancada > 0 /*Valor de quantidade SUS maior que 0*/	   
       AND eve_siasus.cd_prestador IS NOT NULL  /*Prestador SUS not null*/
       AND eve_siasus.vl_base_repassado IS NULL /* Valor repassado null*/
       AND config_ffcv.cd_multi_empresa = 2
       AND ((config_ffcv.sn_repassa_bpa_teto = 'N' AND Nvl (eve_siasus.sn_sobra, 'N') = 'N') OR (config_ffcv.sn_repassa_bpa_teto = 'S'))
       /*	   
       AND eve_siasus.cd_prestador = 399   --AND atendime.cd_atendimento = 2214487


/* Select 5 */ /*Select relacionaveis ao SUS*/
SELECT dbamv . pkg_repasse . Fnc_fnrm_retorna_grupo_repasse (Decode (dbamv . pkt_config_ffas . Retorna_campo ('SN_INTEGRA_REPASSE'), 'N',prestador . cd_prestador, 
               Nvl (eve_siasus . cd_prestador_executante,prestador . cd_prestador)), eve_siasus . cd_multi_empresa, convenio . cd_convenio, NULL, 
               eve_siasus . cd_ssm,atendime . cd_ori_ate, NULL,Decode (atendime . tp_atendimento, 'A', atendime . cd_ser_dis, 
               atendime . cd_servico), NULL, atendime . tp_atendimento, NULL, NULL) "Grupo de Repasse", 
       prestador . cd_prestador                               "Prestador", 
       prestador . nm_prestador, 
       eve_siasus . dt_eve_siasus                             "Data", 
       eve_siasus . cd_atendimento                            "Atend", 
       eve_siasus . cd_eventos                                "Conta", 
       Nvl (eve_siasus . nm_paciente, paciente . nm_paciente) "Paciente", 
       eve_siasus . cd_ssm                                    "Procedimento", 
       NULL                                                   "Atividade", 
       To_number (NULL)                                       "Vl. Repassado", 
       To_date (NULL)                                         "Dt. Repasse", 
       To_date (NULL)                                         "Compet. Fat.", 
       To_number (NULL)                                       "Codigo", 
       4                                                      "ContaConvenio", 
       eve_siasus . cd_convenio                               "Convenio", 
       To_number (NULL)                                       "Remessa", 
       eve_siasus . qt_lancada                                "Quantidade" 
	   
FROM   dbamv . eve_siasus, 
       dbamv . prestador, 
       dbamv . paciente, 
       dbamv . atendime, 
       dbamv . convenio, 
       dbamv . config_ffcv, 
       dbamv . empresa_prestador 
WHERE  empresa_prestador.cd_multi_empresa = 2
       AND eve_siasus.cd_multi_empresa = empresa_prestador.cd_multi_empresa 
       AND eve_siasus.cd_prestador_pode_ter = empresa_prestador.cd_prestador 
       AND eve_siasus.cd_prestador_pode_ter = prestador.cd_prestador 
       AND eve_siasus.cd_convenio = convenio.cd_convenio 
       AND eve_siasus.cd_atendimento = atendime.cd_atendimento (+) 
       AND eve_siasus.cd_paciente = paciente.cd_paciente (+) 
       AND Nvl (prestador.tp_vinculo, 'X') != 'U' 
       AND eve_siasus.qt_lancada > 0 
       AND eve_siasus.cd_prestador_pode_ter IS NOT NULL 
       AND eve_siasus.vl_base_repassado_anest IS NULL 
       AND config_ffcv.cd_multi_empresa = 2 
       AND ( ( config_ffcv.sn_repassa_bpa_teto = 'N'AND Nvl (eve_siasus.sn_sobra, 'N') = 'N' ) OR ( config_ffcv.sn_repassa_bpa_teto = 'S' ) )  
       AND eve_siasus.cd_prestador_pode_ter = 399 AND atendime.cd_atendimento = 2214487
/* Select 6 */
SELECT dbamv . pkg_repasse . Fnc_fnrm_retorna_grupo_repasse (prestador . cd_prestador,reg_fat . cd_multi_empresa, convenio . cd_convenio, 
               pro_fat . cd_gru_pro,pro_fat . cd_pro_fat, atendime . cd_ori_ate, itreg_fat . cd_setor, 
               atendime . cd_servico, itreg_fat . cd_ati_med,atendime . tp_atendimento, 
               itreg_fat . dt_lancamento, itreg_fat . hr_lancamento) "Grupo de Repasse", 
       prestador . cd_prestador                                     "Prestador", 
       prestador . nm_prestador, 
       itreg_fat . dt_lancamento                                    "Data", 
       atendime . cd_atendimento                                    "Atend", 
       reg_fat . cd_reg_fat                                         "Conta", 
       paciente . nm_paciente                                       "Paciente", 
       itreg_fat . cd_pro_fat 
       "Procedimento", 
       ati_med . ds_ati_med                                         "Atividade", 
       To_number (NULL) 
       "Vl. Repassado", 
       To_date (NULL) 
       "Dt. Repasse", 
       reg_fat . dt_fechamento 
       "Compet. Fat.", 
       itreg_fat . cd_lancamento                                    "Codigo", 
       5 
       "ContaConvenio", 
       reg_fat . cd_convenio                                        "Convenio", 
       reg_fat . cd_remessa                                         "Remessa", 
       itreg_fat . qt_lancamento                                    "Quantidade" 
	   
FROM   dbamv . reg_fat, 
       dbamv . itreg_fat, 
       dbamv . prestador, 
       dbamv . atendime, 
       dbamv . paciente, 
       dbamv . ati_med, 
       dbamv . convenio, 
       dbamv . itlan_med, 
       dbamv . pro_fat, 
       dbamv . empresa_prestador 
WHERE  reg_fat.sn_fechada = 'S' 
       AND reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat 
       AND itreg_fat.cd_prestador IS NOT NULL 
       AND reg_fat.cd_atendimento = atendime.cd_atendimento 
       AND itlan_med.cd_reg_fat (+) = itreg_fat.cd_reg_fat 
       AND Nvl (Nvl (itlan_med.cd_tipo_vinculo, itreg_fat.cd_tipo_vinculo), 0) 
           NOT IN (6,7, 8, 17,21,23, 29, 40, 44 ) 
       AND itlan_med.cd_lancamento (+) = itreg_fat.cd_lancamento 
       AND Nvl (Nvl (itlan_med.tp_pagamento, itreg_fat.tp_pagamento), 'X') <> 'C' 
       AND convenio.tp_convenio = 'H' 
       AND itreg_fat.cd_ati_med = ati_med.cd_ati_med (+) 
       AND atendime.cd_paciente = paciente.cd_paciente 
       AND itreg_fat.cd_prestador = prestador.cd_prestador 
       AND reg_fat.cd_convenio = convenio.cd_convenio 
       AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat 
       AND prestador.cd_prestador = empresa_prestador.cd_prestador 
       AND empresa_prestador.cd_multi_empresa = reg_fat.cd_multi_empresa 
       AND itreg_fat.cd_prestador = 399
