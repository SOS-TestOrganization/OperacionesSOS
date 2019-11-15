

/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmValidaNumeroAutorizacion 
* Desarrollado por		: <\A Ing. Álvaro Zapata					A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2006/08/31  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM 				*					AM\>
* Descripción			: <\DM									DM\>
* 				: <\DM									DM\>
* Nuevos Parámetros		: <\PM  							>
* Nuevas Variables		: <\VM  									VM\>
* Fecha Modificación		: <\FM									FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE           procedure [dbo].[spPmValidaNumeroAutorizacion]
@cdgo_ofcna			char(5),
@nmro_log  			numeric(18),
@cnsctvo_cdgo_tpo_idntfccn 	Int,
@nmro_idntfccn 		Varchar(23)


AS

--Set	@cdgo_ofcna 	= '01'
--Set	@nmro_log	= '1314900'

declare
@fcha		Datetime,
@dia		int,
@vlr_prmtro	Int


Set NoCount ON

Declare 
@tbNumeroAutorizacion Table(
fcha_vldcn	Datetime,
existe		Char default 'N',
cnsctvo_estdo_drcho		Int
)

Declare
@cnsctvo_cdgo_ofcna udtConsecutivo

Select	@cnsctvo_cdgo_ofcna 	= cnsctvo_cdgo_ofcna
From	bdAfiliacionValidador.dbo.tbOficinas_vigencias
Where	cdgo_ofcna  		= @cdgo_ofcna

If	(Select ltrim(rtrim(vlr_prmtro))
	From	dbo.tbtablaParametros
	Where	cnsctvo_prmtro	in (4))	= ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- atenea
		
	or

	(Select ltrim(rtrim(vlr_prmtro))
	From	dbo.tbtablaParametros
	Where	cnsctvo_prmtro	in (5))	= ltrim(rtrim(CONVERT(varchar(30), SERVERPROPERTY('machinename')))) -- temis


	Begin

			If exists (Select 1 From bdIPSIntegracion.dbo.tbLog
					Where 	cnsctvo_cdgo_ofcna		= @cnsctvo_cdgo_ofcna
					And	nmro_vrfccn			= @nmro_log
					And	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
					And	nmro_idntfccn			= @nmro_idntfccn)
				Begin	
					Insert Into @tbNumeroAutorizacion (fcha_vldcn, existe, cnsctvo_estdo_drcho)
					Select	Convert(char(10),fcha_vldcn,111), 'S', cnsctvo_cdgo_estdo_afldo 
					From	bdIPSIntegracion.dbo.tbLog
					Where 	cnsctvo_cdgo_ofcna		= @cnsctvo_cdgo_ofcna
					And	nmro_vrfccn			= @nmro_log
					And	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
					And	nmro_idntfccn			= @nmro_idntfccn
				End
			Else
				Begin
					Insert Into @tbNumeroAutorizacion (fcha_vldcn, existe, cnsctvo_estdo_drcho)
					Select	Null, 'N', 0 
				End

			--Calcula la "fecha hasta" la cual tiene vigencia el reporte
			Select @fcha = dbo.fnCalcularFechaReporteValidadorDerechos(fcha_vldcn) from @tbNumeroAutorizacion
			--select @fcha

			/*
			--Calcula en días la diferencia de la fecha del reporte (de acuerdo a la fecha de validación) con la fecha actual 
			Select @dia = datediff(dd,@fcha,getdate())
			--Select @dia

			Select	@vlr_prmtro	= vlr_prmtro
			From	tbTablaParametroValidacion_vigencias
			where	cnsctvo_prmtro = 1 --valor del parametro 5*/

			--Select *, @dia as dia, @vlr_prmtro as vlr_prmtro From @tbNumeroAutorizacion
			Select *,  @fcha as fcha_mxma_cmprbnte, @cnsctvo_cdgo_ofcna as cnsctvo_cdgo_ofcna From @tbNumeroAutorizacion

	END

Else

	Begin
		If exists (Select 1 From bdSisalud.dbo.tbLog
				Where 	cnsctvo_cdgo_ofcna		= @cnsctvo_cdgo_ofcna
				And	nmro_vrfccn			= @nmro_log
				And	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
				And	nmro_idntfccn			= @nmro_idntfccn)
			Begin	
				Insert Into @tbNumeroAutorizacion (fcha_vldcn, existe, cnsctvo_estdo_drcho)
				Select	Convert(char(10),fcha_vldcn,111), 'S', cnsctvo_cdgo_estdo_afldo 
				From	bdSisalud.dbo.tbLog
				Where 	cnsctvo_cdgo_ofcna		= @cnsctvo_cdgo_ofcna
				And	nmro_vrfccn			= @nmro_log
				And	cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
				And	nmro_idntfccn			= @nmro_idntfccn
			
			End
		Else
			Begin
				Insert Into @tbNumeroAutorizacion (fcha_vldcn, existe, cnsctvo_estdo_drcho)
				Select	Null, 'N', 0 
			End

		--Calcula la "fecha hasta" la cual tiene vigencia el reporte
		Select @fcha = dbo.fnCalcularFechaReporteValidadorDerechos(fcha_vldcn) from @tbNumeroAutorizacion
		--select @fcha

		/*
		--Calcula en días la diferencia de la fecha del reporte (de acuerdo a la fecha de validación) con la fecha actual 
		Select @dia = datediff(dd,@fcha,getdate())
		--Select @dia

		Select	@vlr_prmtro	= vlr_prmtro
		From	tbTablaParametroValidacion_vigencias
		where	cnsctvo_prmtro = 1 --valor del parametro 5*/

		--Select *, @dia as dia, @vlr_prmtro as vlr_prmtro From @tbNumeroAutorizacion
		Select *,  @fcha as fcha_mxma_cmprbnte, @cnsctvo_cdgo_ofcna as cnsctvo_cdgo_ofcna From @tbNumeroAutorizacion

	END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaNumeroAutorizacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

