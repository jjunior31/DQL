SELECT atendime.cd_atendimento AS atendimento
      ,paciente.cd_paciente prontuario
      ,paciente.nm_paciente paciente
      ,Floor(Months_Between(SYSDATE,paciente.dt_nascimento)/12) AS idade
      ,CASE
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
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=50
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=64 THEN '50 a 64 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >=65
       AND  Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) <=80 THEN '65 a 80 Anos'
       WHEN Floor(Months_Between(sysdate, paciente.dt_nascimento)/12) >80 THEN 'Acima de 80 Anos'
       END faixa_etaria
      ,Decode(paciente.tp_sexo,'F','Feminino','M','Masculino') sexo
      ,nvl(religiao.ds_religiao,'SEM DECLARACAO') religiao
      ,To_Char(atendime.dt_atendimento,'dd.mm.yyyy') dt_atendimento
      ,convenio.nm_convenio convenio
      ,CASE WHEN convenio.cd_convenio = 1 THEN 'SUS' ELSE 'Conv/Particular' END Classificacao
      ,Nvl((SELECT 'Oncologico'
              FROM atendime d
             WHERE d.cd_atendimento = atendime.cd_atendimento
               AND EXISTS (SELECT a.cd_atendimento
                             FROM atendime a
                            WHERE a.cd_atendimento = d.cd_atendimento
                              AND (a.cd_cid LIKE 'C%' OR a.cd_cid LIKE 'D%'))),'Não Oncologico') tipo_paciente
      ,NVL((Select max('Cirurgico')  FROM aviso_cirurgia WHERE aviso_cirurgia.cd_atendimento = atendime.cd_atendimento),'Clinico') Esp_inter
      ,atendime.cd_cid
      ,cid.ds_cid
      ,CASE
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
       END grupo_cid
      ,prestador.nm_prestador
      ,especialid.ds_especialid
      ,To_Date(atendime.dt_alta) dt_alta
      ,unid_int.ds_unid_int
      ,((To_Date(atendime.dt_alta)) - To_Date(atendime.dt_atendimento)) dias_inter
      ,Nvl((SELECT Max(a.cd_atendimento) FROM dbamv.atendime a WHERE a.cd_paciente  = atendime.cd_paciente AND a.tp_atendimento = 'A'),NULL) reapro
      ,Nvl((SELECT Max(a.cd_atendimento) FROM dbamv.atendime a WHERE a.cd_paciente = atendime.cd_paciente  AND a.cd_atendimento <> atendime.cd_atendimento AND a.tp_atendimento = 'I' AND (a.dt_atendimento - atendime.dt_atendimento)<=30),NULL) Reinter
      ,Nvl((SELECT 'Sim'
              FROM dbamv.pw_documento_clinico
                  ,dbamv.editor_registro_campo
                  ,dbamv.pw_editor_clinico
                  ,dbamv.editor_campo
             WHERE pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico
               AND editor_registro_campo.cd_registro = pw_editor_clinico.cd_editor_registro
               AND editor_campo.cd_campo = editor_registro_campo.cd_campo
               AND atendime.cd_atendimento = pw_documento_clinico.cd_atendimento
               AND Dbms_Lob.SubStr(editor_registro_campo.lo_valor,4000,1) IS NOT NULL
               AND pw_documento_clinico.cd_atendimento IS NOT NULL
               AND (editor_campo.ds_identificador = 'nm_eupneico_2'
                OR editor_campo.ds_identificador = 'nm_eupneico_3'
                OR editor_campo.ds_identificador = 'nm_osteo_3'
                OR editor_campo.ds_identificador = 'nm_osteo_4')
               AND pw_editor_clinico.cd_documento = 158
              GROUP BY 1 ),'Não')fisio

  FROM dbamv.especialid
      ,dbamv.prestador
      ,dbamv.unid_int
      ,dbamv.atendime
      ,dbamv.paciente
      ,dbamv.convenio
      ,dbamv.religiao
      ,dbamv.esp_med
      ,dbamv.leito
      ,dbamv.cid

 WHERE paciente.cd_paciente = atendime.cd_paciente
   AND convenio.cd_convenio = atendime.cd_convenio
   AND leito.cd_leito = atendime.cd_leito
   AND unid_int.cd_unid_int = leito.cd_unid_int
   AND religiao.cd_religiao(+) = paciente.cd_religiao
   AND prestador.cd_prestador = atendime.cd_prestador
   AND esp_med.cd_prestador = atendime.cd_prestador
   AND especialid.cd_especialid = esp_med.cd_especialid
   AND cid.cd_cid = atendime.cd_cid
   AND atendime.dt_alta BETWEEN '01/05/2021' AND '31/05/2021'
   AND atendime.cd_mot_alt NOT IN (46,47,48)
   AND esp_med.sn_especial_principal = 'S'
   AND atendime.cd_multi_empresa = 2
   AND atendime.tp_atendimento = 'I'

ORDER BY To_Date(atendime.dt_alta) ASC