/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spActualizaSaldoResponsablePago
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento se encarga de actualizar el saldo del responsable del pago			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spActualizaSaldoResponsablePago
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcUsuarioCreacion		udtUsuario,
	@lcControlaError		int Output		

As Declare 
@MaximoConsecutivoResponsable		udtConsecutivo,
@cnsctvo_acmldo_scrsl_aprtnte			udtConsecutivo,
@ldFechaSistema				Datetime	
Set Nocount On


Set	@ldFechaSistema			=	Getdate()          
Select	@MaximoConsecutivoResponsable 	=	 isnull(max(cnsctvo_acmldo_scrsl_aprtnte) ,0)
From	TbAcumuladosSucursalAportante




Select 	       a.cnsctvo_acmldo_scrsl_aprtnte,	a.nmro_unco_idntfccn_empldr,	a.cnsctvo_scrsl,
	       a.cnsctvo_cdgo_clse_aprtnte,		a.tpo_dcmnto,			a.nmro_dcmnto,
	       a.dbts,				a.crdts,				a.vlr_sldo,
	       a.intrs_mra,
	       a.cntdd_fctrs_mra,			a.fcha_ultmo_pgo,		a.fcha_ultma_fctra,
	       a.fcha_mra,				a.ultma_oprcn,
	       b.cnsctvo_estdo_cnta,		b.ttl_pgr,			b.fcha_gnrcn,
	       IDENTITY(int, 1,1) AS ID_Num	
Into 	#TmpSaldos
From   TbAcumuladosSucursalAportante  a,	TbEstadosCuenta	b
Where 	1 	=	2	

Insert	into 	#TmpSaldos
Select  0,				nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,	1,				nmro_estdo_cnta,
	ttl_pgr,				0,				0,
	0,
	0,				Null,				fcha_gnrcn,
	Null,				0,
	cnsctvo_estdo_cnta,		ttl_pgr,				fcha_gnrcn	
From 	TbEstadosCuenta
Where 	cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn


Update #TmpSaldos
Set	cnsctvo_acmldo_scrsl_aprtnte	=	a.cnsctvo_acmldo_scrsl_aprtnte,
	intrs_mra			=	a.intrs_mra,
	cntdd_fctrs_mra			=	a.cntdd_fctrs_mra,
	fcha_ultmo_pgo			=	a.fcha_ultmo_pgo,
	fcha_mra			=	a.fcha_mra,
	vlr_sldo				=	a.vlr_sldo
From	TbAcumuladosSucursalAportante	a,	#TmpSaldos	b
Where	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.ultma_oprcn			=	1	

UPDATE	TbAcumuladosSucursalAportante
Set	ultma_oprcn	=	0
From	TbAcumuladosSucursalAportante	a,	#TmpSaldos	b
Where	a.cnsctvo_acmldo_scrsl_aprtnte	=	b.cnsctvo_acmldo_scrsl_aprtnte


Insert	into	TbAcumuladosSucursalAportante
Select	(ID_Num	+	@MaximoConsecutivoResponsable),	nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,					1,				nmro_dcmnto,
	dbts,								crdts,				vlr_sldo		+	dbts,
	@ldFechaSistema,
	@lcUsuarioCreacion,
	intrs_mra,
	cntdd_fctrs_mra,
	fcha_ultmo_pgo,
	fcha_ultma_fctra,
	fcha_mra,
	1,	
	'N',
	Null
From	#TmpSaldos


 


If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end