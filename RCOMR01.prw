#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} RCOMR01
//TODO RELATÓRIO SIMPLES PARA IMPRESSÃO DE CADASTRO DE PRODUTO
@author Administrador
@since 16/05/2018
@version undefined

@type function
/*/
User Function RCOMR01()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := PadR ("RCOMR01", Len (SX1->X1_GRUPO))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1(cPerg,"01","Código de?"  ,'','',"mv_ch1","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Código ate?" ,'','',"mv_ch2","C",TamSx3 ("B1_COD")[1] ,0,,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReportDef()
oReport	:PrintDialog()	

Return Nil

/*/{Protheus.doc} ReportDef
//TODO DEFINIÇÃO DA ESTRUTURA DO RELATORIO
@author Administrador
@since 16/05/2018
@version undefined

@type function
/*/
Static Function ReportDef()

oReport := TReport():New("RCOMR01","Cadastro de Produtos",cPerg,{|oReport| PrintReport(oReport)},"Impressão de cadastro de produtos em TReport simples.")
oReport:SetLandscape(.T.)

oSecCab := TRSection():New( oReport , "Produtos", {"QRY"} )
TRCell():New( oSecCab, "B1_COD"     , "QRY")
TRCell():New( oSecCab, "B1_DESC"    , "QRY")
TRCell():New( oSecCab, "B1_TIPO"    , "QRY")
TRCell():New( oSecCab, "B1_UM"      , "QRY")

//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
TRFunction():New(oSecCab:Cell("B1_COD"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil

/*/{Protheus.doc} PrintReport
//TODO MONTA A QUERY PARA PESQUISA
@author Administrador
@since 16/05/2018
@version undefined
@param oReport, object, descricao
@type function
/*/
Static Function PrintReport(oReport)

Local cQuery     := ""

Pergunte(cPerg,.F.)

cQuery += " SELECT " + CRLF 
cQuery += "     SB1.B1_COD " + CRLF 
cQuery += "    ,SB1.B1_DESC " + CRLF 
cQuery += "    ,SB1.B1_TIPO " + CRLF 
cQuery += "    ,SB1.B1_UM " + CRLF 
cQuery += "  FROM " + RetSqlName("SB1") + " SB1 " + CRLF 
cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial ("SB1") + "' " + CRLF 
cQuery += "   AND SB1.B1_COD    BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF 
cQuery += "   AND SB1.D_E_L_E_T_ = ' ' " + CRLF 
cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

oSecCab:BeginQuery()
oSecCab:EndQuery({{"QRY"},cQuery})    
oSecCab:Print()

Return Nil