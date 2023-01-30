SELECT cd_produto
      ,ds_produto
      ,ds_especie
      ,ds_classe
      ,unidade
      ,padronizado
      ,dias_consolidado
      ,saldo_atual
      ,(saida_total/(To_Date('08/07/2021') - To_Date('01/07/2021')+1)) AS consumo_diario
      ,saida_total
      ,CASE WHEN Round(saldo_atual/(saida_total/dias_consolidado)) = 0 THEN 1 ELSE Round(saldo_atual/(saida_total/dias_consolidado)) END dias_estoque
      ,CASE WHEN Round((saida_total/dias_consolidado) - saldo_atual) <0 THEN 0 ELSE Round((saida_total/dias_consolidado) - saldo_atual) END AS sugestao

      ,CASE WHEN Round(saldo_atual/(saida_total/dias_consolidado)) >=  0 AND Round(saldo_atual/(saida_total/dias_consolidado)) <=10 THEN 'Entre 10 dias'
            WHEN Round(saldo_atual/(saida_total/dias_consolidado)) >= 11 AND Round(saldo_atual/(saida_total/dias_consolidado)) <=15 THEN 'Entre 15 dias'
            WHEN Round(saldo_atual/(saida_total/dias_consolidado))>=  16 AND Round(saldo_atual/(saida_total/dias_consolidado)) <=30 THEN 'Entre 30 dias'
            WHEN Round(saldo_atual/(saida_total/dias_consolidado)) >=  31 THEN 'Acima de 30 dias' END est_dias
 FROM (
SELECT  produto.cd_produto
       ,produto.ds_produto
       ,especie.ds_especie
       ,classe.ds_classe
       ,unidade.ds_unidade unidade
       ,Decode(produto.sn_padronizado,'S','Sim','N','Não') padronizado
       ,(SELECT (To_Date(dh_realizacao_consolidacao) - Trunc(SYSDATE,'mm')+1) FROM dbamv.fechamento_do_mes WHERE sn_fechamento_do_mes = 'N' AND To_Char(SYSDATE,'mm/yyyy') = To_Char(dt_competencia,'mm/yyyy') AND dh_realizacao_consolidacao IS NOT NULL) dias_consolidado
       ,(SELECT SUM (est_pro.qt_estoque_atual)/Verif_vl_fator_prod (produto.cd_produto) qt_estoque /*Consulta: Responsavel pela Quantidade em estoque*/
           FROM dbamv.est_pro,
                dbamv.produto,
	              dbamv.empresa_produto,
	              dbamv.estoque
          WHERE estoque.cd_estoque = est_pro.cd_estoque
            AND empresa_produto.cd_multi_empresa = estoque.cd_multi_empresa
            AND produto.cd_produto = empresa_produto.cd_produto
            AND produto.cd_produto = est_pro.cd_produto
            AND empresa_produto.cd_produto(+) = itmvto_estoque.cd_produto
            AND empresa_produto.cd_multi_empresa = 2
            --AND (:cd_estoque is null or estoque.cd_estoque in  (SELECT REGEXP_SUBSTR(:cd_estoque,'[^,]+', 1, LEVEL) FROM DUAL CONNECT BY REGEXP_SUBSTR(:cd_estoque, '[^,]+', 1, LEVEL) IS NOT NULL))
          GROUP BY produto.cd_produto) saldo_atual
       ,CASE WHEN SUM((Nvl (itmvto_estoque . qt_movimentacao,0)* uni_pro.vl_fator )*(Decode(mvto_estoque.tp_mvto_estoque,'D',-1,'C',-1,'N',-1,1)) / Verif_vl_fator_prod (itmvto_estoque.cd_produto)* Nvl(produto.vl_fator_pro_fat,1)) = 0 THEN 1
             WHEN SUM((Nvl (itmvto_estoque . qt_movimentacao,0)* uni_pro.vl_fator )*(Decode(mvto_estoque.tp_mvto_estoque,'D',-1,'C',-1,'N',-1,1)) / Verif_vl_fator_prod (itmvto_estoque.cd_produto)* Nvl(produto.vl_fator_pro_fat,1)) < 0 THEN 1
             ELSE SUM((Nvl (itmvto_estoque . qt_movimentacao,0)* uni_pro.vl_fator )*(Decode(mvto_estoque.tp_mvto_estoque,'D',-1,'C',-1,'N',-1,1)) / Verif_vl_fator_prod (itmvto_estoque.cd_produto)* Nvl(produto.vl_fator_pro_fat,1)) END saida_total

  FROM dbamv.itmvto_estoque
      ,dbamv.mvto_estoque
      ,dbamv.unidade
      ,dbamv.produto
      ,dbamv.especie
      ,dbamv.estoque
      ,dbamv.uni_pro
      ,dbamv.classe

 WHERE mvto_estoque.dt_mvto_estoque BETWEEN '01/07/2021' AND To_Date('08/07/2021') + 86399/86400
   AND itmvto_estoque.cd_mvto_estoque = mvto_estoque.cd_mvto_estoque
   AND itmvto_estoque.cd_produto = produto.cd_produto(+)
   AND mvto_estoque.cd_estoque = estoque.cd_estoque
   AND produto.cd_especie = especie.cd_especie
   AND produto.cd_classe = classe.cd_classe
   AND especie.cd_especie = classe.cd_especie
   AND uni_pro.cd_uni_pro = itmvto_estoque.cd_uni_pro
   AND produto.cd_produto = uni_pro.cd_produto(+)
   AND uni_pro.cd_unidade = unidade.cd_unidade
   AND mvto_estoque.tp_mvto_estoque IN ('P','S','C','D','N')
   AND mvto_estoque.cd_multi_empresa = 2
   AND produto.sn_mestre = 'N' AND produto.cd_produto IN (25,11799,1835,2557)
   --AND (:cd_produto is null or produto.cd_produto in  (SELECT REGEXP_SUBSTR(:cd_produto,'[^,]+', 1, LEVEL) FROM DUAL CONNECT BY REGEXP_SUBSTR(:cd_produto, '[^,]+', 1, LEVEL) IS NOT NULL))
   --AND (:cd_estoque is null or estoque.cd_estoque in  (SELECT REGEXP_SUBSTR(:cd_estoque,'[^,]+', 1, LEVEL) FROM DUAL CONNECT BY REGEXP_SUBSTR(:cd_estoque, '[^,]+', 1, LEVEL) IS NOT NULL))

GROUP BY itmvto_estoque.cd_produto
        ,produto.sn_padronizado
        ,produto.cd_produto
        ,produto.ds_produto
        ,especie.cd_especie
        ,especie.ds_especie
        ,unidade.ds_unidade
        ,classe.cd_classe
        ,classe.ds_classe

ORDER BY 1 ASC )
