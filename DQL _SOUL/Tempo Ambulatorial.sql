SELECT atendime.cd_atendimento atendimento,
       To_Char(atendime.dt_atendimento,'dd/mm/yyyy')Data_atendimento,
       To_Char(atendime.dt_chegada_paciente,'hh24:mi')Hora_chegada,
       To_Char(atendime.hr_atendimento,'hh24:mi')Hora_atendimento,
       fnc_hsv_calc_horas(Sum (((atendime.hr_atendimento)- atendime.dt_chegada_paciente)*86400)) Tempo_Recepção,
       atendime.nr_chamada_painel senha,
       To_Char(pre_med.hr_pre_med,'hh24:mi')Atendimento_medico,
       To_Char(atendime.hr_alta,'hh24:mi')Hora_alta,
       fnc_hsv_calc_horas(Sum (((atendime.hr_alta)- pre_med.hr_pre_med)*86400)) Tempo_Medico,
       fnc_hsv_calc_horas(Sum (((atendime.hr_alta)- atendime.dt_chegada_paciente)*86400))AS "Tempo Permancia",
       prestador.nm_prestador
  FROM atendime,
       prestador,
       pre_med
 WHERE atendime.cd_prestador = prestador.cd_prestador
   AND pre_med.cd_atendimento = atendime.cd_atendimento
   AND pre_med.cd_prestador = prestador.cd_prestador(+)
   AND atendime.cd_ori_ate = 32
   AND atendime.dt_atendimento = pre_med.dt_pre_med
   --AND atendime.tp_atendimento = 'A'
   AND atendime.dt_atendimento BETWEEN '01/01/2019' AND '31/01/2019'
GROUP BY atendime.cd_atendimento,
         atendime.cd_paciente,
         atendime.dt_atendimento,
         atendime.dt_chegada_paciente,
         atendime.hr_atendimento,
         atendime.nr_chamada_painel,
         pre_med.hr_pre_med,
         prestador.nm_prestador,
         atendime.hr_alta
ORDER BY atendime.dt_atendimento