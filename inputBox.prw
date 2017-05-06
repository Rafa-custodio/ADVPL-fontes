#include 'protheus.ch'
#include 'parmtype.ch'

/***********************************************************
****Função que retorna uma caixa para o usuário digitar algo
****Autor: Rafael Custodio
****Data: 05/05/2017
************************************************************/

user function inputBox()
	Local oError := ErrorBlock({|e|ChecErro(e)}) //Exibir erro
	Local cRetorno := ""

	cRetorno := FWInputBox("Linguagem de programação usada no Protheus?", "")
	
	if(UPPER(cRetorno) == "ADVPL")
	
		MsgInfo("Parabéns! Você acertou! **" + cRetorno + "**", "CORRETO")
			Else
				MsgAlert("Não foi desta vez :(", "SAIR")
	EndIf
		

	ErrorBlock(oError)
return