SELECT imp_bra.cd_tiss AS "COD. TISS",
       imp_bra.cd_tuss AS "COD. TUSS",
       imp_bra.cd_pro_fat AS "COD. PROCEDIMENTO",
       pro_fat.ds_pro_fat AS "DESCRIÇÃO FATURAMENTO",
  FROM dbamv.reg_fat,
       dbamv.produto,
       dbamv.pro_fat,
       dbamv.itreg_fat,
       dbamv.custo_medio_mensal
 WHERE reg_fat . cd_reg_fat = itreg_fat . cd_reg_fat
   AND pro_fat .cd_pro_fat = itreg_fat.cd_pro_fat
   AND produto . cd_pro_fat = itreg_fat . cd_pro_fat(+)
   AND custo_medio_mensal.cd_produto = produto.cd_produto
   AND itreg_fat.hr_lancamento BETWEEN '01/01/2019' AND '31/07/2019'
   AND reg_fat.cd_convenio = 11
/*GROUP BY pro_fat.cd_pro_fat,
        pro_fat.ds_pro_fat,
        itreg_fat.vl_unitario  */



