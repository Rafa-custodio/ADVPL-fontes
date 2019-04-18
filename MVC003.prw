#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Cadastro de albuns (Mod.3)"

/*/{Protheus.doc} MVC003
Exemplo de modelo 3 utilizando MVC
@type function
@author Rafael Custodio
@since 13/02/2019
@version 1.0
/*/
User Function MVC003()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZZB")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	oBrowse:AddLegend( "ZZB->ZZB_TIPO == '1'", "GREEN",	"CD" )
	oBrowse:AddLegend( "ZZB->ZZB_TIPO == '2'", "RED",	"DVD" )
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MVC003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MVC003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MVC003' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MVC003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

Static Function ModelDef()
	
	Local oModel 		:= MPFormModel():New("XMVC008", {|oModel| MdlPreVld(oModel)}, {|oModel| MdlPosVld(oModel)})
	Local oStPai 		:= FWFormStruct(1, 'ZZB')
	Local oStFilho 	:= FWFormStruct(1, 'ZZA')
	Local aZZARel		:= {}
	
	oStFilho:SetProperty('ZZA_FILIAL', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD, FWXFilial()) ) 
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('XMVC003')
	oModel:AddFields('ZZBMASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('ZZADETAIL','ZZBMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	
	// VALIDA��O NA ABERTURA DO MODELO
    oModel:SetVldActivate({|oModel| MdlActiveVld(oModel)})
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZZARel, {'ZZA_FILIAL',	'ZZB_FILIAL'} )
	aAdd(aZZARel, {'ZZA_CODALB',	'ZZB_COD'}) 
	
	
oModel:SetRelation('ZZADETAIL', { { 'ZZA_FILIAL', 'xFilial( "ZZA" )' }, { 'ZZA_CODALB', 'ZZB_COD' } }, ZZA->( IndexKey( 1 ) ) )
	oModel:GetModel('ZZADETAIL'):SetUniqueLine({"ZZA_FILIAL","ZZA_COD"})	//N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	
	oModel:SetPrimaryKey({"ZZA_FILIAL", ""})
	
	//Setando as descri��es
	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('ZZBMASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('ZZADETAIL'):SetDescription('Modelo Produtos')
Return oModel

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('MVC003')
	Local oStPai		:= FWFormStruct(2, 'ZZB')
	Local oStFilho	:= FWFormStruct(2, 'ZZA')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_ZZB',oStPai,'ZZBMASTER')
	oView:AddGrid('VIEW_ZZA',oStFilho,'ZZADETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',40)
	oView:CreateHorizontalBox('GRID',60)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZZB','CABEC')
	oView:SetOwnerView('VIEW_ZZA','GRID')
	
	//Incremento para o numero sequencial da musica
	oView:AddIncrementField('VIEW_ZZA' , 'ZZA_NUM' )
	
	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_ZZB','Grupo')
	oView:EnableTitleView('VIEW_ZZA','Produtos')
Return oView

// PR� VALIDA��O DO MODELO
Static Function MdlPreVld(oModel)
    Local lValid := MsgYesno("Continuar?", "MDL_PREVALID")

    // VALIDA SE o USU�RIO DESEJA CONTINUAR
    If (!lValid)
        Help(NIL, NIL, "MDL_PREVALID", NIL, "Opera��o abortada",;
                1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione SIM para continuar"})
    EndIF
Return (lValid)

// P�S VALIDA��O DO MODELO
Static Function MdlPosVld(oModel)
    
    Local nX      := 0                               // CONTROLE DO LA�O
    Local nCount  := 0                               // CONTADOR DE AUX�LIO
    Local lValid  := .T.                             // CONTROLE DA TRANSA��O
    Local aLines  := FwSaveRows()                    // ARMAZENA ESTADO DAS LINHAS
    Local oMdlZA2 := oModel:GetModel("MD_DETAILZZA") // GUARDA O SUBMODELO ZA2
	oModel := FWModelActive()
    // LA�O AT� A QUANTIDADE LINHAS
    For nX := 1 To oMdlZA2:Length()
        oMdlZA2:GoLine(nX) // POSICIONA NA LINHA REFERENTE AO CONTADOR

        // VERIFICA SE A LINHA EST� DELETADA E SE O TIPO � IGUAL A INT�RPRETE
        If (!oMdlZA2:IsDeleted() .And. AllTrim(oMdlZA2:GetValue("ZZA_COMP2")) == "")
            ++nCount
        EndIf

        // CASO HAJA MAIS DE UM INT�RPRETE, RETORNA ERRO
        If (nCount > 1)
            Help(NIL, NIL, "MDL_POSVALID", NIL, "Mais de um int�rprete por m�sica",;
                1, 0, NIL, NIL, NIL, NIL, NIL, {"Remova " + Lower(Extenso(nCount - 1, .T.)) +;
                IIf(nCount-1 > 1, " int�rpretes", " interprete")})

            lValid := .F.
        EndIf
    Next nX

    // RESTAURA O ESTADO ANTERIOR DAS LINAHS
    FwRestRows(aLines)
Return (lValid)

Static Function MdlActiveVld(oModel)
    Local lValid := .T.

    If (dDataBase != Date())
        Help(NIL, NIL, "MDL_ACTIVEVLD", NIL, "Data inv�lida",;
                1, 0, NIL, NIL, NIL, NIL, NIL, {"A data do Protheus est� divergente da data do sistema"})

        lValid := .F.
    EndIf
Return (lValid)
