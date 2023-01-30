select
  --monta o ABC
	t2.*,

	case
		when sum(PERC_GERAL) OVER(ORDER BY PERC_GERAL DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) < 80 then 'A'
		when sum(PERC_GERAL) OVER(ORDER BY PERC_GERAL DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) > 95 then 'C'
		else 'B'
	end curva_abc,
	--  consumo medio por dia
	qt_consumo / (last_day(to_date(:anomes_fin,'yyyymm')) - to_date(:anomes_ini,'yyyymm') + 1) qt_consumo_dia ,

    sum(PERC_GERAL) OVER(ORDER BY PERC_GERAL DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) ACUMULADO_PERC
from
	(
	select
		-- Cria o valor acumulado geral e valor total geral
		t.*,
		Sum(vl_custo_periodo ) OVER(ORDER BY vl_custo_periodo DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) ACUMULADO_GERAL,
		Sum(vl_custo_periodo ) OVER(partition by 'total' ) TOTAL_GERAL ,
    vl_custo_periodo / Sum(vl_custo_periodo ) OVER(partition by 'total' ) * 100 PERC_GERAL
	from
		(
		Select
			-- ordenar por vl_custo_periodo e considerando somente os produtos com qt_consumo
			consumo.cd_especie,
			consumo.ds_especie,
			cd_produto cd_produto,
			ds_produto ds_produto,
			Dbamv.Verif_Ds_Unid_Prod(Cd_Produto) ds_unidade,
			Sum(consumo.qt_consumo) qt_consumo,
			Sum(consumo.vl_custo_periodo ) vl_custo_periodo
		From
			(
			Select
				-- referência o relatório de ABC de consumo (MGES > Relatório > Administrativos > ABC de Consumo (parametros: estoque e período)
				Especie.cd_especie,
				Especie.ds_especie,
				C_Conest.Cd_Produto,
				produto.ds_produto,
				Trunc((Sum(Nvl(C_Conest.Qt_Saida_Setor,0)+Nvl(C_Conest.Qt_Saida_Paciente,0)+Nvl(Decode(:P_Estoque,null,0,(Decode(Estoque.Tp_Estoque,'D',Nvl(C_Conest.Qt_Transferencia_Saida,0),0))),0))-Sum(Nvl(C_Conest.Qt_Devolucao_Setor,0)+Nvl(C_Conest.Qt_Devolucao_Paciente,0)+Nvl(Decode(:P_Estoque,null,0,(Decode(Estoque.Tp_Estoque,'D',Nvl(C_Conest.Qt_Entrada_Transferido,0),0))),0)))/Verif_Vl_Fator_Prod(C_Conest.Cd_Produto),4) Qt_Consumo,
				Trunc((Sum(Nvl(C_Conest.Vl_Saida_Setor,0)+Nvl(C_Conest.Vl_Saida_Paciente,0)+Nvl(Decode(:P_Estoque,null,0,(Decode(Estoque.Tp_Estoque,'D',Nvl(C_Conest.Vl_Transferencia_Saida,0),0))),0))-Sum(Nvl(C_Conest.Vl_Devolucao_Setor,0)+Nvl(C_Conest.Vl_Devolucao_Paciente,0)+Nvl(Decode(:P_Estoque,null,0,(Decode(Estoque.Tp_Estoque,'D',Nvl(C_Conest.Vl_Entrada_Transferido,0),0))),0))),4) Vl_Custo_Periodo
			From
				Dbamv.C_Conest,
				Dbamv.Produto,
				Dbamv.Estoque,
				Dbamv.Especie
			Where
				Estoque.Cd_Estoque = C_Conest.Cd_Estoque
				And C_Conest.Cd_Produto = Produto.Cd_Produto
				And Produto.Cd_Especie = Especie.Cd_Especie
				And Estoque.Cd_Multi_Empresa = 2 --:P_Cd_Multi_Empresa
				And Produto.Tp_Ativo = 'S'
        AND ('1' IS NULL OR C_Conest.cd_estoque IN
                  (SELECT  REGEXP_SUBSTR('1','[^,]+', 1, LEVEL)
                  FROM DUAL
                  CONNECT BY  REGEXP_SUBSTR('1', '[^,]+', 1, LEVEL) IS NOT NULL)
              )
        AND ('1' IS NULL OR ESPECIE.CD_ESPECIE IN
                  (SELECT  REGEXP_SUBSTR('1','[^,]+', 1, LEVEL)
                  FROM DUAL
                  CONNECT BY  REGEXP_SUBSTR('1', '[^,]+', 1, LEVEL) IS NOT NULL)
              )
				And C_Conest.Cd_Ano||LPAD(C_Conest.Cd_Mes, 2,'0') between '01/06/2022' and '30/06/2022'
				and ('S' is null or 'S' = produto.sn_padronizado)
			Group By
				Especie.cd_especie,
				Especie.ds_especie,
				C_Conest.Cd_Produto,
				produto.ds_produto
			) consumo
		Where
			consumo.qt_consumo > 0
		GROUP BY
			consumo.cd_especie,
			consumo.ds_especie,
			cd_produto,
			ds_produto,
			Dbamv.Verif_Ds_Unid_Prod(Cd_Produto)
		) t
	) t2
