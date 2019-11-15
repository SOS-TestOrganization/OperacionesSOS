

/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoFode
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento para generar el plano del ingenio Providencia				 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
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
CREATE   PROCEDURE [dbo].[spPlanoFode]
As

Declare
@tbla			varchar(128),
@cdgo_cmpo 		varchar(128),
@oprdr 		varchar(2),
@vlr 			varchar(250),
@cmpo_rlcn 		varchar(128),
@cmpo_rlcn_prmtro 	varchar(128),
@cnsctvo		Numeric(4),
@IcInstruccion		Nvarchar(4000),
@IcInstruccion1		Nvarchar(4000),
@IcInstruccion2		Nvarchar(4000),
@lcAlias		char(2),
@lnContador		Int,
@ldFechaSistema	Datetime,
@nmro_estdo_cnta	char(15)	,
@mes 			char(2),
@ano 			char(4)


Set Nocount On



Select	@ldFechaSistema	=	Getdate()

set	@mes = substring(convert(varchar(10),getdate(),111),6,2)
set	@ano = substring(convert(varchar(10),getdate(),111),1,4)




-- Contador de condiciones
Select @lnContador = 1
set	@nmro_estdo_cnta	=	NULL

Select 	@nmro_estdo_cnta 	 =	vlr
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	'nmro_estdo_cnta' 	

--select * from tbestadoscuenta where nmro_estdo_cnta=1525916

Select  nmro_cntrto,cnsctvo_cdgo_tpo_cntrto,
	'8050011572' Campo1,
    '0' Campo2,   
    'I' Campo3,   
     0  Campo4, --Cedula del empleado   
     'DESAL' Campo5, 
	 convert(char(10),a.fcha_crcn,103) Campo6,
     convert(char(10),fcha_mxma_pgo,103) Campo7,
     vlr_cbrdo Campo8,
	 0	nui_afldo
into 	#tmpcontratoFode
From  	tbestadoscuenta a, tbestadoscuentaContratos b, tbliquidaciones c , tbperiodosliquidacion_vigencias p
Where 	nmro_estdo_cnta 		= @nmro_estdo_cnta
And   	a.cnsctvo_estdo_cnta 	=  b.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=  c.cnsctvo_cdgo_lqdcn
And	c.cnsctvo_cdgo_prdo_lqdcn	=  p.cnsctvo_cdgo_prdo_lqdcn

Update  #tmpcontratoFode
Set	nui_afldo	=	nmro_unco_idntfccn_afldo
From	#tmpcontratoFode a, bdafiliacion..tbcontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

Update  #tmpcontratoFode
Set	Campo4		=	nmro_idntfccn
From	#tmpcontratoFode a, bdafiliacion..tbvinculados  b
Where 	a.nui_afldo	=	b.nmro_unco_idntfccn

select	Campo1, 
		Campo2, 
		Campo3,  
		campo4, 
		Campo5, 
		campo6, 
        campo7, 
        CONVERT(NUMERIC(12),Sum(CONVERT(NUMERIC(12),Campo8))) Campo8
into #tmpcontratoXCedula
from #tmpcontratoFode
Group by Campo1, Campo2, Campo3, Campo4, Campo5, campo6, campo7

select * from #tmpcontratoXCedula

