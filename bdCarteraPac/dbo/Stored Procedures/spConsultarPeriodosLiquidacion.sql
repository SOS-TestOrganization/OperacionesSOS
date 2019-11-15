/*------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		dbo.spConsultarPeriodosLiquidacion							
* Desarrollado por	: <\A	Francisco Eduardo Riaño L - Qvision S.A	          A\>	
* Descripción		: <\D	Procedimento almacenado que realiza la consulta de los periodos activos de liquidacion 
							del usuario logueado para la fecha actual D\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/07/18	FC\>
*------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*------------------------------------------------------------------------------------------------------------------------------
* Modificado Por     : <\AM Francisco Eduardo Riaño L - Qvision S.A  AM\>    
* Descripcion        : <\D  D\> 
* Nuevas Variables   : <\VM  VM\>    
* Fecha Modificacion : <\FM 2019/07/18  FM\>    
*------------------------------------------------------------------------------------------------------------------------------*/

-- exec [BDCarteraPAC].[dbo].[spConsultarPeriodosLiquidacion]

CREATE PROCEDURE  [dbo].[spConsultarPeriodosLiquidacion]

As
Begin

	Set NoCount On;

	Declare		--@fcha_actl datetime = convert(datetime,'2019-12-01 00:00:00'),
				@fcha_actl											datetime = getdate(), 
				@nmroAnios											int = 0,
				@fechaPeriodoActual									datetime =DATEADD (month , 1, getdate()),
				@parametroMesesAnteriores							int,
				@lnCodigoParametroGeneralMesesPeriodosAnteriores	varchar(15) = '20'
	
	-- se trae el parametro de numero de meses a consultar anteriores
	select @parametroMesesAnteriores = vlr_prmtro_nmrco - 1
	from dbo.tbParametrosGenerales_Vigencias a with(nolock)
	where cdgo_prmtro_gnrl = @lnCodigoParametroGeneralMesesPeriodosAnteriores

	-- Si el mes actual es diciembre se permitira facturas del siguiente año
	If month(@fcha_actl) = 12
		set @nmroAnios = 1

	Select	a.cnsctvo_cdgo_prdo_lqdcn, 
			a.dscrpcn_prdo_lqdcn ,
			case when (bdrecaudos.dbo.fncalculaperiodo(@fechaPeriodoActual)	  > = 	bdrecaudos.dbo.fncalculaperiodo(a.fcha_incl_prdo_lqdcn)
			And		bdrecaudos.dbo.fncalculaperiodo(@fechaPeriodoActual)	   <= 	bdrecaudos.dbo.fncalculaperiodo(a.fcha_fnl_prdo_lqdcn)) then 'S' else 'N' end as periodo_actual
	From	[dbo].[tbPeriodosliquidacion_Vigencias] a with(nolock)
	Where	a.fcha_fnl_prdo_lqdcn between DATEADD(MM, -@parametroMesesAnteriores,@fcha_actl) and DATEADD(YY,@nmroAnios,DATEADD(MM, (13 - month(@fcha_actl)),@fcha_actl))
	And		@fcha_actl between a.inco_vgnca and a.fn_vgnca

End
