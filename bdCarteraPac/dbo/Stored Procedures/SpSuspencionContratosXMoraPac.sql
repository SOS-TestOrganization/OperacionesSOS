
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpSuspencionContratosXMoraPac
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Permite suspender los contratos que tienen  mora Pac			D\>
* Observaciones		: <\O										O\>
* Parametros		: <\P 										P\>
* Variables		: <\V 										V\>
			: <\V Parmetros que condicionan la consulta					V\>
			: <\V Fecha que se convierte de date a caracter					V\>
			* Fecha Creacion: <\FC 2002/06/21						FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Ing. Fernando Valencia E 			AM\>
* Descripcion			: <\DM Se crean campos del empleador y la relacion con tbProcesosCarteraPac DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2006/05/19					 FM\>
*---------------------------------------------------------------------------------
* Sau 66080 Se modifica para aquellos contratos mayores  de $10.000
QUICK				Analista		Descripcion
2013-001-002925		sismpr01		se crea parametro general para manejar la tolerancia en el proceso de suspension 20130211
*---------------------------------------------------------------------------------*/
CREATE          PROCEDURE [dbo].[SpSuspencionContratosXMoraPac]  

		@Fecha_Proceso				Datetime,		
		@lcUsuario					udtusuario

AS    Declare 	@Max_cnsctvo_prcso	udtConsecutivo,	
		@lnProceso					udtConsecutivo,
		@Fecha_Inicio_Proceso		datetime,
		@Fecha_Fin_Proceso			Datetime,
		@Fecha_corte				Datetime,
		@lnError					int,
		@lnProceso_nvdd				int,
		@Maxcnsctvo_mrccn_mra_pc	int,
		@tolerancia					int,
        @diafechamaximapago         int 
Set Nocount On


Set		@lnProceso			=	49		--Mora Pac
set     @diafechamaximapago = (select datepart(day,fcha_mxma_pgo)-1 from tbperiodosliquidacion_vigencias where @Fecha_Proceso between fcha_incl_prdo_lqdcn and fcha_fnl_prdo_lqdcn)

--Select		@Fecha_corte			= 	dateadd(day,-1,Convert(varchar(6),bdRecaudos.dbo.fncalculaperiodo(@Fecha_Proceso))+'01')
---select datepart(day, fcha_mxma_pgo) from tbperiodosliquidacion_vigencias where '20130405' between fcha_incl_prdo_lqdcn and fcha_fnl_prdo_lqdcn
Select		@Fecha_corte			= 	dateadd(day,@diafechamaximapago,Convert(varchar(6),bdRecaudos.dbo.fncalculaperiodo(@Fecha_Proceso))+'01')


Select	@Max_cnsctvo_prcso		=	isnull(cnsctvo_prcso,0)	+	1
From	bdcarteraPac..TbProcesosCarteraPac

Set		@Fecha_Inicio_Proceso		=	Getdate()

Insert	into bdcarteraPac..TbProcesosCarteraPac 
Values	(@Max_cnsctvo_prcso,			@lnProceso,			@Fecha_Inicio_Proceso,			NULL,			@lcUsuario)

-- QUICK 2013-001-002925
select	@tolerancia = vlr_prmtro_nmrco
from	tbparametrosgenerales_vigencias
where	getdate() between inco_vgnca and fn_vgnca
and		cnsctvo_cdgo_prmtro_gnrl	= 2

if @tolerancia is null
	select @tolerancia = 0

--Trae la informacion de los Contratos que se tienen saldo mayor a  cero
--donde la fecha de generacion del documento sea menor a la fecha de corte
Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	a.nmro_estdo_cnta,
	c.*,
datediff(day,dateadd(dd,-1,d.fcha_mxma_pgo),getdate())   dias_mora,
	0	Dias_mora_Especial, 
	'N'	Suspender
into    #tmpEstadosCuentaContratosSUS  
From    bdcarteraPac..TbEstadosCuenta a, 
		bdcarteraPac..tbliquidaciones b , 
		bdcarteraPac..tbEstadosCuentaContratos c ,
		bdcarteraPac..tbperiodosliquidacion_vigencias  d
where   c.sldo	 									> 	@tolerancia --10000 -- QUICK 2013-001-002925
And		a.cnsctvo_cdgo_lqdcn						=	b.cnsctvo_cdgo_lqdcn
And		a.cnsctvo_estdo_cnta						=	c.cnsctvo_estdo_cnta
And		b.cnsctvo_cdgo_prdo_lqdcn					=	d.cnsctvo_cdgo_prdo_lqdcn	
And		b.cnsctvo_cdgo_estdo_lqdcn					=	3	--Finalizada
And		d.fcha_mxma_pgo								<=	@Fecha_Corte
And		convert(int,ltrim(rtrim(c.nmro_cntrto)))	>	0
And		a.cnsctvo_cdgo_estdo_estdo_cnta				!=	4


If  @@error	!=	0 	
Begin 
	Return -1
end	

/*
--Se actualiza el numero de dias mora para  aquellas empresas especiales
Update  #tmpEstadosCuentaContratos
Set	Dias_mora_Especial  = e.nmro_ds
From 	#tmpEstadosCuentaContratos a , bdcarteraPac..tbDiasCobromoraSucursal_vigencias b ,	bdcarteraPac..tbdiasmora_vigencias e
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
And	b.cnsctvo_cdgo_ds_mra		=	e.cnsctvo_cdgo_ds_mra
And	getdate() between  b.inco_vgnca  and b.fn_vgnca 
And	getdate() between  e.inco_vgnca  and e.fn_vgnca 
*/


Update  #tmpEstadosCuentaContratosSUS
Set	Dias_mora_Especial  	= 	b.ds_pra_sspnsn
From 	#tmpEstadosCuentaContratosSUS a , bdAfiliacion..tbDatosComercialesSucursal b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And		a.cnsctvo_scrsl				=	b.cnsctvo_scrsl
And		a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte


If  @@error	!=	0 	
Begin 
	Return -1
end	


--Se marca para suspender aquellos contratos donde 
--la fecha maxima de pago - la fecha del proceso sea mayor al numero de dias especiales para la mora
Update  #tmpEstadosCuentaContratosSUS
Set		Suspender	  = 'S'
From 	#tmpEstadosCuentaContratosSUS 
Where 	dias_mora	>	Dias_mora_Especial


If  @@error	!=	0 	
Begin 
	Return -1
end	




--Se crea una tabla temporal con los contratos que se van a suspender
Select 	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto ,	0	nmro_unco_idntfccn_ctznte,	'S'	Suspender
into	#tmpContratosMoraSUS
From	#tmpEstadosCuentaContratosSUS
Where 	Suspender		=	'S'
Group by cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto 


If  @@error	!=	0 	
Begin 
	Return -1
end	



--Se crea la tabla temporal con los contratos que no estan vigentes
Select 	cnsctvo_cdgo_tpo_cntrto, nmro_cntrto  
Into 	#tmpContratosNoVigentesSUS
From 	#tmpContratosMoraSUS
Where 	1 = 2



If  @@error	!=	0 	
Begin 
	Return -1
end	

--Se insertan los contratos que no estan activos
Insert Into #tmpContratosNoVigentesSUS
Select 	cnsctvo_cdgo_tpo_cntrto, nmro_cntrto
From 	#tmpContratosMoraSUS  a
Where 	NOT Exists (	Select	1 
						FROM	bdafiliacion..tbContratos b 
						WHERE 	a.cnsctvo_cdgo_tpo_cntrto 	= 	b.cnsctvo_cdgo_tpo_cntrto
						And 	a.nmro_cntrto				= 	b.nmro_cntrto	
						And		b.estdo_cntrto				=	'A'	
						And		a.cnsctvo_cdgo_tpo_cntrto	=	2  --contratos Pac	
						And		Convert(Varchar(10),@Fecha_Proceso,111) 	Between 	Convert(Varchar(10), b.inco_vgnca_cntrto,111) And Convert(Varchar(10), b.fn_vgnca_cntrto,111)
					)

If  @@error	!=	0 	
		Begin 
			Return -1
		end	

--Se borran los contratos que no estan activos...
Delete 	#tmpContratosMoraSUS
From 	#tmpContratosMoraSUS a,		#tmpContratosNoVigentesSUS b
Where 	a.cnsctvo_cdgo_tpo_cntrto 	= 	b.cnsctvo_cdgo_tpo_cntrto
And 	a.nmro_cntrto			= 	b.nmro_cntrto	


If  @@error	!=	0 	
		Begin 
			Return -1
		end	


--Actualiza el nui del cotizante
Update	#tmpContratosMoraSUS
Set	nmro_unco_idntfccn_ctznte	=	nmro_unco_idntfccn_afldo
From	#tmpContratosMoraSUS a, bdafiliacion..tbcontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto


If  @@error	!=	0 	
		Begin 
			Return -1
		end	



--Se Crea una tabla temporal con los beneficiarios de cada contrato PAc
Select 	distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,			b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_bnfcro,	'S'	Suspender
into	#tmpBeneficiariosxContratoPacSUS	
From	#tmpContratosMoraSUS a,	bdAfiliacion..tbBeneficiarios 	b
Where	Convert(Varchar(10),@Fecha_Proceso,111)	Between	Convert(Varchar(10),b.inco_vgnca_bnfcro,111)	And	Convert(Varchar(10),b.fn_vgnca_bnfcro,111)
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	b.estdo				=	'A'



If  @@error	!=	0 	
Begin 
	Return -1
end	



--Se verifca cuales de esos beneficiarios ya se encuentran suspendidos para no volver a suspenderlos
Update	#tmpBeneficiariosxContratoPacSUS
Set		Suspender		=	'N'
From 	bdafiliacion..tbHistoricoEstadosBeneficiario 	a,
			bdAfiliacion..tbCausasHistoricoEstadosBeneficiarios  b,		
			#tmpBeneficiariosxContratoPacSUS		   c 
Where	a.cnsctvo_cdgo_estdo_bfcro	=		5	--Suspendido 
And 	a.hbltdo 					= 		'S'
And 	Convert(Varchar(10),@Fecha_Proceso,111)		Between 	Convert(Varchar(10),a.inco_vgnca_estdo_bnfcro,111) And Convert(Varchar(10),a.fn_vgnca_estdo_bnfcro,111) 
And 	b.cnsctvo_cdgo_csa_nvdd 	=		99	-- Mora PAC
And 	b.estdo_rgstro 				=  		'S' 
And 	Convert(Varchar(10),@Fecha_Proceso,111)		Between 	Convert(Varchar(10),b.inco_vgnca_csa,111) And Convert(Varchar(10),b.fn_vgnca_csa,111)
And 	a.cnsctvo_hstrco_estdo 		= 		b.cnsctvo_hstrco_estdo
And		c.cnsctvo_cdgo_tpo_cntrto	=		a.cnsctvo_cdgo_tpo_cntrto
And		c.nmro_cntrto				=		a.nmro_cntrto
And		c.nmro_unco_idntfccn_bnfcro	=		a.nmro_unco_idntfccn_bnfcro
And		c.cnsctvo_bnfcro			=		a.cnsctvo_bnfcro



If  @@error	!=	0 	
Begin 
	Return -1
end	



Update	#tmpContratosMoraSUS
Set		Suspender	=	'N'
From	#tmpContratosMoraSUS a, #tmpBeneficiariosxContratoPacSUS b
Where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrtoAnd		a.nmro_cntrto				=	b.nmro_cntrto
And		b.Suspender					=	'N'


If  @@error	!=	0 	
Begin 
	Return -1
end	


Create Table #TmpDetInformacionNovedad	(
cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,			nmro_cntrto			udtNumeroFormulario,
nmro_unco_idntfccn	 	udtConsecutivo,			cnsctvo_idntfcdr	 		udtConsecutivo,		--  Beneficiario
cnsctvo_idntfcdr_ds	 	udtConsecutivo,			cnsctvo_idntfcdr_trs		udtConsecutivo,
cnsctvo_idntfcdr_ctro		udtConsecutivo,			cnsctvo_cdgo_tpo_nvdd		udtConsecutivo,
cnsctvo_cdgo_csa_nvdd		udtConsecutivo,			fcha_nvdd			datetime,
adcnl				udtLogico,			usro				udtUsuario,
cnsctvo_cdgo_tpo_cntrto_psc	udtConsecutivo,			nmro_cntrto_psc			udtNumeroFormulario,
cnsctvo_cdgo_estdo_cvl		udtConsecutivo,			cnsctvo_cdgo_sb_csa_nvdd	udtConsecutivo,
estdo				udtLogico,			cnsctvo_cdgo_cncpto_nvdd	udtConsecutivo,
cnsctvo_nvdd			udtNumeroFormulario,		nmro_unco_idntfccn_ctznte	udtConsecutivo,
cnsctvo_cdgo_clse_aprtnte	udtConsecutivo,			cnsctvo_plnlla			udtConsecutivo,
cnsctvo_lna			udtConsecutivo,			cnsctvo_dtlle_nvdd_gnrda	udtConsecutivo,
cnsctvo_cmpo		 	udtConsecutivo,			vlr_nvo			 	udtConsecutivo,
cnsctvo_prdcto			udtConsecutivo,			actlza_bnfcro			udtLogico,
actlza_cbrnza			udtLogico,			inco_vgnca			Datetime,
fn_vgnca			Datetime,			cnsctvo_idntfcdr_rgstro 	udtConsecutivo	  )



If  @@error	!=	0 	
		Begin 
			Return -1
		end	


Insert	Into	#TmpDetInformacionNovedad
Select 	distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,			b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_bnfcro,	0,	0,	0,
	14, 	-- Cambio de estado
	99,	-- Mora PAC
	@Fecha_Proceso,	'N',	@lcUsuario,	0,	0,	0,	0,	'A',	
	4,	-- beneficiarios
	0,
	a.nmro_unco_idntfccn_ctznte,		0,	0,	0,	0,	0,	5,	0,	'N',	'N',	@Fecha_Proceso,
	'9999/12/31',	0	
From	#tmpContratosMoraSUS a,	bdAfiliacion..tbBeneficiarios 	b
Where	Convert(Varchar(10),@Fecha_Proceso,111)	Between	Convert(Varchar(10),b.inco_vgnca_bnfcro,111)	And	Convert(Varchar(10),b.fn_vgnca_bnfcro,111)
And		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And		a.nmro_cntrto				=	b.nmro_cntrto
And		a.Suspender					=	'S'
And		b.estdo						=	'A'


If  @@error	!=	0 	
Begin 
	Return -1
end	



Exec @lnError	=	bdAfiliacion..spAdmonCambioEstado	'0',	
						2,	---- Novedad Realizada x Proceso
						@lcUsuario,	
						@lnProceso_nvdd	Output	


If  @@error	!=	0 	
Begin 
	Return -1
end	


--Se crea la tabla de los que suspendio..
Select	IDENTITY(int, 1,1) AS ID_Num,
	cnsctvo_cdgo_tpo_nvdd,		cnsctvo_cdgo_csa_nvdd,		fcha_nvdd,			
	cnsctvo_nvdd,			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				nmro_unco_idntfccn,		cnsctvo_idntfcdr,	Estdo	,	
	'S'	Suspender
into 	#tmpSuspendidosSUS
From	#TmpDetInformacionNovedad	
where 	Estdo	=	'A'


Select @Maxcnsctvo_mrccn_mra_pc	=	isnull(max(cnsctvo_mrccn_mra_pc),0)
From	tbLogMarcacionMoraPac


insert	into	tbLogMarcacionMoraPac
Select	(ID_Num +@Maxcnsctvo_mrccn_mra_pc),
	 @lnProceso,
	 cnsctvo_cdgo_tpo_nvdd,
	 cnsctvo_cdgo_csa_nvdd,
	 fcha_nvdd,
	 cnsctvo_nvdd,
	 @lnProceso_nvdd,
	 cnsctvo_cdgo_tpo_cntrto,
	 nmro_cntrto,
	 nmro_unco_idntfccn,
	 cnsctvo_idntfcdr,
	 Estdo, 
	 @Max_cnsctvo_prcso,	---Relacion tbProcesosCateraPac
	 0,
	 0,
	 0		
	
From	 #tmpSuspendidosSUS


--Se actuliza la información del empleador en el log
update  a 
set 	nmro_unco_idntfccn_empldr	=b.nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl			=b.cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte	=b.cnsctvo_cdgo_clse_aprtnte
from 		tbLogMarcacionMoraPac  		a 
inner join  	#tmpEstadosCuentaContratosSUS 	b
On 	a.cnsctvo_cdgo_tpo_cntrto	=b.cnsctvo_cdgo_tpo_cntrto
and	a.nmro_cntrto			=b.nmro_cntrto


--Se guarda la informacion en un log


Drop	table 	 #tmpEstadosCuentaContratosSUS
Drop	Table	 #tmpBeneficiariosxContratoPacSUS
Drop	table	 #tmpContratosMoraSUS
Drop 	table	 #tmpSuspendidosSUS
Drop	table	 #tmpContratosNoVigentesSUS
Drop 	table	 #TmpDetInformacionNovedad


-- Se Captura la fecha final proceso
Set	@Fecha_Fin_Proceso	=	Getdate()
-- Se Actualiza el fin del proceso
Update bdcarteraPac..TbProcesosCarteraPac
Set	fcha_fn_prcso	=	@Fecha_Fin_Proceso
Where	cnsctvo_prcso	=	@Max_cnsctvo_prcso


