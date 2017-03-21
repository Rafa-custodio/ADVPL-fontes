#include 'protheus.ch'
#include 'parmtype.ch'

/***
*** Autor: Rafael Custodio
*** Descrição: Fonte desenvolvido para exemplificar o uso de IF e Operadores Maior e menor em ADVPL com Strings
***/

user function DIFERENC()
	// Preciso que a saída abaixo seja 1 ou 2.
	
	Local num1 := '2'
	
	if num1 < '1' .OR. num1 > '2'  //Mesmo sendo strings, o ADVPL consegue verificar se é maior ou menor.
		alert("Os numeros não conferem", "STRINGS")
	else 
		msgalert("YES - O numero é: " + cValToChar(num1), "CONFERIDO")
	
	endif
	
return