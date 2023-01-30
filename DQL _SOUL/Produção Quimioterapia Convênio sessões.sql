SELECT To_Char(vdic.data_agenda,'mm/yyyy') AS mes,
       vdic.cod_paciente AS prontuario,
       vdic.nm_paciente AS paciente,
       vdic.data_agenda AS data_atendimento,
       vdic.nm_convenio AS convenio,
       Nvl((SELECT prestador.nm_prestador
          FROM dbamv.prestador,
               dbamv.atendime
         WHERE prestador.cd_prestador = atendime.cd_prestador
           AND atendime.cd_atendimento = vdic.cod_atendimento),'Prestador Não Cadastrado')prestador,
       CASE WHEN vdic.cod_item_agendamento IN (1101,1102,1121) THEN 'Quimioteraipa Endovenosa'ELSE vdic.ds_item_agendamento END AS forma_aplicação,
       CASE WHEN vdic.cod_atendimento IS NULL THEN 'Ausente' ELSE 'Presente' END Absenteismo

FROM vdic_horarios_agenda_scma vdic

WHERE Trunc(vdic.data_agenda) BETWEEN '13/08/2021' AND To_Date('13/08/2021') +86399/86400
  AND vdic.cod_servico = 32
  AND vdic.cod_setor = 317

ORDER BY 1 ASC
