#include 'protheus.ch'
#include 'parmtype.ch'

//Função que cria arquivo TXT e verifica se o arquivo realmente foi criado.
//Adaptada por Rafael Custodio 11/11/2016
user function GERATXT()

Local cDir    := "C:\"
Local cArq    := "Teste_Arquivo.txt"

//³FCreate - É o comando responsavel pela criação do arquivo.                                                         ³

Local nHandle := FCreate(cDir+cArq)
Local nCount  := 0


//³nHandle - A função FCreate retorna o handle, que indica se foi possível ou não criar o arquivo. Se o valor for     ³
//³menor que zero, não foi possível criar o arquivo.                                                                  ³


If nHandle < 0
	MsgAlert("Erro durante criação do arquivo.", "Erro!")
Else
	
	//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
	
	For nLinha := 1 to 50
		FWrite(nHandle, "Gravando linha " + StrZero(nLinha, 2) + CRLF)
	Next nLinha
	
	//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³

	FClose(nHandle)
EndIf

	If FILE("C:\Arquivo_teste.txt")
		MsgInfo("Arquivo Texto criado no seguinte caminho: " + cValToChar(cDir) + cValToChar(cArq))
	Else 
		Alert("Não foi possível localizar o arquivo texto.", "Erro!")
	EndIf
	
return
