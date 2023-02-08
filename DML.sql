--*Delete*--
DELETE FROM usu_origem WHERE cd_ori_ate = 45

--*Insert*--
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);


INSERT INTO cod_Pro (
  cd_pro_fat,
  cd_convenio,
  ds_codigo_cobranca,
  ds_nome_cobranca,
  ds_unidade_cobranca,
  tp_atendimento,
  cd_multi_empresa,
  cd_cod_pro)
SELECT
  cd_amb_92,
  8,
  cd_cbhpm_5,
  descricao_tuss,
  NULL,
  'T',
  2,
  seq_cod_pro.NEXTVAL
FROM
  de_para_tuss_cbhpm
WHERE
 CD_CBHPM_5 IS NOT null
 
 
NSERT INTO excecao_pedido_exame (cd_excecao_pedido_exame,cd_exa_rx,cd_exa_lab,tp_atendimento,cd_convenio,cd_setor)                                       
SELECT seq_excecao_pedido_exame.NEXTVAL,cd_exa_rx,NULL,'I',null,NULL
FROM exa_rx 
WHERE sn_ativo = 'S' AND cd_exa_rx NOT IN

--*Update*--
SELECT * FROM mov_int WHERE cd_atendimento =

UPDATE mov_int SET hr_MOV_INT = To_Date ('25/10/2020 23:50:16', 'dd/mm/yyyy hh24:mi:ss')  WHERE cd_atendimento =  AND cd_mov_int =

UPDATE mov_int SET DT_MOV_INT = To_Date ('25/10/2020','dd/mm/yyyy')  WHERE cd_atendimento =   AND cd_mov_int =

UPDATE mov_int SET hr_lib_mov = To_Date ('25/10/2020 23:55:16', 'dd/mm/yyyy hh24:mi:ss')  WHERE cd_atendimento =  AND cd_mov_int =

UPDATE mov_int SET DT_lib_mov = To_Date ('25/10/2020','dd/mm/yyyy')  WHERE cd_atendimento =  AND cd_mov_int =
