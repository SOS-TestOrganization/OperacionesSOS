/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpActualizaEstadoEstadoCuentaManual
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento actualiza el estado del estado de cuenta manual					D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/03/04											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE SpActualizaEstadoEstadoCuentaManual
	
	@lnNumeroEstadoCuentaManual			varchar(15),
	@lnConsecutivoEstadoEstadoCuenta		udtConsecutivo,
	@lcUsuario					udtUsuario,
	@lnProcesoExitoso				int		output,
	@lcMensaje					char(200)	output

As	

	
Set Nocount On		

Begin Tran Uno

Set	@lnProcesoExitoso	=	0
Update 	tbcuentasManuales
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	@lnConsecutivoEstadoEstadoCuenta
Where 	nmro_estdo_cnta		=	@lnNumeroEstadoCuentaManual
			
If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error Actualizando estado del estado de cuenta Manual'
			Rollback tran uno
			Return -1
		end	

Commit tran uno