
/*---------------------------------------------------------------------------------
* Metodo o PRG		: spPasoSuspensionxMoraPAC
* Desarrollado por  : <\A Diana Lorena Gomez    A\>
* Descripcion		: <\D Ejecuta el proceso de suspension x Mora para Planes Complementarios en el tren díario y el mensual de procesos D\>
* Observaciones		: <\O O\>
* Parametros		: <\P  P\>
* Variables			: <\V                V\>
* Fecha Creacion	: <\FC 2010/05/31           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM Janeth Barrera  AM\>
* Descripcion			 : <\DM Se incluye la lectura del parametro @lnDiaProceso que indica el dia de ejecucion del proceso el cual es administrado por el usuario DM\>
* Nuevos Parametros	 	 : <\PM PM\>
* Nuevas Variables		 : <\VM VM\>
* Fecha Modificacion	 : <\FM 2016/11/03 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spPasoSuspensionxMoraPAC]
As
Set Nocount on

declare 
@dia						int,
@Fecha_Proceso				Datetime,		
@lcUsuario					udtusuario,
@procesoejecutado           int,
@lnDiaProceso				int


select	@lnDiaProceso = vlr_prmtro_nmrco
from	tbparametrosgenerales_vigencias
where	getdate() between inco_vgnca and fn_vgnca
and		cnsctvo_cdgo_prmtro_gnrl	= 8


-- Sino logra recuperar el dia de ejecucion del proceso
if @lnDiaProceso is null
Begin
	select 'No existe el parametro vigente Dia proceso suspension pac'
	return
End


select @dia= DAY(Getdate()) 

--- SE VERIFICA SI YA PASO EL DIA DEL PROCESO Y NO SE HA EJECUTADO EL PROCESO PARA QUE SE EJECUTE

set @procesoejecutado = (	Select count(*) 
							From	dbo.tbProcesosCarteraPac
							Where	cnsctvo_cdgo_tpo_prcso						= 49
							And		cnsctvo_prcso								= (Select max(cnsctvo_prcso) from dbo.tbProcesosCarteraPac where cnsctvo_cdgo_tpo_prcso = 49 )
							And		bdrecaudos.dbo.fncalculaperiodo(getdate())	=  bdrecaudos.dbo.fncalculaperiodo(fcha_inco_prcso))

if @dia = @lnDiaProceso
	Begin
		Set @Fecha_Proceso 	=	Getdate()
		Set @lcUsuario 		=	'admcarpac01' 
        Execute  SpSuspencionContratosXMoraPac   @Fecha_Proceso, @lcUsuario              
	End
else
	if @dia > @lnDiaProceso and @procesoejecutado = 0
	begin
			Set @Fecha_Proceso 	=	Getdate()
			Set @lcUsuario 		=	'admcarpac01' 
			
			Execute  SpSuspencionContratosXMoraPac   @Fecha_Proceso, @lcUsuario    
	end



