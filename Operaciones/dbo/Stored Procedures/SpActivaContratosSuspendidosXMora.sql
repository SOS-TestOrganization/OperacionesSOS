/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpActivaContratosSuspendidosXMora
* Desarrollado por	: <\A Ing. Rolando Simbaqueva							A\> 
* Descripcion		: <\D Permite Activar los contratos que estaban suspendidos x Mora		D\>
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
* Modificado Por		: <\AM Ing. Fernando Valencia Echeverry                                           AM\>
* Descripcion			: <\DM Se cambia en la tabla  #TmpDetInformacionNovedad  para que  solo tome los suspendidos del contratoDM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2006/06/23 FM\>

QUICK				Analista		Descripcion
2013-001-002925		sismpr01		se crea parametro general para manejar la tolerancia en el proceso de suspension, activamos tambien los afiliados 
									que tienen mora inferior e igual al parametro de la tolerancia  20130214

*---------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[SpActivaContratosSuspendidosXMora]  
		@ldFechaActual		Datetime,
		@lcUsuario		udtUsuario
		

AS    Declare
@lnProceso						int,
@lnError						int,
@Maxcnsctvo_mrccn_mra_pc		int,
@tolerancia						int
 
Set Nocount On

-- QUICK 2013-001-002925
select	@tolerancia = vlr_prmtro_nmrco
from	tbparametrosgenerales_vigencias
where	getdate() between inco_vgnca and fn_vgnca
and		cnsctvo_cdgo_prmtro_gnrl	= 2

if @tolerancia is null
	select @tolerancia = 0

-- se crea temporal con los afiliados que se encuentran suspendidos
-- Con causa mora Pac
Select 	a.cnsctvo_cdgo_tpo_cntrto, 		a.nmro_cntrto,			a.cnsctvo_bnfcro,		a.nmro_unco_idntfccn_bnfcro,
	b.nmro_unco_idntfccn_aprtnte, 		b.cnsctvo_cdgo_clse_aprtnte,	b.cnsctvo_cdgo_csa_nvdd,	'S'	Activar,
	Convert(Numeric(10),0)	nmro_unco_idntfccn_ctznte	
Into	#TempSuspendidos
From 	bdafiliacion..tbHistoricoEstadosBeneficiario a, 	
	bdAfiliacion..tbCausasHistoricoEstadosBeneficiarios  b
Where	a.cnsctvo_cdgo_estdo_bfcro	=		5	--Suspendido 
And 	a.hbltdo 			= 		'S'
And 	Convert(Varchar(10),@ldFechaActual,111)		Between 	Convert(Varchar(10),a.inco_vgnca_estdo_bnfcro,111) And Convert(Varchar(10),a.fn_vgnca_estdo_bnfcro,111) 
And 	b.cnsctvo_cdgo_csa_nvdd 	=		99	-- 99 Mora Pac
And 	b.estdo_rgstro 			=  		'S' 
And 	Convert(Varchar(10),@ldFechaActual,111)		Between 	Convert(Varchar(10),b.inco_vgnca_csa,111) And Convert(Varchar(10),b.fn_vgnca_csa,111)
And 	a.cnsctvo_hstrco_estdo 		= 		b.cnsctvo_hstrco_estdo



If  @@error	!=	0 	
Begin 
	Return -1
end	


--Trae la informacion de los Contratos que se tienen saldo mayor a  cero
--donde la fecha de generacion del documento sea menor a la fecha de corte
Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	a.nmro_estdo_cnta,
	c.*,
	datediff(day,d.fcha_mxma_pgo,@ldFechaActual)  dias_mora,
	0	Dias_mora_Especial, 
	'N'	Suspender
into    #tmpEstadosCuentaContratos  
From    bdcarteraPac..TbEstadosCuenta a, bdcarteraPac..tbliquidaciones b , bdcarteraPac..tbEstadosCuentaContratos c ,
	bdcarteraPac..tbperiodosliquidacion_vigencias  d
where   c.sldo	 					> 	0
And	a.cnsctvo_cdgo_lqdcn				=	b.cnsctvo_cdgo_lqdcn
And	a.cnsctvo_estdo_cnta				=	c.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_prdo_lqdcn			=	d.cnsctvo_cdgo_prdo_lqdcn	
And	b.cnsctvo_cdgo_estdo_lqdcn			=	3	--Finalizada
And	d.fcha_mxma_pgo				<=	@ldFechaActual
And	convert(int,ltrim(rtrim(c.nmro_cntrto)))	>	0
And	a.cnsctvo_cdgo_estdo_estdo_cnta != 4


--Trae  la infomacion paraal final actulizar los datos del empleador 
Select  a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
	a.nmro_estdo_cnta,
	c.*
into    #tmpEstadosCuentaContratosTotal  
From    bdcarteraPac..TbEstadosCuenta a, bdcarteraPac..tbliquidaciones b , bdcarteraPac..tbEstadosCuentaContratos c ,
	bdcarteraPac..tbperiodosliquidacion_vigencias  d
where   c.sldo	 					> 	0
And	a.cnsctvo_cdgo_lqdcn				=	b.cnsctvo_cdgo_lqdcn
And	a.cnsctvo_estdo_cnta				=	c.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_prdo_lqdcn			=	d.cnsctvo_cdgo_prdo_lqdcn	
And	convert(int,ltrim(rtrim(c.nmro_cntrto)))	>	0


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

Update  #tmpEstadosCuentaContratos
Set	Dias_mora_Especial  	= 	b.ds_pra_sspnsn
From 	#tmpEstadosCuentaContratos a , bdAfiliacion..tbDatosComercialesSucursal b
Where	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte

If  @@error	!=	0 	
Begin 
	Return -1
end	



--Se marca para suspender aquellos contratos donde 
--la fecha maxima de pago - la fecha del proceso sea mayor al numero de dias especiales para la mora
Update  #tmpEstadosCuentaContratos
Set		Suspender	  = 'S'
From 	#tmpEstadosCuentaContratos 
Where 	dias_mora	>	Dias_mora_Especial

If  @@error	!=	0 	
Begin 
	Return -1
end	

-- QUICK 2013-001-002925
select cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,sum(sldo)  sldo
into #tempcon1
from #tmpEstadosCuentaContratos
where Suspender	  = 'S'
group by cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto
having sum(sldo) <=  @tolerancia

-- QUICK 2013-001-002925
delete #tmpEstadosCuentaContratos
from #tmpEstadosCuentaContratos ec
		inner join #tempcon1 tc
			on ec.cnsctvo_cdgo_tpo_cntrto = tc.cnsctvo_cdgo_tpo_cntrto
			and  ec.nmro_cntrto = tc.nmro_cntrto
If  @@error	!=	0 	
Begin 
	Return -1
end	

--Se crea una tabla temporal con los contratos que se van a suspender
Select 	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto ,	0	nmro_unco_idntfccn_ctznte,	'S'	Suspender
into	#tmpContratosMora
From	#tmpEstadosCuentaContratos
Where 	Suspender		=	'S'
Group by cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto 


If  @@error	!=	0 	
Begin 
	Return -1
end	


--Actualiza el nui del cotizante
Update	#tmpContratosMora
Set	nmro_unco_idntfccn_ctznte	=	nmro_unco_idntfccn_afldo
From	#tmpContratosMora a, bdafiliacion..tbcontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto


If  @@error	!=	0 	
Begin 
	Return -1
end	



--Se Crea una tabla temporal con los beneficiarios de cada contrato PAc
Select 	distinct a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,			b.nmro_unco_idntfccn_bnfcro,
	b.cnsctvo_bnfcro,
	'S'	Suspender
into	#tmpBeneficiariosxContratoPac	
From	#tmpContratosMora a,	bdAfiliacion..tbBeneficiarios 	b
Where	Convert(Varchar(10),@ldFechaActual,111)	Between	Convert(Varchar(10),b.inco_vgnca_bnfcro,111)	And	Convert(Varchar(10),b.fn_vgnca_bnfcro,111)
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	b.estdo				=	'A'

If  @@error	!=	0 	
Begin 
	Return -1
end	


--Se verifca cuales de esos beneficiarios ya se encuentran suspendidos y estan en el proceso de mora
Update	#TempSuspendidos
Set	Activar		=	'N'
From 	#tmpBeneficiariosxContratoPac a,
	#TempSuspendidos	c 
Where	c.cnsctvo_cdgo_tpo_cntrto	=		a.cnsctvo_cdgo_tpo_cntrto
And	c.nmro_cntrto			=		a.nmro_cntrto
And	c.nmro_unco_idntfccn_bnfcro	=		a.nmro_unco_idntfccn_bnfcro
And	c.cnsctvo_bnfcro		=		a.cnsctvo_bnfcro

If  @@error	!=	0 	
Begin 
	Return -1
end	


--Se crea una tabla temporal con los contratos que se van a Activar
Select 	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto ,
	cnsctvo_cdgo_csa_nvdd,
	0	nmro_unco_idntfccn_ctznte
into	#TempActivarPac
From	#TempSuspendidos
Where 	Activar		=	'S'
Group by cnsctvo_cdgo_tpo_cntrto ,	nmro_cntrto , cnsctvo_cdgo_csa_nvdd

If  @@error	!=	0 	
Begin 
	Return -1
end	


Update	#TempActivarPac
Set	nmro_unco_idntfccn_ctznte	=	nmro_unco_idntfccn_afldo
From	#TempActivarPac a, bdafiliacion..tbcontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

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
cnsctvo_cmpo		 	udtConsecutivo,			vlr_nvo			 	varchar(128),
cnsctvo_prdcto			udtConsecutivo,			actlza_bnfcro			udtLogico,
actlza_cbrnza			udtLogico,			inco_vgnca			Datetime,
fn_vgnca			Datetime,			cnsctvo_idntfcdr_rgstro 	udtConsecutivo 	  )

If  @@error	!=	0 
Begin 
	Return  -1
End

-- se inserta en la tabla los registros a los cuales se les necesita crear la novedad
Insert	Into	#TmpDetInformacionNovedad
Select 	a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto,			b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_bnfcro,	 0,	0,	0,
	14, 	-- Cambio de estado
	a.cnsctvo_cdgo_csa_nvdd,	-- Mora Pac
	@ldFechaActual,	'N',	@lcUsuario,	0,	0,	0,	0,	'A',	
	4,	-- beneficiarios
	0,
	a.nmro_unco_idntfccn_ctznte,		0,	0,	0,	0,	0,	5,	0,	'N',	'N',	Null,
	@ldFechaActual,	0
From	#TempActivarPac a,	bdAfiliacion..tbBeneficiarios b, #TempSuspendidos c
Where	a.cnsctvo_cdgo_csa_nvdd		=	99	-- Mora Pac
And	Convert(Varchar(10),@ldFechaActual,111)	Between	Convert(Varchar(10),b.inco_vgnca_bnfcro,111)	And	Convert(Varchar(10),b.fn_vgnca_bnfcro,111)
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	b.estdo				=	'A'
And	b.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	b.nmro_cntrto			=	c.nmro_cntrto
And     	b.cnsctvo_bnfcro		=	c.cnsctvo_bnfcro

If  @@error	!=	0 	
Begin 
	Return -1
end	



If Exists(	Select	1
	From	#TmpDetInformacionNovedad)
Begin
	

	-- ACOTAR SUSPENDIDOS
	Exec @lnError	=	bdAfiliacion..spAdmonCambioEstado	'0',	
						2,	---- Novedad Realizada x Proceso
						@lcUsuario,	
						@lnProceso	Output	
						
	If  @@error	!=	0 	Or	 @lnError	 != 	0
	Begin 
		Return -1
	end	

	-- ACTIVAR LOS REGISTROS SUSPENDIDOS
	Update	#TmpDetInformacionNovedad	Set	vlr_nvo		=	1,
		inco_vgnca	=	@ldFechaActual,
		fn_vgnca 	=	'9999/12/31'

	If  @@error	!=	0 	
		Begin 
			Return -1
		end		
--select '#TmpDetInformacionNovedad',* from #TmpDetInformacionNovedad
	Exec @lnError	=	bdAfiliacion..spAdmonCambioEstado	'0',	
						2,	---- Novedad Realizada x Proceso
						@lcUsuario,	
						@lnProceso	Output	
						
	If  @@error	!=	0 	Or	 @lnError	 != 	0
	Begin 
		Return -1
	end	


End



--Se crea la tabla de los que suspendio..
Select	IDENTITY(int, 1,1) AS ID_Num,
	cnsctvo_cdgo_tpo_nvdd,		cnsctvo_cdgo_csa_nvdd,		fcha_nvdd,			
	cnsctvo_nvdd,			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,				nmro_unco_idntfccn,		cnsctvo_idntfcdr,	Estdo	,	
	'S'	Suspender
into 	#tmpActivadosFinal
From	#TmpDetInformacionNovedad	


Select @Maxcnsctvo_mrccn_mra_pc	=	isnull(max(cnsctvo_actvcn_mra_pc),0)
From	tbLogActivacionMoraPac


insert	into	tbLogActivacionMoraPac
Select	(ID_Num +@Maxcnsctvo_mrccn_mra_pc),
	 50,
	 cnsctvo_cdgo_tpo_nvdd,
	 cnsctvo_cdgo_csa_nvdd,
	 fcha_nvdd,
	 cnsctvo_nvdd,
	 @lnProceso,
	 cnsctvo_cdgo_tpo_cntrto,
	 nmro_cntrto,
	 nmro_unco_idntfccn,
	 cnsctvo_idntfcdr,
	 Estdo,
	 0,
	 0,
	 0,
	 convert(char(10),getdate(),111)	---Relacion tbProcesosCateraPac
From	 #tmpActivadosFinal



update  a 
set 	    nmro_unco_idntfccn_empldr		=b.nmro_unco_idntfccn_empldr,
	    cnsctvo_scrsl			=b.cnsctvo_scrsl,
	    cnsctvo_cdgo_clse_aprtnte		=b.cnsctvo_cdgo_clse_aprtnte
from 	    tbLogActivacionMoraPac  	a 
inner join #tmpEstadosCuentaContratosTotal 	b
On 	    a.cnsctvo_cdgo_tpo_cntrto		=b.cnsctvo_cdgo_tpo_cntrto
and	    a.nmro_cntrto			=b.nmro_cntrto
and	    convert(char(10),fcha_crcn,111)	= convert(char(10),getdate(),111)	
         
     

--depende del dia de ejecucion se ejecuta la suspencion en mora Pac


Declare		@diaEvaluacion	char(2),
		@PeriodoEvaluacion  	int,
		@fechaEvaluacion    	varchar(10),
		@estado_suspencion	char(1)	


drop table #tmpEstadosCuentaContratosTotal

Set	 @fechaEvaluacion 	= 	convert(varchar(10),getdate(),112)
Set	 @PeriodoEvaluacion	= 	convert(int,substring(@fechaEvaluacion,1,6))
Set	 @diaEvaluacion	= 	substring(@fechaEvaluacion,7,2)	

if  @diaEvaluacion >=	'09'
    Begin 		
	Select  @estado_suspencion	=  	estdo_sspncn
	From 	bdcarteraPac..tbperiodossuspencion
	Where   prdo_sspncn		 = 	@PeriodoEvaluacion

	If 	@estado_suspencion	=	'A'
		Begin
			-- ejecuta la suspencion

			Exec @lnError	=	bdcarteraPac..SpSuspencionContratosXMoraPac	@ldFechaActual,@lcUsuario

			If  (@@error	!=	0 	Or	 @lnError	 != 	0)
				Begin
					Return -1
				End
			Else
				Begin
					--Se actualiza el estado suspencion para el proceso
					Update bdcarteraPac..tbperiodossuspencion
					Set	estdo_sspncn	=	'P'
					Where   prdo_sspncn		 = @PeriodoEvaluacion
				End
		 End
     End



----------------------------------------------------------------------------------------------------------
--INICIA  PROCESO TEMPORAL DE LEVANTAR MARCA EXTEMPORANEO PARA EMPRESAS ENVIADAS POR CARTERA PAC
--- SISDGB01   27/11/2012
----------------------------------------------------------------------------------------------------------
/*

-- sismpr01 - 20130214 - se cambia tabla temporal por tabla fija de nombre bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad para manejo de vigencias

create table #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn varchar(15), nmro_unco_idntfccn int)

insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860003563')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890309556')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800162612')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890399032')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('815001629')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900378212')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890399027')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891900129')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860002537')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890300406')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890301536')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890321151')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800096812')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('830127551')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890319047')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900483014')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890300005')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800099903')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890311274')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860001317')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900279984')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890320250')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900461844')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900512502')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890329872')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890321150')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900386417')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890314970')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860047239')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890300634')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891900101')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800034586')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890327886')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891400380')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('815002936')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800197268')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890399011')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('816002020')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('816002019')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('816002018')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800249860')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860007538')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('805008989')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890331531')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('815000477')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890328876')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890321989')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800030924')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891900343')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('860002127')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890399012')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891501133')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890300346')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890301463')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890301602')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890302594')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891380007')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('891400378')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900458593')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('890301960')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('900081360')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('800254518')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('805001157')
insert into #tmpEmpresasMarcaExtemporaneo (nmro_idntfccn) values ('899999063')


update  a
set nmro_unco_idntfccn = v.nmro_unco_idntfccn
from #tmpEmpresasMarcaExtemporaneo a inner join bdafiliacion.dbo.tbvinculados v
on a.nmro_idntfccn = v.nmro_idntfccn
where v.cnsctvo_cdgo_tpo_idntfccn = 9
*/

declare @periodo_actual int, @periodo_anterior int

set @periodo_actual = ( select cnsctvo_cdgo_prdo_lqdcn from bdcarterapac.dbo.tbperiodosliquidacion_vigencias where getdate() between  fcha_incl_prdo_lqdcn and fcha_fnl_prdo_lqdcn )
set @periodo_anterior = @periodo_actual -1

select * into #tmpLiquidacionesFinalizadas from bdcarterapac.dbo.tbliquidaciones l
where cnsctvo_cdgo_prdo_lqdcn between @periodo_anterior and @periodo_actual
and cnsctvo_cdgo_estdo_lqdcn = 3 -- finalizada


-- Fecha: 2014-10-02
-- Por: Francisco J Gonzalez R
-- Qcuik 2014-00001-000019933

Declare @dFechaSistema Datetime
Set @dFechaSistema = Convert(Char(10),Getdate(), 111)

--Select @dFechaSistema

/* Se adicionan las empresas no existentes en tbEmpresasExcluidaMarcaExtemporaneidad, con dias para suspension mayor a cero */

Insert Into	bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad	(
		nmro_unco_emprsa_exclda,			inco_vgnca,
		fn_vgnca,							usro_exclsn,
		fcha_exclsn,						obsrvcns)
Select	Distinct a.nmro_unco_idntfccn_empldr,		@dFechaSistema, 
		'9999-12-31',						'admcarpac01',					
		Getdate(),							'Quick 2014-00001-000019933 proceso tren diario X440'
From	bdAfiliacion..tbDatosComercialesSucursal a 
Where	a.ds_pra_sspnsn			> 0
And		Not Exists (Select 1
					From	bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad b
					Where	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_emprsa_exclda
					And		@dFechaSistema BetWeen b.inco_vgnca And b.fn_vgnca		)
And		a.nmro_unco_idntfccn_empldr > 0
Order by a.nmro_unco_idntfccn_empldr

----

/* Se acotan las empresas que existentes en tbEmpresasExcluidaMarcaExtemporaneidad, pero qye ya no tienen dias para suspension mayor a cero */

Update	a
Set		fn_vgnca	= Getdate()
-- Select a.*
From	bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad a
Where	Not Exists (Select 1
					From	bdAfiliacion..tbDatosComercialesSucursal b
					Where	a.nmro_unco_emprsa_exclda = b.nmro_unco_idntfccn_empldr
					And		@dFechaSistema BetWeen a.inco_vgnca And a.fn_vgnca
					And		b.ds_pra_sspnsn			> 0)


-- Fin Quick 2014-00001-000019933




-- sismpr01 - 20130214 - se cambia tabla temporal por tabla fija de nombre bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad para manejo de vigencias

select	ec.* 
into	#tmpEstadosCuenta
from	bdcarterapac.dbo.tbestadoscuenta ec 
			inner join  #tmpLiquidacionesFinalizadas l
				on ec.cnsctvo_cdgo_lqdcn = l.cnsctvo_cdgo_lqdcn
where	Exists (	select	1 
					from	bdcarterapac.dbo.tbEmpresasExcluidaMarcaExtemporaneidad ee
					where	getdate() between inco_vgnca and fn_vgnca
					And		ec.nmro_unco_idntfccn_empldr = ee.nmro_unco_emprsa_exclda
				)

If exists(Select 1 from temporal.dbo.sysobjects where name = 'tmpCopiaPagosExtemporaneos') 
Begin 
	Drop table temporal.dbo.tmpCopiaPagosExtemporaneos 
End 

select * into temporal.dbo.tmpCopiaPagosExtemporaneos 
from bdcarterapac..tbabonos 
where cnsctvo_estdo_cnta in (select cnsctvo_estdo_cnta from #tmpEstadosCuenta )
and extmprno = 'S'

/*
Select ti.cdgo_tpo_idntfccn,v.nmro_idntfccn, ec.cnsctvo_scrsl,ltrim(Rtrim(sa.nmbre_scrsl)) as sucursal,
ec.nmro_estdo_cnta,
ec.ttl_fctrdo,
ec.vlr_iva,
ec.sldo_fvr,
ec.ttl_pgr,
ec.sldo_estdo_cnta,
ec.Fcha_crcn,
pl.dscrpcn_prdo_lqdcn,
p.cnsctvo_cdgo_pgo as numero_pago,
p.fcha_aplccn,
p.usro_aplccn,
p.fcha_rcdo,
p.cnsctvo_rcdo_cncldo,
ab.vlr_abno,
ab.extmprno
from temporal.dbo.tmpCopiaPagosExtemporaneos  a inner join bdcarterapac.dbo.tbpagos p
on a.cnsctvo_cdgo_pgo = p.cnsctvo_cdgo_pgo
inner join tbestadoscuenta ec 
on a.cnsctvo_estdo_cnta = ec.cnsctvo_estdo_cnta
inner join bdafiliacion.dbo.tbvinculados v
on ec.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbtiposidentificacion ti
on ti.cnsctvo_cdgo_tpo_idntfccn = v.cnsctvo_cdgo_tpo_idntfccn
inner join dbo.tbliquidaciones l
on ec.cnsctvo_cdgo_lqdcn = l.cnsctvo_cdgo_lqdcn
inner join dbo.tbperiodosliquidacion pl
on l.cnsctvo_cdgo_prdo_lqdcn = pl.cnsctvo_cdgo_prdo_lqdcn
inner join dbo.tbabonos ab
on ab.cnsctvo_cdgo_pgo = p.cnsctvo_cdgo_pgo
and ab.cnsctvo_estdo_cnta = a.cnsctvo_estdo_cnta
inner join bdafiliacion.dbo.tbsucursalesaportante sa
on ec.nmro_unco_idntfccn_empldr = sa.nmro_unco_idntfccn_empldr
and ec.cnsctvo_scrsl = sa.cnsctvo_scrsl
and ec.cnsctvo_cdgo_clse_aprtnte =sa.cnsctvo_cdgo_clse_aprtnte
group by ti.cdgo_tpo_idntfccn,v.nmro_idntfccn, ec.cnsctvo_scrsl,ltrim(Rtrim(sa.nmbre_scrsl)),
ec.nmro_estdo_cnta,
ec.ttl_fctrdo,
ec.vlr_iva,
ec.sldo_fvr,
ec.ttl_pgr,
ec.sldo_estdo_cnta,
ec.Fcha_crcn,
pl.dscrpcn_prdo_lqdcn,
p.cnsctvo_cdgo_pgo ,
p.fcha_aplccn,
p.usro_aplccn,
p.fcha_rcdo,
p.cnsctvo_rcdo_cncldo,
ab.vlr_abno,
ab.extmprno
*/


begin tran

update bdcarterapac.dbo.tbabonos
set extmprno = 'N'
where cnsctvo_estdo_cnta in (select cnsctvo_estdo_cnta from #tmpEstadosCuenta )
and extmprno = 'S'

if @@error != 0  
begin
rollback tran
end
else
begin
commit tran
end
