SELECT atendime.cd_atendimento,
       paciente.cd_paciente,
       paciente.nm_paciente,
       To_Char(atendime.dt_atendimento,'dd/mm/yyyy') dt_atendimento,
       To_Char(paciente.dt_cadastro,'dd/mm/yyyy') dt_cadastro,
       paciente.nr_ddd_fone,
       paciente.nr_fone,
       paciente.nr_ddd_celular,
       paciente.nr_celular,
       paciente.email,
       ori_ate.ds_ori_ate,
       atendime.tp_atendimento,
       convenio.nm_convenio,
       prestador.nm_mnemonico
  FROM dbamv.prestador,
       dbamv.atendime,
       dbamv.paciente,
       dbamv.convenio,
       dbamv.ori_ate,
       (SELECT (To_Date('01/01/2010', 'dd/mm/yyyy') -1) + ROWNUM  data FROM cid) contador
 WHERE Trunc(atendime.dt_atendimento) = contador.data
   AND atendime.cd_prestador = prestador.cd_prestador
   AND atendime.cd_paciente = paciente.cd_paciente
   AND atendime.cd_convenio = convenio.cd_convenio
   AND atendime.cd_ori_ate = ori_ate.cd_ori_ate
   AND contador.data  = paciente.dt_cadastro
   AND atendime.tp_atendimento IN ('A','U')
   AND ori_ate.cd_ori_ate = 32
   AND contador.data BETWEEN '01/02/2020' AND '31/10/2020'


