#include 'protheus.ch'
#include 'parmtype.ch'

user function CALC()
Private nV1 := 0
Private oV1 := 0
Private oV2 := 0
Private nV2 := 0

	
	DEFINE DIALOG oDlg TITLE "CALCULADORA ADVPL" FROM 180,180 TO 550,700 PIXEL
   
  nRadio := 1
  aItems := {'(+) ADIÇÃO','(-) SUBTRAÇÃO','(*) MULTIPLICAÇÃO','(/) DIVISÃO'}
  
@ 02,009 SAY "Valor 1" SIZE 100, 10 OF oDlg PIXEL
@ 02,045 MSGET oV1 Var nV1   PICTURE "@E 999,999.99" SIZE 50, 10 OF oDlg PIXEL  when .T.
@ 20,009 SAY "Valor 2" SIZE 100, 10 OF oDlg PIXEL
@ 20,045 MSGET oV2 Var nV2   PICTURE "@E 999,999.99" SIZE 50, 10 OF oDlg PIXEL  when .T.
  
  oRadio := TRadMenu():New (50,09,aItems,,oDlg,,,,,,,,100,12,,,,.T.)
  oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}  //120
  oBtn := TButton():New( 100, 002, 'Calcular',oDlg,{|| calculo() }, 100,010,,,.F.,.T.,.F.,,.F.,,,.F. )
  DEFINE SBUTTON FROM 100, 120 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
  ACTIVATE DIALOG oDlg CENTERED
	
	
return

Static Function calculo()
local nResult := 0

	If nRadio == 1
	nResult := nV1 + nV2
	MsgAlert(cValToChar(nResult), "Resultado Adição")
		Elseif nRadio == 2
		nResult := nV1 - nV2
		MsgInfo(cValToChar(nResult), "Resultado Subtração")
			Elseif nRadio == 3
			nResult := nV1 * nV2
			MsgInfo(cValToChar(nResult), "Resultado multiplicação")
				Elseif nRadio == 4
				nResult := nV1 / nV2
				MsgInfo(cValToChar(nResult), "Resultado Divisão")
	EndIf

Return
