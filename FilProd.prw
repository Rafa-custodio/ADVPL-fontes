#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FilProd
//TODO Monta uma tela amigável para o usuário com as informações desejadas
@author Rafael Custodio
@since 13/05/2018
@version undefined

@type function
/*/
User Function FilProd()      
	Local cPerg := "FILPROD"

PutSx1(cPerg,"01","Produto: "  		,"","",		"mv_ch1" ,"C",6,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",)
	
	If Pergunte(cPerg,.T.)
                                                                     
		cIniProc	:= Substr(Time(),1,8)
		Processa({|| MntQry()}	 	,,"Processando...") //EXECUTA A CONSULTA SQL MONTANDO A TABELA TMP
		cFimProc	:= Substr(Time(),1,8)
		MBTela() //CHAMA A FUNÇÃO MBROWSE PARA MOSTRAR A TELA PARA O USUÁRIO.

	EndIf
	


/***
Monta a Mbrowse para demonstração dos dados ao usuário.  
**/
Static Function MBTela()
SetPrvt("CCADASTRO,AROTINA,CDELFUNC,ACAMPOS,_STRU")
SetPrvt("_NVAR,_CARQ,_CINDEX,_CCHAVE,")

cCadastro := "Cadastro Especifico"

ACAMPOS:={}
PRIVATE aRotina := { { "Relatório" ,  "AxRel"   , 0, 1 },;
                     { "Ajuda" ,  "U_axAjuda"   , 0, 2 }}
                    // { "Incluir"    , "axInclui"  , 0, 3 },;
                   //  { "Alterar"    , "axAltera" , 0, 4 }}//,;
                     //{ "Excluir"    , "axExclui" , 0, 5 } }

cdelfunc:=".T."

_stru:={}
AADD(_stru,{"RB_FIL","C",2,0})
AADD(_stru,{"RB_COD","C",15,0})
AADD(_stru,{"RB_DESC","C",50,0})

_nvar:=1
_cArq:=Criatrab(_stru,.T.)

DBUSEAREA(.t.,,_carq,"TRB")
DBSELECTAREA("TMP")
DBGOTOP()
WHILE !EOF()
        DBSELECTAREA("TRB")
        RECLOCK("TRB",.T.)
        TRB->RB_FIL:= TMP->FILIAL
        TRB->RB_COD:= TMP->CODIGO
        TRB->RB_DESC:= TMP->DESCRICAO
       // TRB->RB_valor  :=_nvar
        MSUNLOCK()
       // _nvar:=_nvar+0.11
        DBSELECTAREA("TMP")
        DBSKIP()
ENDDO

_cIndex:=Criatrab(Nil,.F.)
_cChave:="RB_FIL+RB_COD"
Indregua("TRB",_cIndex,_cchave,,,"Selecionando Registros...")
dBSETINDEX(_cIndex+ordbagext())

aCampos:={{"Filial "  ,"RB_FIL"     ,"C",2,0 ,"@!"},;
          {"Valor  "  ,"RB_COD" ,"N",15,0,"@!"},;
          {"Parametro","RB_DESC"   ,"C",50,0,"@!"}}
          //{"Descricao","RB_DESCRIC" ,"C",50,0,"@!"}}


mBrowse( 6,1,22,75,"TRB",acampos)

DBCLOSEAREA("TRB")
FERASE(_carq+".DBF")
FERASE(_cindex+ordbagext())


Return 
// fUNÇÃO PARA MONTAR A QUERY DESEJADA

Static Function MntQry()
	Local cQuery := " "
	
	cQuery += ""
	cQuery += " SELECT B1_FILIAL AS 'FILIAL', "
	cQuery += " B1_COD AS 'CODIGO', B1_DESC AS 'DESCRICAO' "
	cQuery += " FROM SB1990 WHERE B1_COD = '"+MV_PAR01+"' AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	
	// VERIFICAR SE A TABELA JA ESTÁ ABERTA, SE ESTIVER, FECHA ELA SEM DÓ NEM PIEDADE
		If Select("TMP") >0
			dbSelectArea("TMP")
			dbCloseArea("TMP")
		EndIf
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)
	
Return nil
//-------------------------------------
// Alerta para ajuda

User Function axAjuda()

MsgInfo("<b><h2>Filtra Produto</h2></b><br> Esta função tem como objetivo filtrar o produto informado pelo usuário.<br> Este programa foi criado em 2018 específico para teste.")

Return