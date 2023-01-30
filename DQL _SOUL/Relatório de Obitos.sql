SELECT To_Char(atendime.dt_alta,'dd/mm/yyyy')dt_alta,
       atendime.cd_atendimento,
       fc_obter_iniciais(paciente.nm_paciente) nm_paciente,
       trunc((months_between(atendime.dt_alta, paciente.dt_nascimento))/12) idade,
       paciente.tp_sexo,
       To_Char(paciente.dt_nascimento,'dd/mm/yyyy')dt_nascimento,
       cid.cd_cid,
       cid.ds_cid descricao,
       Decode(aviso_cirurgia.cd_aviso_cirurgia,'null','S/A',aviso_cirurgia.cd_aviso_cirurgia)aviso_cirurgia,
       cirurgia.ds_cirurgia,
       convenio.nm_convenio,
       unid_int.ds_unid_int,
       prestador.nm_prestador,
       To_Char(atendime.dt_alta,'mm/yyyy') mes
  FROM atendime,
       paciente,
       convenio,
       unid_int,
       prestador,
       leito,
       mot_alt,
       cid,
       aviso_cirurgia,
       cirurgia,
       cirurgia_aviso
 WHERE atendime.cd_convenio = convenio.cd_convenio
   AND atendime.cd_paciente = paciente.cd_paciente
   AND atendime.cd_prestador = prestador.cd_prestador
   AND aviso_cirurgia.cd_atendimento = atendime.cd_atendimento
   AND cirurgia_aviso.cd_aviso_cirurgia = aviso_cirurgia.cd_aviso_cirurgia
   AND cirurgia_aviso.cd_cirurgia = cirurgia.cd_cirurgia
   AND atendime.cd_cid = cid.cd_cid
   AND atendime.cd_leito = leito.cd_leito
   AND leito.cd_unid_int = unid_int.cd_unid_int
   AND atendime.cd_mot_alt = mot_alt.cd_mot_alt
   AND atendime.cd_multi_empresa = 2
   AND mot_alt.cd_mot_alt = 47
   AND atendime.dt_alta BETWEEN '01/01/2019' AND '26/06/2019'
GROUP BY To_Char(atendime.dt_alta,'dd/mm/yyyy'),
       atendime.cd_atendimento,
       fc_obter_iniciais(paciente.nm_paciente) ,
       trunc((months_between(atendime.dt_alta, paciente.dt_nascimento))/12),
       To_Char(atendime.dt_alta,'mm/yyyy'),
       paciente.tp_sexo,
       To_Char(paciente.dt_nascimento,'dd/mm/yyyy'),
       cid.cd_cid,
       cid.ds_cid ,
       aviso_cirurgia.cd_aviso_cirurgia,
       cirurgia.ds_cirurgia,
       convenio.nm_convenio,
       unid_int.ds_unid_int,
       prestador.nm_prestador
ORDER BY 2,12


