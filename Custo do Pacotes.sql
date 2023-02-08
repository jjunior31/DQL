SELECT cd_atendimento
      ,dt_atendimento
      ,tp_atendimento
      ,Max(nm_prestador) nm_prestador
      ,Max(cd_convenio) cd_convenio
      ,Max(cd_pro_fat) cd_por_fat
      ,Max(convenio) convenio
      ,Max(procedimento) procedimento
      ,Max(vl_receita) vl_receita
      ,CASE WHEN :opme = '1' THEN nvl(Max(vl_matmed) - Max(vl_opme),0)
            when :opme = '0' then Max(vl_matmed) END opme
      ,vl_matmed
      ,Max(vl_opme) vl_opme
      ,Max(vl_diaria) vl_diaria
      ,Max(vl_honorario) vl_honorario
      ,Max(vl_procedimento) vl_procedimento

FROM (
SELECT atendime.cd_atendimento
      ,atendime.dt_atendimento
      ,atendime.tp_atendimento
      ,prestador.nm_prestador
      ,convenio.cd_convenio
      ,pro_fat.cd_pro_fat
      ,convenio.cd_convenio||'-'||convenio.nm_convenio convenio
      ,pro_fat.cd_pro_fat||'-'||pro_fat.ds_pro_fat procedimento
      ,fa_custo_atendimento.vl_receita
      ,fa_custo_atendimento.vl_matmed
      ,NULL vl_opme
      ,fa_custo_atendimento.vl_diaria
      ,fa_custo_atendimento.vl_honorario
      ,fa_custo_atendimento.vl_procedimento

  FROM fa_custo_atendimento
  INNER JOIN atendime ON fa_custo_atendimento.cd_atendimento = atendime.cd_atendimento
  INNER JOIN paciente ON atendime.cd_paciente = paciente.cd_paciente
  INNER JOIN pro_fat  ON atendime.cd_pro_int = pro_fat.cd_pro_fat
  INNER JOIN convenio ON atendime.cd_convenio = convenio.cd_convenio
  INNER JOIN prestador ON atendime.cd_prestador = prestador.cd_prestador
  left  JOIN cirurgia ON fa_custo_atendimento.cd_cirurgia = cirurgia.cd_cirurgia
  INNER JOIN cid ON atendime.cd_cid = cid.cd_cid
  INNER JOIN sgru_cid ON cid.cd_sgru_cid = sgru_cid.cd_sgru_cid
  INNER JOIN gru_cid  ON sgru_cid.cd_gru_cid = gru_cid.cd_gru_cid

 WHERE atendime.cd_multi_empresa = 2

GROUP BY atendime.cd_atendimento
      ,atendime.dt_atendimento
      ,atendime.tp_atendimento
      ,prestador.nm_prestador
      ,convenio.cd_convenio
      ,pro_fat.cd_pro_fat
      ,convenio.cd_convenio
      ,convenio.nm_convenio
      ,pro_fat.cd_pro_fat
      ,pro_fat.ds_pro_fat
      ,fa_custo_atendimento.vl_receita
      ,fa_custo_atendimento.vl_matmed
      ,fa_custo_atendimento.vl_diaria
      ,fa_custo_atendimento.vl_honorario
      ,fa_custo_atendimento.vl_procedimento

UNION ALL

SELECT atendime.cd_atendimento
      ,atendime.dt_atendimento
      ,atendime.tp_atendimento
      ,NULL nm_prestador
      ,NULL cd_convenio
      ,NULL cd_pro_fat
      ,NULL convenio
      ,NULL procedimento
      ,NULL vl_receita
      ,NULL vl_matmed
      ,SUM(To_number (Decode (mvto_estoque . tp_mvto_estoque, 'P', 1,'C', -1)) * itmvto_estoque . qt_movimentacao * uni_pro . vl_fator
       * verif_vl_custo_medio(produto . cd_produto,mvto_estoque . dt_mvto_estoque,'R',produto.vl_custo_medio,mvto_estoque . hr_mvto_estoque,2))vl_opme
      ,NULL vl_diaria
      ,NULL vl_honorario
      ,NULL vl_procedimento

FROM dbamv.atendime
INNER JOIN mvto_estoque ON atendime.cd_atendimento = mvto_estoque.cd_atendimento
INNER JOIN itmvto_estoque ON mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
INNER JOIN uni_pro ON itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
INNER JOIN produto ON itmvto_estoque.cd_produto = produto.cd_produto

 WHERE atendime.cd_multi_empresa = 2
 AND produto.cd_especie = 3
GROUP BY atendime.cd_atendimento
        ,atendime.dt_atendimento
        ,atendime.tp_atendimento
)
GROUP BY cd_atendimento
        ,dt_atendimento
        ,tp_atendimento
        ,vl_matmed
