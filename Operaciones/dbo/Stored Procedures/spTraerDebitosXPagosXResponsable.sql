
/*---------------------------------------------------------------------------------
* Metodo o PRG			: spTraerDebitosXPagosXResponsable
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso         A\>
* Descripcion			: <\D Este procedimiento Consulta los documentos debitos para aplicar con los pagos	    D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\V V\>
* Fecha Creacion		: <\FC 2002/07/02 FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Jean Paul Villaquiran AM\>
* Descripcion			: <\DM Se realizan algunas recfactorizaciones   DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2019/06/11 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Juan Manuel Victoria AM\>
* Descripcion			: <\DM Se incluyen campos de deducciones e impuestos   DM\>
* Nuevos Parametros		: <\PM PM\>
* Nuevas Variables		: <\VM VM\>
* Fecha Modificacion	: <\FM 2019/07/03 FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[spTraerDebitosXPagosXResponsable]
(

		@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo = null	,
		@nmro_unco_idntfccn_empldr	udtConsecutivo = null	,
		@cnsctvo_scrsl udtConsecutivo = null	
)
As  		
begin	
		Set Nocount On;				
	
		-- se trae la informacion de los estado de cuenta				
		Select			c.Dscrpcn_tpo_dcmnto as Dscrpcn_tpo_dcmnto,
						a.nmro_estdo_cnta as nmro_dcto,		
						p.fcha_incl_prdo_lqdcn	as fcha_dcmto,	
						a.ttl_pgr as vlr_dcmnto,
						0	 ttl_dcmnto   , 
						convert(numeric(12,0),0) vlr_aplcr	,
						a.cnsctvo_cdgo_tpo_dcmnto as cnsctvo_cdgo_tpo_dcmnto,	 
						a.cnsctvo_estdo_cnta as Consecutivo_documento_origen ,
						a.cnsctvo_cdgo_estdo_estdo_cnta  estado_documento ,
						1	nivel_Contrato,
						convert(numeric(12,0),0) vlr_rte_fnte,
						convert(numeric(12,0),0) vlr_rte_ica,
						convert(numeric(12,0),0) vlr_estmplls,
						convert(numeric(12,0),0) vlr_otrs
		Into			#tmpDocumentoDebito
		From			dbo.tbestadosCuenta a with(nolock)
		inner join		dbo.tbtipodocumentos  c with(nolock)
		on				c.cnsctvo_cdgo_tpo_dcmnto = a.cnsctvo_cdgo_tpo_dcmnto
		inner join		dbo.tbliquidaciones l with(nolock)
		on				a.cnsctvo_cdgo_lqdcn = l.cnsctvo_cdgo_lqdcn
		inner join		dbo.tbperiodosliquidacion_vigencias p with(nolock)
		on				l.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
		Where			c.cnsctvo_cdgo_tpo_dcmnto	in (1,6)	-- estados de cuenta y Facturas
		And				a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
		And				a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
		And				l.cnsctvo_cdgo_estdo_lqdcn	=	3   --Finalizada..
		And				a.cnsctvo_estdo_cnta		>   	0
		And				a.nmro_estdo_cnta		>	0	-- es  decir que ya este finalizada
		And				a.cnsctvo_cdgo_estdo_estdo_cnta	!=	4;

		update			#tmpDocumentoDebito
		Set				ttl_dcmnto = valor_saldo_Estado_cnta
		from			#tmpDocumentoDebito a , ( Select b.cnsctvo_estdo_cnta , sum(b.sldo) 	valor_saldo_Estado_cnta
		from			#tmpDocumentoDebito a, dbo.tbestadoscuentacontratos b with(nolock)
		where			a.Consecutivo_documento_origen = b.cnsctvo_estdo_cnta
		And				b.sldo >	0 
		Group by		b.cnsctvo_estdo_cnta ) tmpSaldoEstadoCuenta
		Where			a.Consecutivo_documento_origen = tmpSaldoEstadoCuenta.cnsctvo_estdo_cnta

		delete from		#tmpDocumentoDebito where  ttl_dcmnto = 0;

		-- se insertan la informacion de las notas debito pendiente
		Insert into		#tmpDocumentoDebito
		Select			Dscrpcn_tpo_dcmnto,	a.nmro_nta    nmro_dcto,	a.fcha_crcn_nta	fcha_dcmto,
						( a.vlr_nta  +        a.vlr_iva)  vlr_dcmnto,
						a.sldo_nta	 ttl_dcmnto   ,  convert(numeric(12,0),0) vlr_aplcr,		c.cnsctvo_cdgo_tpo_dcmnto,	convert(int,a.nmro_nta)	Consecutivo_documento_origen ,
						a.cnsctvo_cdgo_estdo_nta    estado_documento,
						0	nivel_Contrato,convert(numeric(12,0),0) vlr_rte_fnte,
						convert(numeric(12,0),0) vlr_rte_ica,
						convert(numeric(12,0),0) vlr_estmplls,
						convert(numeric(12,0),0) vlr_otrs
		from			dbo.tbNotasPac a with(nolock),  
						dbo.tbtipodocumentos  c with(nolock)
		Where  			c.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito
		And				a.nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
		And				a.cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
		and				a.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
		And				a.sldo_nta			>	0
		And				a.cnsctvo_cdgo_estdo_nta	!=	6;

		--Actualiza si la nota aplica a nivel de contrato
		Update			#tmpDocumentoDebito
		Set				nivel_Contrato	=	1
		From			#tmpDocumentoDebito a
		inner join dbo.tbNotascontrato b with(nolock) on a.nmro_dcto	=	b.nmro_nta
		where				b.cnsctvo_cdgo_tpo_nta		=	1	--notas debito
		and				a.cnsctvo_cdgo_tpo_dcmnto	=	2;

		Select 	*  
		from			#tmpDocumentoDebito;

		drop table #tmpDocumentoDebito
end