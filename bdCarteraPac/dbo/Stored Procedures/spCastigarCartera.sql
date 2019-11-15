



/*---------------------------------------------------------------------------------
* Metodo o PRG				:  spCastigarCartera
* Desarrollado por		: <\A Ing. FernandoValencia E 							A\> 
* Descripcion					: <\D Permite generar las NC de las cartera a castigar			D\>
* Observaciones				: <\O										O\>
* Parametros					: <\P 										P\>
* Variables						: <\V 										V\>
* Fecha Creacion			: <\FC 2008/02/29 					FC\>
*
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/


CREATE   PROCEDURE [dbo].[spCastigarCartera]  
@usuario UdtUsuario
as 

declare @lnValorTotalNota 						int,
				@lnSdoEstadoCuenta 				int,
				@lnValorIvaNota 				int,
				@lnNuiResponsable 				int,
				@lnConsecutivoSucursal 			int,
				@lnClaseAportante 				int,
				@lnConsecutivoEstadocuenta 		int,
			    @lntipoDocumento				int,
			    @ldFechaSistema 				datetime,
				@lnConsecutivoTipoMovimiento 	int,
				@lnConsecutivoPlan 				int   

Set Nocount On

CREATE TABLE dbo.#TMPcontratosresponsableprevio (
	cnsctvo_estdo_cnta 					int NULL ,
	nmro_unco_idntfccn_empldr			int NULL ,
	cnsctvo_scrsl 						int NULL ,
	cnsctvo_cdgo_clse_aprtnte			int NULL ,
	ttl_fctrdo 							numeric (12, 0) NULL ,
	vlr_iva 							numeric (12, 0) NULL ,
	ttl_pgr 							numeric (12, 0) NULL ,
	nmro_estdo_cnta 					char (15)  NULL ,
	cnsctvo_cdgo_tpo_cntrto 			int NULL ,
	nmro_cntrto 						char (15)  NULL ,
	nmbre_afldo 						char (200)  NULL ,
	nmbre_scrsl 						char (200)  NULL ,
	rzn_scl 							char (200) NULL ,
	dgto_vrfccn 						int NULL ,
	nmro_idntfccn_empldr 				char (20)  NULL ,
	cdgo_tpo_idntfccn_empldr 			char (3) NULL ,
	cnsctvo_cdgo_tpo_idntfccn_Empldr	int NULL ,
	cdgo_tpo_idntfccn 					char (3)  NULL ,
	nmro_idntfccn 						char (23)  NULL ,
	accn 								char (15)  NULL ,
	cnsctvo_cdgo_pln 					int NULL ,
	nmro_unco_idntfccn_afldo 			int NULL ,
	cnsctvo_cdgo_estdo_estdo_cnta		int NULL ,
	sldo_estdo_cnta						numeric (12, 0) NULL ,
	vlr_cbrdo_cntrto					numeric (12, 0) NULL ,
	sldo_cntrto							numeric (12, 0) NULL ,
	cnsctvo_estdo_cnta_cntrto			int NULL ,
	fcha_crcn_nta						Datetime Null
) 


CREATE TABLE dbo.#TMPconceptonotacastigo (
	cdgo_cncpto_lqdcn 					char (5) NOT NULL ,
	dscrpcn_cncpto_lqdcn 				udtDescripcion NOT NULL ,
	Valor 								numeric(12, 0) NULL ,
	cnsctvo_cdgo_pln 					udtConsecutivo NULL ,
	cnsctvo_cdgo_tpo_mvmnto 			udtConsecutivo NOT NULL ,
	oprcn 								udtConsecutivo NOT NULL ,
	slcta_atrzdr 						char (1)  NOT NULL ,
	cnsctvo_cdgo_autrzdr_espcl 			int NOT NULL ,
	cnsctvo_cdgo_cncpto_lqdcn 			udtConsecutivo NOT NULL ,
	cnsctvo_cdgo_bse_aplcda 			udtConsecutivo NOT NULL) 
	
	

CREATE TABLE dbo.#TMPconceptonotadebito (
	cdgo_cncpto_lqdcn 					char (5)  NOT NULL ,
	dscrpcn_cncpto_lqdcn 				varchar (150)  NOT NULL ,
	Valor 								numeric(12, 0) NULL ,
	cnsctvo_cdgo_pln 					int NULL ,
	cnsctvo_cdgo_tpo_mvmnto 			int NOT NULL ,
	oprcn 								int NOT NULL ,
	slcta_atrzdr 						char (1)  NOT NULL ,
	cnsctvo_cdgo_autrzdr_espcl 			int NOT NULL ,
	cnsctvo_cdgo_cncpto_lqdcn 			int NOT NULL ,
	cnsctvo_cdgo_bse_aplcda				int NOT NULL )


CREATE TABLE  dbo.#TMPcontratosresponsablePlan  (
	 cnsctvo_estdo_cnta   				int  NULL ,
	 nmro_unco_idntfccn_empldr   		int  NULL ,
	 cnsctvo_scrsl   					int  NULL ,
	 cnsctvo_cdgo_clse_aprtnte   		int  NULL ,
	 ttl_fctrdo   						numeric (12, 0) NULL ,
	 vlr_iva   							numeric (12, 0) NULL ,
	 ttl_pgr   							numeric (12, 0) NULL ,
	 nmro_estdo_cnta   					char  (15)   NULL ,
	 cnsctvo_cdgo_tpo_cntrto   			int  NULL ,
	 nmro_cntrto   						char  (15)   NULL ,
	 nmbre_afldo   						char  (200)   NULL ,
	 nmbre_scrsl   						char  (200)   NULL ,
	 rzn_scl   							char  (200)   NULL ,
	 dgto_vrfccn   						int  NULL ,
	 nmro_idntfccn_empldr   			char  (20)   NULL ,
	 cdgo_tpo_idntfccn_empldr   		char  (3)   NULL ,
	 cnsctvo_cdgo_tpo_idntfccn_Empldr   int  NULL ,
	 cdgo_tpo_idntfccn   				char  (3)   NULL ,
	 nmro_idntfccn   					char  (23)   NULL ,
	 accn   							char  (15)   NULL ,
	 cnsctvo_cdgo_pln   				int  NULL ,
	 nmro_unco_idntfccn_afldo   		int  NULL ,
	 cnsctvo_cdgo_estdo_estdo_cnta 		int  NULL ,
	 sldo_estdo_cnta   					numeric (12, 0) NULL ,
	 vlr_cbrdo_cntrto   				numeric (12, 0) NULL ,
	 sldo_cntrto   						numeric (12, 0) NULL ,
	 cnsctvo_estdo_cnta_cntrto   		int  NULL ,
	 fcha_crcn_nta						Datetime NULL,
	 valor   							int  NOT NULL ,
	 cnsctvo_cdgo_cncpto_lqdcn   		int  NOT NULL 
) 


CREATE TABLE  dbo.#TMPcontratosresponsable  (
	 cnsctvo_estdo_cnta_cntrto   	int  NULL ,
	 nmro_cntrto   					char  (15)   NULL ,
	 cdgo_tpo_idntfccn   			char  (3)   NULL ,
	 nmro_idntfccn   				char  (23)   NULL ,
	 nmbre_afldo   					char  (200)   NULL ,
	 sldo_cntrto   					numeric (12, 0) NULL ,
	 valor   						int  NOT NULL ,
	 SELECCIONADO   				char  (15)   NULL ,
	 cnsctvo_cdgo_cncpto_lqdcn   	int  NOT NULL ,
	 cnsctvo_cdgo_tpo_cntrto   		int  NULL ,
	 cnsctvo_cdgo_pln   			int  NULL ,
	 nmro_unco_idntfccn_afldo   	int  NULL ,
	 sldo_estdo_cnta   				numeric (12, 0) NULL ,
	 vlr_cbrdo_cntrto   			numeric (12, 0) NULL ,
	 vlr_sn_iva   					int  NOT NULL ,
	 vlr_iva   						int  NOT NULL 
) 


CREATE TABLE  dbo.#TMPcontratosresponsablexplan  (
	 nmro_cntrto   				char  (15)   NULL ,
	 cdgo_tpo_idntfccn   		char  (3)   NULL ,
	 nmro_idntfccn   			char  (23)   NULL ,
	 nmbre_afldo   				char  (200)   NULL ,
	 sldo_cntrto   				numeric (12, 0) NULL ,
	 valor   					int  NOT NULL ,
	 SELECCIONADO   			char  (15)   NULL ,
	 cnsctvo_cdgo_cncpto_lqdcn  int  NOT NULL ,
	 cnsctvo_cdgo_tpo_cntrto   	int  NULL ,
	 cnsctvo_cdgo_pln   		int  NULL ,
	 nmro_unco_idntfccn_afldo   int  NULL ,
	 sldo_estdo_cnta   			numeric (12, 0) NULL ,
	 vlr_cbrdo_cntrto   		numeric (12, 0) NULL ,
	 vlr_sn_iva   				int  NOT NULL ,
	 vlr_iva   					int  NOT NULL 
)


select nmro_dcmnto, cnsctvo_cdgo_tpo_dcmnto
into #tmpEstadosCuenta
from #tmpDatosCastigar 
group by nmro_dcmnto, cnsctvo_cdgo_tpo_dcmnto

-------------------------------------------------
declare @nmro_estdo_cnta           udtconsecutivo
declare @cnsctvo_cdgo_tpo_dcmnto   udtconsecutivo
declare crEstadoscuenta cursor  for
select  nmro_dcmnto, cnsctvo_cdgo_tpo_dcmnto from #tmpEstadosCuenta

open crEstadoscuenta
fetch crEstadoscuenta into @nmro_estdo_cnta, @cnsctvo_cdgo_tpo_dcmnto
while (@@FETCH_STATUS = 0)
Begin


set 		@ldFechaSistema=getdate()
set 		@lnConsecutivoTipoMovimiento = 4
set 		@lnConsecutivoPlan = null


insert into dbo.#TMPconceptonotacastigo
Select	cdgo_cncpto_lqdcn, 	  dscrpcn_cncpto_lqdcn,	   convert(numeric(12),0)	Valor,
	   	cnsctvo_cdgo_pln,  	  cnsctvo_cdgo_tpo_mvmnto,	   oprcn     , slcta_atrzdr , 	0 cnsctvo_cdgo_autrzdr_espcl,
	   	cnsctvo_cdgo_cncpto_lqdcn,cnsctvo_cdgo_bse_aplcda
	From    tbconceptosliquidacion_vigencias 
	Where      (@ldFechaSistema  between inco_vgnca   And    fn_vgnca )  
	And (vsble_usro			= 	'S' )
	And cnsctvo_cdgo_tpo_mvmnto	=	4  --=	@lnConsecutivoTipoMovimiento
	And (cnsctvo_cdgo_pln			=	@lnConsecutivoPlan or @lnConsecutivoPlan is null)
 	And cnsctvo_vgnca_cncpto_lqdcn in (110,111,112,113)
------------------------------------------------------------------


if @cnsctvo_cdgo_tpo_dcmnto= 9
	begin
		insert into #TMPcontratosresponsableprevio 
		exec SpConsultaContratosEstadoCuenta @nmro_estdo_cnta
	end
else 	
   begin
	 	insert into #TMPcontratosresponsableprevio 
   	exec SpConsultaContratosNotasDebito @nmro_estdo_cnta
   end

update #TMPcontratosresponsableprevio 
set accn='SELECCIONADO'

insert into #TMPconceptonotadebito
select DISTINCT a.* 
from #TMPconceptonotacastigo a inner join #TMPcontratosresponsableprevio b 
on a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln 



INSERT INTO dbo.#TMPcontratosresponsablePlan
SELECT a.*,0 valor,b.cnsctvo_cdgo_cncpto_lqdcn
FROM #TMPcontratosresponsableprevio  a , #TMPconceptonotadebito b
WHERE a.cnsctvo_cdgo_pln = b.cnsctvo_cdgo_pln 



insert into dbo.#TMPcontratosresponsablexplan
SELECT  nmro_cntrto,	cdgo_tpo_idntfccn,	nmro_idntfccn,  
	nmbre_afldo,  sldo_cntrto AS sldo_cntrto,	a.valor , 
        accn as  'SELECCIONADO',
	b.cnsctvo_cdgo_cncpto_lqdcn ,
	a.cnsctvo_cdgo_tpo_cntrto,	a.cnsctvo_cdgo_pln,		
	nmro_unco_idntfccn_afldo ,	sldo_estdo_cnta, 
	vlr_cbrdo_cntrto, 0 AS vlr_sn_iva, 0 AS vlr_iva 
	FROM  #TMPcontratosresponsablePlan a,  #TMPconceptonotadebito b
	WHERE   a.cnsctvo_cdgo_cncpto_lqdcn 	= b.cnsctvo_cdgo_cncpto_lqdcn
	AND  	a.cnsctvo_cdgo_pln 		= b.cnsctvo_cdgo_pln 
	ORDER BY nmbre_afldo



insert into dbo.#TMPcontratosresponsable
SELECT a.cnsctvo_estdo_cnta_cntrto, b.*  
FROM #TMPcontratosresponsablePlan  a INNER JOIN #TMPcontratosresponsablexplan b
ON a.nmro_cntrto=b.nmro_cntrto
AND a.cnsctvo_cdgo_tpo_cntrto=b.cnsctvo_cdgo_tpo_cntrto
AND a.cnsctvo_cdgo_cncpto_lqdcn=b.cnsctvo_cdgo_cncpto_lqdcn

update #TMPconceptonotadebito
set Valor=vlr_sn_iva
from #TMPconceptonotadebito a inner join #TMPcontratosresponsablexplan b 
on 		a.cnsctvo_cdgo_cncpto_lqdcn	=b.cnsctvo_cdgo_cncpto_lqdcn
and   a.cnsctvo_Cdgo_pln					=b.cnsctvo_Cdgo_pln

update #TMPcontratosresponsable
set valor=sldo_cntrto

update #TMPcontratosresponsable
set vlr_sn_iva= (isnull(valor,0) /1.1)

update #TMPcontratosresponsable
set vlr_iva=isnull(valor-vlr_sn_iva,0)


update #TMPcontratosresponsablexplan
set valor=sldo_cntrto

update #TMPcontratosresponsablexplan
set vlr_sn_iva= (isnull(valor,0) /1.1)

update #TMPcontratosresponsablexplan
set vlr_iva=isnull(valor-vlr_sn_iva,0)


select  @lnValorTotalNota 					=  	sum(vlr_sn_iva) from #TMPcontratosresponsablexplan
select  @lnValorIvaNota 						=  	sum(isnull(vlr_iva,0)) from #TMPcontratosresponsablexplan
select  @lnSdoEstadoCuenta 					=  	sum(sldo_cntrto) from #TMPcontratosresponsablexplan
select 	@lnConsecutivoEstadocuenta 	= 	cnsctvo 										from #tmpDatosCastigar where nmro_dcmnto=@nmro_estdo_cnta
select 	@lnNuiResponsable	  				= 	nmro_unco_idntfccn_empldr 	from #tmpDatosCastigar where nmro_dcmnto=@nmro_estdo_cnta	  
select 	@lnConsecutivoSucursal 	  	= 	cnsctvo_scrsl								from #tmpDatosCastigar where nmro_dcmnto=@nmro_estdo_cnta
select 	@lnClaseAportante						= 	cnsctvo_cdgo_clse_aprtnte 	from #tmpDatosCastigar where nmro_dcmnto=@nmro_estdo_cnta
select  @lntipoDocumento						=   cnsctvo_cdgo_tpo_dcmnto 		from #tmpDatosCastigar where nmro_dcmnto=@nmro_estdo_cnta    

exec SpGrabarNotaCreditoCastigo 2, 1, @lnValorIvaNota, @lnConsecutivoEstadocuenta, @lnValorTotalNota, 'Castigo de cartera autorizado por  gerencia general cruzada contra  provisión', @lnNuiResponsable,@lnConsecutivoSucursal,@lnClaseAportante, @usuario ,@lnSdoEstadoCuenta, @lntipoDocumento, 0, '',0

delete  #TMPconceptonotadebito
delete  #TMPcontratosresponsablePlan
delete  #TMPcontratosresponsable 
delete  #TMPconceptonotacastigo
delete  #TMPcontratosresponsablexPlan
delete  #TMPcontratosresponsableprevio 

   		fetch crEstadoscuenta into @nmro_estdo_cnta, @cnsctvo_cdgo_tpo_dcmnto
End
close crEstadoscuenta
deallocate crEstadoscuenta
