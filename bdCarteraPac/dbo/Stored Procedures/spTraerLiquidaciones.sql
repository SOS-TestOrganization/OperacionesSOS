
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerLiquidaciones
* Desarrollado por	: <\A Ing. Rolando Simbaqueva Lasso						A\>
* Descripcion		: <\D Retorna los datos de las liquidaciones			D\>
* Observaciones		: <\O  													O\>
* Parametros		: <\P Fecha a la cual se valida la vigencia				P\>
					<\P consecutivo del promotor que se desea localizar		P\>				 
					<\P cadena de busqueda por descripcion					P\>				 
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2002/10/01	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por		: <\AM  Francisco E. Riaño - Qvision S.A AM\>
* Descripcion			: <\DM Se realzia ajuste para control de cambio de seleccion de periodo de liquidacion DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2018-07-18  FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure	[dbo].[spTraerLiquidaciones]
(
	@lConsecutivoLiquidacion	UdtConsecutivo	= Null,
	@lcEstadoPeriodo			udtConsecutivo	= Null
)
As	
Begin

	Set NoCount On;
	Declare		--@fcha_actl datetime = convert(datetime,'2019-12-01 00:00:00'),
				@fcha_actl											datetime = getdate(), 
				@nmroAnios											int = 0,
				@fechaPeriodoActual									datetime = DATEADD(month, 1, getdate()),
				@parametroMesesAnteriores							int,
				@lnCodigoParametroGeneralMesesPeriodosAnteriores	varchar(15) = '20'

	-- se trae el parametro de numero de meses a consultar anteriores
	select @parametroMesesAnteriores = vlr_prmtro_nmrco - 1
	from dbo.tbParametrosGenerales_Vigencias a with(nolock)
	where cdgo_prmtro_gnrl = @lnCodigoParametroGeneralMesesPeriodosAnteriores

	-- Si el mes actual es diciembre se permitira facturas del siguiente año
	If			month(@fcha_actl) = 12
	begin
				set	@nmroAnios = 1
	end

	select		a.cnsctvo_cdgo_lqdcn, 
				d.dscrpcn_tpo_prcso,
				c.dscrpcn_estdo_lqdcn,
				a.vlr_lqddo, 
				a.nmro_cntrts,
				a.nmro_estds_cnta,
				b.fcha_incl_prdo_lqdcn,
				b.fcha_fnl_prdo_lqdcn, 
				a.usro_crcn,
				d.cnsctvo_cdgo_tpo_prcso,
				c.cnsctvo_cdgo_estdo_lqdcn,
				a.obsrvcns,
				a.cnsctvo_cdgo_prdo_lqdcn
	from		dbo.tbliquidaciones a  with(nolock)
	inner join  dbo.TbTipoProceso d with(nolock)
	on			a.cnsctvo_cdgo_tpo_prcso 	= 	d.cnsctvo_cdgo_tpo_prcso
	inner join  dbo.tbEstadosLiquidacion c with(nolock)
	on    		a.cnsctvo_cdgo_estdo_lqdcn 	 = 	c.cnsctvo_cdgo_estdo_lqdcn
	inner join  dbo.tbPeriodosliquidacion_Vigencias b with(nolock)
	on	 		a.cnsctvo_cdgo_prdo_lqdcn	 = 	b.cnsctvo_cdgo_prdo_lqdcn 
	Where		a.cnsctvo_cdgo_estdo_lqdcn NOT IN (4,3)
	and			b.fcha_fnl_prdo_lqdcn between dateadd(MM, -@parametroMesesAnteriores,@fcha_actl) and dateadd(YY,@nmroAnios,dateadd(MM, (13 - month(@fcha_actl)),@fcha_actl))
	And			@fcha_actl between b.inco_vgnca and b.fn_vgnca
	and			a.cnsctvo_cdgo_lqdcn = isnull(@lConsecutivoLiquidacion,a.cnsctvo_cdgo_lqdcn);
	
End