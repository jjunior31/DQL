WITH pacote_sus AS (
SELECT DISTINCT atendime.cd_atendimento
      ,atendime.cd_paciente
      ,convenio.nm_convenio AS convenio
      ,procedimento_sus.cd_procedimento
      ,procedimento_sus.ds_procedimento AS procedimento
      ,prestador.cd_prestador
      ,prestador.nm_prestador AS medico
      ,CASE WHEN aviso_cirurgia.cd_aviso_cirurgia IS NULL THEN'CL' ELSE 'CC'END AS esp_pac
      ,(SELECT Sum(To_Number(m.dt_lib_mov - m.dt_mov_int))
          FROM mov_int m,leito, unid_int
          WHERE m.cd_atendimento = atendime.cd_atendimento
            AND m.cd_leito = leito.cd_leito
            AND leito.cd_unid_int = unid_int.cd_unid_int
            AND unid_int.cd_unid_int = 10) dia_uti
      ,(SELECT Sum(To_Number(m.dt_lib_mov - m.dt_mov_int))
          FROM mov_int m,leito, unid_int
          WHERE m.cd_atendimento = atendime.cd_atendimento
            AND m.cd_leito = leito.cd_leito
            AND leito.cd_unid_int = unid_int.cd_unid_int
            AND unid_int.cd_unid_int <> 10) dia_apto
      ,fa.qtd_diaria AS diaria
      ,aviso_cirurgia.cd_aviso_cirurgia
      ,nvl(Round(((aviso_cirurgia.dt_fim_limpeza - aviso_cirurgia.dt_realizacao)*86400/60),0),0) AS min_cir
      ,Nvl(fa.vl_diaria,0) AS vl_diaria
      ,Nvl(fa.vl_honorario,0) AS vl_honorario
      ,Nvl(fa.vl_matmed,0) AS vl_mat_med
      ,(SELECT SUM(To_number (Decode (mvto_estoque . tp_mvto_estoque, 'P', 1,'C', -1)) * itmvto_estoque . qt_movimentacao * uni_pro . vl_fator
           * verif_vl_custo_medio(produto . cd_produto,mvto_estoque . dt_mvto_estoque,'R',produto.vl_custo_medio,mvto_estoque . hr_mvto_estoque,2))vl_opme
        FROM dbamv.mvto_estoque,
        dbamv.itmvto_estoque,
        dbamv.produto,
        dbamv.uni_pro
        WHERE mvto_estoque.cd_atendimento = atendime.cd_atendimento
          AND mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
          AND itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
          AND itmvto_estoque.cd_produto = produto.cd_produto
          AND produto.cd_especie = 3)vl_opme
      ,Nvl(fa.vl_procedimento,0) AS vl_procedimento
      ,Nvl(fa.vl_receita,0) AS vl_receita
      ,Nvl(fa.vl_resultado,0) AS vl_resultado
      ,Nvl(fa.vl_rentabilidade,0) AS vl_rentabilidade

  FROM dbamv.atendime
  JOIN fa_custo_atendimento fa ON atendime.cd_atendimento = fa.cd_atendimento
  left JOIN aviso_cirurgia ON atendime.cd_atendimento = aviso_cirurgia.cd_atendimento
  JOIN procedimento_sus ON atendime.cd_procedimento = procedimento_sus.cd_procedimento
  JOIN prestador ON atendime.cd_prestador = prestador.cd_prestador
  JOIN convenio on atendime.cd_convenio = convenio.cd_convenio

WHERE atendime.dt_atendimento between :ini and To_Date(:fin) + 86399/86400
  AND atendime.cd_convenio in (1,2)

)

SELECT  cd_atendimento
       ,cd_paciente
       ,convenio
       ,cd_procedimento
       ,procedimento
       ,cd_prestador
       ,medico
       ,esp_pac
       ,dia_uti
       ,dia_apto
       ,diaria
       ,Count(cd_aviso_cirurgia) qtd_cirurgia
       ,Sum(min_cir)min_cir
       ,vl_diaria
       ,vl_honorario
       ,(vl_mat_med - Nvl(vl_opme,0)) vl_mat_med
       ,Nvl(vl_opme,0) vl_opme
       ,vl_procedimento
       ,vl_receita
       ,vl_resultado
       ,vl_rentabilidade

  FROM pacote_sus


GROUP BY  cd_atendimento
       ,cd_paciente
       ,convenio
       ,cd_procedimento
       ,procedimento
       ,cd_prestador
       ,medico
       ,esp_pac
       ,dia_uti
       ,dia_apto
       ,diaria
       ,vl_diaria
       ,vl_honorario
       ,vl_mat_med
       ,vl_opme
       ,vl_procedimento
       ,vl_receita
       ,vl_resultado
       ,vl_rentabilidade

ORDER BY 1 ASC
