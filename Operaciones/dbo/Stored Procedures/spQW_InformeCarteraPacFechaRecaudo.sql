
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spQW_InformeCarteraPacFechaRecaudo
* Desarrollado por		: <\A Ing. Francisco J Gonzalez							A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los pagos  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables				: <\V  													V\>
* Fecha Creacion		: <\FC 2018/09/06										FC\>
*
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------*/

-- exec [dbo].[spQW_InformeCarteraPacFechaRecaudo] '20180101', '20180201'	
-- exec [dbo].[spQW_InformeCarteraPacFechaRecaudo] '20170401', '20180901', 'S'	

CREATE PROCEDURE [dbo].[spQW_InformeCarteraPacFechaRecaudo] --'20180101', '20180101'	
@fechaInterface1		datetime = Null,
@fechaInterface2		datetime = Null,
@cVigenciasAbiertas		Char(1) = 'N'


As

Set Nocount On

--Declare		@fechaHoy		Datetime	= Getdate(),
--			@dFechaMinima	Datetime	= '2018-10-01'

Create table #TmpPagos(
	cnsctvo_cdgo_pgo			udtConsecutivo,
	dscrpcn_estdo_pgo           varchar(30),
	dscrpcn_tpo_pgo				varchar(30),
	vlr_dcmnto					udtValorGrande,
	cdgo_tpo_idntfccn			varchar(3),
	nmro_idntfccn				varchar(15),
	dscrpcn_clse_aprtnte		varchar(200),
	nmbre_scrsl					varchar(200),
	rzn_scl						varchar(200),
	fcha_rcdo					datetime,
	fcha_intrfce				datetime,
	fcha_aplccn					datetime,
	nmro_rmsa					int,
	nmro_lna					int,
	nmro_dcmnto					udtNumeroFormulario,
	usro_crcn					udtUsuario,
	cnsctvo_cdgo_estdo_pgo		udtConsecutivo,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	cnsctvo_scrsl				udtConsecutivo,
	cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,
	dgto_vrfccn					int,
	sldo_pgo					udtValorGrande,
	cnsctvo_prcso				int,
    dscrpcn_sde_crtra			VARCHAR(200)
)

-- Se contrala que solo se haga para el mes de la fecha incial

If @fechaInterface1 Is Not Null And @cVigenciasAbiertas = 'N'
	Set @fechaInterface2 = Convert(Char(4),Year(@fechaInterface1)) + '-' + Rtrim(Convert(Char(2),Month(@fechaInterface1))) + '-' + Rtrim(Convert(Char(2),bdAfiliacion.dbo.fnCalculaUltimoDiaMes(Month(@fechaInterface1), Year(@fechaInterface1))))
--Else
--Begin
--	Set @fechaInterface1 = @dFechaMinima
--	Set @fechaInterface1 = Convert(Char(4),Year(@fechaHoy)) + '-' + Rtrim(Convert(Char(2),Month(@fechaHoy))) + '-' + Rtrim(Convert(Char(2),bdAfiliacion.dbo.fnCalculaUltimoDiaMes(Month(@fechaHoy), Year(@fechaHoy))))
--End

--declare @fechaInterface1 datetime 
--declare @fechaInterface2 datetime

--Set @fechaInterface1='20060608'
--Set @fechaInterface2='20060708'

--Select @fechaInterface1, @fechaInterface2

--Return

select @fechaInterface1 = @fechaInterface1+'00:00:00'
select @fechaInterface2 = @fechaInterface2+'23:59:59'


Insert into #TmpPagos Select		
		a.cnsctvo_cdgo_pgo,
		space(30),
		space(30),
		a.vlr_dcmnto,
		space(3),  
		space(15), 
		space(10), 
		space(10),
		space(10), 
		a.fcha_rcdo,
		b.fcha_fn_prcso,
		a.fcha_aplccn, 
		a.nmro_rmsa,
		a.nmro_lna,
		a.nmro_dcmnto,
		a.usro_crcn, 
		a.cnsctvo_cdgo_estdo_pgo,  
		a.cnsctvo_cdgo_tpo_pgo,     
		0,
		0,
		0, 
		0,
		a.sldo_pgo,
		a.cnsctvo_prcso,
        space(150) as dscrpcn_sde_crtra
From		bdCarteraPac.dbo.tbPagos a 
Inner Join	tbprocesoscarterapac b 
	On 		a.cnsctvo_prcso = b.cnsctvo_prcso
Where 		a.fcha_rcdo BETWEEN @fechaInterface1 and @fechaInterface2


--select * From bdCarteraPac.dbo.tbprocesoscarterapac
--select * From tbTipoProceso

--select * From bdCarteraPac.dbo.tbPagos
--/*
--Update a
--Set nmro_unco_idntfccn_empldr= b.nmro_unco_idntfccn
--From tbcuentasmanuales a
--Inner Join 			bdAfiliacion.dbo.tbVinculados b 
--on nmro_idntfccn_rspnsble_pgo = nmro_idntfccn
--Inner Join 	  		bdAfiliacion.dbo.tbtiposidentificacion c
--on a.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn
--where nmro_unco_idntfccn_empldr=0

--Update a
--Set nmro_unco_idntfccn_empldr= b.nmro_unco_idntfccn
--From tbcuentasmanuales a
--Inner Join 			bdAfiliacion.dbo.tbVinculados b 
--on nmro_idntfccn_rspnsble_pgo = nmro_idntfccn
--Inner Join 	  		bdAfiliacion.dbo.tbtiposidentificacion c
--on a.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn
--where nmro_unco_idntfccn_empldr=0

--*/





Update 	#TmpPagos
Set		dscrpcn_estdo_pgo				=	b.dscrpcn_estdo_pgo
From		#TmpPagos   a 
Inner Join  bdCarteraPac.dbo.tbestadospago  b
	On		a.cnsctvo_cdgo_estdo_pgo 	= b.cnsctvo_cdgo_estdo_pgo


Update 	#TmpPagos
Set		dscrpcn_clse_aprtnte			=	b.dscrpcn_clse_aprtnte 
From		#TmpPagos   a 
Inner Join	bdAfiliacion.dbo.tbClasesAportantes  b
	On		a.cnsctvo_cdgo_clse_aprtnte =	b.cnsctvo_cdgo_clse_aprtnte


Update 	#TmpPagos
Set		dscrpcn_tpo_pgo=b.dscrpcn_tpo_pgo
From		#TmpPagos   a 
Inner Join  bdCarteraPac.dbo.tbTipospago  b
	On		a.cnsctvo_cdgo_tpo_pgo		=	b.cnsctvo_cdgo_tpo_pgo


---------

Update 	#TmpPagos 
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl				=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a1 
Inner Join	bdCarteraPac.dbo.TbEstadoscuenta  b
On		a1.nmro_dcmnto				=	b.nmro_estdo_cnta


Update 	#TmpPagos
Set		nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr,
		cnsctvo_scrsl				=	b.cnsctvo_scrsl,
		cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
From		#TmpPagos   a2 
Inner Join  bdCarteraPac.dbo.tbcuentasmanuales  b
	On	a2.nmro_dcmnto				=	b.nmro_estdo_cnta


Update 	#tmpPagos
Set	 	rzn_scl	 =  c.rzn_scl
From 		#tmpPagos a3 
Inner Join bdAfiliacion.dbo.tbempleadores b
	On 	a3.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
	And	a3.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
Inner Join bdAfiliacion.dbo.tbempresas c 
	On	a3.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn


Update		#tmpPagos
Set	 	rzn_scl	 =   ltrim(rtrim(isnull(c.prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(c.sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(c.prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(c.sgndo_nmbre,'')))
From 		#tmpPagos a4 
Inner Join bdAfiliacion.dbo.tbempleadores b
	On	a4.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
	And	a4.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte 
Inner Join bdAfiliacion.dbo.tbpersonas c
	On	a4.nmro_unco_idntfccn_empldr	=	c.nmro_unco_idntfccn
	And	a4.rzn_scl						=	''


Update 	#TmpPagos
Set		cdgo_tpo_idntfccn	= c.cdgo_tpo_idntfccn,
		nmro_idntfccn		= b.nmro_idntfccn,
		dgto_vrfccn			= b.dgto_vrfccn
From		#TmpPagos   a    	
Inner Join bdAfiliacion.dbo.tbVinculados b 
ON 		a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn
Inner Join  bdAfiliacion.dbo.tbTiposIdentificacion  c
On 		c.cnsctvo_cdgo_tpo_idntfccn 	= b.cnsctvo_cdgo_tpo_idntfccn
			

Update #tmpPagos
Set nmbre_scrsl=b.nmbre_scrsl
From		bdAfiliacion.dbo.tbSucursalesAportante b 
Inner Join	#tmpPagos a 
	ON	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
	AND	a.cnsctvo_scrsl 				= b.cnsctvo_scrsl 
	AND	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte
                  


Update a
Set a.dscrpcn_sde_crtra=s.dscrpcn_sde
From		bdAfiliacion.dbo.tbSucursalesAportante b 
Inner Join	#tmpPagos a 
	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr 
	AND a.cnsctvo_scrsl 				= b.cnsctvo_scrsl 
	AND a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte
Inner Join bdafiliacion.dbo.tbsedes s
	On b.sde_crtra_pc					= s.cnsctvo_cdgo_sde



/*
Select  a.cnsctvo_cdgo_pgo,		e.dscrpcn_estdo_pgo,	t.dscrpcn_tpo_pgo , 		a.vlr_dcmnto,		
	f.cdgo_tpo_idntfccn, 		d.nmro_idntfccn, 	i.dscrpcn_clse_aprtnte,		b.nmbre_scrsl,			
	a.rzn_scl,		
	convert(char(20),replace(convert(char(20),a.fcha_rcdo,120), '-','/')) fcha_rcdo,
	convert(char(10),a.fcha_intrfce,111),
	a.nmro_rmsa,			a.nmro_lna,		a.nmro_dcmnto,			a.usro_crcn,
	a.cnsctvo_cdgo_estdo_pgo,	a.cnsctvo_cdgo_tpo_pgo, a.nmro_unco_idntfccn_empldr, 	a.cnsctvo_scrsl, 
	a.cnsctvo_cdgo_clse_aprtnte,  	d.dgto_vrfccn, 		a.sldo_pgo	
From    #TmpPagos a Inner Join
                    bdConsulta.dbo.tbSucursalesAportante b 	ON 	a.nmro_unco_idntfccn_empldr 	= b.nmro_unco_idntfccn_empldr AND a.cnsctvo_scrsl = b.cnsctvo_scrsl AND
                						    	a.cnsctvo_cdgo_clse_aprtnte 	= b.cnsctvo_cdgo_clse_aprtnte inner   JOIN
                     bdConsulta.dbo.tbVinculados d 	      	ON 	a.nmro_unco_idntfccn_empldr 	= d.nmro_unco_idntfccn Inner Join
                      bdAfiliacion.dbo.tbTiposIdentificacion f 	ON 	d.cnsctvo_cdgo_tpo_idntfccn 	= f.cnsctvo_cdgo_tpo_idntfccn Inner Join
                      bdAfiliacion.dbo.tbClasesAportantes i 		ON 	b.cnsctvo_cdgo_clse_aprtnte 	= i.cnsctvo_cdgo_clse_aprtnte Inner Join
                      bdCarteraPac.dbo.tbestadospago e 		ON 	a.cnsctvo_cdgo_estdo_pgo 	= e.cnsctvo_cdgo_estdo_pgo  Inner Join
	           bdCarteraPac.dbo.tbTipospago      T		ON	a.cnsctvo_cdgo_tpo_pgo	= t.cnsctvo_cdgo_tpo_pgo	
*/

select 	a2.cnsctvo_cdgo_pgo,		
	a2.dscrpcn_estdo_pgo,                
	a2.dscrpcn_tpo_pgo,		
	a2.vlr_dcmnto,			
	a2.cdgo_tpo_idntfccn,		
	a2.nmro_idntfccn,		
	a2.dscrpcn_clse_aprtnte,		
	a2.nmbre_scrsl,			
	a2.rzn_scl,				
	convert(char(10),fcha_rcdo,111)  as  fcha_rcdo ,			
	convert(char(10),fcha_intrfce,111) as fcha_intrfce,	
	convert(char(10),fcha_aplccn,111) as  fcha_aplccn,		
	a2.nmro_rmsa,			
	a2.nmro_lna,			
	a2.nmro_dcmnto,			
	a2.usro_crcn,		
	a2.cnsctvo_cdgo_estdo_pgo,	
	a2.cnsctvo_cdgo_tpo_pgo,		
	a2.nmro_unco_idntfccn_empldr,	
	a2.cnsctvo_scrsl,			
	a2.cnsctvo_cdgo_clse_aprtnte,	
	a2.dgto_vrfccn,			
	a2.sldo_pgo		,
    a2.dscrpcn_sde_crtra,
	b.Dscrpcn_tpo_dcmnto,	c.nmro_estdo_cnta nmro_dcmnto_crce,	(vlr_abno)	 vlr_aplcdo   ,b.cnsctvo_cdgo_tpo_dcmnto ,	 
	 c.cnsctvo_estdo_cnta 	 Consecutivo_documento_origen , cnsctvo_cdgo_estdo_estdo_cnta  estado_documento,
	 c.ttl_fctrdo,vlr_iva,c.ttl_fctrdo+vlr_iva vlr_dcmnto_dbto,sldo_estdo_cnta sldo_dcmnto_dbto,convert(date,fcha_incl_prdo_lqdcn,108) fcha_dcmnto
into #DatosInforme
From 		#TmpPagos a2 	
Inner Join	tbAbonos  a
	On	a.cnsctvo_cdgo_pgo			= a2.cnsctvo_cdgo_pgo
Inner Join	tbEstadoscuenta  c
	On	a.cnsctvo_estdo_cnta		= c.cnsctvo_estdo_cnta
Inner Join	tbLiquidaciones d 
	On	c.cnsctvo_cdgo_lqdcn		= d.cnsctvo_cdgo_lqdcn
Inner Join	tbPeriodosLiquidacion_vigencias e
	On	d.cnsctvo_cdgo_prdo_lqdcn	= e.cnsctvo_cdgo_prdo_lqdcn,
			tbtipoDocumentos  b  
Where	b.cnsctvo_cdgo_tpo_dcmnto	= 1	-- estados de cuenta
union
select a2.cnsctvo_cdgo_pgo,		
	a2.dscrpcn_estdo_pgo,                
	a2.dscrpcn_tpo_pgo,		
	a2.vlr_dcmnto,			
	a2.cdgo_tpo_idntfccn,		
	a2.nmro_idntfccn,		
	a2.dscrpcn_clse_aprtnte,		
	a2.nmbre_scrsl,			
	a2.rzn_scl,				
	convert(char(10),fcha_rcdo,111)  as  fcha_rcdo ,			
	convert(char(10),fcha_intrfce,111) as fcha_intrfce,	
	convert(char(10),fcha_aplccn,111) as  fcha_aplccn,		
	a2.nmro_rmsa,			
	a2.nmro_lna,			
	a2.nmro_dcmnto,			
	a2.usro_crcn,		
	a2.cnsctvo_cdgo_estdo_pgo,	
	a2.cnsctvo_cdgo_tpo_pgo,		
	a2.nmro_unco_idntfccn_empldr,	
	a2.cnsctvo_scrsl,			
	a2.cnsctvo_cdgo_clse_aprtnte,	
	a2.dgto_vrfccn,			
	a2.sldo_pgo		,
    a2.dscrpcn_sde_crtra,
	Dscrpcn_tpo_dcmnto,	a.nmro_nta  ,	 vlr	 ttl_dcmnto   ,  	b.cnsctvo_cdgo_tpo_dcmnto,	
	convert(int,a.nmro_nta)	Consecutivo_documento_origen  , 	cnsctvo_cdgo_estdo_nta	estado_documento,
	vlr_nta,vlr_iva,vlr_nta+vlr_iva,sldo_nta, convert(date,fcha_crcn_nta,108)
From 		#TmpPagos a2
Inner Join	TbPagosNotas a
	 On	a.cnsctvo_cdgo_pgo			=	a2.cnsctvo_cdgo_pgo
Inner Join	tbnotasPac c 
	 On	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
	And	a.nmro_nta					=	c.nmro_nta,
			tbtipoDocumentos b 
Where  	b.cnsctvo_cdgo_tpo_dcmnto	=	2		--notas debito



--fcha_dcmnto

--criterio sea por 
--fcha_Recaudo
--fcha_intrfce,***
--fcha dcmnto debito

select * From #DatosInforme  --where cnsctvo_cdgo_pgo = 1423462
order by cnsctvo_cdgo_pgo
drop table #TmpPagos
drop table #DatosInforme

 --select * From bdCarteraPac.dbo.tbcuentasmanuales  where nmro_estdo_cnta = 2363866 
 --select * From bdCarteraPac.dbo.TbEstadoscuenta     where nmro_estdo_cnta = 2363866 
  --select * From bdCarteraPac.dbo.TbEstadoscuenta     where nmro_estdo_cnta = 2363866      
 -- select * From		bdCarteraPac.dbo.tbPagos  where cnsctvo_cdgo_pgo = 1423462
 --[spTraerDocumentosDebitosAplicadosXPago] 1423462
 --select * From bdCarteraPac.dbo.tbAbonos where cnsctvo_cdgo_pgo = 1423462
 --select * From bdCarteraPac.dbo.TbEstadoscuenta     where cnsctvo_estdo_cnta = 1366131 
 --select * From bdCarteraPac.dbo.TbPagosNotas where cnsctvo_cdgo_pgo = 1423462

