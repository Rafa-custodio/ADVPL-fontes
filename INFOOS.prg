#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} infoos
//TODO Mostra informações referente a determinada OS
@author Rafael Custodio
@since 14/05/2018
@version 0.001

@type function
/*/
User Function INFOOS()      
	Local cPerg := "INFOOS"

PutSx1(cPerg,"01","OS? "  		,"","",		"mv_ch1" ,"C",6,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",)
	
	If Pergunte(cPerg,.T.)
                                                                     
		cIniProc	:= Substr(Time(),1,8)
		Processa({|| MntQry()}	 	,,"Processando...") //EXECUTA A CONSULTA SQL MONTANDO A TABELA TMP
		cFimProc	:= Substr(Time(),1,8)
		MBTela() //chamada de função MBTela()

	EndIf
	
/****************************************************************
Monta a Mbrowse para demonstração dos dados ao usuário.  
*****************************************************************/
Static Function MBTela()
SetPrvt("CCADASTRO,AROTINA,CDELFUNC,ACAMPOS,_STRU")
SetPrvt("_NVAR,_CARQ,_CINDEX,_CCHAVE,")

cCadastro := "Informacao OS"

ACAMPOS:={}
PRIVATE aRotina := { { "Excel" ,  "U_RelExel"   , 0, 1 },;
                     { "Ajuda" ,  "U_axAjuda"   , 0, 2 }}
                    

cdelfunc:=".T."

_stru:={}
AADD(_stru,{"RB_OS","C",6,0})
AADD(_stru,{"RB_CODIGO","C",6,0})
AADD(_stru,{"RB_NOME","C",54,0})
AADD(_stru,{"RB_PAIS","C",40,0})
AADD(_stru,{"RB_PEDIDO","C",6,0})
AADD(_stru,{"RB_PRODUTO","C",15,0})
AADD(_stru,{"RB_ITEM","C",2,0})
AADD(_stru,{"RB_VENDA","N",8,0})
AADD(_stru,{"RB_VALOR","N",8,0})
AADD(_stru,{"RB_PBRUTO","C",8,0})
AADD(_stru,{"RB_PLIQUI","C",8,0})

_nvar:=1
_cArq:=Criatrab(_stru,.T.)

DBUSEAREA(.t.,,_carq,"TRB")
DBSELECTAREA("TMP")
DBGOTOP()
WHILE !EOF()
        DBSELECTAREA("TRB")
        RECLOCK("TRB",.T.)
       TRB->RB_OS:= TMP->OS
        TRB->RB_CODIGO:= TMP->CODIGO
        TRB->RB_NOME:= TMP->NOME
        TRB->RB_PAIS:= TMP->PAIS
        TRB->RB_PEDIDO:= TMP->PEDIDO
        TRB->RB_PRODUTO:= TMP->PRODUTO
        TRB->RB_ITEM:= TMP->ITEM
        TRB->RB_VENDA:= TMP->VENDA
        TRB->RB_VALOR:= TMP->VALOR
        TRB->RB_PBRUTO:= cValToChar(TMP->PBRUTO) //TMP->PBRUTO
        TRB->RB_PLIQUI:= cValToChar(TMP->PLIQUI) //TMP->PLIQUI
        MSUNLOCK()
       
        DBSELECTAREA("TMP")
        DBSKIP()
ENDDO

_cIndex:=Criatrab(Nil,.F.)
_cChave:="RB_OS+RB_CODIGO"
Indregua("TRB",_cIndex,_cchave,,,"Selecionando Registros...")
dBSETINDEX(_cIndex+ordbagext())

aCampos:={{"Os "  			,"RB_OS"     ,"C",6,0 ,"@!"},;
          {"Codigo  "  		,"RB_CODIGO" ,"C",6,0,"@!"},;
          {"Nome Cliente  " ,"RB_NOME" ,"C",54,0,"@!"},;
          {"Pais  "  		,"RB_PAIS" ,"C",40,0,"@!"},;
          {"Pedido  "  		,"RB_PEDIDO" ,"C",6,0,"@!"},;
          {"Produto  "  	,"RB_PRODUTO" ,"C",15,0,"@!"},;
          {"Item  "  		,"RB_ITEM" ,"C",2,0,"@!"},;
          {"Venda  "  		,"RB_VENDA" ,"N",8,0,"@E"},;
          {"Valor  " 		,"RB_VALOR" ,"N",8,0,"@E"},;
          {"Peso Bruto  "  	,"RB_PBRUTO" ,"N",8,0,"@!"},;
          {"Peso Liquido  " ,"RB_PLIQUI" ,"N",8,0,"@!"}}
// @E 999,999,999.99

mBrowse( 6,1,22,75,"TRB",acampos)

DBCLOSEAREA("TRB")
FERASE(_carq+".DBF")
FERASE(_cindex+ordbagext())


Return 
/**************************
Função para montar a  query e criar a tabela TMP
****************************/

Static Function MntQry()
	Local cQuery := " "
	Local cEnter := Chr(13) 
	
	cQuery := " SELECT 	C9_ORDSEP AS 'OS'	,"	+cEnter																													
	cQuery += " A1_COD 			AS 'CODIGO' 	,"+cEnter 
	cQuery += " A1_NOME 			AS 'NOME'		,"+cEnter 
	cQuery += " A1_MUN 		AS 'PAIS' 			,"							 
	cQuery += " C6_NUM 			AS 'PEDIDO' 	,"+cEnter 
	cQuery += " C6_PRODUTO 		AS 'PRODUTO' 	," 
	cQuery += " C6_ITEM 		AS 'ITEM' 			,"							
	cQuery += " C6_QTDVEN 		AS 'VENDA' 		,"+cEnter 
	cQuery += " C6_VALOR AS 'VALOR'," 							
	cQuery += " CB0_PESOB 	AS 'PBRUTO' 	,"+cEnter 
	//--	CB0_CODETI AS 'ETIQUETA',
	cQuery += " CB0_PESOL 	AS 'PLIQUI'" 	 																
	cQUery += " FROM SC6010 SC6"+cEnter 
	cQuery += " INNER JOIN SC9010 SC9" 
	cQuery += " ON (C9_FILIAL=C6_FILIAL 	AND C9_PEDIDO= C6_NUM" +cEnter		
	cQuery += " AND C9_ITEM=C6_ITEM 	AND C9_NFISCAL=''	AND SC9.D_E_L_E_T_='')" 	
	cQuery += " INNER JOIN CB0010 CB0"+cEnter 
	cQuery += " ON (CB0_FILIAL=C6_FILIAL 	AND CB0_CODPRO= C9_PRODUTO 	AND CB0_LOTE=C9_LOTECTL AND CB0_SLOTE=C9_NUMLOTE"
	cQuery += " AND CB0.D_E_L_E_T_='')" +cEnter 	
	cQuery += " INNER JOIN SA1010 SA1" 
	cQuery += " ON (A1_FILIAL=C6_FILIAL		AND A1_COD=C6_CLI"+cEnter			
	cQuery += " AND A1_LOJA=C6_LOJA"			
	cQuery += " AND SA1.D_E_L_E_T_='') "+cEnter 	
	cQuery += " WHERE   C6_FILIAL>='20' AND C9_ORDSEP = '"+MV_PAR01+"' AND SC6.D_E_L_E_T_='' "+cEnter	
	cQuery += " GROUP BY C9_ORDSEP, A1_COD, A1_NOME, A1_MUN , C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, C6_VALOR, CB0_PESOB,CB0_PESOL"+cEnter
	cQuery += " ORDER BY ITEM "
	
	cQuery := ChangeQuery(cQuery)
	
	// VERIFICAR SE A TABELA JA ESTÁ ABERTA, SE ESTIVER, FECHA ELA SEM DÓ NEM PIEDADE
		If Select("TMP") >0
			dbSelectArea("TMP")
			dbCloseArea("TMP")
		EndIf
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)
	
Return nil
/********************************
Função AxAjuda, Função atoa, sem utilidade alguma no programa.
*********************************/
User Function axAjuda()

AVISO("AJuda - OS", "Este programa tem o objetivo de mostrar infomações de OS a quais notas fiscais ainda não foram geradas.", {"Fechar"}, 2)

Return
/************************
User Function que chama a static GerExcel.
*************************/
User Function RelExel()

If MsgYesNo( 'Confirma?', 'Gerar arquivo Excel' )
 
	//Processa({||MntQry() 	},,"Processando...")
	MsAguarde( { || GerExcel() },,"O arquivo Excel está sendo gerado ... ")
 
Else
 
MsgAlert( 'Abortado pelo usuário', 'Gera arquivo Excel' )
 
Endif
 
Return( Nil )

/***************************
Função que gera a planilha Excel.
***************************/
Static Function GerExcel()
	Local oExcel := FWMSEXCEL():New()
	Local lOk := .F.
	Local cArq := ""
	Local cDir := GetSrvProfString("Startpath","")
	Local cDirTmp := "C:\SPOOL\"


	dbSelectArea("TMP")
	TMP->( dbGotop() )
	oExcel:AddworkSheet("INFOOS")
	oExcel:AddTable ("INFOOS","Informacao_os")
	oExcel:AddColumn("INFOOS","Informacao_os","OS",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","CODIGO",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","NOME",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","PAIS",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","PEDIDO",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","PRODUTO",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","ITEM",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","VENDA",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","VALOR",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","PBRUTO",1,1)
	oExcel:AddColumn("INFOOS","Informacao_os","PLIQUI",1,1)
		
	While TMP->(!EOF())

			oExcel:AddRow("INFOOS","Informacao_os",{ TMP->(OS),;
														 TMP->(CODIGO),;
														 TMP->(NOME),;
														 TMP->(PAIS),;
														 TMP->(PEDIDO),;
														 TMP->(PRODUTO),;
														 TMP->(ITEM),;
														 TMP->(VENDA),;
														 TMP->(VALOR),;
														 TMP->(PBRUTO),;
														 TMP->(PLIQUI)})
		lOk := .T.
		TMP->( dbSkip() )
	
	EndDo

	oExcel:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"
	oExcel:GetXMLFile( cArq )
	If __CopyFile( cArq, cDirTmp + cArq )
		If lOk
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			oExcelApp:SetVisible(.T.)
			MsgInfo( "Arquivo <b>" + cDirTmp + cArq + "  </b>gerado com sucesso!." )
		Endif
	Else
		MsgAlert( "Erro ao copiar arquivo para temporário do usuário:<br> - Verifique a pasta SPOOL<br> - Verifique permissões de usuário", "AVISO")
	Endif


Return
