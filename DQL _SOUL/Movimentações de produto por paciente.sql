SELECT dt_mvto_estoque,
       atendimento,
       prontuario,
       paciente,
       dt_atend,
       unid_intern,
       medico,
       convenio,
       produto,
       unidade,
       total
 FROM (
SELECT   mvto_estoque.dt_mvto_estoque
        ,mvto_estoque.cd_atendimento Atendimento
	    ,atendime.cd_paciente prontuario
	    ,paciente.nm_paciente Paciente
	    ,to_char(atendime.dt_atendimento, 'dd/mm/yyyy') Dt_Atend
     	,unid_int.ds_unid_int Unid_Intern
      ,prestador.nm_prestador Medico
	    ,convenio.nm_convenio Convenio
	    ,itmvto_estoque.cd_produto Cod_Produto
	    ,produto.ds_produto Produto
	    ,verif_ds_unid_prod(itmvto_estoque.cd_produto) Unidade
	    ,sum(decode(tp_mvto_estoque, 'P', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto) Qt_Saida
	    ,sum(decode(tp_mvto_estoque, 'C', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto) Qt_Devolvida
      ,(sum(decode(tp_mvto_estoque, 'P', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto))-(sum(decode(tp_mvto_estoque, 'C', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto)) Total
  FROM dbamv.atendime
	    ,dbamv.convenio
	    ,dbamv.mvto_estoque
	    ,dbamv.itmvto_estoque
	    ,dbamv.leito
	    ,dbamv.paciente
	    ,dbamv.prestador
	    ,dbamv.produto
	    ,dbamv.uni_pro
	    ,dbamv.unid_int
	    ,dbamv.estoque
	    ,dbamv.setor
WHERE atendime.cd_atendimento = mvto_estoque.cd_atendimento
	AND atendime.cd_paciente = paciente.cd_paciente
	AND atendime.cd_leito = leito.cd_leito(+)
	AND leito.cd_unid_int = unid_int.cd_unid_int(+)
	AND atendime.cd_prestador = prestador.cd_prestador
	AND atendime.cd_convenio = convenio.cd_convenio
	AND mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
	AND MVTO_ESTOQUE.CD_ESTOQUE = ESTOQUE.CD_ESTOQUE
	AND ESTOQUE.CD_MULTI_EMPRESA = 2
	AND ATENDIME.CD_MULTI_EMPRESA = 2
	AND itmvto_estoque.cd_produto = produto.cd_produto
	AND itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
	AND mvto_estoque.tp_mvto_estoque IN ('C','P')
  AND atendime.dt_alta IS NULL
	AND mvto_estoque.dt_mvto_estoque
	AND mvto_estoque.cd_setor = setor.cd_setor
	AND PRODUTO.CD_PRODUTO = '15367'
GROUP BY uni_pro.vl_fator
	,itmvto_estoque.cd_produto
	,mvto_estoque.cd_atendimento
  ,unid_int.ds_unid_int
  ,prestador.nm_prestador
	,atendime.cd_paciente
	,paciente.nm_paciente
	,atendime.dt_atendimento
	,atendime.dt_alta
	,unid_int.ds_unid_int
	,prestador.nm_prestador
	,convenio.nm_convenio
  ,produto.ds_produto
  ,leito.ds_leito

ORDER BY 1 ASC
         ,produto.ds_produto)
WHERE total >= 5