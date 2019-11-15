
---------------------------------------------------
/*---------------------------------------------------------------------------------
* Metodo o PRG 			:  SpGrabarFechaImpresionEstadoCuentaManual
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
CREATE              PROCEDURE SpGrabarFechaImpresionEstadoCuentaManual
	@lnImpreso			char(1),
	@lcUsuarioCreacion		udtUsuario
	
As	

SET NOCOUNT ON

begin tran  
	update 	tbCuentasManuales 
	set 	fcha_imprsn=getdate(),
	 	imprso	   	='S',
		usro_imprsn	=@lcUsuarioCreacion
	from 	tbCuentasManuales a 
	inner 	Join #TMP_EstadosCuentaFinal b 
	on 	a.nmro_estdo_cnta=b.nmro_estdo_cnta
	where 	(a.imprso = 'N' or a.imprso is null)
	drop table #TMP_EstadosCuentaFinal
commit tran
