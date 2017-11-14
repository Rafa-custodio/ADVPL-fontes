//Program U_MDIOK.PRG//
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa responsavel por bloquear o acesso por SIGAMDI     ³±±
±±³          ³ 													          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MdiOk()

Local lMdiOk


Begin Sequence

    //Permite o Acesso ao SIGAMDI apenas para o Administrador do Sistema
    If !( lMdiOk := ( __cUserId == "000000" .OR. __cUserId == "000111" .OR. __cUserId == "000145" ) ) //ID's permitidos
        Alert("Usuário sem permissão para usar o SigaMDI, favor mudar para<b> SigaADV</b>","MdiOk")
        Break
    EndIf

End Sequence

Return( lMdiOk )
