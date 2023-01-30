SELECT itpre_med . ds_itpre_med, 
       itpre_med . ds_itpre_med                                  observacao, 
       '24 Horas'                                                Validade, 
       for_apl . ds_for_apl, 
       itpre_med . qt_itpre_med 
       || ' ' 
       || uni_pro . cd_unidade 
       || Decode (itpre_med . tp_tempo, NULL, '', 
                                        '/' 
                                        || itpre_med . tp_tempo) volume, 
       itpre_med . qt_infusao 
       || ' ' 
       || uni_pro_inf . cd_unidade                               infusao, 
       tip_fre . ds_tip_fre, 
       tip_presc . ds_tip_presc, 
       atendime . cd_atendimento 
FROM   dbamv . atendime, 
       dbamv . leito, 
       dbamv . paciente, 
       dbamv . unid_int, 
       dbamv . itpre_med, 
       dbamv . pre_med, 
       dbamv . for_apl, 
       dbamv . tip_fre, 
       dbamv . tip_presc, 
       dbamv . uni_pro, 
       dbamv . uni_pro uni_pro_inf 
WHERE  ( atendime.tp_atendimento = 'I' 
         AND atendime.dt_alta IS NULL  -- Atendiemntos sem altas
         AND atendime.cd_paciente = paciente.cd_paciente 
         AND atendime.cd_leito = leito.cd_leito 
         AND leito.cd_unid_int = unid_int.cd_unid_int 
         AND atendime.cd_atendimento = pre_med.cd_atendimento 
         AND pre_med.cd_pre_med = itpre_med.cd_pre_med 
         AND itpre_med.cd_tip_presc = tip_presc.cd_tip_presc 
         AND itpre_med.cd_tip_esq = tip_presc.cd_tip_esq 
         AND itpre_med.cd_for_apl = for_apl.cd_for_apl (+) 
         AND itpre_med.cd_tip_fre = tip_fre.cd_tip_fre (+) 
         AND itpre_med.cd_uni_pro = uni_pro.cd_uni_pro (+) 
         AND itpre_med.cd_uni_pro_inf = uni_pro_inf.cd_uni_pro (+) 
         AND atendime.cd_multi_empresa = 2 
         AND itpre_med.cd_tip_esq = 'DEN' 
         AND pre_med.dt_pre_med = '02/11/20' )
         AND atendime.cd_atendimento = 2320536  

UNION 

SELECT itpre_med . ds_itpre_med, 
       itpre_med . ds_itpre_med                                  observacao, 
       '24 Horas'                                                Validade, 
       for_apl . ds_for_apl, 
       itpre_med . qt_itpre_med 
       || ' ' 
       || uni_pro . cd_unidade 
       || Decode (itpre_med . tp_tempo, NULL, '', 
                                        '/' 
                                        || itpre_med . tp_tempo) volume, 
       itpre_med . qt_infusao 
       || ' ' 
       || uni_pro_inf . cd_unidade                               infusao, 
       tip_fre . ds_tip_fre, 
       tip_presc . ds_tip_presc, 
       atendime . cd_atendimento 
FROM   dbamv . atendime, 
       dbamv . leito, 
       dbamv . paciente, 
       dbamv . unid_int, 
       dbamv . itpre_med, 
       dbamv . pre_med, 
       dbamv . for_apl, 
       dbamv . tip_fre, 
       dbamv . tip_presc, 
       dbamv . uni_pro, 
       dbamv . uni_pro uni_pro_inf 
WHERE  ( atendime.tp_atendimento <> 'I' 
         AND atendime.dt_alta IS NULL  -- Atendiemntos sem altas
         AND atendime.cd_paciente = paciente.cd_paciente 
         AND atendime.cd_leito = leito.cd_leito 
         AND leito.cd_unid_int = unid_int.cd_unid_int 
         AND atendime.cd_atendimento = pre_med.cd_atendimento 
         AND pre_med.cd_pre_med = itpre_med.cd_pre_med 
         AND itpre_med.cd_tip_presc = tip_presc.cd_tip_presc 
         AND itpre_med.cd_tip_esq = tip_presc.cd_tip_esq 
         AND itpre_med.cd_for_apl = for_apl.cd_for_apl (+) 
         AND itpre_med.cd_tip_fre = tip_fre.cd_tip_fre (+) 
         AND itpre_med.cd_uni_pro = uni_pro.cd_uni_pro (+) 
         AND itpre_med.cd_uni_pro_inf = uni_pro_inf.cd_uni_pro (+) 
         AND atendime.cd_multi_empresa = 2 
         AND 1 = 1 
         AND itpre_med.cd_tip_esq = 'DEN' 
         AND pre_med.dt_pre_med = '02/11/20') 
         AND atendime.cd_atendimento = 2320536 
     