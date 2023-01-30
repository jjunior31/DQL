SELECT UNIQUE atendime.cd_atendimento,
       paciente.cd_paciente,
       paciente.nm_paciente,
       To_Char(atendime.dt_atendimento,'dd/mm/yyyy') dt_atendimento,
       To_Char(paciente.dt_cadastro,'dd/mm/yyyy') dt_cadastro,
       To_Char(atendime.dt_atendimento,'mm/yyy') mes,
       Decode(mov_int.tp_mov,'I','Intenarcao','O','Transferencia') tp_entrada,
       paciente.nr_ddd_fone,
       paciente.nr_fone,
       paciente.nr_ddd_celular,
       paciente.nr_celular,
       paciente.email,
       atendime.tp_atendimento,
       convenio.nm_convenio,
       prestador.nm_mnemonico

FROM dbamv.prestador,
     dbamv.unid_int,
     dbamv.atendime,
     dbamv.paciente,
     dbamv.convenio,
     dbamv.mov_int,
     dbamv.leito,
     (SELECT (To_Date('01/01/2010','dd/mm/yyyy')-1)+ ROWNUM data FROM cid) contador

WHERE Trunc(atendime.dt_atendimento) = contador.data
  AND mov_int.cd_atendimento(+) = atendime.cd_atendimento
  AND paciente.dt_cadastro = atendime.dt_atendimento
  AND mov_int.cd_leito = leito.cd_leito(+)
  AND atendime.cd_paciente = paciente.cd_paciente
  AND atendime.cd_convenio = convenio.cd_convenio
  AND atendime.cd_leito = leito.cd_leito
  AND atendime.cd_prestador = prestador.cd_prestador
  AND leito.cd_unid_int = unid_int.cd_unid_int
  AND contador.data = paciente.dt_cadastro
  AND atendime.tp_atendimento = 'I'
  AND contador.data BETWEEN '01/01/2020' AND '31/10/2020'
  AND unid_int.cd_unid_int = 10


ORDER BY 1 ASC
