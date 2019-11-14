/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spActualizaSaldoContrato
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento se encarga de actualizar el saldo del responsable del pago			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spActualizaSaldoContrato
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcUsuarioCreacion		udtUsuario,
	@lcControlaError		int Output		

As Declare 

@MaximoConsecutivoContrato			udtConsecutivo,
@cnsctvo_acmldo_scrsl_aprtnte			udtConsecutivo,
@ldFechaSistema				Datetime	
Set Nocount On


Set	@ldFechaSistema			=	Getdate()          
Select	@MaximoConsecutivoContrato	 	=	 isnull(max(Cnsctvo_Acmldo_cntrto) ,0)
From	TbAcumuladosContrato




Select 	       a.Cnsctvo_Acmldo_cntrto,		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,
	       a.tpo_dcmnto,			a.nmro_dcmnto,
	       a.dbts,				a.crdts,				a.vlr_sldo,
	       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,		a.fcha_ultma_fctra,
	       a.fcha_mra,				a.ultma_oprcn,
	       b.cnsctvo_estdo_cnta,		c.vlr_cbrdo,			b.fcha_gnrcn,
	       b.nmro_unco_idntfccn_empldr,		--se adiciono la sucursal aportante
	       b.cnsctvo_scrsl,
	       b.cnsctvo_cdgo_clse_aprtnte,
	        IDENTITY(int, 1,1) AS ID_Num
Into 	#TmpSaldosContrato
From   TbAcumuladosContrato	  a,	TbEstadosCuenta	b,	TbEstadosCuentaContratos	c
Where 	1 	=	2	


Insert	into 	#TmpSaldosContrato
Select    0,				cnsctvo_cdgo_tpo_cntrto,		nmro_cntrto,
	1,				nmro_estdo_cnta,
	vlr_cbrdo,			0,				0,
	0,				Null,				fcha_gnrcn,
	Null,				0,
	a.cnsctvo_estdo_cnta,		ttl_pgr,				fcha_gnrcn,
       	a.nmro_unco_idntfccn_empldr,      a.cnsctvo_scrsl,		              a.cnsctvo_cdgo_clse_aprtnte

From 	TbEstadosCuenta	a,	TbEstadosCuentaContratos b
Where 	cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn
And	a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta


Update #TmpSaldosContrato
Set	Cnsctvo_Acmldo_cntrto		=	a.Cnsctvo_Acmldo_cntrto,
	cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
	fcha_ultmo_pgo			=	a.fcha_ultmo_pgo,
	fcha_mra			=	a.fcha_mra,
	vlr_sldo				=	a.vlr_sldo
From	TbAcumuladosContrato		a,	#TmpSaldosContrato	b
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl	--se adiciono la sucursal aportante
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.ultma_oprcn			=	1	

Update	TbAcumuladosContrato
Set		ultma_oprcn		=	0
From	TbAcumuladosContrato	a,	#TmpSaldosContrato	b
Where	a.Cnsctvo_Acmldo_cntrto		=	b.Cnsctvo_Acmldo_cntrto


Insert	into	TbAcumuladosContrato
Select	(ID_Num	+	@MaximoConsecutivoContrato),		1,				nmro_dcmnto,
	dbts,								crdts,				vlr_sldo		+	dbts,
	@ldFechaSistema,
	@lcUsuarioCreacion,
	cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,			1,
	cntdd_fctrs_mra,
	fcha_ultmo_pgo,
	fcha_ultma_fctra,
	fcha_mra,
	'N',
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	Null
From	#TmpSaldosContrato




If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end