SELECT * FROM (
SELECT 
-- DADOS DO PACIENTES
       ATENDIME.CD_PACIENTE AS "Número do Prontuário"
      ,ATENDIME.CD_ATENDIMENTO as "Número de Atendimento"
      ,TO_CHAR(PACIENTE.DT_NASCIMENTO, 'DD/MM/YYYY') as "Data de Nascimento"
      ,PACIENTE.TP_SEXO as "Sexo (F ou M ou I)"
      ,PACIENTE.NR_CEP as "CEP"
      ,PACIENTE.NM_BAIRRO as "Bairro"
      ,CIDADE.NM_CIDADE as "Município"
      ,CIDADE.CD_UF as "Estado"
--FONTE_PAGADORA
      ,CONVENIO.NR_REGISTRO_OPERADORA_ANS As "Código da Fonte Pagadora"
      , null as "Local de Atendimento"
--DADOS DO ATENDIMENTO
      ,ATENDIME.DT_ATENDIMENTO as "Data de Internação"
      ,ATENDIME.DT_ALTA as "Data da saída do Hospital"
      ,(select al.cd_cid from pw_registro_alta al
         where al.cd_atendimento = ATENDIME.cd_atendimento and rownum = 1) As "Diagnóstico principal"
      ,ATENDIME.CD_CID as "Diagnóstico secundário 1"
      ,ATENDIME.CD_CID as "Diagnóstico secundário 2"
--PROCEDIMENTO 1
      ,(select LISTAGG(cirurgia.CD_PRO_FAT, ' || ') WITHIN GROUP (ORDER BY cirurgia.cd_cirurgia) ds_cirurgia
          from aviso_cirurgia ac, cirurgia_aviso ca, atendime at, cirurgia
         where ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA 
           and at.cd_atendimento(+) = ac.CD_ATENDIMENTO
           and cirurgia.cd_cirurgia = ca.cd_cirurgia
           and at.cd_atendimento = atendime.cd_atendimento
           and sn_principal = 'S') as "Procedimento realizado 1"
      ,(select LISTAGG(to_char(ac.DT_REALIZACAO, 'dd/mm/yyyy'), ' || ') WITHIN GROUP (ORDER BY cirurgia.cd_cirurgia) ds_cirurgia
          from aviso_cirurgia ac, cirurgia_aviso ca, atendime at, cirurgia
         where ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
           and at.cd_atendimento(+) = ac.CD_ATENDIMENTO
           and cirurgia.cd_cirurgia = ca.cd_cirurgia
           and at.cd_atendimento = atendime.cd_atendimento
           and sn_principal = 'S') as "Data do Procedimento"
--PROCEDIMENTO 2
      ,(select LISTAGG(cirurgia.CD_PRO_FAT, ' || ') WITHIN GROUP (ORDER BY cirurgia.cd_cirurgia) ds_cirurgia
          from aviso_cirurgia ac, cirurgia_aviso ca, atendime at, cirurgia
         where ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
           and at.cd_atendimento(+) = ac.CD_ATENDIMENTO
           and cirurgia.cd_cirurgia = ca.cd_cirurgia
           and at.cd_atendimento = atendime.cd_atendimento
           and sn_principal <> 'S') as "Procedimento realizado 2"
      ,(select LISTAGG(to_char(ac.DT_REALIZACAO, 'dd/mm/yyyy'), ' || ') WITHIN GROUP (ORDER BY cirurgia.cd_cirurgia) ds_cirurgia
          from aviso_cirurgia ac, cirurgia_aviso ca, atendime at, cirurgia
         where ca.CD_AVISO_CIRURGIA = ac.CD_AVISO_CIRURGIA
           and at.cd_atendimento(+) = ac.CD_ATENDIMENTO
           and cirurgia.cd_cirurgia = ca.cd_cirurgia
           and at.cd_atendimento = atendime.cd_atendimento
           and sn_principal <> 'S') as "Data do procedimento"
      ,DECODE(MOT_ALT.TP_MOT_ALTA, 'A', 'ALTA', 'D', 'ALTA ADMINISTRATIVA', 'O', 'OBITO', 'T', 'TRANSFERENCIA', 'INDEFINIDO') as "Tipo de Alta"
--Admissão na Uti
      ,(select min(m.dt_mov_int) utia from mov_int m, leito l
         where l.CD_LEITO = m.cd_leito and l.cd_unid_int in (14, 12)
           and m.tp_mov in ('I', 'O')
           and nvl(m.sn_reserva, 'N') <> 'S'
           and sn_extra = 'N'
           and not exists (select cd_leito from mov_int
                            where cd_atendimento = m.cd_atendimento
                              and cd_leito = m.cd_leito_anterior
                              and cd_tip_acom = 28)
                              and m.cd_atendimento = atendime.cd_atendimento) as "Data da 1ª admissão na UTI"
      ,(select max(TO_CHAR(m.dt_lib_mov, 'DD/MM/YYYY')) utia
          from mov_int m, leito l
         where l.CD_LEITO = m.cd_leito and l.cd_unid_int in (14, 12)
          and m.tp_mov in ('I', 'O')
          and nvl(m.sn_reserva, 'N') <> 'S'
          and sn_extra = 'N'
          and m.cd_tip_acom IN (28, 24)
          and m.cd_atendimento = atendime.cd_atendimento) "ULTIMA ALTA UTI (dd/mm/yyyy)"
--Passagens na uti
      ,(SELECT count(cd_tip_acom) numero_pass_utia
          FROM mov_int m 
         where m.cd_atendimento = atendime.cd_atendimento
           and m.cd_tip_acom = 28
           and cd_leito_anterior is not null) "Nº de passagens na UTI"
-- Uso de ventilação mecanica
      ,case when (select sum(case CAST(DS_RESPOSTA AS VARCHAR2(2000)) when 'true' then 1 else 0 end) total
                    from VDIC_PW_RESPOSTA_DOCUMENTO 
                   where CD_DOCUMENTO in (421,422)
                     and cd_atendimento = atendime.cd_atendimento
                     and cd_campo_pai in (297900, 274641) ) > 0 then 'S' else 'N' end as "Uso de ventilação mecânica"
-- Total de ventilação mecanica
      ,(select sum(case CAST(DS_RESPOSTA AS VARCHAR2(2000)) when 'true' then 1 else 0 end)
          from VDIC_PW_RESPOSTA_DOCUMENTO
         where CD_DOCUMENTO in (421, 422)
           and cd_atendimento = atendime.cd_atendimento
           and cd_campo_pai in (297900, 274641)) as "Dias de ventilação mecânica"
      ,RECEM_NASCIDO.VL_PESO as "Peso do recém-nascido"
      ,NVL(LOC_PROCED.DS_LOC_PROCED, ORI_ATE.DS_ORI_ATE) as "origem do paciente"
      ,(select sum(vl_total_conta) from reg_fat rf where rf.cd_atendimento = atendime.cd_atendimento) as "Valor faturado"

FROM DBAMV.ATENDIME
    ,DBAMV.PACIENTE
    ,DBAMV.CID
    ,DBAMV.CONVENIO
    ,DBAMV.MOT_ALT
    ,DBAMV.ESPECIALID
    ,DBAMV.CIDADE
    ,DBAMV.PRESTADOR
    ,DBAMV.RECEM_NASCIDO
    ,DBAMV.LOC_PROCED
    ,DBAMV.ORI_ATE
WHERE TRUNC(ATENDIME.DT_ALTA) BETWEEN '01/01/2021' and '31/12/2021'
  AND DT_ALTA IS NOT NULL
  AND ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE
  AND ATENDIME.CD_CID = CID.CD_CID(+)
  AND ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO
  AND ATENDIME.CD_ESPECIALID = ESPECIALID.CD_ESPECIALID(+)
  AND ATENDIME.CD_MOT_ALT = MOT_ALT.CD_MOT_ALT(+)
  AND CIDADE.CD_CIDADE = PACIENTE.CD_CIDADE(+)
  AND PRESTADOR.CD_PRESTADOR = ATENDIME.CD_PRESTADOR
  AND RECEM_NASCIDO.CD_ATENDIMENTO(+) = ATENDIME.CD_ATENDIMENTO
  AND LOC_PROCED.CD_LOC_PROCED(+) = ATENDIME.CD_LOC_PROCED
  AND ORI_ATE.CD_ORI_ATE(+) = ATENDIME.CD_ORI_ATE
  and atendime.cd_mot_alt not in (48,46)
  AND ATENDIME.CD_MULTI_EMPRESA = 2
  AND ATENDIME.TP_ATENDIMENTO = 'I'
  AND PACIENTE.CD_PACIENTE <> 2 )
