SELECT atendime.cd_atendimento AS "Atendimento",
       paciente.nm_paciente AS "Nome Paciente",
       To_Char(atendime.dt_atendimento,'dd/mm/yyyy')AS "Data Atendimento",
       FC_IDADE_PAC('A',paciente.dt_nascimentO)AS "IDADE",
       CID.DS_CID AS "CID",
       PRESTADOR.NM_PRESTADOR AS "MÉDICO",
       (SELECT PACIENTE.CD_PACIENTE
          FROM PACIENTE,
               ATENDIME
         WHERE PACIENTE.CD_PACIENTE = ATENDIME.CD_PACIENTE
           AND ATENDIME
  FROM ATENDIME,
       PACIENTE,
       PRESTADOR,
       CID
 WHERE PACIENTE.CD_PACIENTE = ATENDIME.CD_PACIENTE
   AND PRESTADOR.CD_PRESTADOR = ATENDIME.CD_PRESTADOR
   AND CID.CD_CID = ATENDIME.CD_CID
   AND ATENDIME.TP_ATENDIMENTO = 'A'
   AND CID.CD_CID LIKE 'C61%'
   AND ATENDIME.CD_CONVENIO = 2
   AND Trunc (ATENDIME.DT_ATENDIMENTO,'YYYY') BETWEEN '01/04/2010' AND '30/11/2019'
ORDER BY 1 ASC

