
/*----------------------------------------------------------------------------------------
* Metodo o PRG		: [spPTLEjecutaCarteraVencida]
* Desarrollado por	: 
* Descripcion		: Procedimiento que consulta los afiliados de los empleadores para generar el certificado de afiliacion pos    
* Observaciones		: <\O		O\>    
* Parametros		: <\P		P\>
* Variables			: <\V		V\>
* Fecha Creacion	: <\FC		FC\>
*---------------------------------------------------------------------------------*/  
/*
* Modificado por		: <\A	Ing. Cesar García																			A\>
* Descripción			: <\D	Se optimiza procedimiento con buenas prácticas, creación de índices y rompimiento de código	D\>
* Observaciones			: <\O		O\>
* Parámetros			: <\P		P\>
* Fecha Modificacion:	: <\FM	2017-03-14																					FM\>
*-----------------------------------------------------------------------------------------*/
/*
* Modificado por		: <\A	Ing. Diana Gomez																	A\>
* Descripción			: <\D	Se ajusta el agrupamiento del encabezado y el orden final de retorno de datos de la consulta	D\>
* Observaciones			: <\O	se realiza pruebas para los casos de misma ciudad y sede, diferente ciudad misma sede, diferente ciudad, diferente sede	O\>
* Parámetros			: <\P		P\>
* Fecha Modificacion:	: <\FM	2017-05-10																					FM\>
*-----------------------------------------------------------------------------------------*/
/*
* Modificado por		: <\A	Carlos Vela - Qvision	A\>
* Descripción			: <\D	Se elimina consultas innecesarias que deterioran el rendimiento, tambien se modifica agregan indices y 
								se modifican querys ineficientes. 	D\>
* Observaciones			: <\O		O\>
* Parámetros			: <\P		P\>
* Fecha Modificacion:	: <\FM	2019-07-25																					FM\>
*-----------------------------------------------------------------------------------------*/

/*Declare @nmro_unco_idntfccn int
select * from bdafiliacion.dbo.tbvinculados
where nmro_idntfccn ='800197268'
set  @nmro_unco_idntfccn =30045029*/

CREATE PROCEDURE [dbo].[spPTLEjecutaCarteraVencida]
@nmro_unco_idntfccn int
As
Set Nocount On

Begin
	Declare			@tbla				varchar(128),
					@cdgo_cmpo 			varchar(128),
					@oprdr 				varchar(2),
					@vlr 				varchar(250),
					@cmpo_rlcn 			varchar(128),
					@cmpo_rlcn_prmtro 	varchar(128),
					@cnsctvo			Numeric(4),
					@IcInstruccion		Nvarchar(4000),
					@IcInstruccion1		Nvarchar(4000),
					@IcInstruccion2		Nvarchar(4000),
					@IcInstruccion3		Nvarchar(4000),
					@IcInstruccion4		Nvarchar(4000),
					@lcAlias			char(2),
					@lnContador			Int,
					@ldFechaSistema		Datetime,
					@Fecha_Corte		Datetime,
					@cnsctvo_scrsl 		int,
					@Fecha_Caracter		varchar(15)	

	Create Table	#tmpLiquidacionesFinalizadas
		(
			fcha_crcn					DateTime,
			cnsctvo_cdgo_prdo_lqdcn		Int,
			cnsctvo_cdgo_lqdcn			Int,
			fcha_fnl_prdo_lqdcn			DateTime
		)

	Create table	#tbCarteraConsultar
		(
			nmro_unco_idntfccn_afldo	int,
			nmro_unco_idntfccn_empldr	int,
			--cdgo_tpo_idntfccn_empldr varchar(3),
			nmro_cntrto					int,
			cnsctvo_cdgo_tpo_cntrto		int,
			nmro_idntfccn_empldr		varchar(23) ,
			cnsctvo_scrsl				int, 
			cnsctvo_cdgo_clse_aprtnte	int	
		)

	Create table	#tbCarteraSucursales
		(
			nmro_unco_idntfccn_empldr	int,
			cnsctvo_scrsl				int, 
			cnsctvo_cdgo_clse_aprtnte	int	
		)


	CREATE NONCLUSTERED INDEX [idx_nmro_unco_id_empldr]
	ON	#tbCarteraConsultar ([nmro_unco_idntfccn_empldr])

	Create Table	#tmpEstadosCuenta
		(
			nmro_unco_idntfccn_empldr	Int,
			cnsctvo_scrsl				Int,
			cnsctvo_cdgo_clse_aprtnte	Int,
			Fcha_crcn					Datetime,
			Periodo						Int,
			sldo						Numeric,
			cnsctvo_cdgo_prmtr			Int,
			Cnsctvo_cdgo_sde			Int,
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_cdgo_tpo_dcmnto		Int,
			nmro_dcmnto					VarChar(15),
			cntdd_bnfcrs				Int,
			fcha_crte					Datetime
		)

	Create Table	#tmpNotasDebito
		(
			nmro_unco_idntfccn_empldr	Int,
			cnsctvo_scrsl				Int,
			cnsctvo_cdgo_clse_aprtnte	Int,
			Fcha_crcn_nta				DateTime,
			Periodo						Int,
			sldo_nta_cntrto				Numeric,
			cnsctvo_cdgo_prmtr			Int,
			Cnsctvo_cdgo_sde			Int,
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_cdgo_tpo_dcmnto		Int,
			nmro_dcmnto					VarChar(15),
			cntdd_bnfcrs				Int,
			fcha_crte					DateTime
		)

	Create Table	#tmpDocumentosDebitos
		(
			nmro_unco_idntfccn_empldr	Int,
			cnsctvo_scrsl				Int,
			cnsctvo_cdgo_clse_aprtnte	Int,
			Fcha_crcn					DateTime,
			Periodo						Int,
			sldo						Numeric,
			cnsctvo_cdgo_prmtr			Int,
			Cnsctvo_cdgo_sde			Int,
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_cdgo_tpo_dcmnto		Int,
			dfrnca_mra					Int,
			nmro_dcmnto					VarChar(15),
			cntdd_bnfcrs				Int,
			fcha_crte					DateTime
		)

	Create Table	#tmpCarteraVencidaTotal
		(
			nmro_unco_idntfccn_empldr	Int,
			cnsctvo_scrsl				Int,
			cnsctvo_cdgo_clse_aprtnte	Int,
			Fcha_crcn					DateTime,
			Periodo						Int,
			sldo						Numeric,
			cnsctvo_cdgo_prmtr			Int,
			Cnsctvo_cdgo_sde			Int,
			cnsctvo_cdgo_tpo_cntrto		Int,
			nmro_cntrto					VarChar(15),
			cnsctvo_cdgo_tpo_dcmnto		Int,
			nmro_dcmnto					VarChar(15),
			cntdd_bnfcrs				Int,
			fcha_crte					DateTime
		)

	Create Table	#tmpFormulario
		(
			nmro_frmlro						VarChar(15),
			cnsctvo_cdgo_tpo_frmlro			Int,
			cnsctvo_cdgo_assr				Int,
			nmbre_assr						Char(150),
			cdgo_assr						Char(150),
			nmbre_crdndr					Char(150),
			cnsctvo_cdgo_tpo_cntrto			Int,
			nmro_cntrto						VarChar(15)
		)

	CREATE NONCLUSTERED INDEX [idx_cnsctvo_assr]
	ON #tmpFormulario ([cnsctvo_cdgo_assr], [cdgo_assr])

	CREATE NONCLUSTERED INDEX [idx_cntrto]
	ON #tmpFormulario ([cnsctvo_cdgo_tpo_cntrto],[nmro_cntrto])
	INCLUDE ([nmbre_assr],[cdgo_assr],[nmbre_crdndr])

	Create Table	#tmpInfomeCarteraFinal
		(
			Nmro_idntfccn						Varchar(30),
			Nmbre_scrsl							Varchar(150),
			cdgo_tpo_idntfccn					Char(3),
			nmbre_prmtr							Char(100),
			prmtr_crtra_pc						Varchar(150),
			dscrpcn_sde							Varchar(150),
			cdgo_sde							Char(3),
			sldo								Numeric,
			drccn								Varchar(80),
			tlfno								Varchar(30),
			cnsctvo_cdgo_cdd					Int,
			dscrpcn_cdd							Varchar(150),
			nmro_idntfccn_ctznte				Char(20),
			tpo_idntfccn_ctznte					Char(10),
			nmbre_ctznte						Char(100),
			cnsctvo_cdgo_tpo_cntrto				Int,
			nmro_cntrto							Char(15),
			cnsctvo_cdgo_pln					Int,
			dscrpcn_pln							Char(30),
			drccn_ctznte						Char(100),
			tlfno_ctznte						Char(50),
			dscrpcn_cdd_ctznte					Char(100),
			nmro_dcmnto							Char(15),
			nmro_unco_idntfccn_afldo			Int,
			cnsctvo_cdgo_tpo_idntfccn			Int,
			nmro_unco_idntfccn_empldr			Int,
			cnsctvo_scrsl						Int,
			cnsctvo_cdgo_clse_aprtnte			Int,
			cnsctvo_cdgo_tpo_dcmnto				Int,
			cntdd_bnfcrs						Int,
			inco_vgnca_cntrto					DateTime,
			fn_vgnca_cntrto						DateTime,
			fcha_crte							Char(10),
			cnsctvo_cdgo_sde					Int,
			cnsctvo_cdgo_tpo_idntfccn_empldr	Int,
			cdgo_assr							Char(10),
			nmbre_assr							Char(150),
			nmbre_crdndr						Char(150)
		)

	CREATE NONCLUSTERED INDEX [idx_pln]
	ON #tmpInfomeCarteraFinal	([cnsctvo_cdgo_pln])

	CREATE NONCLUSTERED INDEX [idx_tpo_idntfccn]
	ON #tmpInfomeCarteraFinal ([cnsctvo_cdgo_tpo_idntfccn])

	CREATE NONCLUSTERED INDEX [idx_assr]
	ON #tmpInfomeCarteraFinal ([cdgo_assr])

	Create Table #tmpPeriodosLiquidacion
	(
		cnsctvo_cdgo_prdo_lqdcn	Int,
		fcha_incl_prdo_lqdcn	DateTime,
		fcha_fnl_prdo_lqdcn		DateTime
	)

	CREATE NONCLUSTERED INDEX [idx_prdo_lqdcn]
	ON	#tmpPeriodosLiquidacion ([cnsctvo_cdgo_prdo_lqdcn])

	Create Table #tmpTiposIdentificacion
	(
		cnsctvo_cdgo_tpo_idntfccn	Int,
		cdgo_tpo_idntfccn			Char(5)
	)

	Create Table #tmpSedes
	(
		cnsctvo_cdgo_sde	Int,
		cdgo_sde			Char(5),
		dscrpcn_sde			VarChar(150)
	)

	--Create Table #tmpVinculados
	--(
	--	nmro_unco_idntfccn			Int,
	--	cnsctvo_cdgo_tpo_idntfccn	Int,
	--	nmro_idntfccn				VarChar(23)
	--)

	--CREATE NONCLUSTERED INDEX [idx_nmro_unco_id]
	--ON	#tmpVinculados	([nmro_unco_idntfccn])
	--INCLUDE ([cnsctvo_cdgo_tpo_idntfccn],[nmro_idntfccn])

	--CREATE NONCLUSTERED INDEX [idx_nmro_unco_id2]
	--ON	#tmpVinculados	([nmro_unco_idntfccn])
	--INCLUDE ([cnsctvo_cdgo_tpo_idntfccn])

	Create Table #tmpClasesAportante
	(
		cnsctvo_cdgo_clse_aprtnte	Int,
		cdgo_clse_aprtnte			Char(2),
		dscrpcn_clse_aprtnte		VarChar(150)
	)

	Create Table	#tmpCodigosAsesor
	(
		cnsctvo_cdgo_assr		Int,
		cdgo_assr				Char(10),
		cnsctvo_assr			Int,
		cnsctvo_cdgo_assr_jfe	Int,
		inco_vgnca				Datetime,
		fn_vgnca				DateTime
	)

	Insert Into	#tmpPeriodosLiquidacion
	Select		cnsctvo_cdgo_prdo_lqdcn,	fcha_incl_prdo_lqdcn,	fcha_fnl_prdo_lqdcn
	From		bdCarteraPac.dbo.tbperiodosliquidacion_vigencias	With(NoLock)

	Insert Into	#tmpTiposIdentificacion
	Select		cnsctvo_cdgo_tpo_idntfccn,	cdgo_tpo_idntfccn
	From		bdAfiliacion.dbo.tbTiposidentificacion	With(NoLock)

	Insert Into #tmpSedes
	Select		cnsctvo_cdgo_sde,	cdgo_sde,	dscrpcn_sde
	From		bdafiliacion.dbo.tbSedes	With(NoLock)

	Insert Into	#tmpClasesAportante
	Select		cnsctvo_cdgo_clse_aprtnte,	cdgo_clse_aprtnte,	dscrpcn_clse_aprtnte
	From		bdAfiliacion.dbo.tbClasesAportantes	With(NoLock)

	Insert Into	#tmpCodigosAsesor
	Select		cnsctvo_cdgo_assr,	cdgo_assr,	cnsctvo_assr,	cnsctvo_cdgo_assr_jfe,	inco_vgnca,	fn_vgnca
	From		bdAfiliacion.dbo.tbCodigosAsesor_Vigencias	With(NoLock)
	where 		getdate() between inco_vgnca and fn_vgnca

	Insert Into #tmpLiquidacionesFinalizadas  
	select		a.fcha_incl_prdo_lqdcn,		b.cnsctvo_cdgo_prdo_lqdcn, 
				cnsctvo_cdgo_lqdcn,			a.fcha_fnl_prdo_lqdcn 
	from 		#tmpPeriodosLiquidacion				a	With(NoLock)
	Inner Join	bdCarteraPac.dbo.tbliquidaciones	b	With(NoLock)	On	b.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_cdgo_prdo_lqdcn
	Where		b.cnsctvo_cdgo_estdo_lqdcn	=	3 

	--Consultar el Ãºltimo responsable de pago para el afiliado a la fecha de consulta
	 /*20150609 consultar los empeladores asociadoa al afiliado*/

	Insert into #tbCarteraConsultar
			(
				nmro_unco_idntfccn_afldo,				nmro_cntrto,					cnsctvo_cdgo_tpo_cntrto,					nmro_unco_idntfccn_empldr,
				cnsctvo_scrsl,							cnsctvo_cdgo_clse_aprtnte
			)
	Select		a.nmro_unco_idntfccn_afldo, vc.nmro_cntrto, vc.cnsctvo_cdgo_tpo_cntrto, b.nmro_unco_idntfccn_aprtnte, vc.cnsctvo_scrsl_ctznte, b.cnsctvo_cdgo_clse_aprtnte
	From		bdafiliacion.dbo.tbContratos			a	With(NoLock)
	inner join	bdafiliacion.dbo.tbCobranzas			b	With(NoLock)	on	a.nmro_cntrto = b.nmro_cntrto
																			and a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	inner join	bdafiliacion.dbo.tbVigenciasCobranzas	vc	With(NoLock)	on	b.nmro_cntrto = vc.nmro_cntrto
																			and b.cnsctvo_cdgo_tpo_cntrto = vc.cnsctvo_cdgo_tpo_cntrto
																			and b.cnsctvo_cbrnza = vc.cnsctvo_cbrnza
	where		a.nmro_unco_idntfccn_afldo	=	@nmro_unco_idntfccn
	and			vc.estdo_rgstro				=	'S'
	and			a.cnsctvo_cdgo_tpo_cntrto	=	2
	group by	a.nmro_unco_idntfccn_afldo, vc.nmro_cntrto, vc.cnsctvo_cdgo_tpo_cntrto, b.nmro_unco_idntfccn_aprtnte, vc.cnsctvo_scrsl_ctznte ,b.cnsctvo_cdgo_clse_aprtnte

	If @@ROWCOUNT = 0
		Begin
			Insert into #tbCarteraConsultar
			(			nmro_unco_idntfccn_afldo,					nmro_cntrto,					cnsctvo_cdgo_tpo_cntrto,					nmro_unco_idntfccn_empldr,
						cnsctvo_scrsl,								cnsctvo_cdgo_clse_aprtnte
			)
			select		a.nmro_unco_idntfccn_afldo,					vc.nmro_cntrto,					vc.cnsctvo_cdgo_tpo_cntrto,					b.nmro_unco_idntfccn_aprtnte,
						vc.cnsctvo_scrsl_ctznte,					b.cnsctvo_cdgo_clse_aprtnte
			from		bdafiliacion.dbo.tbContratos			a	With(NoLock)
			inner join	bdafiliacion.dbo.tbCobranzas			b	With(NoLock)	on	a.nmro_cntrto				=	b.nmro_cntrto
																					and	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
			inner join	bdafiliacion.dbo.tbVigenciasCobranzas	vc	With(NoLock)	on	b.nmro_cntrto				=	vc.nmro_cntrto
																					and	b.cnsctvo_cdgo_tpo_cntrto	=	vc.cnsctvo_cdgo_tpo_cntrto
																					and	b.cnsctvo_cbrnza			=	vc.cnsctvo_cbrnza
			where		b.nmro_unco_idntfccn_aprtnte	=	@nmro_unco_idntfccn
			and			vc.estdo_rgstro					=	'S'
			and			a.cnsctvo_cdgo_tpo_cntrto		=	2
			group by	a.nmro_unco_idntfccn_afldo, vc.nmro_cntrto, vc.cnsctvo_cdgo_tpo_cntrto, b.nmro_unco_idntfccn_aprtnte, vc.cnsctvo_scrsl_ctznte ,b.cnsctvo_cdgo_clse_aprtnte
		End




	Insert into	#tmpEstadosCuenta
	SELECT		a.nmro_unco_idntfccn_empldr,					a.cnsctvo_scrsl,				a.cnsctvo_cdgo_clse_aprtnte,				a.Fcha_crcn,
				bdrecaudos.dbo.fnCalculaPeriodo(a.Fcha_crcn),	c.sldo,							b.prmtr_crtra_pc,							b.sde_crtra_pc,
				c.cnsctvo_cdgo_tpo_cntrto,						c.nmro_cntrto,					1,											a.nmro_estdo_cnta,
				c.cntdd_bnfcrs,									e.fcha_incl_prdo_lqdcn
	FROM		#tbCarteraConsultar							con	With(NoLock)
	inner join  bdCarteraPac.dbo.tbestadosCuenta			a	With(NoLock)	on	con.nmro_unco_idntfccn_empldr	=	a.nmro_unco_idntfccn_empldr
																				and con.cnsctvo_scrsl				=	a.cnsctvo_scrsl
																				and con.cnsctvo_cdgo_clse_aprtnte	=	a.cnsctvo_cdgo_clse_aprtnte
	inner join	bdCarteraPac.dbo.tbEstadosCuentaContratos	c	With(NoLock)	on	a.cnsctvo_estdo_cnta			=	c.cnsctvo_estdo_cnta
																				and c.nmro_cntrto					=	con.nmro_cntrto
																				and c.cnsctvo_cdgo_tpo_cntrto		=	con.cnsctvo_cdgo_tpo_cntrto
	inner join  bdafiliacion.dbo.tbSucursalesAportante		b	With(NoLock)	on	a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
																				And	a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte   
																				And	a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     						   
	inner join	#tmpSedes									s	With(NoLock)	on	b.sde_crtra_pc					=	s.cnsctvo_cdgo_sde  
	inner join  bdCarteraPac.dbo.tbpromotores				p	With(NoLock)	on  b.prmtr_crtra_pc				=	p.cnsctvo_cdgo_prmtr 
	inner join	bdCarteraPac.dbo.Tbliquidaciones			d	With(NoLock)	on  a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn   
	inner join	#tmpPeriodosLiquidacion						e	With(NoLock)	on  e.cnsctvo_cdgo_prdo_lqdcn		=	d.cnsctvo_cdgo_prdo_lqdcn  
	inner join  #tmpClasesAportante							l	With(NoLock)	On	b.cnsctvo_cdgo_clse_aprtnte		=	l.cnsctvo_cdgo_clse_aprtnte 
	Where 		c.sldo 	>	 0 
	And			d.cnsctvo_cdgo_estdo_lqdcn	=	3	   
	And			a.cnsctvo_cdgo_estdo_estdo_cnta  != 4    --anulado

	--Segundo se hace para Notas Debito
	Insert Into	#tmpNotasDebito
	select  	a.nmro_unco_idntfccn_empldr,						a.cnsctvo_scrsl,				a.cnsctvo_cdgo_clse_aprtnte,				a.Fcha_crcn_nta,
				bdrecaudos.dbo.fnCalculaPeriodo(a.Fcha_crcn_nta),	c.sldo_nta_cntrto,				b.prmtr_crtra_pc,							b.sde_crtra_pc,
				c.cnsctvo_cdgo_tpo_cntrto,							c.nmro_cntrto,					2,											a.nmro_nta,
				0,													e.fcha_incl_prdo_lqdcn
	from 		bdCarteraPac.dbo.tbnotasPac				a	With(NoLock)
	inner join	bdafiliacion.dbo.tbsucursalesaportante	b	With(NoLock)	On	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
																			And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
																			And	a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
	inner join	bdCarteraPac.dbo.tbnotasContrato		c	With(NoLock)	On	a.nmro_nta					=	c.nmro_nta
																			And	a.cnsctvo_cdgo_tpo_nta		=	c.cnsctvo_cdgo_tpo_nta
	inner join	#tmpPeriodosLiquidacion					e	With(NoLock)	On	e.cnsctvo_cdgo_prdo_lqdcn	=	a.cnsctvo_prdo
	where		c.sldo_nta_cntrto		 >	 0
	And			1	=	2

	Insert Into	#tmpNotasDebito
	SELECT		a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,										a.cnsctvo_cdgo_clse_aprtnte ,
				a.Fcha_crcn_nta,				bdrecaudos.dbo.fnCalculaPeriodo(a.Fcha_crcn_nta),		c.sldo_nta_cntrto,
				b.prmtr_crtra_pc,				b.sde_crtra_pc,											c.cnsctvo_cdgo_tpo_cntrto,
				c.nmro_cntrto,					2,														a.nmro_nta,
				0,								e.fcha_incl_prdo_lqdcn
	FROM		#tbCarteraSucursales						con	With(NoLock)
	inner join  bdCarteraPac.dbo.tbnotasPac					a	With(NoLock)	on	con.nmro_unco_idntfccn_empldr	=	a.nmro_unco_idntfccn_empldr
																				and con.cnsctvo_scrsl				=	a.cnsctvo_scrsl
																				and con.cnsctvo_cdgo_clse_aprtnte	=	a.cnsctvo_cdgo_clse_aprtnte
	inner join	bdCarteraPac.dbo.tbnotasContrato			c	With(NoLock)	on	a.nmro_nta						=	c.nmro_nta
																				and a.cnsctvo_cdgo_tpo_nta			=	c.cnsctvo_cdgo_tpo_nta
	inner join	bdCarteraPac.dbo.tbEstadosCuentaContratos	ecc	With(NoLock)	on	c.cnsctvo_estdo_cnta_cntrto		=	ecc.cnsctvo_estdo_cnta_cntrto
																				and c.nmro_cntrto					=	ecc.nmro_cntrto
																				and c.cnsctvo_cdgo_tpo_cntrto		=	ecc.cnsctvo_cdgo_tpo_cntrto
	inner join  bdafiliacion.dbo.tbSucursalesAportante		b	With(NoLock)	on	a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
																				And	a.cnsctvo_scrsl					=	b.cnsctvo_scrsl
	inner join  #tmpSedes									s	With(NoLock)	on	b.sde_crtra_pc					=	s.cnsctvo_cdgo_sde  
	inner join  #tmpPeriodosLiquidacion						e	With(NoLock)	On	e.cnsctvo_cdgo_prdo_lqdcn		=	a.cnsctvo_prdo
	inner join  bdCarteraPac.dbo.tbpromotores				p	With(NoLock)	on	b.prmtr_crtra_pc				=	p.cnsctvo_cdgo_prmtr 
	inner join	#tmpClasesAportante							l	With(NoLock)	on	b.cnsctvo_cdgo_clse_aprtnte		=	l.cnsctvo_cdgo_clse_aprtnte
	Where 		c.sldo_nta_cntrto 	>	 0 
	And			a.cnsctvo_cdgo_tpo_nta	=	1    --Nota Debito
	And			a.cnsctvo_cdgo_estdo_nta	!=	6     --Estado diferente de anulada

	Insert into	#tmpEstadosCuenta
	Select		nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,						cnsctvo_cdgo_clse_aprtnte,						Fcha_crcn_nta,
				Periodo,								sldo_nta_cntrto,					cnsctvo_cdgo_prmtr,								Cnsctvo_cdgo_sde,
				cnsctvo_cdgo_tpo_cntrto,				nmro_cntrto,						cnsctvo_cdgo_tpo_dcmnto,						nmro_dcmnto,
				cntdd_bnfcrs,							fcha_crte
	From		#tmpNotasDebito	With(NoLock)

	Insert Into	#tmpDocumentosDebitos
	SELECT		nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,						cnsctvo_cdgo_clse_aprtnte,						Fcha_crcn,
				Periodo,								sldo,								cnsctvo_cdgo_prmtr,								Cnsctvo_cdgo_sde,
				cnsctvo_cdgo_tpo_cntrto,				nmro_cntrto,						cnsctvo_cdgo_tpo_dcmnto,						0,
				nmro_dcmnto,							cntdd_bnfcrs,						fcha_crte
	From		#tmpEstadosCuenta	With(NoLock)

	--select * from #tmpDocumentosDebitos
	Update		#tmpDocumentosDebitos
	Set			dfrnca_mra	=	Datediff(Month,Convert(varchar(6), Periodo)+'01',Substring(convert(varchar(8),getdate(),112),1,6)+ '01')

	Insert Into	#tmpCarteraVencidaTotal
	Select  	nmro_unco_idntfccn_empldr,				cnsctvo_scrsl,						cnsctvo_cdgo_clse_aprtnte,						Fcha_crcn,
				Periodo,								sldo,								cnsctvo_cdgo_prmtr,								Cnsctvo_cdgo_sde,
				cnsctvo_cdgo_tpo_cntrto,				nmro_cntrto,						cnsctvo_cdgo_tpo_dcmnto,						nmro_dcmnto,
				cntdd_bnfcrs,							fcha_crte
	From		#tmpDocumentosDebitos	With(NoLock)
	where 		dfrnca_mra	>	0

	--Insert Into	#tmpVinculados
	--Select		v.nmro_unco_idntfccn,	v.cnsctvo_cdgo_tpo_idntfccn,	v.nmro_idntfccn
	--from		#tmpCarteraVencidaTotal			c	With(NoLock)
	--inner join	bdAfiliacion.dbo.tbVinculados	v	With(NoLock)	on	v.nmro_unco_idntfccn= c.nmro_unco_idntfccn_empldr
	--Where		v.vldo= 'S'

	Insert Into	#tmpInfomeCarteraFinal
	Select		Nmro_idntfccn,								Nmbre_scrsl,					cdgo_tpo_idntfccn,					NULL,						prmtr_crtra_pc,
				dscrpcn_sde,								cdgo_sde,						sldo,								d.drccn,					d.tlfno,
				d.cnsctvo_cdgo_cdd,							ci.dscrpcn_cdd,					NULL,								NULL,						NULL,
				b.cnsctvo_cdgo_tpo_cntrto,					b.nmro_cntrto,					0,									NULL,						NULL,
				NULL,										NULL,							b.nmro_dcmnto,						0,							0,
				d.nmro_unco_idntfccn_empldr,				d.cnsctvo_scrsl,				d.cnsctvo_cdgo_clse_aprtnte,		cnsctvo_cdgo_tpo_dcmnto,	cntdd_bnfcrs,
				NULL,										NULL,							convert(char(10),fcha_crte,111),	e.cnsctvo_cdgo_sde,			0,
				NULL,										NULL,							NULL
	From		#tmpCarteraVencidaTotal					b	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbVinculados 			a	With(NoLock)	On	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_empldr
	Inner Join	#tmpTiposIdentificacion 				c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_idntfccn	=	a.cnsctvo_cdgo_tpo_idntfccn
	Inner Join	bdafiliacion.dbo.tbsucursalesaportante 	d	With(NoLock)	On	b.nmro_unco_idntfccn_empldr	=	d.nmro_unco_idntfccn_empldr
																			And	b.cnsctvo_cdgo_clse_aprtnte	=	d.cnsctvo_cdgo_clse_aprtnte
																			And	b.cnsctvo_scrsl				=	d.cnsctvo_scrsl
	Inner Join	#tmpSedes  								e	With(NoLock)	On	d.sde_crtra_pc				=	e.cnsctvo_cdgo_sde
	Inner Join	bdafiliacion.dbo.tbciudades  			ci	With(NoLock)	On	d.cnsctvo_cdgo_cdd			=	ci.cnsctvo_cdgo_cdd

	Update		#tmpInfomeCarteraFinal
	Set			nmbre_prmtr	=	case when isnull(prmtr_crtra_pc,0) != 0 then ltrim(Rtrim(cdgo_prmtr)) + ' ' + ltrim(rtrim(dscrpcn_prmtr)) else '' end  
	From		#tmpInfomeCarteraFinal					a	With(NoLock)
	Inner Join	bdCarteraPac.dbo.tbpromotores_vigencias	b	With(NoLock)	On	a.prmtr_crtra_pc	=	b.cnsctvo_cdgo_prmtr

	Update		#tmpInfomeCarteraFinal
	Set			nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo,
				cnsctvo_cdgo_pln			=	b.cnsctvo_cdgo_pln,
				inco_vgnca_cntrto			=	b.inco_vgnca_cntrto,
				fn_vgnca_cntrto = b.fn_vgnca_cntrto
	From		#tmpInfomeCarteraFinal			a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbcontratos	b	With(NoLock)	On	a.nmro_cntrto				=	b.nmro_cntrto
																	And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto

	Update		#tmpInfomeCarteraFinal
	Set			dscrpcn_pln			=	b.dscrpcn_pln
	From		#tmpInfomeCarteraFinal			a	With(NoLock)
	Inner Join	bdplanbeneficios.dbo.tbplanes	b	With(NoLock)	On	a.cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln

	Update		#tmpInfomeCarteraFinal
	Set			nmro_idntfccn_ctznte		=	ltrim(rtrim(b.nmro_idntfccn)),
				cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn
	From		#tmpInfomeCarteraFinal			a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbVinculados	b	With(NoLock)	On	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn

	Update		#tmpInfomeCarteraFinal
	Set			tpo_idntfccn_ctznte		=	ltrim(rtrim(b.cdgo_tpo_idntfccn))
	From		#tmpInfomeCarteraFinal	a
	Inner Join	#tmpTiposIdentificacion	b	On	a.cnsctvo_cdgo_tpo_idntfccn	=	b.cnsctvo_cdgo_tpo_idntfccn

	Update		#tmpInfomeCarteraFinal
	Set			nmbre_ctznte		=	ltrim(rtrim(prmr_aplldo)) + ' '  + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' ' + ltrim(rtrim(sgndo_nmbre))  ,
				drccn_ctznte		=	drccn_rsdnca,
				tlfno_ctznte		=	tlfno_rsdnca,
				dscrpcn_cdd_ctznte	=	ci.dscrpcn_cdd	
	From		#tmpInfomeCarteraFinal		a	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbpersonas	b	With(NoLock)	On	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
	Inner Join	bdafiliacion.dbo.tbciudades	ci	With(NoLock)	On	cnsctvo_cdgo_cdd_rsdnca		=	ci.cnsctvo_cdgo_cdd

	Update		#tmpInfomeCarteraFinal
	Set			cnsctvo_cdgo_tpo_idntfccn_empldr = v.cnsctvo_cdgo_tpo_idntfccn
	From		#tmpInfomeCarteraFinal			i	With(NoLock)
	Inner Join	bdAfiliacion.dbo.tbVinculados	v	With(NoLock)	On	i.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn

	Insert Into	#tmpFormulario
	Select		fc.nmro_frmlro,					fc.cnsctvo_cdgo_tpo_frmlro,						com.cnsctvo_cdgo_assr,					NULL,
				NULL,							NULL,											com.cnsctvo_cdgo_tpo_cntrto,			com.nmro_cntrto
	From		#tmpInfomeCarteraFinal					icf	With(NoLock)
	inner join	bdAfiliacion.DBO.tbformulariosxcontrato fc	With(NoLock)	on	icf.cnsctvo_cdgo_tpo_cntrto = fc.cnsctvo_cdgo_tpo_cntrto
																			and icf.nmro_cntrto = fc.nmro_cntrto
	inner join	bdAfiliacion.DBO.tbformularioscomision	com	With(NoLock)	on	fc.cnsctvo_cdgo_tpo_cntrto	= com.cnsctvo_cdgo_tpo_cntrto	--With(index(IX_Contrato))
																			And	fc.nmro_cntrto			= com.nmro_cntrto
																			And fc.cnsctvo_cdgo_tpo_frmlro = com.cnsctvo_cdgo_tpo_frmlro
																			And fc.nmro_frmlro = com.nmro_frmlro

	Update		#tmpFormulario
	Set			nmbre_assr 		= ltrim(rtrim(Isnull(a.prmr_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_nmbre,'')))+' '+ltrim(rtrim(Isnull(a.prmr_aplldo,'')))+' '+ltrim(rtrim(Isnull(a.sgndo_aplldo,''))),
    			cdgo_assr		= c.cdgo_assr
	From		#tmpFormulario							f	With(NoLock)
	inner join 	#tmpCodigosAsesor						c	With(NoLock)	on	f.cnsctvo_cdgo_assr		=	c.cnsctvo_cdgo_assr
	inner join 	bdafiliacion.dbo.tbAsesoresComerciales	a	With(NoLock)	on	c.cnsctvo_assr 			= 	a.cnsctvo_assr

	update		#tmpFormulario
	set			nmbre_crdndr = ltrim(rtrim(Isnull(b.prmr_nmbre,'')))+' '+
				ltrim(rtrim(Isnull(b.sgndo_nmbre,'')))+' '+
				ltrim(rtrim(Isnull(b.prmr_aplldo,'')))+' '+
				ltrim(rtrim(Isnull(b.sgndo_aplldo,'')))
	from		#tmpFormulario							a	With(NoLock)
	Inner Join	bdAfiliacion.DBO.tbAsesoresComerciales	b	With(NoLock)	On	b.cnsctvo_assr			=	a.cnsctvo_cdgo_assr
	Inner Join	#tmpCodigosAsesor						c	With(NoLock)	On	a.cdgo_assr				=	c.cdgo_assr
	Inner Join	#tmpCodigosAsesor						d	With(NoLock)	On	c.cnsctvo_cdgo_assr_jfe =	d.cnsctvo_cdgo_assr
																			and	d.cnsctvo_assr			=	b.cnsctvo_assr


	Update		icf
	Set			icf.cdgo_assr		= ltrim(rtrim(f.cdgo_assr)),
 				icf.nmbre_assr		= f.nmbre_assr,		
	 			icf.nmbre_crdndr	= f.nmbre_crdndr
	From		#tmpInfomeCarteraFinal	icf	With(NoLock)
	Inner Join	#tmpFormulario			f	With(NoLock)	on	icf.cnsctvo_cdgo_tpo_cntrto = f.cnsctvo_cdgo_tpo_cntrto
															and icf.nmro_cntrto				= f.nmro_cntrto

	Update		#tmpInfomeCarteraFinal
	Set			cdgo_assr = ' ', 
 				nmbre_assr = ' ',		
	 			nmbre_crdndr = ' '
	where		cdgo_assr = '9999'

	--select * from #tmpInfomeCarteraFinal
	declare		@mensaje varchar(800)

	select		@mensaje =  ltrim(Rtrim(vlr_prmtro_crctr ))
	from		bdseguridad.dbo.tbParametrosGeneralesPortal_Vigencias	With(NoLock)
	where		cnsctvo_cdgo_prmtro_gnrl_slctd_sld = 118
	and			getdate() between inco_vgnca and fn_Vgnca

	---Cabecera del informe
    Select		Nmro_idntfccn	ni_rspnsble_pgo,				Nmbre_scrsl	rspnsble_pgo,			cdgo_tpo_idntfccn	ti_rspnsble_pgo,			max(dscrpcn_cdd) dscrpcn_cdd ,
				dscrpcn_sde,									max(drccn) drccn,								max(tlfno) tlfno,											nmbre_prmtr,
				'' tpo_idntfccn_ctznte,							'' nmro_idntfccn_ctznte,				'' nmbre_ctznte,									0	nmro_cntrto,
				''	dscrpcn_pln,								0	nmro_dcmnto,					''	prdo,										0	sldo,
				0	vlr_sb_ttl_pln,								sum(sldo)	ttl_gnrl,				''	mnsje_fnl_pgna,						'C'	tpo_rgstro_rprte
	From		#tmpInfomeCarteraFinal	With(NoLock)
	group by	Nmro_idntfccn,									Nmbre_scrsl,						cdgo_tpo_idntfccn,								
				dscrpcn_sde,																				nmbre_prmtr
	UNION  
	--- Detalle del informe
	Select		Nmro_idntfccn	ni_rspnsble_pgo,				Nmbre_scrsl	rspnsble_pgo,			cdgo_tpo_idntfccn	ti_rspnsble_pgo,			dscrpcn_cdd,
				dscrpcn_sde,									drccn,								tlfno,											nmbre_prmtr,
				tpo_idntfccn_ctznte,							nmro_idntfccn_ctznte,				nmbre_ctznte,									nmro_cntrto	aflcn,
				dscrpcn_pln,									nmro_dcmnto,						substring(fcha_crte,1,7)	prdo,				sldo,
				0	vlr_ttl,									0	ttl_gnrl,						''	mnsje_fnl_pgna,								'D'	tpo_rgstro_rprte
	from		#tmpInfomeCarteraFinal	With(NoLock)
	UNION  
	--- Subtotales por contrato de PAC
	Select		Nmro_idntfccn	ni_rspnsble_pgo,				Nmbre_scrsl	rspnsble_pgo,			cdgo_tpo_idntfccn	ti_rspnsble_pgo,			dscrpcn_cdd,
				dscrpcn_sde,									drccn,								tlfno,											nmbre_prmtr,
				tpo_idntfccn_ctznte,							nmro_idntfccn_ctznte,				nmbre_ctznte,									0	nmro_cntrto,
				'' as dscrpcn_pln,									0	nmro_dcmnto,					'' prdo,										0	sldo,
				sum(sldo)	vlr_ttl,							0	ttl_gnrl,						''	mnsje_fnl_pgna,								'S' as tpo_rgstro_rprte
	From		#tmpInfomeCarteraFinal	With(NoLock)
	group by	Nmro_idntfccn,									Nmbre_scrsl,						cdgo_tpo_idntfccn,								dscrpcn_cdd,
				dscrpcn_sde,									drccn,								tlfno,											nmbre_prmtr,
				nmro_idntfccn_ctznte,							tpo_idntfccn_ctznte,				nmbre_ctznte									
	--order by	dscrpcn_sde,dscrpcn_cdd, Nmro_idntfccn,nmro_idntfccn_ctznte,tpo_rgstro_rprte,dscrpcn_pln
	order by	dscrpcn_sde, Nmro_idntfccn,nmro_idntfccn_ctznte,tpo_rgstro_rprte,dscrpcn_pln
	
	Drop Table	#tmpLiquidacionesFinalizadas
	Drop Table	#tbCarteraConsultar
	Drop Table	#tmpEstadosCuenta
	Drop Table	#tmpNotasDebito
	Drop Table	#tmpDocumentosDebitos
	Drop Table	#tmpCarteraVencidaTotal
	Drop Table	#tmpFormulario
	Drop Table	#tmpInfomeCarteraFinal
	Drop Table	#tmpPeriodosLiquidacion
	Drop Table	#tmpTiposIdentificacion
	Drop Table	#tmpSedes
	--Drop Table	#tmpVinculados
	Drop Table	#tmpClasesAportante
	Drop Table	#tmpCodigosAsesor
	Drop Table  #tbCarteraSucursales

End
