select pw_documento_clinico.cd_atendimento as "Atendimento"
      ,paciente.nm_paciente
      ,adm_medica.dh_criacao as "Dt_Abertura_pro"
      ,ava_enf.adm_enf       as "Dt_Admissao_Enf"
      ,ava_enf.dt_ecg        as "Dt_ecg_1"
      ,ava_enf.hr_ecg        as "Hr_ecg_1" 
      ,ava_enf.dt_ecg_1      as "Dt_ecg_2"
      ,ava_enf.hr_ecg_1      as "Hr_ecg_2"
      ,ava_enf.dt_ecg_2      as "Dt_ecg_3"
      ,ava_enf.hr_ecg_2      as "Hr_ecg_3" 
      ,ava_hemo.adm_enf      as "Dt_adm_Hemo"
      ,ava_hemo.por          as "Por"
      ,ava_hemo.rec          as "Recanalizacao"
      ,desfecho.desfecho     as "Desfecho"
       
  from editor_registro_campo
      ,pw_documento_clinico
      ,pw_editor_clinico
      ,editor_campo
      ,paciente
      ,(select pw_documento_clinico.cd_atendimento/*Sub-Select responsável por dados da admissão medico*/
              ,pw_documento_clinico.dh_criacao
         from editor_registro_campo
             ,pw_documento_clinico
             ,pw_editor_clinico
             ,editor_campo
       where editor_registro_campo.cd_campo = editor_campo.cd_campo
         and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
         and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
         and Dbms_Lob.SubStr(editor_registro_campo.lo_valor,4000,1) = 'true'
         and pw_editor_clinico.cd_documento = 155         
         and editor_campo.ds_campo like 'Rota%'
        group by pw_documento_clinico.cd_atendimento
                ,pw_documento_clinico.dh_criacao)adm_medica
      ,(select pw_documento_clinico.cd_atendimento /* Sub-Select responsável por dados da Avaliação da Enfermagem.*/
              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)adm_enf
              ,ava.dt_ecg 
              ,ava.hr_ecg  
              ,ava.dt_ecg_1 
              ,ava.hr_ecg_1 
              ,ava.dt_ecg_2 
              ,ava.hr_ecg_2        
          from editor_registro_campo
              ,pw_documento_clinico
              ,pw_editor_clinico
              ,editor_campo
              ,(select pw_documento_clinico.cd_atendimento/* Sub-Select responsável por dados da data do 1º ECG*/
                      ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)dt_ecg
                      ,ava1.hr_ecg
                      ,ava2.dt_ecg_1
                      ,ava2.hr_ecg_1
                      ,ava4.dt_ecg_2
                      ,ava4.hr_ecg_2
                  from editor_registro_campo
                      ,pw_documento_clinico
                      ,pw_editor_clinico
                      ,editor_campo
                      ,(select pw_documento_clinico.cd_atendimento /* Sub-Select responsável por dados da Hora do 1º ECG */
                              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)hr_ecg
                          from editor_registro_campo
                              ,pw_documento_clinico
                              ,pw_editor_clinico
                              ,editor_campo
                         where editor_registro_campo.cd_campo = editor_campo.cd_campo
                           and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                           and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                           and editor_campo.ds_identificador = 'NM_HORA2_9'
                           and pw_editor_clinico.cd_documento = 156)ava1
                       ,(select pw_documento_clinico.cd_atendimento /* Sub-Select responsável por dados da data do 2º ECG */
                              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)dt_ecg_1
                              ,ava3.hr_ecg_1
                          from editor_registro_campo
                              ,pw_documento_clinico
                              ,pw_editor_clinico
                              ,editor_campo
                              ,(select pw_documento_clinico.cd_atendimento/* Sub-Select responsável por dados da Hora do 2º ECG */
                                     ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)hr_ecg_1
                                 from editor_registro_campo
                                     ,pw_documento_clinico
                                     ,pw_editor_clinico
                                     ,editor_campo
                                where editor_registro_campo.cd_campo = editor_campo.cd_campo
                                  and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                                  and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                                  and editor_campo.ds_identificador = 'NM_HORA2_10'
                                  and pw_editor_clinico.cd_documento = 156)ava3
                         where editor_registro_campo.cd_campo = editor_campo.cd_campo
                           and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                           and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                           and pw_documento_clinico.cd_atendimento = ava3.cd_atendimento
                           and editor_campo.ds_identificador = 'Metadado_P_20680_8'
                           and pw_editor_clinico.cd_documento = 156)ava2
                       ,(select pw_documento_clinico.cd_atendimento /* Sub-Select responsável por dados da data do 3º ECG */
                               ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)dt_ecg_2
                               ,ava5.hr_ecg_2
                           from editor_registro_campo
                                ,pw_documento_clinico
                                ,pw_editor_clinico
                                ,editor_campo
                                ,(select pw_documento_clinico.cd_atendimento/* Sub-Select responsável por dados da Hora do 3º ECG */
                                        ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)hr_ecg_2
                                    from editor_registro_campo
                                        ,pw_documento_clinico
                                        ,pw_editor_clinico
                                        ,editor_campo
                                   where editor_registro_campo.cd_campo = editor_campo.cd_campo
                                     and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                                     and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                                     and editor_campo.ds_identificador = 'NM_HORA2_11'
                                     and pw_editor_clinico.cd_documento = 156)ava5
                           where editor_registro_campo.cd_campo = editor_campo.cd_campo
                             and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                             and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                             and pw_documento_clinico.cd_atendimento = ava5.cd_atendimento
                             and editor_campo.ds_identificador = 'Metadado_P_20680_12'
                             and pw_editor_clinico.cd_documento = 156)ava4 
                             
                 where editor_registro_campo.cd_campo = editor_campo.cd_campo
                   and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                   and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
                   and pw_documento_clinico.cd_atendimento = ava1.cd_atendimento
                   and pw_documento_clinico.cd_atendimento = ava2.cd_atendimento
                   and pw_documento_clinico.cd_atendimento = ava4.cd_atendimento
                   and editor_campo.ds_identificador = 'Metadado_P_20680_4'
                   and pw_editor_clinico.cd_documento = 156)ava
         where editor_registro_campo.cd_campo = editor_campo.cd_campo
           and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
           and pw_editor_clinico.cd_documento_clinico = pw_documento_clinico.cd_documento_clinico
           and pw_documento_clinico.cd_atendimento = ava.cd_atendimento
           and editor_campo.ds_identificador = 'Metadado_P_20711_1'
           and pw_editor_clinico.cd_documento = 156)ava_enf
      ,(select pw_documento_clinico.cd_atendimento/*Sub-Consulta responsavel por identificar data e hora da Adimssao na Hemodinamica*/
              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1) adm_enf
              ,hemo_por.por 
              ,hemo_por.rec 
          from editor_registro_campo
              ,pw_documento_clinico
              ,pw_editor_clinico
              ,editor_campo
              ,(select pw_documento_clinico.cd_atendimento/*Sub-Consulta responsavel por identificar o Usuário Campo: Por*/
                      ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)por
                      ,re_hemo.rec
                  from editor_registro_campo 
                      ,pw_documento_clinico
                      ,pw_editor_clinico
                      ,editor_campo
                      ,(select pw_documento_clinico.cd_atendimento/*Sub-Consulta responsavel por identtificar a data e hora da Recanalização*/
                              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1)rec
                          from editor_registro_campo                  
                              ,pw_documento_clinico
                              ,pw_editor_clinico
                              ,editor_campo
                        where editor_registro_campo.cd_campo = editor_campo.cd_campo
                          and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                          and pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico
                          and editor_campo.ds_identificador = 'Metadado_P_20805_3'
                          and pw_editor_clinico.cd_documento = 150) re_hemo
                where editor_registro_campo.cd_campo = editor_campo.cd_campo 
                  and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
                  and pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico
                  and pw_documento_clinico.cd_atendimento = re_hemo.cd_atendimento 
                  and editor_campo.ds_identificador = 'Metadado_P_20806_1'
                   and pw_editor_clinico.cd_documento = 150)hemo_por           
        where editor_registro_campo.cd_campo = editor_campo.cd_campo
          and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
          and pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico
          and pw_documento_clinico.cd_atendimento = hemo_por.cd_atendimento
          and editor_campo.ds_identificador = 'Metadado_P_20805_4'
          and pw_editor_clinico.cd_documento = 150)ava_hemo
      ,(select pw_documento_clinico.cd_atendimento/*Sub-Consulta responsavel pelo Desfecho de Enfermagem*/
              ,dbms_lob.substr(editor_registro_campo.lo_valor,4000,1) desfecho
          from editor_registro_campo
              ,pw_documento_clinico
              ,pw_editor_clinico
              ,editor_campo
        where editor_registro_campo.cd_campo = editor_campo.cd_campo
          and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro
          and pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico
          and editor_campo.ds_identificador = 'Observacao_desfecho_1'
          and pw_editor_clinico.cd_documento = 186)desfecho
              
 where editor_registro_campo.cd_campo = editor_campo.cd_campo
   and pw_editor_clinico.cd_editor_registro = editor_registro_campo.cd_registro(+)
   and pw_documento_clinico.cd_documento_clinico = pw_editor_clinico.cd_documento_clinico(+)
   and pw_documento_clinico.cd_paciente = paciente.cd_paciente
   and pw_documento_clinico.cd_atendimento = adm_medica.cd_atendimento(+)
   and adm_medica.cd_atendimento = ava_hemo.cd_atendimento
   and pw_documento_clinico.cd_atendimento = ava_hemo.cd_atendimento(+)
   and pw_documento_clinico.cd_atendimento = desfecho.cd_atendimento(+)
   and pw_documento_clinico.cd_atendimento = ava_enf.cd_atendimento(+)
   and adm_medica.dh_criacao between '20/08/2020' and '30/08/2020' 
   --and pw_documento_clinico.cd_atendimento = 2264853  
   
group by pw_documento_clinico.cd_atendimento 
        ,paciente.nm_paciente
        ,adm_medica.dh_criacao 
        ,ava_enf.adm_enf 
        ,ava_enf.dt_ecg 
        ,ava_enf.hr_ecg 
        ,ava_enf.dt_ecg_1 
        ,ava_enf.hr_ecg_1 
        ,ava_enf.dt_ecg_2 
        ,ava_enf.hr_ecg_2 
        ,ava_hemo.adm_enf 
        ,ava_hemo.por 
        ,ava_hemo.rec 
        ,desfecho.desfecho  
