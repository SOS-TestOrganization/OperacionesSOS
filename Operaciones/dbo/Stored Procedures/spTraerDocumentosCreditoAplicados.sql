
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerDocumentosCreditoAplicados
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento trae la informacion de los documentos credito aplicados			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE  PROCEDURE spTraerDocumentosCreditoAplicados
			@lntipoNota		udtConsecutivo,
			@lntipoDocumento	udtConsecutivo,
			@lnNumeroInicial	varchar(15),
			@lnnumeroFinal		varchar(15)

	

As  			
set nocount on				
	

SELECT    space(50)		dscrpcn_tpo_dcmnto,
	     space(15)		nmro_dcmto,
	     space(50)		dscrpcn_Estdo_dcmnto, 
	     convert(numeric(12,0),0)	vlr_dcmnto , 
	     space(3)		cdgo_tpo_idntfccn,
	     space(20)		nmro_idntfccn, 	
	     space(50)		dscrpcn_clse_aprtnte,
	     space(100)		nmbre_scrsl,
 	     space(200)		rzn_scl,
	     convert(datetime,null)	fcha_crcn,
	     space(30)			usro_crcn,
	     convert(int,0)		nmro_unco_idntfccn_empldr,
	     convert(int,0)		cnsctvo_scrsl,
	     convert(int,0)		cnsctvo_cdgo_clse_aprtnte,
	     convert(int,0)		cnsctvo_cdgo_tpo_nta,
	     convert(int,0)		cnsctvo_cdgo_estdo_nta ,
	     convert(int,0)		dgto_vrfccn,
	     convert(datetime,null)	fcha_crcn_nta,
	     convert(int,0)		cnsctvo_cdgo_tpo_dcmnto ,
	     convert(numeric(12,0),0)	sldo_dcmnto
into	     #TmpDocumentoCredito	
From	     TbPagos
Where        1	=	2 		

--si son  pagos
if 	@lntipoDocumento	=	4
	Begin
		insert	into #TmpDocumentoCredito
		select  b.dscrpcn_tpo_dcmnto,
			convert(varchar(15),cnsctvo_cdgo_pgo),
			c.dscrpcn_estdo_pgo,
			a.vlr_dcmnto,
			f.cdgo_tpo_idntfccn,
			e.nmro_idntfccn,
			i.dscrpcn_clse_aprtnte,
			d.nmbre_scrsl,
			space(100),
			a.fcha_crcn,
			a.usro_crcn,
			a.nmro_unco_idntfccn_empldr,
			a.cnsctvo_scrsl,
			a.cnsctvo_cdgo_clse_aprtnte,
			0,
			0,
			dgto_vrfccn,
			a.fcha_crcn,
			@lntipoDocumento,
			a.sldo_pgo
		From	tbpagos	a	,	tbtipodocumentos	b,
			tbestadosPago	c,
			bdAfiliacion.dbo.tbSucursalesAportante d,
			bdAfiliacion.dbo.tbVinculados		e,
			bdAfiliacion.dbo.tbTiposIdentificacion f,
			bdAfiliacion.dbo.tbClasesAportantes	i
		where   a.cnsctvo_cdgo_estdo_pgo 		<>  	1 
		--And	a.cnsctvo_cdgo_tpo_pgo			=  	2
		and	a.usro_crcn				<> 	'Migracion01'
		--and	a.fcha_crcn				>= 	'20040209'	
		And	b.cnsctvo_cdgo_tpo_dcmnto	=	4 
		and	a.cnsctvo_cdgo_estdo_pgo	=	c.cnsctvo_cdgo_estdo_pgo	
		And	a.nmro_unco_idntfccn_empldr 	= 	d.nmro_unco_idntfccn_empldr
		AND 	a.cnsctvo_scrsl 		= 	d.cnsctvo_scrsl
		AND 	a.cnsctvo_cdgo_clse_aprtnte 	= 	d.cnsctvo_cdgo_clse_aprtnte
		And	a.nmro_unco_idntfccn_empldr 	= 	e.nmro_unco_idntfccn 
		And	e.cnsctvo_cdgo_tpo_idntfccn 	= 	f.cnsctvo_cdgo_tpo_idntfccn
		And	a.cnsctvo_cdgo_clse_aprtnte 	= 	i.cnsctvo_cdgo_clse_aprtnte 
		And	a.cnsctvo_cdgo_pgo between  convert(int,@lnNumeroInicial) and convert(int,@lnnumeroFinal)
		--inicializa el proceso automatico -- porque hay datos de migracion con inconsistencias.. mientras se depuran
		-- y esten aplicados
		---manuales
		-- Pagos

	End
Else
	Begin
		--- si son notas credito
		insert	into #TmpDocumentoCredito
		select  b.dscrpcn_tpo_dcmnto,
			a.nmro_nta,
			c.dscrpcn_estdo_nta,
			(a.vlr_nta+ a.vlr_iva),
			f.cdgo_tpo_idntfccn,
			e.nmro_idntfccn,
			i.dscrpcn_clse_aprtnte,
			d.nmbre_scrsl,
			space(100),
			a.fcha_crcn_nta,
			a.usro_crcn,
			a.nmro_unco_idntfccn_empldr,
			a.cnsctvo_scrsl,
			a.cnsctvo_cdgo_clse_aprtnte,
	     		a.cnsctvo_cdgo_tpo_nta,
	     		a.cnsctvo_cdgo_estdo_nta ,
			dgto_vrfccn,
			a.fcha_crcn_nta,
			@lntipoDocumento,
			a.sldo_nta
		From	tbNotasPac	a	,	tbtipodocumentos	b,
			tbEstadosNota	c,
			bdAfiliacion.dbo.tbSucursalesAportante d,
			bdAfiliacion.dbo.tbVinculados		e,
			bdAfiliacion.dbo.tbTiposIdentificacion f,
			bdAfiliacion.dbo.tbClasesAportantes	i
		where   (a.cnsctvo_cdgo_estdo_nta 		=	4 or a.cnsctvo_cdgo_estdo_nta= 7)  	
		and	a.usro_crcn				<> 	'Migracion01'
		and	a.fcha_crcn_nta				>=	'20040209'
		And	b.cnsctvo_cdgo_tpo_dcmnto	=	3
		and	a.cnsctvo_cdgo_tpo_nta		=	2	
		and	a.cnsctvo_cdgo_estdo_nta	=	c.cnsctvo_cdgo_estdo_nta	
		And	a.nmro_unco_idntfccn_empldr 	= 	d.nmro_unco_idntfccn_empldr
		AND 	a.cnsctvo_scrsl 		= 	d.cnsctvo_scrsl
		AND 	a.cnsctvo_cdgo_clse_aprtnte 	= 	d.cnsctvo_cdgo_clse_aprtnte
		And	a.nmro_unco_idntfccn_empldr 	= 	e.nmro_unco_idntfccn 
		And	e.cnsctvo_cdgo_tpo_idntfccn 	= 	f.cnsctvo_cdgo_tpo_idntfccn
		And	a.cnsctvo_cdgo_clse_aprtnte 	= 	i.cnsctvo_cdgo_clse_aprtnte 
		And	a.nmro_nta between  @lnNumeroInicial and @lnnumeroFinal
		-- y esten aplicados
		 --Nota Credito
		--nota Credito
	End







Update 	#TmpDocumentoCredito
Set  	rzn_scl	     =  c.rzn_scl
From 	#TmpDocumentoCredito a ,  bdafiliacion..tbempleadores b,	bdafiliacion..tbempresas c
Where 	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn 

Update 	#TmpDocumentoCredito
Set  	rzn_scl	     =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From 	#TmpDocumentoCredito a	,bdafiliacion..tbempleadores b,	bdafiliacion..tbpersonas c--,	tbclasesempleador d
Where	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn
And	a.nmro_unco_idntfccn_empldr		=	c.nmro_unco_idntfccn



select * from	#TmpDocumentoCredito


drop table #TmpDocumentoCredito