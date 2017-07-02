#include 'protheus.ch'
#INCLUDE 'TBICONN.CH'
//PARA GERAR O PROTHEUS DOC: CONTROL ALT D

/*/{Protheus.doc} RELCUST
//TODO Função para gerar relatório em formato Excel
@author Rafael Custodio
@since 01/07/2017
@version 1.0.0

@type function
/*/
User Function RELCUST()

	Private lRet	:= .T.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 092,232,333,849,"RELATORIO EM EXCEL",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 000,116,{||"RELATORIO EM EXCEL"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,068,008)
oSay2      := TSay():New( 012,072,{||"Este programa tem como objetivo gerar um relatorio em Excel."},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,148,008)
oSay3      := TSay():New( 108,000,{||"Desenvolvido por Rafael."},oDlg1,,,.F.,.F.,.F.,.T.,CLR_CYAN,CLR_WHITE,084,008)
oBtn1      := TButton():New( 040,040,"GERAR EXCEL",oDlg1,{||Process()},076,032,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 040,176,"DESISTIR",oDlg1,{||oDlg1:End()},072,032,,,,.T.,,"",,,,.F. )
				
				//042, 002, "Botão 03",oDlg,{||Process()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F.
oDlg1:Activate(,,,.T.)

Return Nil

/***************************************************************************************************************************************************/
Static Function MntQry()
	Local cQuery := ""

	cQuery := " "
	cQuery += " SELECT " 
	cQuery += " ZZ9_NOME NOME, "
	cQuery += " ZZ9_DATA DATA_ATUAL, "
	cQuery += " ZZ9_CARGO CARGO "
	cQuery += " FROM ZZ9990"


	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), 'TR1', .F., .T.)


Return Nil
/***************************************************************************************************************************************************/
Static Function GeraExcel(cAliasOri)
	Local oExcel := FWMSEXCEL():New()
	Local lOk := .F.
	Local cAliasGen := cAliasOri
	Local cArq := ""
	Local cDir := GetSrvProfString("Startpath","")
	Local cDirTmp := "C:\SPOOL\"

	dbSelectArea("TR1")
	TR1->( dbGotop() )

	oExcel:AddworkSheet("RELCUSTO")
	oExcel:AddTable ("RELCUSTO","ZZ9")
	oExcel:AddColumn("RELCUSTO","ZZ9","NOME",1,1)
	oExcel:AddColumn("RELCUSTO","ZZ9","DATA_ATUAL",1,1)
	oExcel:AddColumn("RELCUSTO","ZZ9","CARGO",1,1)

	While TR1->(!EOF())

		oExcel:AddRow("RELCUSTO","ZZ9",{;
		TR1->(NOME),;
		TR1->(DATA_ATUAL),;
		TR1->(CARGO)})

		lOk := .T.
		TR1->( dbSkip() )

	EndDo

	oExcel:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml" //Está gerando o XML do arquivo
	oExcel:GetXMLFile( cArq )
	If __CopyFile( cArq, cDirTmp + cArq )
		If lOk
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			oExcelApp:SetVisible(.T.)
			//Sucesso!
			MsgInfo( "O arquivo: <b>" + cDirTmp + cArq + "</b> foi gerado com sucesso." )
		Endif
	Else   //Caso o Excel não seja gerado, verifique a existencia do diretório Spool ou Permissão de usuário.
		Alert( "<b>Houve algum erro ao gravar o arquivo!</b>" )
	Endif
	
Return Nil

/******************* Função que gera o Excel ********************************/
Static Function Process()

Processa({||MntQry() 	},,"Processando...")
	MsAguarde( { || GeraExcel("TR1") },,"Gerando arquivo excel... ")

	dbSelectArea("TR1")
	dbCloseArea()

Return Nil