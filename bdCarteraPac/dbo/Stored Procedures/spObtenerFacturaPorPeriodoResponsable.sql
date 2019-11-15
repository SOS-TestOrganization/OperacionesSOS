/*------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		dbo.spObtenerFacturaPorPeriodoResponsable							
* Desarrollado por	: <\A	Francisco Eduardo Riaño L - Qvision S.A	          A\>	
* Descripción		: <\D	Procedimento almacenado que realiza la consulta de las facturas
							asociadas a un responsable de pago - carteraweb D\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	nmro_idntfccn, cdgo_tpo_idntfccn, periodo P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/09/24	FC\>
*------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION    
*------------------------------------------------------------------------------------------------------------------------------
* Modificado Por     : <\AM		AM\>    
* Descripcion        : <\D		D\> 
* Nuevas Variables   : <\VM		VM\>    
* Fecha Modificacion : <\FM		FM\>    
*------------------------------------------------------------------------------------------------------------------------------*/

-- exec [BdCarteraPAC].[dbo].[spObtenerFacturaPorPeriodoResponsable] '900092385', 9, '2019-09-01'

CREATE PROCEDURE  [dbo].spObtenerFacturaPorPeriodoResponsable
(
	@nmro_idntfccn		UdtNumeroIdentificacion,
	@cdgo_tpo_idntfccn	udtConsecutivo,
	@periodo			varchar(15)
)

As
Begin

	Set NoCount On;

	Declare		@fechaActual					datetime		= getdate(),
				@lnTipoIdentificacionPersona	udtconsecutivo	= 1,
				@nmro_unco_idntfccn				udtconsecutivo,
				@cnsctvo_cdgo_prdo_lqdcn		udtConsecutivo,
				@dscrpcn_prdo_lqdcn				udtDescripcion;

	create table #facturasResponsable
				(
				cnsctvo_estdo_cnta	udtConsecutivo,
				nmro_estdo_cnta		nvarchar(15),
				dscrpcn_prdo_lqdcn	nvarchar(150),
				ttl_pgr				udtValorGrande,				
				);

	select		@nmro_unco_idntfccn = nmro_unco_idntfccn 
	from		BDAfiliacion.dbo.tbVinculados with(nolock)
	where		nmro_idntfccn = @nmro_idntfccn 
	and			cnsctvo_cdgo_tpo_idntfccn = @cdgo_tpo_idntfccn

	insert into	#facturasResponsable
	(
				cnsctvo_estdo_cnta,
				nmro_estdo_cnta,
				dscrpcn_prdo_lqdcn,
				ttl_pgr
	)
	select		cnsctvo_estdo_cnta,
				ltrim(rtrim(a.nmro_estdo_cnta)) as nmro_estdo_cnta,
				ltrim(rtrim(c.dscrpcn_prdo_lqdcn)) as dscrpcn_prdo_lqdcn,
				a.ttl_pgr	
	from		dbo.tbEstadosCuenta					a with(nolock)
	inner join	dbo.tbLiquidaciones					b with(nolock)
		on		a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
	inner join	dbo.tbPeriodosliquidacion_Vigencias c with(nolock)
		on		b.cnsctvo_cdgo_prdo_lqdcn = c.cnsctvo_cdgo_prdo_lqdcn	
	where		@fechaActual between c.inco_vgnca and c.fn_vgnca
	And         c.fcha_incl_prdo_lqdcn		= @periodo
	And			a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn

	select		cnsctvo_estdo_cnta,
				nmro_estdo_cnta,
				dscrpcn_prdo_lqdcn,
				ttl_pgr
	from		#facturasResponsable;

End