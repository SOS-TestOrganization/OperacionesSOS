

/*----------------------------------------------------------------------------------
* Metodo o PRG 		: spSSTraerSexo
* Desarrollado por		: <\A Ing. Roberto Rueda Naranjo  						A\>
* Descripcion			: <\D 									  	D\>
				  <\D .										D\>
* Observaciones			: <\O  										O\>
* Parametros			: <\P Codigo Interno								P\>
				  <\P Consecutivo de la Referencia						P\>
* Variables			: <\V  										V\>
* Fecha Creacion		: <\FC 2004/05/19								FC\>
*
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		              : <\AM	AM\>
* Descripcion			 : <\DM	DM\>
* Nuevos Parametros	 	 : <\PM	PM\>
* Nuevas Variables		 : <\VM	VM\>
* Fecha Modificacion		 : <\FM	FM\>
*---------------------------------------------------------------------------------*/

CREATE procedure [dbo].[spSSTraerSexo]

@ldFechaReferencia			datetime		= Null,
@lcCodigoSexo				udtCodigo		= Null,
@lcTraerTodosVisibleUsuario		udtLogico		= 'N'

AS

Set Nocount On

IF  @ldFechaReferencia IS NULL
	SET @ldFechaReferencia = GETDATE()

IF @lcCodigoSexo IS NULL
	SELECT	Substring(Ltrim(Rtrim(a.dscrpcn_sxo)),1,50) dscrpcn_sxo,
			a.cnsctvo_cdgo_sxo,
			a.cdgo_sxo
	FROM		bdAfiliacionValidador.dbo.tbSexos_Vigencias a
	WHERE	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
	AND		a.vsble_usro	= 'S'
ELSE
	SELECT	Substring(Ltrim(Rtrim(a.dscrpcn_sxo)),1,50) dscrpcn_sxo,
			a.cnsctvo_cdgo_sxo,
			a.cdgo_sxo
	FROM		bdAfiliacionValidador.dbo.tbSexos_Vigencias a
	WHERE	(@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)
	AND		a.vsble_usro	= 'S'
	AND		a.cdgo_sxo	= @lcCodigoSexo

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerSexo] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

