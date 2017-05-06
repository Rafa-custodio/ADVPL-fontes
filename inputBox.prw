#include 'protheus.ch'
#include 'parmtype.ch'

/***********************************************************
****Fun��o que retorna uma caixa para o usu�rio digitar algo
****Autor: Rafael Custodio
****Data: 05/05/2017
************************************************************/

user function inputBox()
	Local oError := ErrorBlock({|e|ChecErro(e)}) //Exibir erro
	Local cRetorno := ""

	cRetorno := FWInputBox("Linguagem de programa��o usada no Protheus?", "")
	
	if(UPPER(cRetorno) == "ADVPL")
	
		MsgInfo("Parab�ns! Voc� acertou! **" + cRetorno + "**", "CORRETO")
			Else
				MsgAlert("N�o foi desta vez :(", "SAIR")
	EndIf
		

	ErrorBlock(oError)
return