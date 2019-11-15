

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsDetEmpleador
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el reporte del Estadistico de facturacion			 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Fernando Valencia EAM\>
* Descripcion			: <\DM  Generar todas las sucursales al seleccionar 999999999 Inexistente en el clienteDM\>
* Descripcion			: <\DM  Al ignorar la sede saca todas las sedes                                                          DM\>
* Descripcion			: <\DM  Se agrega el campo valor ants de iva                                                          DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2006/03/30 FM\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing. Juan Manuel Victoria EAM\>
* Descripcion			: <\DM  Se realiza ajuste de consulta se camia left por inner DM\>
* Descripcion			: <\DM  Al registra sede influencia                                                         DM\>
* Descripcion			: <\DM                                                           DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2017/03/16 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsDetEmpleador]

As
Declare
@tbla						varchar(128),
@cdgo_cmpo 					varchar(128),
@oprdr 						varchar(2),
@vlr 						varchar(250),
@cmpo_rlcn 					varchar(128),
@cmpo_rlcn_prmtro 			varchar(128),
@cnsctvo					Numeric(4),
@IcInstruccion				Nvarchar(4000),
@IcInstruccion1				Nvarchar(4000),
@IcInstruccion2				Nvarchar(4000),
@lcAlias					char(2),
@lnContador					Int,
@ldFechaSistema				Datetime,
@Fecha_Corte				Datetime,
@Fecha_Caracter				varchar(15),
@lnValorIva					numeric(12,2),
@cnsctvo_cdgo_sde  			int,
@cnsctvo_cdgo_clse_aprtnte 	int,
@nmro_unco_idntfccn_empldr  int, 
@cnsctvo_scrsl 				int,
@prdo 						int,
@Valor_Porcentaje_Iva		int,
@cnsctvo_cdgo_lqdcn1		Int,
@cnsctvo_cdgo_lqdcn2		Int

Set Nocount On

Select	@ldFechaSistema	=	Getdate()

Select	@Valor_Porcentaje_Iva	= prcntje
From	bdCarteraPac.dbo.tbConceptosLiquidacion_Vigencias with(nolock)
Where	cnsctvo_cdgo_cncpto_lqdcn	= 3
And	@ldFechaSistema	Between inco_vgnca And 	fn_vgnca


--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar


Set	@cnsctvo_cdgo_sde  			=	NULL
Set	@cnsctvo_cdgo_clse_aprtnte 	=	NULL
Set	@nmro_unco_idntfccn_empldr  =	NULL
Set	@cnsctvo_scrsl 				=	NULL
Set	@prdo 						=	NULL
Set @cnsctvo_cdgo_lqdcn1		=	NULL
Set @cnsctvo_cdgo_lqdcn2		=	NULL

/*

Set	@cnsctvo_cdgo_sde  			=	 7
Set	@cnsctvo_cdgo_clse_aprtnte 		=	 1
Set	@nmro_unco_idntfccn_empldr  		=	 100003
Set	@cnsctvo_scrsl 			=	 1
Set	@prdo 					=	200907*/
/*
select * from bdafiliacion.dbo.tbVinculados v where v.nmro_idntfccn = '805001157'
select * from bdafiliacion.dbo.tbSucursalesAportante sa where sa.nmro_unco_idntfccn_empldr = 100003
*/

Select 	@prdo 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'prdo' 

Select 	@cnsctvo_cdgo_sde 	 =	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 = 	'cnsctvo_cdgo_sde' 

Select 	@cnsctvo_cdgo_clse_aprtnte  	=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_cdgo_clse_aprtnte' 

Select 	@nmro_unco_idntfccn_empldr 	=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'nmro_unco_idntfccn_empldr' 

Select 	@cnsctvo_scrsl	 		=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_scrsl' 

Select 	@cnsctvo_cdgo_lqdcn1	=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_cdgo_lqdcn' 
And		oprdr				=	'>='

Select 	@cnsctvo_cdgo_lqdcn2	=	vlr	
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 	 		= 	'cnsctvo_cdgo_lqdcn' 
And		oprdr				=	'<='



-- Contador de condiciones
Select @lnContador = 1

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar

select    bdRecaudos.dbo.fnCalculaPeriodo (a.fcha_incl_prdo_lqdcn) 	prdo,
	 cnsctvo_cdgo_lqdcn
into 	#tmpLiquidacionesFinalizadas
from 	bdCarteraPac.dbo.tbperiodosliquidacion_vigencias a with(nolock), bdCarteraPac.dbo.tbliquidaciones b with(nolock)
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn
And	b.cnsctvo_cdgo_estdo_lqdcn	IN	(3,6)
--select * from 		#tmpLiquidacionesFinalizadas
     
				
-- primero se hace para estados de cuenta

Create Table #tmpDetEmpleador	(
	prdo						udtPeriodo,
	nmro_unco_idntfccn_empldr	Int,
	cnsctvo_cdgo_clse_aprtnte	Int,
	cnsctvo_scrsl				Int,
	cnsctvo_estdo_cnta			Int,	
	nmbre_scrsl					udtDescripcion,
	nmro_estdo_cnta			Varchar(15),
	cdgo_sde					Char(30),
	dscrpcn_sde					udtDescripcion,
	drccn						udtDireccion,
	tlfno						udtTelefono,
	cnsctvo_cdgo_lqdcn			Int,
	sde_crtra_pc				Int,
	cnsctvo_cdgo_sde_atncn		Int
	)

/*
Select  	
	prdo,
	nmro_unco_idntfccn_empldr,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_scrsl,
	a.cnsctvo_estdo_cnta,
	space(200)	nmbre_scrsl,
	a.nmro_estdo_cnta,
	space(30)	cdgo_sde,
	space(100)	dscrpcn_sde,
	space(80)	drccn ,
	space(30)	tlfno,
	a.cnsctvo_cdgo_lqdcn,
	0 As sde_crtra_pc
into	#tmpDetEmpleador
from	TbestadosCuenta a, 
	TbEstadosCuentaContratos  c,
	#tmpLiquidacionesFinalizadas  d 
where	 a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=	d.cnsctvo_cdgo_lqdcn	
And	 1	=	2


Select 	@prdo 	 =	vlr	
Select 	@cnsctvo_cdgo_sde 	 =	vlr	

Select 	@cnsctvo_cdgo_clse_aprtnte  	=	vlr	
Select 	@nmro_unco_idntfccn_empldr 	=	vlr	
Select 	@cnsctvo_scrsl	 			=	vlr	

Select 	@cnsctvo_cdgo_lqdcn1	=	vlr	
Select 	@cnsctvo_cdgo_lqdcn2	=	vlr	
*/
If @nmro_unco_idntfccn_empldr Is Null
Begin

	If @cnsctvo_cdgo_sde is null
	Begin

		Insert	into	#tmpDetEmpleador
		SELECT	prdo,
				a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_scrsl,
				a.cnsctvo_estdo_cnta,
				b.nmbre_scrsl, a.nmro_estdo_cnta,
				null cdgo_sde,
				null dscrpcn_sde,
				b.drccn ,
				b.tlfno, 
				a.cnsctvo_cdgo_lqdcn,
				b.sde_crtra_pc,
				b.cnsctvo_cdgo_sde_atncn
		FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
				#tmpLiquidacionesFinalizadas d ,
				bdafiliacion.dbo.tbSucursalesAportante  b with(nolock) 
		Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
		And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
		And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
		And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     
--		And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
--		And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
--		And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
		And		(d.prdo = @prdo)
		And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

		Insert	into	#tmpDetEmpleador
		SELECT	prdo,
				a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_scrsl,
				a.cnsctvo_estdo_cnta,
				b.nmbre_scrsl, a.nmro_estdo_cnta,
				null cdgo_sde,
				null dscrpcn_sde,
				b.drccn ,
				b.tlfno,
				a.cnsctvo_cdgo_lqdcn,
				b.sde_crtra_pc,
				b.cnsctvo_cdgo_sde_atncn
		FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
				#tmpLiquidacionesFinalizadas d ,
				bdafiliacion.dbo.tbSucursalesAportante  b with(nolock) 
		Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
		And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
		And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
		And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl     
--		And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
--		And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
--		And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
		And		(d.prdo = @prdo)
		And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

	end
	Else
	begin

		Insert	into	#tmpDetEmpleador
		SELECT	prdo,
				a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_scrsl,
				a.cnsctvo_estdo_cnta,
				b.nmbre_scrsl, a.nmro_estdo_cnta,
				s.cdgo_sde,
				s.dscrpcn_sde,
				b.drccn ,
				b.tlfno,
				a.cnsctvo_cdgo_lqdcn,
				b.sde_crtra_pc,
				b.cnsctvo_cdgo_sde_atncn
		FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
				#tmpLiquidacionesFinalizadas d ,
				bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)  ,
				bdafiliacion.dbo.tbsedes s with(nolock)
		Where	a.cnsctvo_cdgo_lqdcn				=	d.cnsctvo_cdgo_lqdcn  
		And		a.cnsctvo_cdgo_estdo_estdo_cnta		!= 	4	 
		And		a.nmro_unco_idntfccn_empldr			=	b.nmro_unco_idntfccn_empldr  
		And		a.cnsctvo_cdgo_clse_aprtnte			=	b.cnsctvo_cdgo_clse_aprtnte  
		And		a.cnsctvo_scrsl						=	b.cnsctvo_scrsl     
		And		b.sde_crtra_pc						=	@cnsctvo_cdgo_sde
		And		b.sde_crtra_pc						=	s.cnsctvo_cdgo_sde
		And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
--		And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
--		And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
--		And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
		And		(d.prdo = @prdo)
		And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

		Insert	into	#tmpDetEmpleador
		SELECT	prdo,
				a.nmro_unco_idntfccn_empldr,
				a.cnsctvo_cdgo_clse_aprtnte,
				a.cnsctvo_scrsl,
				a.cnsctvo_estdo_cnta,
				b.nmbre_scrsl, a.nmro_estdo_cnta,
				s.cdgo_sde,
				s.dscrpcn_sde,
				b.drccn ,
				b.tlfno,
				a.cnsctvo_cdgo_lqdcn,
				b.sde_crtra_pc,
				b.cnsctvo_cdgo_sde_atncn
		FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
				#tmpLiquidacionesFinalizadas d ,
				bdafiliacion.dbo.tbSucursalesAportante  b with(nolock) ,
				bdafiliacion.dbo.tbsedes s with(nolock)
		Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
		And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
		And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
		And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl     
		And		b.sde_crtra_pc				=	@cnsctvo_cdgo_sde
		And		b.sde_crtra_pc				=	s.cnsctvo_cdgo_sde
		And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
--		And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
--		And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
--		And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
		And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
		And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

	end 			
 	

End
Else
Begin

	if @cnsctvo_cdgo_sde is null
		begin

			if @cnsctvo_scrsl = 999999999----Para que el informe salga por todas sucursales
				begin

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							null cdgo_sde,
							null dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
							#tmpLiquidacionesFinalizadas d,
							bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)
					Where 	 a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							null cdgo_sde,
							null dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
							#tmpLiquidacionesFinalizadas d,
							bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl     
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

				end

			else    ----Para una sucursal
				begin

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							null cdgo_sde,
							null dscrpcn_sde,
							b.drccn ,
							b.tlfno, 
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM      bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
	   					#tmpLiquidacionesFinalizadas d,
	   					bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							null cdgo_sde,
							null dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
							#tmpLiquidacionesFinalizadas d,
							bdafiliacion.dbo.tbSucursalesAportante  b with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl     
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

				end 				 
		end


	-------- para cuando trae codigo de sede
	else 
		begin

			if @cnsctvo_scrsl = 999999999----Para que el informe salga por todas sucursales
				begin

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							s.cdgo_sde,
							s.dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
	   						#tmpLiquidacionesFinalizadas d ,
	   						bdafiliacion.dbo.tbSucursalesAportante  b  with(nolock),
	   						bdafiliacion.dbo.tbsedes s with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     
					And		b.sde_crtra_pc					=	@cnsctvo_cdgo_sde
					And		b.sde_crtra_pc					=	s.cnsctvo_cdgo_sde
					And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							s.cdgo_sde,
							s.dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
							#tmpLiquidacionesFinalizadas d ,
							bdafiliacion.dbo.tbSucursalesAportante  b  with(nolock),
							 bdafiliacion.dbo.tbsedes s with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl					=	b.cnsctvo_scrsl     
					And		b.sde_crtra_pc					=	@cnsctvo_cdgo_sde
					And		b.sde_crtra_pc					=	s.cnsctvo_cdgo_sde
					And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

				end
			else  ----Para una sucursal
			  begin

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							s.cdgo_sde,
							s.dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
	   						#tmpLiquidacionesFinalizadas d ,
	   						bdafiliacion.dbo.tbSucursalesAportante  b with(nolock),
	   						bdafiliacion.dbo.tbsedes s with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn				=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta		!= 	4	 
					And		a.nmro_unco_idntfccn_empldr			=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte			=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl						=	b.cnsctvo_scrsl     
					And		b.sde_crtra_pc						=	@cnsctvo_cdgo_sde
					And		b.sde_crtra_pc						=	s.cnsctvo_cdgo_sde
					And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

					Insert	into	#tmpDetEmpleador
					SELECT	prdo,
							a.nmro_unco_idntfccn_empldr,
							a.cnsctvo_cdgo_clse_aprtnte,
							a.cnsctvo_scrsl,
							a.cnsctvo_estdo_cnta,
							b.nmbre_scrsl, a.nmro_estdo_cnta,
							s.cdgo_sde,
							s.dscrpcn_sde,
							b.drccn ,
							b.tlfno,
							a.cnsctvo_cdgo_lqdcn,
							b.sde_crtra_pc,
							b.cnsctvo_cdgo_sde_atncn
					FROM	bdCarteraPac.dbo.tbestadosCuenta a with(nolock),	
							#tmpLiquidacionesFinalizadas d ,
							bdafiliacion.dbo.tbSucursalesAportante  b with(nolock),
							bdafiliacion.dbo.tbsedes s with(nolock)
					Where	a.cnsctvo_cdgo_lqdcn			=	d.cnsctvo_cdgo_lqdcn  
					And		a.cnsctvo_cdgo_estdo_estdo_cnta	!= 	4	 
					And		a.nmro_unco_idntfccn_empldr		=	b.nmro_unco_idntfccn_empldr  
					And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte  
					And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl     
					And		b.sde_crtra_pc				=	@cnsctvo_cdgo_sde
					And		b.sde_crtra_pc				=	s.cnsctvo_cdgo_sde
					And		(@cnsctvo_cdgo_sde is null or (@cnsctvo_cdgo_sde is not null and b.sde_crtra_pc = @cnsctvo_cdgo_sde))
					And		(@nmro_unco_idntfccn_empldr  is null or (@nmro_unco_idntfccn_empldr is not null and a.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr))
					And		(@cnsctvo_cdgo_clse_aprtnte  is null or (@cnsctvo_cdgo_clse_aprtnte is not null and a.cnsctvo_cdgo_clse_aprtnte = @cnsctvo_cdgo_clse_aprtnte))
					And		(@cnsctvo_scrsl  is null or (@cnsctvo_scrsl is not null and a.cnsctvo_scrsl = @cnsctvo_scrsl))
					And		(@prdo  is null or (@prdo is not null and d.prdo = @prdo))
					And		(@cnsctvo_cdgo_lqdcn1  is null or (@cnsctvo_cdgo_lqdcn1 is not null and a.cnsctvo_cdgo_lqdcn >= @cnsctvo_cdgo_lqdcn1 AND @cnsctvo_cdgo_lqdcn2 is not null and a.cnsctvo_cdgo_lqdcn <= @cnsctvo_cdgo_lqdcn2))

			end 				 
	end 
End 

--select * from #tmpDetEmpleador


Select DISTINCT   
		prdo,
		nmro_unco_idntfccn_empldr,
		cnsctvo_cdgo_clse_aprtnte,
		cnsctvo_scrsl,
		a.cnsctvo_estdo_cnta,
		nmbre_scrsl ,
		space(3)						As tpo_idntfccn_emprsa,
		space(15)						As nmro_idntfccn_emprsa,
		space(3)  						As tpo_idntfccn_bene,
		space(15)  						As nmro_idntfccn_bene,
		space(3)  						As tpo_idntfccn_coti,
		space(15)  						As nmro_idntfccn_coti,
		0								As nmro_unco_idntfccn_afldo,
		c.nmro_unco_idntfccn_bnfcro,		
		c.cnsctvo_bnfcro,
--		c.vlr,
		Convert(Numeric(15,2),0) As vlr,
		convert(datetime,null)			As fcha_ncmnto,
		convert(datetime,null)			As inco_vgnca_bnfcro,
		convert(datetime,null)			As fn_vgnca_bnfcro,
		space(150)						As nmbre_bene,
		space(150)						As nmbre_coti,
		space(50)						As dscrpcn_prntsco,
		0								As cnsctvo_cdgo_prntscs,
		b.nmro_cntrto,
		b.cnsctvo_cdgo_tpo_cntrto,
		0								As cnsctvo_cdgo_pln,
		space(50)						As dscrpcn_pln,
		0								As edd_bnfcro,
		a.nmro_estdo_cnta,
		a.cdgo_sde,
		a.dscrpcn_sde,
		a.drccn ,	
		a.tlfno,
		0 as vlr_ants_iva,
		a.cnsctvo_cdgo_lqdcn,

		0 cnsctvo_cdgo_cdd_rsdnca,
		0								As cnsctvo_sde_inflnca_rsdnca,
		Space(150)						As dscrpcn_sde_inflnca_rsdnca,
		Space(150)						As dscrpcn_cdd_rsdnca,
		0								As cnsctvo_sde_aflcn,
		0								As cnsctvo_cdgo_sde_ips,
		a.sde_crtra_pc,
		Space(150)						As dscrpcn_sde_crtra_pc,
		0								As cnsctvo_cdgo_ips,
		Space(150)						As dscrpcn_sde_ips,
		Space(150)						As dscrpcn_sde_atncn,
		a.cnsctvo_cdgo_sde_atncn,
		c.cnsctvo_estdo_cnta_cntrto_bnfcro,
		Convert(Numeric(15,2),0)		As Valor_Iva_Bene,
		0 As cnsctvo_cdgo_sxo,
		Space(25) As dscrpcn_sxo
into	#tmpDetEmpleadorFinal	
From	#tmpDetEmpleador a,	bdCarteraPac.dbo.tbEstadosCuentaContratos b with(nolock),
		bdCarteraPac.dbo.tbCuentasContratosBeneficiarios c with(nolock)--,
		--tbCuentasBeneficiariosConceptos d
Where 	a.cnsctvo_estdo_cnta				=	b.cnsctvo_estdo_cnta
And		b.cnsctvo_estdo_cnta_cntrto			=	c.cnsctvo_estdo_cnta_cntrto
--And		c.cnsctvo_estdo_cnta_cntrto_bnfcro	= 	d.cnsctvo_estdo_cnta_cntrto_bnfcro
--And		d.cnsctvo_cdgo_cncpto_lqdcn			=	4





-- 20190605  Se adiciona los nuevos conceptos generados de pbs y pac plus 
Update	a
Set			vlr	=	b.vlr		
From	#tmpDetEmpleadorFinal a, bdCarteraPac.dbo.tbCuentasBeneficiariosConceptos b with(nolock)
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	= b.cnsctvo_estdo_cnta_cntrto_bnfcro
And		cnsctvo_cdgo_cncpto_lqdcn			in (4,345,346)

Update	a
Set			vlr	=	a.vlr		-	b.vlr
From	#tmpDetEmpleadorFinal a, bdCarteraPac.dbo.tbCuentasBeneficiariosConceptos b with(nolock)
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And		cnsctvo_cdgo_cncpto_lqdcn		=	5

Update	a
Set			vlr	=	a.vlr		-	b.vlr
From	#tmpDetEmpleadorFinal a, bdCarteraPac.dbo.tbCuentasBeneficiariosConceptos b with(nolock)
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And	cnsctvo_cdgo_cncpto_lqdcn		=	6

Update	a
Set			Valor_Iva_Bene		=		b.vlr
From	#tmpDetEmpleadorFinal a, bdCarteraPac.dbo.tbCuentasBeneficiariosConceptos b with(nolock)
Where	a.cnsctvo_estdo_cnta_cntrto_bnfcro	=	b.cnsctvo_estdo_cnta_cntrto_bnfcro
And		cnsctvo_cdgo_cncpto_lqdcn		=	3







Update #tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo
From	#tmpDetEmpleadorFinal a, bdafiliacion.dbo.tbcontratos b with(nolock)
Where  a.nmro_cntrto			=	b.nmro_cntrto
And       a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto



Update #tmpDetEmpleadorFinal
Set	dscrpcn_pln		=	b.dscrpcn_pln
From	#tmpDetEmpleadorFinal a, bdplanbeneficios.dbo.tbplanes b with(nolock)
Where  a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln

Update #tmpDetEmpleadorFinal
Set	cnsctvo_cdgo_prntscs		=	b.cnsctvo_cdgo_prntsco,
	inco_vgnca_bnfcro		=	b.inco_vgnca_bnfcro,
	fn_vgnca_bnfcro		=	b.fn_vgnca_bnfcro
From	#tmpDetEmpleadorFinal a, bdafiliacion.dbo.tbbeneficiarios b with(nolock)
Where  a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro


Update #tmpDetEmpleadorFinal
Set	dscrpcn_prntsco		=	b.dscrpcn_prntsco
From	#tmpDetEmpleadorFinal a, bdafiliacion.dbo.tbparentescos b with(nolock)
Where   a.cnsctvo_cdgo_prntscs	=	b.cnsctvo_cdgo_prntscs


Update #tmpDetEmpleadorFinal
Set	tpo_idntfccn_bene		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_bene		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion.dbo.tbvinculados  b with(nolock),
	bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock)
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #tmpDetEmpleadorFinal
Set	tpo_idntfccn_coti		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_coti		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion.dbo.tbvinculados  b with(nolock),
	bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock)
Where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn

Update #tmpDetEmpleadorFinal

Set	tpo_idntfccn_emprsa		=	c.cdgo_tpo_idntfccn,
        	nmro_idntfccn_emprsa		=	b.nmro_idntfccn
From	#tmpDetEmpleadorFinal a, 	bdafiliacion.dbo.tbvinculados  b with(nolock),
	bdafiliacion.dbo.tbtiposidentificacion 	c with(nolock)
Where   a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn


Update #tmpDetEmpleadorFinal
Set	fcha_ncmnto			=	b.fcha_ncmnto,
	cnsctvo_cdgo_sxo	=	b.cnsctvo_cdgo_sxo
From	#tmpDetEmpleadorFinal a, 	bdafiliacion.dbo.tbpersonas  b with(nolock)
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn


Update #tmpDetEmpleadorFinal
Set	dscrpcn_sxo			=	b.dscrpcn_sxo
From	#tmpDetEmpleadorFinal a, 	bdafiliacion.dbo.tbSexos  b with(nolock)
Where   a.cnsctvo_cdgo_sxo	=	b.cnsctvo_cdgo_sxo




update #tmpDetEmpleadorFinal	
Set	edd_bnfcro	=	BDAFILIACION.DBO.fnCalcularTiempo (fcha_ncmnto,GETDATE(),1,2)

-- bdconsulta

Update  #tmpDetEmpleadorFinal
Set	nmbre_bene			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	#tmpDetEmpleadorFinal a,  bdAfiliacion.dbo.tbpersonas e with(nolock)
Where	  a.nmro_unco_idntfccn_bnfcro	=            e.nmro_unco_idntfccn

Update  #tmpDetEmpleadorFinal
Set	nmbre_coti			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre)) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	#tmpDetEmpleadorFinal a,  bdAfiliacion.dbo.tbpersonas e with(nolock)
Where	  a.nmro_unco_idntfccn_afldo	=            e.nmro_unco_idntfccn

----Para actualizar las sedes 
Update  #tmpDetEmpleadorFinal
Set	cdgo_sde			= c.cdgo_sde,
	dscrpcn_sde			= c.dscrpcn_sde
From	#tmpDetEmpleadorFinal a  	inner join bdAfiliacion.dbo.tbSucursalesAportante e with(nolock)
On 	a.nmro_unco_idntfccn_empldr	= e.nmro_unco_idntfccn_empldr
and	a.cnsctvo_cdgo_clse_aprtnte	= e.cnsctvo_cdgo_clse_aprtnte
and	a.cnsctvo_scrsl			= e.cnsctvo_scrsl 	
					inner join  bdAfiliacion.dbo.tbsedes c
On          e.sde_crtra_pc			=  c.cnsctvo_cdgo_sde	
where a.cdgo_sde is null and a.dscrpcn_sde is null


--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
-- Actualizacion de datos nuevos
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------
-- Actualiza la ciudad de residencia del beneficiario
----------------------------------------------------------------

Update	a
Set		cnsctvo_cdgo_cdd_rsdnca		= b.cnsctvo_cdgo_cdd_rsdnca
From	#tmpDetEmpleadorFinal a inner join bdafiliacion.dbo.tbPersonas b with(nolock)
			On	a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn


------------------------------------------------------------------
-- Actualiza los datos de la ciudad de residencia del beneficiario
------------------------------------------------------------------

Update	a
Set		dscrpcn_cdd_rsdnca			= b.dscrpcn_cdd,
		cnsctvo_sde_inflnca_rsdnca	= b.cnsctvo_sde_inflnca
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbciudades_vigencias b with(nolock)
			On	a.cnsctvo_cdgo_cdd_rsdnca	= b.cnsctvo_cdgo_cdd
			And	@ldFechaSistema				>= b.inco_vgnca
			And	@ldFechaSistema				<= b.fn_vgnca


-------------------------------------------------------------------------------------------------
-- Actualiza la descripcion de la sede de influencia par la ciudad de residencia del beneficiario
-------------------------------------------------------------------------------------------------

Update	a
Set		dscrpcn_sde_inflnca_rsdnca	= b.dscrpcn_sde
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbsedes b with(nolock)
			On	a.cnsctvo_sde_inflnca_rsdnca	= b.cnsctvo_cdgo_sde



-------------------------------------------------------------------------------------------------
-- Actualiza la sede de cartera pac para la sucursal del empleador
-------------------------------------------------------------------------------------------------

Update	a
Set		dscrpcn_sde_crtra_pc	= b.dscrpcn_sde
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbsedes b with(nolock)
			On	a.sde_crtra_pc	= b.cnsctvo_cdgo_sde


----------------------------------------------------------------
-- Actualiza la ips del beneficiario
----------------------------------------------------------------

-- Nui

Update	a
Set		cnsctvo_cdgo_ips		= b.cnsctvo_cdgo_ips
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbAfiliados b with(nolock)
			On	a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn_afldo

-- Consecutivo Sede de la Ips

Update	a
Set		cnsctvo_cdgo_sde_ips		= b.cnsctvo_cdgo_sde_ips
From	#tmpDetEmpleadorFinal a Inner Join bdSiSalud.dbo.tbIpsPrimarias_Vigencias b with(nolock)
			On	a.cnsctvo_cdgo_ips	= b.cdgo_intrno
Where	b.cnsctvo_cdgo_sde_ips Is Not Null

-- Descripcion sede de la Ips

Update	a
Set		dscrpcn_sde_ips			= b.dscrpcn_sde
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbsedes b with(nolock)
			On	a.cnsctvo_cdgo_sde_ips	= b.cnsctvo_cdgo_sde
Where	b.dscrpcn_sde Is Not Null


-- Actualizacion sede atencion

Update	a
Set		dscrpcn_sde_atncn			= b.dscrpcn_sde
From	#tmpDetEmpleadorFinal a Inner Join bdafiliacion.dbo.tbsedes b with(nolock)
			On	a.cnsctvo_cdgo_sde_atncn	= b.cnsctvo_cdgo_sde
Where	b.dscrpcn_sde Is Not Null







--Update  #tmpDetEmpleadorFinal
--Set	vlr_ants_iva= vlr/(Convert(Float,(10 + convert(Int,@Valor_Porcentaje_Iva)))/Convert(Float,10))
--Select  * from #tmpDetEmpleadorFinal order by nmbre_scrsl , nmbre_coti

select a.tpo_idntfccn_coti as TIPO_ID,
a.nmro_idntfccn_coti  as NRO_ID_COT,
a.nmbre_coti as NOMBRE_COTIZANTE,
a.tpo_idntfccn_bene as TIPO_ID_BENEF,
a.nmro_idntfccn_bene	as NRO_ID_BENEF,
a.nmbre_bene as NOMBRE_BENEFICIARIO,
--a.vlr_ants_iva as VLR_SIN_IVA,
Convert(Int,a.vlr) As vlr,
--convert(numeric(12,0),(a.vlr_ants_iva * convert(Int,@Valor_Porcentaje_Iva)/100)) as IVA,
Convert(Int,a.Valor_Iva_Bene) As Valor_Iva_Bene,
Convert(Int,(a.vlr +  a.Valor_Iva_Bene)) as VLR_TOTAL,
a.dscrpcn_prntsco AS  PARENTESCO,
a.edd_bnfcro AS EDAD,
a.dscrpcn_sxo As GENERO,
a.dscrpcn_pln,
a.nmro_cntrto,
a.cnsctvo_scrsl,
a.prdo,
a.nmro_unco_idntfccn_empldr,
a.cnsctvo_cdgo_clse_aprtnte,
a.cnsctvo_estdo_cnta,
a.nmbre_scrsl,
a.tpo_idntfccn_emprsa,
a.nmro_idntfccn_emprsa,
a.nmro_unco_idntfccn_afldo,
a.nmro_unco_idntfccn_bnfcro,
a.cnsctvo_bnfcro,
a.fcha_ncmnto,
a.inco_vgnca_bnfcro,
a.fn_vgnca_bnfcro,
a.cnsctvo_cdgo_prntscs,
a.cnsctvo_cdgo_tpo_cntrto,
a.cnsctvo_cdgo_pln,
a.nmro_estdo_cnta,
a.cdgo_sde,	
a.dscrpcn_sde,
a.drccn,
a.tlfno,
a.cnsctvo_cdgo_lqdcn,
hp.grupo,
dg.dscrpcn_dtlle_grpo,
hp.cnsctvo_prdcto,
p.dscrpcn_prdcto,
hp.cnsctvo_mdlo,
m.dscrpcn_mdlo,

a.dscrpcn_cdd_rsdnca, 
a.dscrpcn_sde_inflnca_rsdnca, 
a.dscrpcn_sde_atncn, 
a.dscrpcn_sde_ips, 
a.dscrpcn_sde_crtra_pc

from #tmpDetEmpleadorFinal a left outer join bdcarterapac.dbo.tbhistoricotarificacionxproceso hp with(nolock)
		on a.nmro_cntrto = hp.nmro_cntrto
		and a.nmro_unco_idntfccn_bnfcro = hp.nmro_unco_idntfccn
		and a.cnsctvo_cdgo_lqdcn = hp.cnsctvo_cdgo_lqdcn
	left outer join bdafiliacion.dbo.tbdetgrupos dg with(nolock)
		on hp.grupo  = dg.cnsctvo_cdgo_dtlle_grpo
	left outer join bdplanbeneficios.dbo.tbmodelos m with(nolock)
		on hp.cnsctvo_mdlo = m.cnsctvo_mdlo
	left outer join bdplanbeneficios.dbo.tbproductos p with(nolock)
		on hp.cnsctvo_prdcto = p.cnsctvo_prdcto
order by  nmro_idntfccn_emprsa, nmbre_scrsl, cnsctvo_scrsl, nmbre_coti




