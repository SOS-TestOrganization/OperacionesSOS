/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spCalcularConsecutivoParaEstadoCuentaManual
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite calcula el consecutivo que sera utilizado en un nuevo estado de cuenta manual D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/04/30 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
declare	@valorActua int
exec	dbo.spCalcularConsecutivoParaEstadoCuentaManual @valorActua output
select	@valorActua
--------------------------------------------------------------------------------*/
CREATE procedure dbo.spCalcularConsecutivoParaEstadoCuentaManual
(
	@valorActual int output
)
as
begin
	set nocount on;

	declare		@fechaActual datetime = getdate(),
				@valorAnterior int;

	begin try

		--Se consulta el consecutivo actual del estado de cuenta y consecutivo anterior		
		Select	@valorActual = Isnull(vlr_actl,0) + 1,
				@valorAnterior	= vlr_actl
		From	bdCarteraPac.dbo.tbTiposConsecutivo_Vigencias
		Where	cnsctvo_cdgo_tpo_cnsctvo = 1  -- consecutivos de estado de cuenta

		--Actualizamos el consecutivo del estado  de cuenta
		Update	dbo.tbTiposConsecutivo_Vigencias
		Set		vlr_actl	= @valorActual,
				vlr_antrr	= @valorAnterior
		Where	cnsctvo_cdgo_tpo_cnsctvo = 1
		
	end try
	begin catch
		throw 51000,'Error Actualizando el tipo de consecutivo',1
	end catch
end