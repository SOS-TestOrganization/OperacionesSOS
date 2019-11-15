/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spConsultarDetallesFacturasPAC
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Consultar el detalle de las facturas con el fin de crear reporte de anexo D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/05/22 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
exec		bdCarteraPAC.dbo.spConsultarDetallesFacturasPAC 30

declare		@cnsctvo_cdgo_lqdcn int = 5,
			@numeroEstadoCuenta varchar(15) = '169563';
--------------------------------------------------------------------------------*/
CREATE procedure [dbo].[spConsultarDetallesFacturasPAC]
(
	@numeroLiquidacion int
)
as
begin

	set nocount on;

		Declare		@fechaActual datetime = getdate(),
					@consecutivoCodigoTipoContactoGeneral int = 1,
					@consecutivoCodigoTipoContactoFE int = 2;

		create 
		table		#EstadosCuentaValidos
					(
					cnsctvo_estdo_cnta udtConsecutivo
					)

		create 
		table		#DetalleFacturasPAC
					(
					cnsctvo_estdo_cnta udtConsecutivo,
					cnsctvo_cdgo_lqdcn udtConsecutivo,
					nmro_estdo_cnta varchar(15),
					nmro_unco_idntfccn_empldr udtConsecutivo,
					cnsctvo_cdgo_clse_aprtnte udtConsecutivo,
					nmro_idntfccn udtNumeroIdentificacionLargo,
					nmro_idntfccn_empldr udtNumeroIdentificacionLargo,
					cdgo_tpo_idntfccn_empldr udtTipoIdentificacion,
					prmr_aplldo	udtApellido,
					sgndo_aplldo udtApellido,
					prmr_nmbre udtNombre,
					sgndo_nmbre udtNombre,
					nmro_cntrto udtNumeroFormulario,
					cdgo_pln udtCodigo,
					vlr_cbrdo udtValorGrande,
					cntdd_bnfcrs int,
					fcha_gnrcn datetime,
					fcha_incl_prdo_lqdcn datetime,
					fcha_fnl_prdo_lqdcn datetime,
					fcha_mxma_pgo datetime,
					Cts_Cnclr udtValorPequeno,
					Cts_sn_Cnclr udtValorPequeno,
					nmbre_scrsl	udtDescripcion,
					drccn	udtDireccion,
					tlfno	udtTelefono,
					dscrpcn_cdd	udtDescripcion,
					dscrpcn_dprtmnto udtDescripcion,
					cnsctvo_scrsl udtConsecutivo,
					cdgo_sde udtSede,
					cnsctvo_cdgo_pln udtConsecutivo,
					cufe varchar(4000),
					cnsctvo_cdgo_rslcn_dn udtConsecutivo,
					prfjo_nmro_estdo_cnta varchar(10),
					cnsctvo_cdd udtConsecutivo
					);

		insert into	#EstadosCuentaValidos
					(
					cnsctvo_estdo_cnta
					)
		select		a.cnsctvo_estdo_cnta
		from		dbo.tbEstadosCuenta a with(nolock)
		inner join	dbo.TbEstadosCuentaContratos	b with(nolock)
		on			a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
		inner join	BDAfiliacion.dbo.tbContratos c with(nolock)
		on			b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
		and			b.nmro_cntrto = c.nmro_cntrto
		where		a.cnsctvo_cdgo_lqdcn = @numeroLiquidacion
		group by	a.cnsctvo_estdo_cnta
		having		count(a.cnsctvo_estdo_cnta) > 1

		insert 
		into		#DetalleFacturasPAC
					(
					cnsctvo_estdo_cnta,
					cnsctvo_cdgo_lqdcn,
					nmro_estdo_cnta,
					nmro_unco_idntfccn_empldr,
					cnsctvo_cdgo_clse_aprtnte,
					nmro_idntfccn,
					prmr_aplldo,
					sgndo_aplldo,
					prmr_nmbre,
					sgndo_nmbre,
					nmro_cntrto,
					vlr_cbrdo,
					cntdd_bnfcrs,
					fcha_gnrcn,
					Cts_Cnclr,
					Cts_sn_Cnclr,
					cnsctvo_scrsl,
					cnsctvo_cdgo_pln,
					cufe,
					cnsctvo_cdgo_rslcn_dn
					)
		select		a.cnsctvo_estdo_cnta,
					a.cnsctvo_cdgo_lqdcn,
					a.nmro_estdo_cnta as numeroEstadoCuenta,
					a.nmro_unco_idntfccn_empldr,
					a.cnsctvo_cdgo_clse_aprtnte,
					d.nmro_idntfccn as numeroIdentificacion,			
					rtrim(ltrim(e.prmr_aplldo)),
					rtrim(ltrim(e.sgndo_aplldo)),
					rtrim(ltrim(e.prmr_nmbre)),
					rtrim(ltrim(e.sgndo_nmbre)),
					c.nmro_cntrto as numeroContrato,
					b.vlr_cbrdo as valorCobrado,
					b.cntdd_bnfcrs as cantidadBeneficiarios,
					a.fcha_gnrcn,
					a.Cts_Cnclr as cuotasACancelar,
					a.Cts_sn_Cnclr as cuotasSinCancelar,
					a.cnsctvo_scrsl,
					c.cnsctvo_cdgo_pln,
					a.cufe,
					a.cnsctvo_cdgo_rslcn_dn
		from		#EstadosCuentaValidos tmpEstadoCuenta
		inner join	dbo.tbEstadosCuenta a with(nolock)
		on			tmpEstadoCuenta.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
		inner join	dbo.TbEstadosCuentaContratos	b with(nolock)
		on			a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
		inner join	BDAfiliacion.dbo.tbContratos c with(nolock)
		on			b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
		and			b.nmro_cntrto = c.nmro_cntrto
		inner join	BDAfiliacion.dbo.tbVinculados d
		on			c.nmro_unco_idntfccn_afldo = d.nmro_unco_idntfccn		
		inner join	BDAfiliacion.dbo.tbPersonas e
		on			d.nmro_unco_idntfccn = e.nmro_unco_idntfccn
		where		a.cnsctvo_cdgo_lqdcn = @numeroLiquidacion
		--and			a.nmro_estdo_cnta in (170235,169613);

		update		a
		set			cdgo_pln = d.cdgo_pln
		from		#DetalleFacturasPAC a
		inner join	BDPlanBeneficios.dbo.tbPlanes d
		on			a.cnsctvo_cdgo_pln = d.cnsctvo_cdgo_pln;

		update		tmp
		set			fcha_incl_prdo_lqdcn = h.fcha_incl_prdo_lqdcn,
					fcha_fnl_prdo_lqdcn	= h.fcha_fnl_prdo_lqdcn,
					fcha_mxma_pgo = h.fcha_mxma_pgo
		from		#DetalleFacturasPAC tmp
		inner join	dbo.tbLiquidaciones g
		on			g.cnsctvo_cdgo_lqdcn = tmp.cnsctvo_cdgo_lqdcn
		inner join	dbo.tbPeriodosliquidacion_Vigencias h
		on			g.cnsctvo_cdgo_prdo_lqdcn = h.cnsctvo_cdgo_prdo_lqdcn;

		update		tmp
		set			tmp.cnsctvo_cdd = i.cnsctvo_cdgo_cdd,
					cdgo_sde = l.cdgo_sde,
					nmbre_scrsl = i.nmbre_scrsl,
					drccn = i.drccn,
					tlfno = i.tlfno
		from		#DetalleFacturasPAC tmp
		inner join	BDAfiliacion.dbo.tbSucursalesAportante i
		on			tmp.cnsctvo_scrsl = i.cnsctvo_scrsl
		and			tmp.nmro_unco_idntfccn_empldr = i.nmro_unco_idntfccn_empldr
		and			tmp.cnsctvo_cdgo_clse_aprtnte = i.cnsctvo_cdgo_clse_aprtnte 		
		inner join	BDAfiliacion.dbo.tbSedes l
		on			l.cnsctvo_cdgo_sde = i.sde_crtra_pc

		update		a
		set			a.drccn = ltrim(rtrim(b.drccn)),
					a.tlfno = ltrim(rtrim(b.tlfno)),
					a.cnsctvo_cdd = b.cnsctvo_cdgo_cdd
		from		#DetalleFacturasPAC a
		inner join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante		b with(nolock)
		on			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
		and			a.cnsctvo_scrsl = b.cnsctvo_scrsl 
		and			a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 
		where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoCodigoTipoContactoGeneral
		and			@fechaActual between b.inco_vgnca and b.fn_vgnca

		update		a
		set			a.drccn = ltrim(rtrim(b.drccn)),
					a.tlfno = ltrim(rtrim(b.tlfno)),
					a.cnsctvo_cdd = b.cnsctvo_cdgo_cdd
		from		#DetalleFacturasPAC a
		inner join	bdAfiliacion.dbo.tbDatosContactosxSucursalAportante b with(nolock)
		on			a.nmro_unco_idntfccn_empldr = b.nmro_unco_idntfccn_empldr 
		and			a.cnsctvo_scrsl = b.cnsctvo_scrsl 
		and			a.cnsctvo_cdgo_clse_aprtnte = b.cnsctvo_cdgo_clse_aprtnte 	
		where		b.cnsctvo_cdgo_tpo_cntcto = @consecutivoCodigoTipoContactoFE	
		and			@fechaActual between b.inco_vgnca and b.fn_vgnca		

		update		tmp
		set			dscrpcn_cdd = ltrim(rtrim(c.dscrpcn_cdd)),
					dscrpcn_dprtmnto = ltrim(rtrim(dp.dscrpcn_dprtmnto))
		from		#DetalleFacturasPAC tmp
		inner join  bdAfiliacion.dbo.tbCiudades_Vigencias c With(NoLock)
		on			tmp.cnsctvo_cdd = c.cnsctvo_cdgo_cdd 
		inner join  bdAfiliacion.dbo.tbDepartamentos dp With(NoLock)
		on			c.cnsctvo_cdgo_dprtmnto = dp.cnsctvo_cdgo_dprtmnto 
		where		@fechaActual between c.inco_vgnca and c.fn_vgnca		

		update		tmp
		set			prfjo_nmro_estdo_cnta = a.prfjo_atrzdo_fctrcn
		from		#DetalleFacturasPAC tmp
		inner join	BDAfiliacionValidador.dbo.tbResolucionesDIAN_Vigencias a
		on			tmp.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn;

		update		tmp
		set			cdgo_tpo_idntfccn_empldr = b.cdgo_tpo_idntfccn,
					nmro_idntfccn_empldr = a.nmro_idntfccn
		from		#DetalleFacturasPAC tmp
		inner join	BDAfiliacion.dbo.tbVinculados a
		on			tmp.nmro_unco_idntfccn_empldr = a.nmro_unco_idntfccn
		inner join	BDAfiliacion.dbo.tbTiposIdentificacion_Vigencias b
		on			a.cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn;

		select		cnsctvo_estdo_cnta,
					cnsctvo_cdgo_lqdcn,
					ltrim(rtrim(nmro_estdo_cnta)) nmro_estdo_cnta,
					nmro_unco_idntfccn_empldr,
					cnsctvo_cdgo_clse_aprtnte,
					nmro_idntfccn,
					nmro_idntfccn_empldr,
					cdgo_tpo_idntfccn_empldr,
					ltrim(rtrim(prmr_aplldo))+' '+ltrim(rtrim(sgndo_aplldo))+' '+ltrim(rtrim(prmr_nmbre))+' '+ltrim(rtrim(sgndo_nmbre)) as nombreCompleto,
					nmro_cntrto,
					cdgo_pln,
					vlr_cbrdo,
					cntdd_bnfcrs,
					fcha_gnrcn,
					fcha_incl_prdo_lqdcn,
					fcha_fnl_prdo_lqdcn ,
					fcha_mxma_pgo ,
					Cts_Cnclr,
					Cts_sn_Cnclr,
					nmbre_scrsl,
					drccn,
					tlfno,
					dscrpcn_cdd,
					dscrpcn_dprtmnto,
					cnsctvo_scrsl,
					cdgo_sde,
					cnsctvo_cdgo_pln,
					cufe,
					prfjo_nmro_estdo_cnta
		from		#DetalleFacturasPAC
		order by	cnsctvo_estdo_cnta;
end