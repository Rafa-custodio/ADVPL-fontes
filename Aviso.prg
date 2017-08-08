#protheus.ch

user function Aviso()
Local nOpc := 0

nOpc := Aviso( "www.custodioti.com.br", 'A Função AVIDO() mostra na tela opções disponíveis para o usuário.', { "Sim", "Não"}, ;
3, "Janela com AVISO e OPCOES",, '', .F., 50000 )


If nOpc == 1

MsgInfo( 'Sim', 'Função 01' )

ElseIf nOpc == 2

MsgInfo( 'Não', 'Função 02' )

Endif
//Código apenas demonstrativo para a função AVISO() do Protheus

Return( Nil )