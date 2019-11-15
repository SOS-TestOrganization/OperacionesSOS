


/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpTraerContratosxDocumentoDebito
* Desarrollado por		: <\A Ing. Rolando simbaqueva lasso									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de loscontratos del responsable de un estado de cuenta donde ya existe el contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/05 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   Ing. Sandra Milena Ruiz Reyes 		AM\>
* Descripcion			: <\DM   Aplicacion de tecnicas de optimizacion	DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion		: <\FM   14/09/2005					FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM   Ing. Juan Manuel Victoria 		AM\>
* Descripcion			: <\DM   Se adicionan campos de deducciones e impuestos	DM\>
* Nuevos Parametros	 	: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion		: <\FM   14/09/2005					FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[SpTraerContratosxDocumentoDebito]
	@lnNumeroDocumento			Varchar(15),
	@lnTipoDocumento			udtConsecutivo
As	
Set Nocount On


If	@lnTipoDocumento = 1		--estado de cuenta
		Begin
				-- se anexo el siguiente codigo para optimizar la consulta
			Select  b.cnsctvo_estdo_cnta_cntrto,			b.cnsctvo_estdo_cnta,		b.cnsctvo_cdgo_tpo_cntrto,
					b.nmro_cntrto,	b.vlr_cbrdo,			b.sldo,
					b.cntdd_bnfcrs, b.fcha_ultma_mdfccn,	b.usro_ultma_mdfccn
			into #tmpContratosEstadosCuenta
			FROM	bdCarteraPac.dbo.tbEstadosCuenta a INNER JOIN
			        bdCarteraPac.dbo.tbestadoscuentacontratos b 
			ON	a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
			WHERE	(a.nmro_estdo_cnta = @lnNumeroDocumento) 
			AND 	(b.sldo > 0)


			Select	c.nmro_cntrto,		f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
				ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(d.sgndo_nmbre)) nombre,
				p.dscrpcn_pln,
				b.vlr_cbrdo,
				b.sldo,
			--	convert(numeric(12,0),0) 	vlr_aplcr ,  -- al valor aplicar le asigna el valor del saldo
				b.sldo 					vlr_aplcr ,  -- al valor aplicar le asigna el valor del saldo
				0 vlr_rte_fnte, 0 vlr_rte_ica, 0 vlr_estmplls, 0 vlr_otrs,
				p.cdgo_pln,	
				c.cnsctvo_cdgo_pln,
				c.cnsctvo_cdgo_tpo_cntrto,
				@lnTipoDocumento			tpo_dcmto,
				@lnNumeroDocumento   			nmro_dcmto,
				b.cnsctvo_estdo_cnta_cntrto		cnsctvo_dcto, 'NO SELECCIONADO' mrca
			FROM    #tmpContratosEstadosCuenta b		   INNER JOIN
				bdAfiliacion.dbo.tbContratos c 
			ON 	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto 
			AND 	b.nmro_cntrto 			= c.nmro_cntrto INNER JOIN
                      		bdAfiliacion.dbo.tbPersonas d 
			ON 	c.nmro_unco_idntfccn_afldo 	= d.nmro_unco_idntfccn INNER JOIN
                      		bdAfiliacion.dbo.tbVinculados e 
			ON 	d.nmro_unco_idntfccn 		= e.nmro_unco_idntfccn INNER JOIN
                      		bdAfiliacion.dbo.tbTiposIdentificacion f 
			ON 	e.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
                      		bdPlanBeneficios.dbo.tbPlanes p 
			ON 	c.cnsctvo_cdgo_pln 		= p.cnsctvo_cdgo_pln
			WHERE   (c.cnsctvo_cdgo_tpo_cntrto = 2)

		End
else
	begin
		--tipo de nota debito
		Select 	c.nmro_cntrto,		f.cdgo_tpo_idntfccn,	e.nmro_idntfccn,
			ltrim(rtrim(d.prmr_aplldo)) + ' ' + ltrim(rtrim(d.sgndo_aplldo)) + ' ' + ltrim(rtrim(d.prmr_nmbre)) + ' ' +ltrim(rtrim(d.sgndo_nmbre)) nombre,
			p.dscrpcn_pln,		b.vlr  vlr_cbrdo,	b.sldo_nta_cntrto  sldo,  
		--	convert(numeric(12,0),0) 	vlr_aplcr ,  -- al valor aplicar le asigna el valor del saldo
			b.sldo_nta_cntrto		vlr_aplcr ,  --al valor aplicar le asinga el valor del saldo
			0 vlr_rte_fnte, 0 vlr_rte_ica, 0 vlr_estmplls, 0 vlr_otrs,
			p.cdgo_pln,	
			c.cnsctvo_cdgo_pln,
			c.cnsctvo_cdgo_tpo_cntrto,
			@lnTipoDocumento		tpo_dcmto,
			@lnNumeroDocumento		nmro_dcmto,
			b.cnsctvo_nta_cntrto		cnsctvo_dcto, 'NO SELECCIONADO' mrca
		FROM	bdCarteraPac.dbo.tbnotaspac a INNER JOIN
		        bdCarteraPac.dbo.tbnotascontrato b 
		ON 	a.nmro_nta = b.nmro_nta 
		AND 	a.cnsctvo_cdgo_tpo_nta		= b.cnsctvo_cdgo_tpo_nta INNER JOIN
		        bdAfiliacion.dbo.tbContratos c 
		ON 	b.cnsctvo_cdgo_tpo_cntrto	= c.cnsctvo_cdgo_tpo_cntrto 
		AND 	b.nmro_cntrto 			= c.nmro_cntrto INNER JOIN
                      	bdAfiliacion.dbo.tbPersonas d 
		ON 	c.nmro_unco_idntfccn_afldo	= d.nmro_unco_idntfccn INNER JOIN
		        bdAfiliacion.dbo.tbVinculados e 
		ON 	d.nmro_unco_idntfccn 		= e.nmro_unco_idntfccn INNER JOIN
		        bdAfiliacion.dbo.tbTiposIdentificacion f 
		ON 	e.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn INNER JOIN
		        bdPlanBeneficios.dbo.tbPlanes p 
		ON 	c.cnsctvo_cdgo_pln 		= p.cnsctvo_cdgo_pln
		WHERE   (a.nmro_nta 			= @lnNumeroDocumento) 
		AND 	(a.cnsctvo_cdgo_tpo_nta 	= 1) 
		AND 	(c.cnsctvo_cdgo_tpo_cntrto 	= 2)
End
drop table #tmpContratosEstadosCuenta


