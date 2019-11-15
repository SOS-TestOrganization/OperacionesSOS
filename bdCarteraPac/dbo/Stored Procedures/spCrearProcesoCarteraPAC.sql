/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spCrearProcesoCarteraPAC
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite generar un proceso de cartera D\>
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
*--------------------------------------------------------------------------------- */
CREATE procedure dbo.spCrearProcesoCarteraPAC
(
	@cnsctvo_cdgo_tpo_prcso int,
	@usuario				udtUsuario,
	@cnsctvo_prcso			int output
)
as
begin
	set nocount on;

	declare		@fechaActual datetime = getdate();

	begin try

		Select		@cnsctvo_prcso	= IsNull(cnsctvo_prcso,0) + 1
		From		dbo.tbProcesosCarteraPac with(nolock);

		Insert	
		Into		dbo.tbProcesosCarteraPac
					(
						cnsctvo_prcso,		
						cnsctvo_cdgo_tpo_prcso,
						fcha_inco_prcso,	
						fcha_fn_prcso,
						usro_crcn
					)
		Values		(
						@cnsctvo_prcso,
						@cnsctvo_cdgo_tpo_prcso,
						@fechaActual,	
						NULL,
						@usuario
					);
	end try
	begin catch
		throw 51000,'Error Insertando el inicio del proceso',1
	end catch
end