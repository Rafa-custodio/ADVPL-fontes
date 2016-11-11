#include 'protheus.ch'
#include 'parmtype.ch'
//Fun��o que cria arquivo TXT e verifica se o arquivo realmente foi criado.
//Adaptada por Rafael Custodio 11/11/2016
user function GERATXT()

Local cDir    := "C:\"
Local cArq    := "Arquivo_teste.txt"

//�FCreate - � o comando responsavel pela cria��o do arquivo.                                                         �

Local nHandle := FCreate(cDir+cArq)
Local nCount  := 0


//�nHandle - A fun��o FCreate retorna o handle, que indica se foi poss�vel ou n�o criar o arquivo. Se o valor for     �
//�menor que zero, n�o foi poss�vel criar o arquivo.                                                                  �


If nHandle < 0
	MsgAlert("Erro durante cria��o do arquivo.", "Erro!")
Else
	
	//�FWrite - Comando reponsavel pela grava��o do texto.                                                                �
	
	For nLinha := 1 to 50
		FWrite(nHandle, "Gravando linha " + StrZero(nLinha, 2) + CRLF)
	Next nLinha
	
	//�FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       �

	FClose(nHandle)
EndIf

	If FILE("C:\Arquivo_teste.txt")
		MsgInfo("Arquivo Texto criado no seguinte caminho: " + cValToChar(cDir) + cValToChar(cArq))
	Else 
		Alert("N�o foi poss�vel localizar o arquivo texto.", "Erro!")
	EndIf
	
return