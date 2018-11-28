#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*/{Protheus.doc} INFOROS
//TODO mostra informações de OS que ainda não foram faturadas.
@author rafael.custodio
@since 28/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function INFOROS()
                        
	Local aButtons 		:= {}
	Local oPesq
	Local oSButton1
	Local aObjects 		:= {}

	Local aSize			:= MsAdvSize()
	Local aInfo			:= {aSize[1], aSize[2], aSize[3], aSize[4], 1, 2}

	Private aPosObj		:= {}
	Private nPos1		:= 0
	Private nPos2		:= 0
	Private nPos3		:= 0
	Private nPos4		:= 0
	Private cPesq 		:= Space(6)
	Private oWBrowse1
	Private aWBrowse1	:= {}
	Static oDlg

	
	
	aAdd( aObjects, { 100, 100, .T., .F. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	nPos1 	:= aPosObj[1,1]
	nPos2 	:= aPosObj[1,2]
	nPos3 	:= aPosObj[1,3]*2.5
	nPos4 	:= aPosObj[1,4]
                                                                                                          
	aAdd(aWBrowse1,{"","","","","","","","","","",""})
	aAdd(aButtons,{"RELATORIO",{|| 	MsAguarde( { || leest()} )}	,"Excel"})

	DEFINE MSDIALOG oDlg TITLE "Pesquisa situação da OS" FROM aSize[7],0 TO aSize[6], aSize[5] COLORS 0, 16777215 PIXEL
	oDlg:lMaximized := .T.
	EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aButtons)
	@ 015, 005 MSGET oPesq VAR cPesq PICTURE "@!" SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton1 FROM 015, 250 TYPE 15 OF oDlg ENABLE ACTION lqest()
	@ nPos1+30, nPos2 LISTBOX oWBrowse1 Fields HEADER "Os","Codigo","Nome","Pais","Pedido","Produto","Item","Venda","Valor","PBruto","PLiqui" SIZE nPos4-05, nPos3-20 OF oDlg PIXEL ColSizes 50,150,50,50
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {aWBrowse1[oWBrowse1:nAt,1],aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3],aWBrowse1[oWBrowse1:nAt,4],;
		aWBrowse1[oWBrowse1:nAt,5],aWBrowse1[oWBrowse1:nAt,6],aWBrowse1[oWBrowse1:nAt,7],aWBrowse1[oWBrowse1:nAt,8],aWBrowse1[oWBrowse1:nAt,9],aWBrowse1[oWBrowse1:nAt,10],aWBrowse1[oWBrowse1:nAt,11]}}
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return


/*/{Protheus.doc} lqest
//TODO CARREGA OS DADOS A SEREM EXIBIDOS NA TELA.
@author rafael.custodio
@since 28/11/2018
@type function
/*/
Static Function lqest()
	Local cQuery 	:= ""
	Local cEnter 	:= Chr(13)
	
	If alltrim(cPesq) == '' 
	
	MsgAlert("Informar os a faturar","VAZIO!")
	
		Else
			cQuery += " SELECT 	C9_ORDSEP AS 'OS'	,"	+cEnter																													
			cQuery += " A1_COD 			AS 'CODIGO' 	,"+cEnter 
				cQuery += " A1_NOME 			AS 'NOME'		,"+cEnter 
				cQuery += " A1_MUN		AS 'PAIS' 			,"							 
					cQuery += " C6_NUM 			AS 'PEDIDO' 	,"+cEnter 
					cQuery += " C6_PRODUTO 		AS 'PRODUTO' 	," 
						cQuery += " C6_ITEM 		AS 'ITEM' 			,"							
						cQuery += " C6_QTDVEN 		AS 'VENDA' 		,"+cEnter 
							cQuery += " C6_VALOR AS 'VALOR'," 							
							cQuery += " CB0_PESOB 	AS 'PBRUTO' 	,"+cEnter 
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
				cQuery += " WHERE  C9_ORDSEP = '"+Alltrim(cPesq)+"' AND SC6.D_E_L_E_T_='' "+cEnter	
				cQuery += " GROUP BY C9_ORDSEP, A1_COD, A1_NOME, A1_MUN , C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, C6_VALOR, CB0_PESOB,CB0_PESOL"+cEnter
			cQuery += " ORDER BY ITEM "
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"QRY", .F., .T.)
		aWBrowse1 := {}
		QRY->( DbGoTop() )
		If QRY->( !Eof() )
			While QRY->( !Eof() )
				Aadd(aWBrowse1,;
					{QRY->OS,;
					QRY->CODIGO,;
					QRY->NOME,;
					QRY->PAIS,;
					QRY->PEDIDO,;
					QRY->PRODUTO,;
					QRY->ITEM,;
					QRY->VENDA,;
					QRY->VALOR,;
					QRY->PBRUTO,;
					QRY->PLIQUI})
					 
				QRY->( DbSkip() )
			Enddo
		Else
			Aadd(aWBrowse1,{"","","","","","","","","","",""})
		EndIf

		oWBrowse1:SetArray(aWBrowse1)
		oWBrowse1:bLine := {|| {aWBrowse1[oWBrowse1:nAt,1],aWBrowse1[oWBrowse1:nAt,2],aWBrowse1[oWBrowse1:nAt,3],aWBrowse1[oWBrowse1:nAt,4],;
			aWBrowse1[oWBrowse1:nAt,5],aWBrowse1[oWBrowse1:nAt,6],aWBrowse1[oWBrowse1:nAt,7],aWBrowse1[oWBrowse1:nAt,8],aWBrowse1[oWBrowse1:nAt,9],aWBrowse1[oWBrowse1:nAt,10],aWBrowse1[oWBrowse1:nAt,11]}}
    
		QRY->( DbCloseArea() )
	endif

Return Nil

 
