SELECT atendime.cd_atendimento,
       ate.cd_atendimento,
       paciente.cd_paciente,
       paciente.nm_paciente,
       atendime.dt_atendimento,

       (SELECT Max(a.dt_alta_medica)
          FROM atendime a
         WHERE a.cd_atendimento < atendime.cd_atendimento
           AND a.cd_paciente = atendime.cd_paciente
           AND a.tp_Atendimento = 'I') ult_dt_alta,
       (SELECT Max(a.dt_atendimento)
          FROM atendime a
         WHERE a.cd_paciente = atendime.cd_paciente
           AND a.cd_atendimento < atendime.cd_atendimento
           AND a.tp_atendimento = 'I') ult_dt_atendimento,
        Round(atendime.dt_atendimento -(SELECT  Max(a.dt_alta_medica)
                                          FROM atendime a
                                         WHERE a.cd_atendimento < atendime.cd_atendimento
                                           AND a.cd_paciente = atendime.cd_paciente
                                           AND a.tp_Atendimento = 'I'),0) dias_reinter,
       Floor(Months_Between(SYSDATE ,paciente.dt_nascimento)/12) dt_nascimento,
       CASE
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <1 THEN '28 dias a 11 meses'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=1
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=4 THEN '1 a 4 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=5
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=9 THEN '5 a 9 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=10
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=14 THEN '10 a 14 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=15
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=19 THEN '15 a 19 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=20
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=29 THEN '20 a 29 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=30
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=39 THEN '30 a 39 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=40
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=49 THEN '40 a 49 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >50
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=64 THEN '50 a 64 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=65
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=80 THEN '65 a 80 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >80 THEN 'Acima de 80 Anos'
       END FAXIA_ETARIA,
       convenio.nm_convenio,
       cid.cd_cid cid,
       cid.ds_cid cid ,
       c.cd_cid ult_cid,
       c.ds_cid utl_cid,
       CASE
       WHEN atendime.cd_cid >= 'A00' AND atendime.cd_cid <= 'A99'THEN 'DOENÇAS INFECCIOSAS'
       WHEN atendime.cd_cid >= 'B00' AND atendime.cd_cid <= 'B99'THEN 'DOENÇAS INFECCIOSAS'
       WHEN atendime.cd_cid >= 'C00' AND atendime.cd_cid <= 'D48'THEN 'NEOPLASIAS'
       WHEN atendime.cd_cid >= 'D49' AND atendime.cd_cid <= 'D99'THEN 'SANGUE'
       WHEN atendime.cd_cid >= 'E00' AND atendime.cd_cid <= 'E99'THEN 'ENDOCRINO'
       WHEN atendime.cd_cid >= 'F00' AND atendime.cd_cid <= 'F99'THEN 'MENTAL'
       WHEN atendime.cd_cid >= 'G00' AND atendime.cd_cid <= 'G99'THEN 'SISTEMA NERVOSO'
       WHEN atendime.cd_cid >= 'H00' AND atendime.cd_cid <= 'H59'THEN 'OLHOS'
       WHEN atendime.cd_cid >= 'H60' AND atendime.cd_cid <= 'H99'THEN 'OUVIDOS'
       WHEN atendime.cd_cid >= 'I00' AND atendime.cd_cid <= 'I99'THEN 'CIRCULATORIO'
       WHEN atendime.cd_cid >= 'J00' AND atendime.cd_cid <= 'J99'THEN 'RESPIRATORIO'
       WHEN atendime.cd_cid >= 'K00' AND atendime.cd_cid <= 'K99'THEN 'DIGESTIVO'
       WHEN atendime.cd_cid >= 'L00' AND atendime.cd_cid <= 'L99'THEN 'PELE'
       WHEN atendime.cd_cid >= 'M00' AND atendime.cd_cid <= 'M99'THEN 'OSTEOMUSCULAR'
       WHEN atendime.cd_cid >= 'N00' AND atendime.cd_cid <= 'N99'THEN 'GENITURINARIO'
       WHEN atendime.cd_cid >= 'O00' AND atendime.cd_cid <= 'O99'THEN 'GRAVIDEZ'
       WHEN atendime.cd_cid >= 'P00' AND atendime.cd_cid <= 'P99'THEN 'PERINATAL'
       WHEN atendime.cd_cid >= 'Q00' AND atendime.cd_cid <= 'Q99'THEN 'CONGENITAS'
       WHEN atendime.cd_cid >= 'R00' AND atendime.cd_cid <= 'R99'THEN 'SINTOMAS'
       WHEN atendime.cd_cid >= 'S00' AND atendime.cd_cid <= 'T99'THEN 'LESOES'
       WHEN atendime.cd_cid >= 'V00' AND atendime.cd_cid <= 'Y99'THEN 'MORBIDADE'
       WHEN atendime.cd_cid >= 'Z00' AND atendime.cd_cid <= 'Z99'THEN 'INFLUENCIAM O ESTADO DE SAUDE'
       WHEN atendime.cd_cid >= 'U00' AND atendime.cd_cid <= 'U99'THEN 'PROPOSITOS ESPECIAIS'
       END GRUP_CID_atual,
       prestador.nm_prestador

  FROM dbamv.atendime ate,
       dbamv.prestador,
       dbamv.atendime,
       dbamv.convenio,
       dbamv.paciente,
       dbamv.cid c,
       dbamv.cid,
      (SELECT To_Date('01/01/2010','dd/mm/yyyy') - 1 + ROWNUM data FROM cid) conta

 WHERE Trunc(atendime.dt_atendimento) = conta.data
   AND paciente.cd_paciente(+) = atendime.cd_paciente
   AND atendime.cd_paciente = ate.cd_paciente(+)
   AND ate.cd_atendimento < atendime.cd_atendimento
   AND ate.dt_atendimento < atendime.dt_alta
   AND atendime.cd_convenio = convenio.cd_convenio(+)
   AND atendime.cd_prestador = prestador.cd_prestador(+)
   AND atendime.cd_cid = cid.cd_cid
   AND ate.cd_cid = c.cd_cid
   AND atendime.tp_atendimento = 'I'
   AND paciente.cd_paciente IN (533795,514537,388161,523747,2707764,530026,523747)
   AND To_Number(To_Date(atendime.dt_atendimento) - To_Date(ate.dt_atendimento)) <=30
   AND ate.tp_atendimento = 'I'
   AND conta.data BETWEEN '01/10/2020' AND '25/10/2020'
   AND atendime.cd_multi_empresa = 2 AND ate.cd_multi_empresa = 2
   AND atendime.dt_atendimento - (SELECT Max(a.dt_alta_medica)
                                    FROM atendime a
                                    WHERE a.cd_atendimento < atendime.cd_atendimento
                                    and a.cd_paciente = atendime.cd_paciente
                                    AND a.cd_mot_alt NOT IN (46,48,6)
                                    AND a.tp_Atendimento = 'I') < 30

