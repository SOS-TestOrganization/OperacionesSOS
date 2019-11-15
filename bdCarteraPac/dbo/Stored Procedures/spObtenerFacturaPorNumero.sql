/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spObtenerFacturaPorNumero
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Obtener factura por numero D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/08/30 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	Francisco E. Riaño L - Qvision S.A AM\>
* Descripcion			: <\DM	Se adiciona el campo para traer la informacion del responsable de pago DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	nmbre_rspnsble VM\>
* Fecha Modificacion	: <\FM	2019-10-02 FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
exec [BDCarteraPAC].[dbo].spObtenerFacturaPorNumero 94525888
--------------------------------------------------------------------------------*/
CREATE procedure [dbo].spObtenerFacturaPorNumero
(
	@numeroFactura varchar(20)
)
as
begin	
	set nocount on;

	declare		@fechaActual datetime = getdate(),
				@consecutivoCodigoTipoNota_Debito smallint = 1,
				@consecutivoCodigoTipoNota_Credito smallint = 2,
				@consecutivoConceptoLiquidacion_Iva smallint = 3,
				@descripcionConceptoLiquidacion_Iva varchar(5) = 'IVA',
				@cdgo_tpo_idntfccn	udtConsecutivo,
				@numeroUnicoIdentificacion		udtConsecutivo;

	create 
	table		#tempResponsable 
				(
				nmbre_rspnsble varchar(250)
				);
	
	create 		
	table		#tmpDetalleFacturas
				(
				cnsctvo_estdo_cnta int,
				nmro_estdo_cnta nvarchar(15),
				dscrpcn_prdo_lqdcn nvarchar(150),
				vlr_cbrdo udtValorGrande,
				ttl_pgr udtValorGrande,
				cnsctvo_cdgo_cncpto_lqdcn udtConsecutivo,
				dscrpcn_cncpto_lqdcn nvarchar(150),
				cnsctvo_cdgo_pln udtConsecutivo,
				dscrpcn_pln nvarchar(150),
				nmro_unco_idntfccn_empldr udtConsecutivo,
				nmbre_rspnsble varchar(250)
				);

	create 		
	table		#tmpNotasEstadosCuenta
				(
				cnsctvo_estdo_cnta int,
				vlr udtValorGrande,
				cnsctvo_cdgo_tpo_nta udtConsecutivo
				);

	insert into #tmpDetalleFacturas
				(
				cnsctvo_estdo_cnta,
				nmro_estdo_cnta,
				dscrpcn_prdo_lqdcn,
				ttl_pgr,
				cnsctvo_cdgo_cncpto_lqdcn,
				vlr_cbrdo,
				nmro_unco_idntfccn_empldr
				)
	select		a.cnsctvo_estdo_cnta,
				ltrim(rtrim(a.nmro_estdo_cnta)) as nmro_estdo_cnta,
				ltrim(rtrim(c.dscrpcn_prdo_lqdcn)) as dscrpcn_prdo_lqdcn,
				a.ttl_pgr,
				d.cnsctvo_cdgo_cncpto_lqdcn,
				d.vlr_cbrdo,
				a.nmro_unco_idntfccn_empldr
	from		dbo.tbEstadosCuenta a with(nolock)
	inner join	dbo.tbEstadosCuentaConceptos d
	on			a.cnsctvo_estdo_cnta = d.cnsctvo_estdo_cnta
	inner join	dbo.tbLiquidaciones b with(nolock)
	on			a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
	inner join	dbo.tbPeriodosliquidacion_Vigencias c with(nolock)
	on			b.cnsctvo_cdgo_prdo_lqdcn = c.cnsctvo_cdgo_prdo_lqdcn		
	where		a.nmro_estdo_cnta = @numeroFactura
	and			@fechaActual between c.inco_vgnca and c.fn_vgnca
	and			d.cnsctvo_cdgo_cncpto_lqdcn != @consecutivoConceptoLiquidacion_Iva;

	select		top 1 @numeroUnicoIdentificacion = a.nmro_unco_idntfccn_empldr	
	from		#tmpDetalleFacturas a;	

	insert into #tempResponsable
	exec		[BDAfiliacion].[dbo].[spTraerNombreResponsablexNumIdentTipoIdent] @numeroUnicoIdentificacion;

	update      a
	set			a.nmbre_rspnsble =  (select top 1 nmbre_rspnsble from  #tempResponsable)
	from		#tmpDetalleFacturas a	

	update		a
	set			a.cnsctvo_cdgo_pln = d.cnsctvo_cdgo_pln,
				a.dscrpcn_pln = d.dscrpcn_pln,
				a.cnsctvo_cdgo_cncpto_lqdcn = e.cnsctvo_cdgo_cncpto_lqdcn,
				a.dscrpcn_cncpto_lqdcn = e.dscrpcn_cncpto_lqdcn				
	from		#tmpDetalleFacturas a	
	inner join	dbo.tbConceptosLiquidacion_Vigencias e
	on			e.cnsctvo_cdgo_cncpto_lqdcn = a.cnsctvo_cdgo_cncpto_lqdcn	
	inner join	BDProcesoBdd.dbo.tbPlanes_Vigencias d
	on			e.cnsctvo_cdgo_pln = d.cnsctvo_cdgo_pln	
	where		@fechaActual between e.inco_vgnca and e.fn_vgnca
	and			@fechaActual between d.inco_vgnca and d.fn_vgnca;

	insert into	#tmpNotasEstadosCuenta
				(
				cnsctvo_estdo_cnta,
				vlr,
				cnsctvo_cdgo_tpo_nta
				)
	select		a.cnsctvo_estdo_cnta,
				sum(b.vlr),
				b.cnsctvo_cdgo_tpo_nta
	from		#tmpDetalleFacturas a
	inner join	dbo.tbNotasEstadoCuenta b
	on			a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
	group by	a.cnsctvo_estdo_cnta,
				b.cnsctvo_cdgo_tpo_nta;

	update		a
	set			vlr_cbrdo =	case cnsctvo_cdgo_tpo_nta 
								when 1 then a.vlr_cbrdo + b.vlr 
								when 2 then a.vlr_cbrdo - b.vlr 
								else a.vlr_cbrdo
							end,
				ttl_pgr =	case cnsctvo_cdgo_tpo_nta 
								when 1 then a.ttl_pgr + b.vlr 
								when 2 then a.ttl_pgr - b.vlr 
								else a.vlr_cbrdo
							end 
	from		#tmpDetalleFacturas a
	inner join	#tmpNotasEstadosCuenta b
	on			a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta

	select		a.cnsctvo_estdo_cnta,
				a.nmro_estdo_cnta,
				a.dscrpcn_prdo_lqdcn,
				max(a.ttl_pgr) ttl_pgr,
				@consecutivoConceptoLiquidacion_Iva as cnsctvo_cdgo_cncpto_lqdcn,
				@descripcionConceptoLiquidacion_Iva as dscrpcn_cncpto_lqdcn,
				sum(a.vlr_cbrdo) * 0.05 vlr_cbrdo,
				a.cnsctvo_cdgo_pln,
				a.dscrpcn_pln,
				a.nmbre_rspnsble
	from		#tmpDetalleFacturas a			
	group by	a.cnsctvo_estdo_cnta,
				a.nmro_estdo_cnta,
				a.dscrpcn_prdo_lqdcn,			
				a.cnsctvo_cdgo_cncpto_lqdcn,
				a.dscrpcn_cncpto_lqdcn,		
				a.cnsctvo_cdgo_pln,
				a.dscrpcn_pln,
				a.nmbre_rspnsble
	union
	select		a.cnsctvo_estdo_cnta,
				a.nmro_estdo_cnta,
				a.dscrpcn_prdo_lqdcn,
				sum(a.ttl_pgr) ttl_pgr,
				a.cnsctvo_cdgo_cncpto_lqdcn,
				a.dscrpcn_cncpto_lqdcn,
				sum(a.vlr_cbrdo) vlr_cbrdo,
				a.cnsctvo_cdgo_pln,
				a.dscrpcn_pln,
				a.nmbre_rspnsble
	from		#tmpDetalleFacturas a			
	group by	a.cnsctvo_estdo_cnta,
				a.nmro_estdo_cnta,
				a.dscrpcn_prdo_lqdcn,			
				a.cnsctvo_cdgo_cncpto_lqdcn,
				a.dscrpcn_cncpto_lqdcn,		
				a.cnsctvo_cdgo_pln,
				a.dscrpcn_pln,
				a.nmbre_rspnsble;
end