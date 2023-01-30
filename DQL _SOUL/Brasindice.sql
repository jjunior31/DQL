SELECT imp_bra.cd_tiss,
       imp_bra.cd_tuss,
       pro_fat.cd_pro_fat,
       pro_fat.ds_pro_fat,
       SUM (itreg_fat . qt_lancamento) qt_faturado,
       itreg_fat.vl_unitario
  FROM dbamv.reg_fat,
       dbamv.pro_fat,
       dbamv.itreg_fat,
       dbamv.imp_bra
 WHERE reg_fat . cd_reg_fat = itreg_fat . cd_reg_fat
   AND pro_fat .cd_pro_fat = itreg_fat.cd_pro_fat(+)
   AND pro_fat.cd_pro_fat = imp_bra.cd_pro_fat
   AND itreg_fat.hr_lancamento BETWEEN '01/01/2019' AND '31/07/2019'
   AND reg_fat.cd_convenio = 11
   --AND pro_fat.cd_pro_fat = '08002495'
GROUP BY pro_fat.cd_pro_fat,
         pro_fat.ds_pro_fat,
         itreg_fat.vl_unitario,
         imp_bra.cd_tiss,
         imp_bra.cd_tuss


