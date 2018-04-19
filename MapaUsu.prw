#Include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MapaUsu  � Autor �Carlos G. Berganton � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Mapeia Acessos dos Usuarios do Sistema                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function mapausu()


//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}
Private titulo       := "Relatorio de Acessos dos Usuarios"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private tamanho      := "M"
Private nomeprog     := "MapaUsu" 
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private cPerg        := "MAPAUS"
Private m_pag        := 01
Private wnrel        := "MapaUsu"
Private cString      := ""



AjustSX1()

Pergunte(cPerg,.T.)

//�������������������������������������������Ŀ
//� Monta a interface padrao com o usuario... �
//���������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aIdiomas := {"Portugues","Ingles","Espanhol"}
Local aTipoImp := {"Em Disco","Via Spool","Direto na Porta","E-Mail"}
Local aFormImp := {"Retrado","Paisagem"}
Local aAmbImp  := {"Servidor","Cliente"}
Local aColAcess:= {000,040,080}
Local aColMenus:= {000,044,088}
Local aAllUsers:= AllUsers()
Local aUser    := {}
Local i        := 0
Local k        := 0
Local j        := 0
Local aMenu    

aModulos := fModulos()
aAcessos := fAcessos()

For i:=1 to Len(aAllUsers)
      aAdd(aUser,aAllUsers[i])
   
Next

   aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][1] < aVar2[1][1]})
 

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(Len(aUser))

//�������������������Ŀ
//� Processa Usuarios �
//���������������������
For i:=1 to Len(aUser)
   IncRegua()

   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 5
  
   @ nLin,000 pSay "I N F O R M A C O E S   D O   U S U A R I O"
   nLin+=1
   @ nLin,000 pSay "User ID.........................: "+aUser[i][01][01] //ID
     nLin+=1
   @ nLin,000 pSay "Nome Completo...................: "+aUser[i][01][04] //Nome Completo
   nLin+=1
   @ nLin,000 pSay "Usuario.........................: "+aUser[i][01][02] //Usuario
   nLin+=1
   @ nLin,000 pSay "Usuario Bloqueado...............: "+If(aUser[i][01][17],"Sim","Nao") //Usuario Bloqueado
   nLin+=1
      @ nLin,000 pSay "Dias a retroceder............: "+cValToChar( aUser[n][1][23][2] ) //Dias a Retroceder
   nLin+=1
       @ nLin,000 pSay "Dias a Avan�ar............: "+cValToChar( aUser[n][1][23][3] ) //Dias a Retroceder
   PswOrder(1)
   PswSeek(aUser[i][1][11],.t.)
   aSuperior := PswRet(NIL)
   

   //����������������������������Ŀ
   //� Imprime Empresas / Filiais �
   //������������������������������
      fCabec(@nLin,50)

      @ nLin,000 pSay Replic("-",132)
      nLin+=1
      @nLin,000 pSay "E M P R E S A S / F I L I A I S"
      nLin+=2
      For k:=1 to Len(aUser[i][02][06])
         fCabec(@nLin,55)

         dbSelectArea("SM0")
         dbSetOrder(1)
         dbSeek(aUser[i][02][06][k])
         @ nLin,005 pSay Substr(aUser[i][02][06][k],1,2)+"/"+Substr(aUser[i][02][06][k],3,4)+If(Found()," "+M0_NOME+" - "+M0_NOMECOM,If(Substr(aUser[i][02][06][k],1,2)=="@@"," - Todos","")) //Empresa / Filial
         nLin+=1
      
      Next k
      nLin+=1
   
   //�������������������
   //� Imprime Modulos �
   //�������������������
         
   //�������������������
   //� Imprime Acessos �
   //�������������������
   
   //�����������������
   //� Imprime Menus �
   //�����������������
                  
Next i

//�������������������������������������Ŀ
//� Finaliza a execucao do relatorio... �
//���������������������������������������
SET DEVICE TO SCREEN

//������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao... �
//��������������������������������������������������������������
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fModulos �Autor  �Carlos G. Berganton � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Array com Codigos e Nomes dos Modulos              ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fModulos()

Local aReturn

aReturn := {{"01","SIGAATF ","Ativo Fixo                       "},;
            {"02","SIGACOM ","Compras                           "},;
            {"03","SIGACON ","Contabilidade                     "},;
            {"04","SIGAEST ","Estoque/Custos                    "},;
            {"05","SIGAFAT ","Faturamento                       "},;
            {"06","SIGAFIN ","Financeiro                        "},;
            {"07","SIGAGPE ","Gestao de Pessoal                 "},;
            {"08","SIGAFAS ","Faturamento Servico               "},;
            {"09","SIGAFIS ","Livros Fiscais                    "},;
            {"10","SIGAPCP ","Planej.Contr.Producao             "},;
            {"11","SIGAVEI ","Veiculos                          "},;
            {"12","SIGALOJA","Controle de Lojas                 "},;
            {"13","SIGATMK ","Call Center                       "},;
            {"14","SIGAOFI ","Oficina                           "},;
            {"15","SIGARPM ","Gerador de Relatorios Beta1       "},;
            {"16","SIGAPON ","Ponto Eletronico                  "},;
            {"17","SIGAEIC ","Easy Import Control               "},;
            {"18","SIGAGRH ","Gestao de R.Humanos               "},;
            {"19","SIGAMNT ","Manutencao de Ativos              "},;
            {"20","SIGARSP ","Recrutamento e Selecao Pessoal    "},;
            {"21","SIGAQIE ","Inspecao de Entrada               "},;
            {"22","SIGAQMT ","Metrologia                        "},;
            {"23","SIGAFRT ","Front Loja                        "},;
            {"24","SIGAQDO ","Controle de Documentos            "},;
            {"25","SIGAQIP ","Inspecao de Projetos              "},;
            {"26","SIGATRM ","Treinamento                       "},;
            {"27","SIGAEIF ","Importacao - Financeiro           "},;
            {"28","SIGATEC ","Field Service                     "},;
            {"29","SIGAEEC ","Easy Export Control               "},;
            {"30","SIGAEFF ","Easy Financing                    "},;
            {"31","SIGAECO ","Easy Accounting                   "},;
            {"32","SIGAAFV ","Administracao de Forca de Vendas  "},;
            {"33","SIGAPLS ","Plano de Saude                    "},;
            {"34","SIGACTB ","Contabilidade Gerencial           "},;
            {"35","SIGAMDT ","Medicina e Seguranca no Trabalho  "},;
            {"36","SIGAQNC ","Controle de Nao-Conformidades     "},;
            {"37","SIGAQAD ","Controle de Auditoria             "},;
            {"38","SIGAQCP ","Controle Estatistico de Processos "},;
            {"39","SIGAOMS ","Gestao de Distribuicao            "},;
            {"40","SIGACSA ","Cargos e Salarios                 "},;
            {"41","SIGAPEC ","Auto Pecas                        "},;
            {"42","SIGAWMS ","Gestao de Armazenagem             "},;
            {"43","SIGATMS ","Gestao de Transporte              "},;
            {"44","SIGAPMS ","Gestao de Projetos                "},;
            {"45","SIGACDA ","Controle de Direitos Autorais     "},;
            {"46","SIGAACD ","Automacao Coleta de Dados         "},;
            {"47","SIGAPPAP","PPAP                              "},;
            {"48","SIGAREP ","Replica                           "},;
            {"49","SIGAGAC ","Gerenciamento Academico           "},;
            {"50","SIGAEDC ","Easy DrawBack Control             "},;
            {"97","SIGAESP ","Especificos                       "},;
            {"98","SIGAESP1","Especificos I                     "}}
               

Return(aReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fAcessos �Autor  �Carlos G. Berganton � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna os Acessos dos Sistema                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fAcessos()

Local aReturn

aReturn := {"Excluir Produtos             ",;
            "Alterar Produtos             ",;
            "Excluir Cadastros            ",;
            "Alterar Solicit. Compras     ",;
            "Excluir Solicit. Compras     ",;
            "Alterar Pedidos Compras      ",;
            "Excluir Pedidos Compras      ",;
            "Analisar Cotacoes            ",;
            "Relat Ficha Cadastral        ",;
            "Relat Bancos                 ",;
            "Relacao Solicit. Compras     ",;
            "Relacao de Pedidos de Compras",;
            "Alterar Estruturas           ",;
            "Excluir Estruturas           ",;
            "Alterar TES                  ",;
            "Excluir TES                  ",;
            "Inventario                   ",;
            "Fechamento Mensal            ",;
            "Proc Diferenca de Inventario ",;
            "Alterar Pedidos de Venda     ",;
            "Excluir Pedidos de Venda     ",;
            "Alterar Helps                ",;
            "Substituicao de Titulos      ",;
            "Inclusao de Dados Via F3     ",;
            "Rotina de Atendimento        ",;
            "Proc. Troco                  ",;
            "Proc. Sangria                ",;
            "Bordero Cheques Pre-Datado   ",;
            "Rotina de Pagamento          ",;
            "Rotina de Recebimento        ",;
            "Troca de Mercadorias         ",;
            "Acesso Tabela de Precos      ",;
            "Abortar c/ Alt-C/Ctrl-Brk    ",;
            "Retorno Temporario p/ o DOS  ",;
            "Acesso Condicao Negociada    ",;
            "Alterar DataBase do Sistema  ",;
            "Alterar Empenhos de OP's     ",;
            "Pode Utilizar Debug          ",;
            "Form. Precos Todos os Niveis ",;
            "Configura Venda Rapida       ",;
            "Abrir/Fechar Caixa           ",;
            "Excluir Nota/Orc LOJA        ",;
            "Alterar Bem Ativo Fixo       ",;
            "Excluir Bem Ativo Fixo       ",;
            "Incluir Bem Via Copia        ",;
            "Tx Juros Condicao Negociada  ",;
            "Liberacao Venda Forcad TEF   ",;
            "Cancelamento Venda TEF       ",;
            "Cadastra Moeda na Abertura   ",;
            "Altera Num. da NF            ",;
            "Emitir NF Retroativa         ",;
            "Excluir Baixa - Receber      ",;
            "Excluir Baixa - Pagar        ",;
            "Incluir Tabelas              ",;
            "Alterar Tabelas              ",;
            "Excluir Tabelas              ",;
            "Incluir Contratos            ",;
            "Alterar Contratos            ",;
            "Excluir Contratos            ",;
            "Uso Integracao SIGAEIC       ",;
            "Inclui Emprestimo            ",;
            "Alterar Emprestimo           ",;
            "Excluir Emprestimo           ",;
            "Incluir Leasing              ",;
            "Alterar Leasing              ",;
            "Excluir Leasing              ",;
            "Incluir Imp. Nao Financ.     ",;
            "Alterar Imp. Nao Financ.     ",;
            "Excluir Imp. Nao Financ.     ",;
            "Incluir Imp. Financ.         ",;
            "Alterar Imp. Financ.         ",;
            "Excluir Imp. Financ.         ",;
            "Incluir Imp. Fin.Export      ",;
            "Alterar Imp. Fin.Export      ",;
            "Excluir Imp. Fin.Export      ",;
            "Incluir Contrato             ",;
            "Alterar Contrato             ",;
            "Excluir Contrato             ",;
            "Lancar Taxa Libor            ",;
            "Consolidar Empresas          ",;
            "Incluir Cadastros            ",;
            "Alterar Cadastros            ",;
            "Incluir Cotacao Moedas       ",;
            "Alterar Cotacao Moedas       ",;
            "Excluir Cotacao Moedas       ",;
            "Incluir Corretoras           ",;
            "Alterar Corretoras           ",;
            "Excluir Corretoras           ",;
            "Incluir Imp./Exp./Cons       ",;
            "Alterar Imp./Exp./Cons       ",;
            "Excluir Imp./Exp./Cons       ",;
            "Baixar Solicitacoes          ",;
            "Visualiza Arquivo Limite     ",;
            "Imprime Doctos. Cancelados   ",;
            "Reativa Doctos. Cancelados   ",;
            "Consulta Doctos. Obsoletos   ",;
            "Imprime Doctos. Obsoletos    ",;
            "Consulta Doctos. Vencidos    ",;
            "Imprime Doctos. Vencidos     ",;
            "Def. Laudo Final Entrega     ",;
            "Imprime Param Relatorio      ",;
            "Transfere Pendencias         ",;
            "Usa Relatorio por E-Mail     "}
                                        
Return(aReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCabec   �Autor  �Carlos G. Berganton � Data �  18/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Quebra de Pagina e Imprime Cabecalho                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabec(nLin,nLimite)

//������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . . �
//��������������������������������������������
If nLin > nLimite 
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 6
Endif

Return
            
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetMnu   �Autor  �Carlos G. Berganton � Data �  15/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Obtem dados de um arquivo .mnu                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetMnu(cArq,cUsuario)

Local aRet := {}
Local aTmp := {}

//������������������
//� Abre o Arquivo �
//������������������
If File(cArq)
   ft_fuse(cArq)
Else
   ApMsgAlert("Arquivo "+AllTrim(cArq)+" nao foi encontrado. Usuario "+AllTrim(cUsuario)+".")
   Return({})
Endif   

While ! ft_feof()

   //���������������������Ŀ
   //� Le linha do Arquivo �
   //�����������������������
   cBuff := ft_freadln()
   aTmp := {}
     
   //��������������������������������Ŀ
   //� Monta Array com Dados da Linha �
   //����������������������������������
   aAdd(aTmp,Substr(cBuff,01,02))
   aAdd(aTmp,Substr(cBuff,03,18))
   aAdd(aTmp,Substr(cBuff,21,10))
   aAdd(aTmp,Substr(cBuff,31,01))
   aAdd(aTmp,{})
   For i:=32 to 89 Step 3
      If Substr(cBuff,i,3)<>"..."
         aAdd(aTmp[5],Substr(cBuff,i,3))
      Endif
   Next
   aAdd(aTmp,Substr(cBuff,122,10))

   //���������������������������Ŀ
   //� Abastece Array de Retorno �
   //�����������������������������
   aAdd(aRet,aTmp)
     
   ft_fskip()
EndDo

ft_fuse()

Return(aRet)
                          
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � Carlos G. Berganton   � Data � 15/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustSX1()

Local aArea	    := GetArea()
Local cPerg		:= "MAPAUS"
Local aRegs		:= {}
Local i

//PutSx1( cPerg, "01","Do ID..............?","mv_ch1","C",06,0,0,"G","mv_par01",""   ,""       )
//PutSx1( cPerg, "02","Ate ID.............?","mv_ch2","C",06,0,0,"G","mv_par02",""   ,""       )
//PutSx1( cPerg, "03","Do Usuario.........?","mv_ch3","C",15,0,0,"G","mv_par03",""   ,""       )
//PutSx1( cPerg, "04","Ate Usuario........?","mv_ch4","C",15,0,0,"G","mv_par04",""   ,""       )
//PutSx1( cPerg, "05","Ordem..............?","mv_ch5","N",01,0,0,"C","mv_par05","ID" ,"Usuario")
//PutSx1( cPerg, "06","Imprime Horarios...?","mv_ch6","N",01,0,0,"C","mv_par06","Sim","Nao"    )
//PutSx1( cPerg, "07","Imprime Emp/Filiais?","mv_ch7","N",01,0,0,"C","mv_par07","Sim","Nao"    )
//PutSx1( cPerg, "08","Imprime Modulos....?","mv_ch8","N",01,0,0,"C","mv_par08","Sim","Nao"    )
//PutSx1( cPerg, "09","Imprime Acessos....?","mv_ch9","N",01,0,0,"C","mv_par09","Sim","Nao"    )
//PutSx1( cPerg, "10","Imprime Menus......?","mv_cha","N",01,0,0,"C","mv_par10","Sim","Nao"    )

U_xPutSx1( cPerg,"01","Do ID..............?","","","mv_ch1","C",6,0,0,"C","","","","","MV_PAR01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
U_xPutSx1( cPerg,"02","Ate ID.............?","","","mv_ch2","C",6,0,0,"C","","","","","MV_PAR02","","","","","","","","","","","","","","","","",{""},{""},{""},"")
U_xPutSx1( cPerg,"03","Imprime Emp/Filiais?" ,"","","mv_ch3","C",1,0,0,"C","","","","","MV_PAR03","","","","","","","","","","","","","","","","",{""},{""},{""},"")
U_xPutSx1( cPerg,"04","Data Vencimento at�:","","","mv_ch4","D",8,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",{""},{""},{""},"")



Return