/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spObtenerBeneficiariosAFacturar
* Desarrollado por		: <\A	Ing. Jean Paul Villaquiran Madrigal	A\>
* Descripción			: <\D	Se consultan y depuran beneficiarios a facturasD\>
* Observaciones			: <\O	O\>
* Parámetros			: <\P  	P\>
* Variables				: <\V  	V\>
* Fecha Creación		: <\FC	17/09/2019 FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM	AM\>
* Descripción				: <\DM	DM\>
* Nuevos Parámetros			: <\PM	PM\>
* Nuevas Variables			: <\VM	VM\>
* Fecha Modificación		: <\FM	FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure spObtenerBeneficiariosAFacturar
(
@fechaCorte datetime
)
as
begin

	declare			@CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC smallint = 2,
					@HABILITADO_SI varchar(1) = 'S';

	set nocount on;

	insert Into		#tmpBeneficiariosActivos                   
	Select 			a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,
					a.cnsctvo_bnfcro,
					a.nmro_unco_idntfccn_bnfcro,
					a.inco_vgnca_bnfcro,
					a.fn_vgnca_bnfcro,
					a.cnsctvo_cdgo_tpo_afldo,
					a.cnsctvo_cdgo_prntsco,
					0 Activo	
	from 			bdafiliacion.dbo.tbBeneficiarios a with(nolock)
	inner join		#tmpEstadosDeCuentaConContrato b
	on				a.nmro_cntrto = b.nmro_cntrto
	and				a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	Where			a.cnsctvo_cdgo_tpo_cntrto = @CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC
	And				datediff(dd,a.inco_vgnca_bnfcro,@fechaCorte) >= 0 
	And				datediff(dd,@fechaCorte,a.fn_vgnca_bnfcro) >= 0;	

	insert into		#tmpHistoricoEstadosBeneficiario 
	Select			a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,
					a.cnsctvo_bnfcro,
					a.nmro_unco_idntfccn_bnfcro,
					a.cnsctvo_cdgo_estdo_bfcro
	from  			bdafiliacion.dbo.tbHistoricoEstadosBeneficiario a with(nolock)
	inner join		#tmpEstadosDeCuentaConContrato b
	on				a.nmro_cntrto = b.nmro_cntrto
	and				a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	Where 			a.cnsctvo_cdgo_tpo_cntrto = @CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC
	And				a.hbltdo = @HABILITADO_SI
	and 			(a.cnsctvo_cdgo_estdo_bfcro = 1 or a.cnsctvo_cdgo_estdo_bfcro = 5)
	And				datediff(dd,a.inco_vgnca_estdo_bnfcro,@fechaCorte)> = 0 
	And				datediff(dd,@fechaCorte,a.fn_vgnca_estdo_bnfcro)> = 0;

	insert into		#tmpBeneficiariosEstadoActivos
	Select 			cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
       				cnsctvo_bnfcro,
					nmro_unco_idntfccn_bnfcro,
					cnsctvo_cdgo_estdo_bfcro,
					0	Suspendido
	From			#tmpHistoricoEstadosBeneficiario
	Where 			cnsctvo_cdgo_estdo_bfcro	=	1;

	insert into		#tmpBeneficiariosEstadoSuspendidos
	Select 			cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
       				cnsctvo_bnfcro,
					nmro_unco_idntfccn_bnfcro,
					cnsctvo_cdgo_estdo_bfcro
	From			#tmpHistoricoEstadosBeneficiario
	Where 			cnsctvo_cdgo_estdo_bfcro = 5;

	Delete			#tmpBeneficiariosEstadoSuspendidos
	From			#tmpBeneficiariosEstadoSuspendidos a 
	inner join		#tmpContratosSuspenConUnacuota b
	on 				(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And				a.nmro_cntrto =	b.nmro_cntrto)

	Update 			#tmpBeneficiariosEstadoActivos
	Set				suspendido	=	1
	From			#tmpBeneficiariosEstadoActivos a 
	inner join 		#tmpBeneficiariosEstadoSuspendidos b
	on				(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	and				a.nmro_cntrto			=	b.nmro_cntrto
	and				a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	and				a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro);

	Update			#tmpBeneficiariosActivos
	Set				Activo		=	1
	From			#tmpBeneficiariosActivos a 
	inner join		#tmpBeneficiariosEstadoActivos b
	on				(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And				a.nmro_cntrto			=	b.nmro_cntrto
	And				a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And				a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro);

	Insert into		#tmpBeneficiarios
	Select			a.nmro_unco_idntfccn_aprtnte,  
					a.cnsctvo_scrsl_ctznte, a.cnsctvo_cdgo_clse_aprtnte , 
					a.nmro_unco_idntfccn_afldo,a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, 
					a.cnsctvo_cbrnza,
					a.cnsctvo_cdgo_pln,
					d.cnsctvo_bnfcro, 	d.nmro_unco_idntfccn_bnfcro, d.inco_vgnca_bnfcro,d.fn_vgnca_bnfcro,	e.vlr_upc,
					e.vlr_rl_pgo,
					0 cnsctvo_estdo_cnta_cntrto,
					convert(numeric(12,0),0)	 vlr_dcto_comercial, 	convert(numeric(12,0),0)	 vlr_otros_dcts, 	convert(numeric(12,0),0)	 vlr_iva , 
					e.vlr_upc  vlr_cta,
					convert(numeric(12,0),0)	 vlr_ttl_bnfcro,
					convert(numeric(12,0),0)	 vlr_ttl_bnfcro_sn_iva,
					convert(numeric(12,0),0)	 vlr_dcto_comercial_aux, 	convert(numeric(12,0),0)	 vlr_otros_dcts_aux, 	convert(numeric(12,0),0)	 vlr_iva_aux,
					a.Grupo_Conceptos ,
					convert(numeric(12,0),0)	vlr_upc_nuevo ,
					convert(numeric(12,0),0)	vlr_rl_pgo_nuevo,
					0	Cambio_Valor_cuota,
					case when	(e.vlr_rl_pgo	>	0) 	then	1	else	0	end Bnfcro_Dfrnte_cro,
					a.cnsctvo_vgnca_cbrnza,
					e.cnsctvo_dtlle_bnfcro_adcnl,
					a.inco_vgnca_cbrnza,
					a.cnsctvo_cdgo_prdcdd_prpgo,
					0	nmro_mss,
					e.inco_vgnca,
					e.fn_vgnca,
					a.cnsctvo_estdo_cnta	
	From 			#Tmpcontratos a, #tmpBeneficiariosActivos d,  
					bdafiliacion.dbo.tbdetbeneficiarioAdicional e with(nolock)
	Where			a.cnsctvo_cdgo_tpo_cntrto	=	d.cnsctvo_cdgo_tpo_cntrto
	And				a.nmro_cntrto =	d.nmro_cntrto
	And				d.cnsctvo_cdgo_tpo_cntrto	=	e.cnsctvo_cdgo_tpo_cntrto
	And				d.nmro_cntrto =	e.nmro_cntrto
	And				d.cnsctvo_bnfcro =	e.cnsctvo_bnfcro
	And				d.nmro_unco_idntfccn_bnfcro	=	e.nmro_unco_idntfccn_bnfcro
	And				a.nmro_cntrto			=	e.nmro_cntrto
	And				a.cnsctvo_cdgo_tpo_cntrto	=	e.cnsctvo_cdgo_tpo_cntrto
	And				a.cnsctvo_cbrnza		=	e.cnsctvo_cbrnza	
	And				convert(varchar(10),@fechaCorte,111) 	between convert(varchar(10),e.inco_vgnca,111) and convert(varchar(10),e.fn_vgnca,111) 
	And				e.estdo_rgstro = @HABILITADO_SI
	And				d. Activo =	 1;

	insert 
	into			#RegistrosClasificarFinal
	select			nmro_unco_idntfccn_bnfcro  nmro_unco_idntfccn,
   					0	edd_bnfcro,
					cnsctvo_cdgo_pln,
					'N'	ps_ss,
					convert(datetime,null) fcha_aflcn_pc	,
					0 cnsctvo_cdgo_prntsco,
					0 cnsctvo_cdgo_tpo_afldo,
					'N' Dscpctdo,
					'N' Estdnte,
					'N'	Antgdd_hcu,
					'N'	Atrzdo_sn_Ps,
					'N' grpo_bsco,
					cnsctvo_cdgo_tpo_cntrto,	
					nmro_cntrto,
					cnsctvo_bnfcro,
					cnsctvo_cbrnza,
					0 grupo,
					0 cnsctvo_prdcto,
					0 cnsctvo_mdlo,
					0 vlr_upc,
					0 vlr_rl_pgo,
					0 cnsctvo_cdgo_tps_cbro,
					0 Cobranza_Con_producto,
					0 Beneficiario_Con_producto,
					0 Con_Modelo,
					2 grupo_tarificacion,
					0 igual_plan,
					0 grupo_modelo,
					nmro_unco_idntfccn_aprtnte,
					cnsctvo_scrsl_ctznte, 
					cnsctvo_cdgo_clse_aprtnte,
					convert(datetime,null) 	inco_vgnca_cntrto,
					'N' bnfcdo_pc,
					'N' Tne_hjos_cnyge_cmpnra,
					'N' cntrtnte_ps_ss,
					'N' grpo_bsco_cn_ps,
					'N' cntrtnte_tn_pc,
					'N' antgdd_clptra,
					cnsctvo_estdo_cnta
	From			#tmpBeneficiarios;

end