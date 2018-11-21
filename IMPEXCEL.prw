#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} IMPEXCEL
//TODO Exemplo rápido de importação de planilha excel.
//CadaStrando produtos a partir de um arquivo CSV devidamente formatado e preenchido
// * ESTE FONTE AINDA PRECISA DE ALGUNS AJUSTES CASO FOR UTILIZAR **
@author Rafael Custodio
@since 21/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function IMPEXCEL()
	
Local oButton1
Local oButton2
Local oButton3
Local oFont1 := TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,030,,.T.,,,,,.F.,.F.)
Local oSay1
Local oOK := LoadBitmap(GetResources(),'br_verde')
Local oNO := LoadBitmap(GetResources(),'br_vermelho')
Private lMsErroAuto	:= .F.
Static oDlg

DEFINE MSDIALOG oDlg TITLE "CADASTRO DE PRODUTO - ARQ CSV." FROM 000, 000  TO 350, 800 COLORS 0, 16777215 PIXEL
@ 005, 003 SAY oSay1 PROMPT "IMPORTAÇÃO DE PRODUTO" SIZE 221, 030 OF oDlg FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 144, 010 BUTTON oButton2 PROMPT "IMPORTAR PLANILHA " SIZE 088, 021 OF oDlg PIXEL ACTION (Processa( {|lEnd| IMPCSV()}, "Aguarde...","Importando cadastro de produto.", .T. ))
@ 144, 300 BUTTON oButton3 PROMPT "FECHAR" SIZE 088, 021 OF oDlg PIXEL ACTION ( oDlg:End() )

_cPrimeiro := .T.
aListAux :=  {}
aListAuy :=  {}
_nTamanho	:=	0
@ 027, 005 SAY oSay1 PROMPT "STATUS DE IMPORTAÇÃO" SIZE 293, 180 OF oDlg FONT oFont1 COLORS 128, 16777215 PIXEL
// Vetor com elementos do Browse
aBrowse   := {{.T.,'','','','','','',0,''}}
// Cria Browse
oBrowse := TCBrowse():New( 037 , 05, 390, 100,,;
{'','USUARIO','CODIGO','DESCRICAO','TIPO','UM','LOCAL','GRUPO','IPI'},{10,30,80,13,55,25,30,35,20},;
oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
oBrowse:SetArray(aBrowse)

// Monta a linha a ser exibina no Browse
oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),;
aBrowse[oBrowse:nAt,02],;
aBrowse[oBrowse:nAt,03],;
aBrowse[oBrowse:nAt,04],;
aBrowse[oBrowse:nAt,05],;
aBrowse[oBrowse:nAt,06],;
aBrowse[oBrowse:nAt,07],;
aBrowse[oBrowse:nAt,08],;
aBrowse[oBrowse:nAt,09]  } }


ACTIVATE MSDIALOG oDlg CENTERED

RETURN
******************************************************************************************************************************************
STATIC FUNCTION IMPCSV()
Local aItenOP 	:= {}
Local nContX		:= 0
Local lRet			:= .F.
Local cCod			:= "" //codigo do usuário
Local cCodigo		:= "" //CODIGO
Local cDescricao	:= "" //DESCRICAO
Local cTp			:= "" //TIPO
Local cUni			:= "" //Unidade de Medida
Local clocal		:= "" //local
Local cGrupo		:= "" //Grupo
Local nIpi			:= 0 //IPI
Local cCentro_Custo	:= "" //Centro Custo
Local _nCont		:= 0
Local aVetor 		:= {}
Local lContinua		:= .T.                           

cRetArq := cGetFile("Arquivos CSV|*.CSV",OemToAnsi("Selecione o Diretorio onde se encontra o arquivo"),,"C:\",.F.,,.F.)

If Empty(cRetArq)
	MsgAlert("Arquivo inválido")
	Return
EndIf

//Pergunte(cPerg,.T.)

aReadCSV 	:= {}
cLineRead   := ""

fT_fUse( cRetArq )
fT_fGotop()

nLin := 0

While (!fT_fEof())
	cLineRead := fT_fReadLn()
	If nLin == 0
	If Alltrim(cLineRead) <> 'OK;B1_CODIGO;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD;B1_GRUPO;B1_IPI;B1_CC'
			Alert("A planilha não está com o layout de colunas padrão. Verifique!")
			MsgInfo(cValToChar(Alltrim(cLineRead)))
			Return
		EndIf
	Else
		aAdd( aReadCSV , cLineRead )
	EndIf
	_nCont++
	fT_fSkip()
	nLin++
End

fT_fUse()
aItenOP := {}
ProcRegua(_nCont)
For nLoop	:= 1 To Len(aReadCSV)
	IncProc("Preparando arquivos a serem importados...")
	aPos 		:= {}
	_cLinha 	:= aReadCSV[nLoop]
	For nLts:=1 to Len(_cLinha)
		If SubStr(_cLinha,nLts,1) == ';'
			Aadd(aPos,nLts)
		EndIf  
		                                   
	Next
	
	cCod			:= RetCodUsr() //Pega o ID do usuário logado no sistema
	cCodigo			:= SubStr(Alltrim(_cLinha),(aPos[1]+1),(aPos[2]-1)-aPos[1])
	cDescricao		:= SubStr(Alltrim(_cLinha),(aPos[2]+1),(aPos[3]-1)-aPos[2])
	cTp				:= SubStr(Alltrim(_cLinha),(aPos[3]+1),(aPos[4]-1)-aPos[3])
	cUni			:= SubStr(Alltrim(_cLinha),(aPos[4]+1),(aPos[5]-1)-aPos[4])
	clocal			:= "01"	
	cGrupo 			:= "0004"
	nIpi			:= SubStr(Alltrim(_cLinha),(aPos[7]+1),(aPos[8]-1)-aPos[7])
	cCentro_Custo	:= '100030100'
	
	
	If !Empty(cCod)
		Aadd(aItenOP,{cCod,cCodigo, cDescricao, cTp,cUni, clocal, cGrupo, nIpi,cCentro_custo})
	EndIf

Next

If Len(aItenOP) > 0
	
	For _nXB := 1 To Len(aItenOP)
		lContinua := .T.
		IncProc("Cadastrando o Produto "+aItenOP[_nXB][2]+". Aguarde...")
		
	
		/******* Verifica se o centro de custo informado é válido ******************
		dbSelectArea("CTT") 
		dbSetOrder(1)
		If !dbSeek(xFilial("CTT")+aItenOP[_nXB][8])
			lContinua := .F.
			Alert("Centro de custo inválido!")
		EndIf
		*****************************************************************************/
		
		If lContinua
			aVetor := {}
			aVetor := {{"B1_FILIAL"   ,xFilial("SB1")	 	,NIL},;
			{"B1_COD"		,aItenOP[_nXB][2]        		,NIL},;
			{"B1_DESC"		,aItenOP[_nXB][3]				,NIL},;
			{"B1_TIPO"		,aItenOP[_nXB][4]           	,NIL},;
			{"B1_UM"		,aItenOP[_nXB][5]				,NIL},;
			{"B1_LOCPAD"    ,aItenOP[_nXB][6]				,NIL},;
			{"B1_GRUPO"     ,"0004"/*aItenOP[_nXB][7]*/     ,NIL},;
			{"B1_IPI"   	,val(aItenOP[_nXB][8])			,NIL},;
			{"B1_CC"   		,aItenOP[_nXB][9]				,NIL},;
			{"B1_GARANT"    ,"2"							,NIL}}
			
			lMsErroAuto := .F.
			BeginTran()			
			
			If lContinua
				MSExecAuto({|x,y| mata010(x,y)},aVetor,3)
			Endif				
			
			If lMsErroAuto .Or. ! lContinua         
				If _cPrimeiro                                                                                                   
					aBrowse[1,1]	:=	.F.
					aBrowse[1,2]	:=	aItenOP[_nXB][1]
					aBrowse[1,3]	:=	aItenOP[_nXB][2]					
					aBrowse[1,4]	:=	aItenOP[_nXB][3]
					aBrowse[1,5]	:=	aItenOP[_nXB][4]
					aBrowse[1,6]	:=	aItenOP[_nXB][5]
					aBrowse[1,7]	:=	aItenOP[_nXB][6]
					aBrowse[1,8]	:=	aItenOP[_nXB][7]
					aBrowse[1,9]	:=	aItenOP[_nXB][8]
					_nTamanho		:=	1
					_cPrimeiro		:=	.F.
				Else
					aListAux :=  {.F., "", aItenOP[_nXB][1], aItenOP[_nXB][2], aItenOP[_nXB][5], aItenOP[_nXB][6], aItenOP[_nXB][9], aItenOP[_nXB][7], aItenOP[_nXB][8]}
					
					aadd(aBrowse, aListAux)
				Endif
				aadd(aListAuy,  {.T., "", aItenOP[_nXB][1], aItenOP[_nXB][2], aItenOP[_nXB][5], aItenOP[_nXB][6], aItenOP[_nXB][9], aItenOP[_nXB][7], aItenOP[_nXB][8]})

				MostraErro()
				DisarmTransaction()
				RollBackSx8()
			Else
				If _cPrimeiro                                                                                                   
					aBrowse[1,1]	:=	.T.
					aBrowse[1,2]	:=	aItenOP[_nXB][1]
					aBrowse[1,3]	:=	aItenOP[_nXB][2]					
					aBrowse[1,4]	:=	aItenOP[_nXB][3]
					aBrowse[1,5]	:=	aItenOP[_nXB][4]
					aBrowse[1,6]	:=	aItenOP[_nXB][5]
					aBrowse[1,7]	:=	aItenOP[_nXB][6]
					aBrowse[1,8]	:=	aItenOP[_nXB][7]
					aBrowse[1,9]	:=	aItenOP[_nXB][8]
					_nTamanho		:=	1
					_cPrimeiro		:=	.F.
				Else
					aListAux :=  {.T., "", aItenOP[_nXB][1], aItenOP[_nXB][2], aItenOP[_nXB][5], aItenOP[_nXB][6], aItenOP[_nXB][9], aItenOP[_nXB][7], aItenOP[_nXB][8]}
					
					aadd(aBrowse, aListAux)
				Endif
				aadd(aListAuy,  {.T., "", aItenOP[_nXB][1], aItenOP[_nXB][2], aItenOP[_nXB][5], aItenOP[_nXB][6], aItenOP[_nXB][9], aItenOP[_nXB][7], aItenOP[_nXB][8]})
				
				EndTran()
			EndIf
			MsUnlockAll()
		EndIf
		
	Next _nXB
	
EndIf
/***
ESTE FONTE AINDA PRECISA DE AJUSTES, MAS A FUNCIONALIDADE DELE ESTÁ OK, SE EXECUTÁ-LO DESTA FORMA,
ELE VAI CADASTAR OS PRODUTOS CORRETAMENTE.
***/
Return