SELECT DISTINCT cd_atendimento
      ,dt_atendimento
      ,tp_atendimento
      ,cd_convenio
      ,convenio
      ,cd_pro_fat
      ,Procedimento
      ,cd_gru_fat
      ,gru_fat
      ,vl_pro_gru
      ,vl_conta
      ,vl_pacote
      ,CASE WHEN vl_pacote IS NOT NULL THEN 'S' ELSE 'N' END pacote

FROM (
SELECT atendime.cd_atendimento
      ,atendime.dt_atendimento
      ,atendime.tp_atendimento
      ,convenio.cd_convenio
      ,convenio.cd_convenio||' - '||convenio.nm_convenio convenio
      ,pro_fat.cd_pro_fat
      ,pro_fat.cd_pro_fat||' - '||pro_fat.ds_pro_fat procedimento
      ,gru_fat.cd_gru_fat
      ,gru_fat.cd_gru_fat||' - '||gru_fat.ds_gru_fat gru_fat
      ,Sum(itreg_fat.vl_total_conta) vl_pro_gru
      ,(SELECT Sum(i.vl_total_conta) FROM itreg_fat i WHERE i.cd_reg_fat = itreg_fat.cd_reg_fat AND i.cd_gru_fat NOT IN(8,2,15,33)) vl_conta
      ,(SELECT Sum(i.vl_total_conta) FROM itreg_fat i WHERE i.cd_reg_fat = itreg_fat.cd_reg_fat AND i.cd_gru_fat = 8) vl_pacote

  FROM dbamv.atendime
  INNER JOIN reg_fat ON atendime.cd_atendimento = reg_fat.cd_atendimento
  INNER JOIN itreg_fat ON reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
  INNER JOIN convenio ON reg_fat.cd_convenio = convenio.cd_convenio
  INNER JOIN pro_fat ON atendime.cd_pro_int = pro_fat.cd_pro_fat
  INNER JOIN gru_fat ON itreg_fat.cd_gru_fat = gru_fat.cd_gru_fat

 WHERE Trunc(atendime.dt_atendimento) BETWEEN :ini AND To_Date(:fin) + 86399/86400
   AND itreg_fat.cd_gru_fat NOT IN (2,8,33)

GROUP BY atendime.dt_atendimento
        ,atendime.cd_atendimento
        ,atendime.tp_atendimento
        ,itreg_fat.cd_reg_fat
        ,gru_fat.cd_gru_fat
        ,gru_fat.ds_gru_fat
        ,convenio.cd_convenio
        ,convenio.nm_convenio
        ,pro_fat.cd_pro_fat
        ,pro_fat.ds_pro_fat

UNION ALL

SELECT atendime.cd_atendimento
      ,atendime.dt_atendimento dt_atendimento
      ,atendime.tp_atendimento
      ,convenio.cd_convenio
      ,convenio.cd_convenio||' - '||convenio.nm_convenio convenio
      ,pro_fat.cd_pro_fat
      ,pro_fat.cd_pro_fat||' - '||pro_fat.ds_pro_fat procedimento
      ,gru_fat.cd_gru_fat
      ,gru_fat.cd_gru_fat||' - '||gru_fat.ds_gru_fat gru_fat
      ,Sum(itreg_amb.vl_total_conta) vl_pro_gru
      ,(SELECT Sum(i.vl_total_conta) FROM itreg_amb i WHERE i.cd_reg_amb = itreg_amb.cd_reg_amb AND i.cd_gru_fat NOT IN (8,2,15,33)) vl_conta
      ,(SELECT Sum(i.vl_total_conta) FROM itreg_amb i WHERE i.cd_reg_amb = itreg_amb.cd_reg_amb AND i.cd_gru_fat = 8) vl_pacote

  FROM dbamv.atendime
  INNER JOIN itreg_amb ON atendime.cd_atendimento = itreg_amb.cd_atendimento
  INNER JOIN reg_amb ON reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
  INNER JOIN convenio ON reg_amb.cd_convenio = convenio.cd_convenio
  INNER JOIN pro_fat ON atendime.cd_pro_int = pro_fat.cd_pro_fat
  INNER JOIN gru_fat ON itreg_amb.cd_gru_fat = gru_fat.cd_gru_fat

 WHERE atendime.dt_atendimento BETWEEN :ini AND  To_Date(:fin) + 86399/86400
   AND itreg_amb.cd_gru_fat NOT IN (2,8,33)

GROUP BY atendime.dt_atendimento
        ,atendime.cd_atendimento
        ,atendime.tp_atendimento
        ,itreg_amb.cd_reg_amb
        ,gru_fat.cd_gru_fat
        ,gru_fat.ds_gru_fat
        ,convenio.cd_convenio
        ,convenio.nm_convenio
        ,pro_fat.cd_pro_fat
        ,pro_fat.ds_pro_fat)



