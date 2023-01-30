select atendime.cd_atendimento
      ,To_Char(mvto_estoque.dt_mvto_estoque,'dd.mm.yyyy') dt_movimentacao
      ,paciente.nm_paciente
      ,convenio.nm_convenio
      ,unid_int.ds_unid_int
      ,produto.cd_produto
      ,produto.ds_produto
      ,(sum(decode(tp_mvto_estoque, 'P', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto))-(sum(decode(tp_mvto_estoque, 'C', 1, 0) * itmvto_estoque.qt_movimentacao * uni_pro.vl_fator) / verif_vl_fator_prod(itmvto_estoque.cd_produto)) Total

  from dbamv.itmvto_estoque
      ,dbamv.mvto_estoque
      ,dbamv.atendime
      ,dbamv.paciente
      ,dbamv.produto
      ,dbamv.convenio
      ,dbamv.unid_int
      ,dbamv.uni_pro
      ,dbamv.leito

 where --mvto_estoque.dt_mvto_estoque = to_date(sysdate) - 2
   itmvto_estoque.cd_mvto_estoque = mvto_estoque.cd_mvto_estoque
   and itmvto_estoque.cd_produto = produto.cd_produto
   and mvto_estoque.cd_atendimento = atendime.cd_atendimento
   and atendime.cd_paciente = paciente.cd_paciente
   and atendime.cd_convenio = convenio.cd_convenio
   and itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
   and atendime.cd_leito = leito.cd_leito
   and unid_int.cd_unid_int = leito.cd_unid_int
   --and produto.cd_produto in (18746,18494,18495,18496,18947)
   AND produto.cd_pro_fat IN (07000993,07006640,07005084,07016338,08018495,08018496,08018497,08018494
                              ,08006272,08014763,08012048,08010741,08002568,08014083,08011744,08006338
                              ,080011743,08002441,08002443,0801264,08010502,08003807,08008370,08802621
                              ,08009959,08002544,08012803,08005876,08002681,08013468,08008212,08002626
                              ,08017980,08014736,08002683,080015721,08006097,08002795,08002845,08017668
                              ,08015603,08017669,08015348,08017682,07007247,08015137,080012107,08002727
                              ,08010743,07001141,08004976,070003531,07005098,07014963,07000547,07013168
                              ,07001322,07005112,37018851,37018420,07001350,08009837,08006289,08002872
                              ,08006308,08002892,08013113,08013112,37018851,37018420,07001350,08009837
                              ,08006289,08002872,08006308,08002892,08013113,080013112,07001427,08002935
                              ,07000570,07001166,08003353,07001491,07000917)


group by To_Char(mvto_estoque.dt_mvto_estoque,'dd.mm.yyyy')
        ,itmvto_estoque.cd_produto
        ,atendime.cd_atendimento
        ,paciente.nm_paciente
        ,convenio.nm_convenio
        ,unid_int.ds_unid_int
        ,produto.cd_produto
        ,produto.ds_produto