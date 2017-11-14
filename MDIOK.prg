//[09:20, 7/11/2017] +55 61 9131-9725: //Program U_MDIOK.PRG//
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
    If !( lMdiOk := ( __cUserId == "000000" .OR. __cUserId == "000111" .OR. __cUserId == "000145" ) ) //Administrador
        Alert("Usuário sem permissão para usar o SigaMDI, favor mudar para SigaADV","MdiOk")
        Break
    EndIf

End Sequence

Return( lMdiOk )
//[09:20, 7/11/2017] +55 61 9131-9725: o Nome do PE é MDIOK