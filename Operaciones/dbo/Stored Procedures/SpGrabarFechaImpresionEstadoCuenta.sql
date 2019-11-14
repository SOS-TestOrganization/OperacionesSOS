
-----------------------

/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  SpGrabarFechaImpresionEstadoCuenta
* Desarrollado por		: <\A Ing. Fernando Valencia E								A\>
* Descripcion			: <\D Este procedimiento Graba le fecha de impresión						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2007/03/02											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE               PROCEDURE SpGrabarFechaImpresionEstadoCuenta
	@lnImpreso			char(1),
	@lcUsuarioCreacion		udtUsuario
	
As	

SET NOCOUNT ON

begin tran  
	update 	tbestadoscuenta 
	set 	fcha_imprsn=getdate(),
	 	imprso	   	='S',
		usro_imprsn	=@lcUsuarioCreacion
	from 	tbestadoscuenta a 
	inner 	Join #TMP_EstadosCuentaFinal b 
	on 	a.nmro_estdo_cnta=b.nmro_estdo_cnta
	where 	(imprso = 'N' or imprso is null)
	drop table #TMP_EstadosCuentaFinal
commit tran
