
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  spValidarResolucionVigenteDIAN
* Desarrollado por		: <\A Francisco Eduardo Riaño L - Qvision S.A	A\>
* Descripcion			: <\D Este procedimiento valida que al la fecha exista una 
							resolución vigente para la generación de facturas PAC	D\>
* Observaciones			: <\O  	O\>
* Parametros			: <\P	P\>
* Variables				: <\V  	V\>
* Fecha Creacion		: <\FC 2019/05/16	FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spValidarResolucionVigenteDIAN]
(	
	@lnProcesoExitoso				varchar(1)	output
)
As	
Begin
	Set Nocount On;

	Declare		@fechaActual			datetime = getDate(),
				@resolucionValida		varchar(1) = 'N',
				@codigoResolucionPAC	varchar(2) = '02',
				@validoSI				varchar(1) = 'S',
				@validoNO				varchar(1) = 'N'

	Set @lnProcesoExitoso = @validoSI;

	Select  @resolucionValida = @validoSI
	From	BDAfiliacionValidador.dbo.tbResolucionesDIAN_Vigencias a
	Where	@fechaActual between a.inco_vgnca and a.fn_vgnca
	And		@fechaActual between a.fcha_inco_atrzn_fctrcn and a.fcha_fn_atrzcn_fctrcn
	And     cdgo_rslcn_dn = @codigoResolucionPAC

	If  @resolucionValida = @validoNO
	Begin
		Set @lnProcesoExitoso = @validoNO;
		;Throw	51000,@lnProcesoExitoso,1
	End

End