SELECT solsai_pro.cd_solsai_pro AS "Cod.Solicitação",
       mvto_estoque.cd_mvto_estoque AS "Cod.Movimentação",
       atendime.cd_atendimento AS "Atendimento do Paciente",
       estoque.ds_estoque AS "Estoque",
       produto.cd_produto AS "Cod.Produto",
       produto.ds_produto AS "Produto",
       itmvto_estoque.qt_movimentacao AS "Qt.Movimentação",
       setor.nm_setor AS "Setor de Baixa",
       prestador.nm_prestador AS "Solicitante",
       mvto_estoque.cd_usuario AS "Atendente"
  FROM mvto_estoque,
       prestador,
       solsai_pro,
       atendime,
       estoque,
       itmvto_estoque,
       produto,
       setor
 WHERE mvto_estoque.cd_atendimento = atendime.cd_atendimento
   AND itmvto_estoque.cd_mvto_estoque = mvto_estoque.cd_mvto_estoque(+)
   AND prestador.cd_prestador = mvto_estoque.cd_prestador(+)
   AND mvto_estoque.cd_solsai_pro(+) = solsai_pro.cd_solsai_pro
   AND itmvto_estoque.cd_produto  =  produto.cd_produto
   AND mvto_estoque.cd_setor = setor.cd_setor
   AND solsai_pro.cd_estoque = estoque.cd_estoque(+)
   AND produto.sn_lote = 'S'
   AND itmvto_estoque.dsp_codigo_de_barras IS NULL
   AND mvto_estoque.cd_multi_empresa = 2
   --AND estoque.cd_estoque = 11
   AND produto.cd_especie IN (1,5)
   AND To_Char(solsai_pro.dt_solsai_pro,'mm/yyyy') = '12/2019'
ORDER BY 1 ASC