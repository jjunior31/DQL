--------------------------------------------------------------
-- CHAMADO....: N/A
-- Assunto....: Atendimetos de Pacientes da linha de Cuidados
-- Banco......: Oracle
-- > Versão..: 12.1.0.2.0
-- ->Instancia: prod
-- Analista...: Jhonatan.Silva
-- Data.......: 09/02/2021
-- Finalidade.: Identificar os pacientes que pertencem a linha de cuidados
-- Versão.....: 1.0
--------------------------------------------------------------

--------------------------------------------------------------
-- Filtros
--------------------------------------------------------------
-- Periodo
-- Especialidade
-- Tipo de Atendimento
-- Convênio
-- Exceção de Origem
--------------------------------------------------------------

--------------------------------------------------------------
-- LOG DE ALTERAÇÕES
--------------------------------------------------------------
-- 1.0 - Versão Inicial

--------------------------------------------------------------
SELECT paciente.cd_paciente,
       paciente.nm_paciente,
       atendime.hr_atendimento,
       atendime.cd_atendimento,
       especialid.cd_especialid,
       especialid.ds_especialid,
       prestador.nm_prestador,
       'Paciente do Serviço' ds_motivo
  FROM dbamv.especialid,
       dbamv.prestador,
       dbamv.atendime,
       dbamv.paciente,
       (SELECT(To_Date('01/01/2010','dd/mm/yyyy') -1)+ ROWNUM data FROM cid ) contador
 WHERE Trunc(atendime.dt_atendimento) = contador.data
   AND atendime.cd_prestador = prestador.cd_prestador
   AND atendime.cd_especialid = especialid.cd_especialid
   AND atendime.cd_paciente = paciente.cd_paciente(+)
   AND atendime.tp_atendimento = 'A'
   AND atendime.cd_convenio = 2
   AND atendime.cd_ori_ate <> 6
   AND especialid.cd_especialid = 27
   AND atendime.cd_atendimento NOT IN (SELECT Min(a.cd_atendimento)FROM atendime a WHERE a.cd_paciente = paciente.cd_paciente)
   AND contador.data BETWEEN '01/01/2020' AND '30/12/2020'

  -- AND paciente.cd_paciente = 3650

GROUP BY paciente.cd_paciente,
         paciente.nm_paciente,
         atendime.hr_atendimento,
         atendime.cd_atendimento,
         especialid.cd_especialid,
         especialid.ds_especialid,
         prestador.nm_prestador

ORDER BY 1 ASC

