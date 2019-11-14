/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spInsertarConceptosLiquidacion
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite inserta y actualizar conceptos de liquidacion D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/05/02 FC\>
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
--------------------------------------------------------------------------------*/
CREATE procedure dbo.spInsertarConceptosLiquidacion
(
	@ldFechaParametroConceptos		datetime,
	@cnsctvo_cdgo_prmtro_prgrmcn	int,
	@vlr_descuento					Numeric(12,2),
	@cnsctvo_cdgo_prdo				int,
	@ldFechaInicialFacturacion		datetime
)
as
begin
	set nocount on;

	declare @ldFechasistema datetime =  getdate();
	--se traen todos los conceptos y su grupo respectivo que se van a tener en cuanta para la liquidacion.
		--y que sean de e facturacion, notas, impuestos o descuentos , intereses		

		Insert Into	#tmpConceptosLiquidacion
		(
				cdgo_cncpto_lqdcn,		
				dscrpcn_cncpto_lqdcn,
				cnsctvo_cdgo_cncpto_lqdcn,	
				cnsctvo_cdgo_pln,
				cnsctvo_cdgo_tpo_mvmnto,	
				oprcn,
				cnsctvo_cdgo_grpo_lqdcn,	
				prcntje
		)
		Select		a.cdgo_cncpto_lqdcn,		
					a.dscrpcn_cncpto_lqdcn,
					a.cnsctvo_cdgo_cncpto_lqdcn,	
					a.cnsctvo_cdgo_pln,
					a.cnsctvo_cdgo_tpo_mvmnto,	
					a.oprcn,
					b.cnsctvo_cdgo_grpo_lqdcn,	
					b.prcntje
		From		dbo.tbConceptosLiquidacion_Vigencias	a With(NoLock)
		Inner Join	dbo.tbGruposxConcepto_Vigencias			b With(NoLock)
			On		a.cnsctvo_cdgo_cncpto_lqdcn	= b.cnsctvo_cdgo_cncpto_lqdcn
		Where		Datediff(Day,a.inco_vgnca,@ldFechaParametroConceptos) >= 0
		And			Datediff(Day,@ldFechaParametroConceptos,a.fn_vgnca) >= 0
		And			a.vsble_usro = 'S'
		And			a.cnsctvo_cdgo_bse_aplcda  	Between	1 And 5  -- que sean de facturacion, notas, impuestos o descuentos , intereses
		And			Datediff(Day,b.inco_vgnca,@ldFechaParametroConceptos) >= 0
		And			Datediff(Day,@ldFechaParametroConceptos,b.fn_vgnca) >= 0

		-- Se calcula el descuento por periodicidad
		Set		@cnsctvo_cdgo_prmtro_prgrmcn = 0
		Set		@vlr_descuento = 0

		Select	@cnsctvo_cdgo_prmtro_prgrmcn = cnsctvo_cdgo_prmtro_prgrmcn,
				@vlr_descuento = vlr
		From	dbo.tbDescuentos_Vigencias With(NoLock)
		Where	cnsctvo_cdgo_prdo = @cnsctvo_cdgo_prdo
		And		Datediff(Day,inco_vgnca,@ldFechasistema) >= 0
		And		Datediff(Day,@ldFechasistema,fn_vgnca) >= 0
		And		espcl = 'N'

		-- se actualiza el valor de otros desucnto como el del pronto pago

		Update	#tmpBeneficiarios
		Set		vlr_otros_dcts		= Case	When @cnsctvo_cdgo_prmtro_prgrmcn = 5 Then (vlr_cta * @vlr_descuento /100)
							Else @vlr_descuento End,
				vlr_otros_dcts_aux	= Case	When @cnsctvo_cdgo_prmtro_prgrmcn = 5 Then (vlr_cta * @vlr_descuento /100)
							Else @vlr_descuento End

		--Se actualiza el tipo de operacion si suma o resta
		--Se actualiza si tiene otros descuentos

		Update		#tmpBeneficiarios
		Set			vlr_otros_dcts		= vlr_otros_dcts	+ Case	When (cnsctvo_cdgo_prmtro_prgrmcn = 6) Then (vlr)
										Else ((vlr_cta * vlr/100)) End,
					vlr_otros_dcts_aux	= vlr_otros_dcts_aux	+ Case	When (cnsctvo_cdgo_prmtro_prgrmcn = 6) Then (vlr)
										Else ((vlr_cta * vlr/100)) End
		From		#tmpBeneficiarios c 
		Inner Join	dbo.tbResponsableXDescuento_Vigencias	a With(NoLock)
			On		a.nmro_unco_idntfccn	= c.nmro_unco_idntfccn_bnfcro 
		Inner Join	dbo.tbDescuentos_Vigencias				b With(NoLock)
			On		a.cnsctvo_cdgo_dscnto	= b.cnsctvo_cdgo_dscnto
		Where		espcl			= 'S'
		And			Datediff(Day,a.inco_vgnca,@ldFechaInicialFacturacion)	>= 0
		And			Datediff(Day,@ldFechaInicialFacturacion,a.fn_vgnca)	>= 0
		And			Datediff(Day,b.inco_vgnca,@ldFechaInicialFacturacion)	>= 0
		And			Datediff(Day,@ldFechaInicialFacturacion,b.fn_vgnca)	>= 0

		Update		#tmpBeneficiarios
		Set			vlr_otros_dcts_aux	= Case	When oprcn = 4 Then (vlr_otros_dcts_aux * -1)
							Else vlr_otros_dcts_aux End
		From		#tmpBeneficiarios			a 
		Inner Join	#tmpConceptosLiquidacion	b
			On		b.cnsctvo_cdgo_grpo_lqdcn	= a.Grupo_Conceptos
		Where		b.cnsctvo_cdgo_cncpto_lqdcn	= 6  --Es el consecutivo del  concepto de otros descuentos

		-- si la operacion es restar entonces automaticamente  se multiplica por -1
		--Con el fin totalizar el valor total pendiendo si suma o resta

		Update		#tmpBeneficiarios
		Set			vlr_iva		= (prcntje * (vlr_cta - vlr_dcto_comercial - vlr_otros_dcts)) /100,
					vlr_iva_aux	= Case	When oprcn = 4 Then (((prcntje * (vlr_cta - vlr_dcto_comercial - vlr_otros_dcts)) /100) * -1)
							Else (((prcntje * (vlr_cta - vlr_dcto_comercial - vlr_otros_dcts)) /100) * 1) End
		From		#tmpBeneficiarios			a 
		Inner Join	#tmpConceptosLiquidacion	b
			On		b.cnsctvo_cdgo_grpo_lqdcn	= a.Grupo_Conceptos
		Where		b.cnsctvo_cdgo_cncpto_lqdcn	= 3  --Es el consecutivo del  concepto del  iva

		--Calcula el valor total para cada beneficiario

		Update	#tmpBeneficiarios
		Set		vlr_ttl_bnfcro			= (vlr_cta + vlr_dcto_comercial_aux + vlr_otros_dcts_aux + vlr_iva_aux),
				vlr_ttl_bnfcro_sn_iva	= (vlr_cta + vlr_dcto_comercial_aux + vlr_otros_dcts_aux)
end