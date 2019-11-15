

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
* Modificado Por		: <\AM  AM\> Ing. Fernando Valencia E 
* Descripcion			: <\DM  DM\> Se modifica segun sau 91274, archivo texto seprado por comas
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\> 2008/10/10
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE [dbo].[spPlanoFodePalmira]
As
Declare
@tbla			varchar(128),
@cdgo_cmpo 		varchar(128),
@oprdr 		    varchar(2),
@vlr 			varchar(250),
@cmpo_rlcn 		varchar(128),
@cmpo_rlcn_prmtro 	varchar(128),
@cnsctvo		Numeric(4),
@lcAlias		char(2),
@lnContador		Int,
@ldFechaSistema	Datetime,
@nmro_estdo_cnta	char(15)	,
@mes 			char(2),
@ano 			char(4),
@cnsctvo_cdgo_lqdcn int 

Set Nocount On

Select	@ldFechaSistema	=	Getdate()

set	@mes = substring(convert(varchar(10),getdate(),111),6,2)
set	@ano = substring(convert(varchar(10),getdate(),111),1,4)


create table #tmpcontratoFode (
nmro_cntrto int, 
cnsctvo_cdgo_tpo_cntrto int,
Codigo_Empleado varchar(15),
Codigo_Concepto varchar(15),
Fecha_Ocurrencia char(10),
Fecha_Liquidacion char(10),
Valor_Novedad numeric(12,0)	,
nui_afldo int
)


-- Contador de condiciones
Select @lnContador = 1
set	@nmro_estdo_cnta	=	NULL

Select 	@cnsctvo_cdgo_lqdcn 	 =	vlr
From 	#tbCriteriosTmp
Where 	cdgo_cmpo 		 = 	 'cnsctvo_cdgo_lqdcn' 	

--select * from tbestadoscuenta where nmro_estdo_cnta=1525916


Insert into #tmpcontratoFode (nmro_cntrto, cnsctvo_cdgo_tpo_cntrto , Codigo_Empleado, Codigo_Concepto, Fecha_Ocurrencia , 
Fecha_Liquidacion , Valor_Novedad,nui_afldo )
Select  nmro_cntrto, 
        cnsctvo_cdgo_tpo_cntrto,
	    0								Codigo_Empleado,
        'OCCISALUD'						Codigo_Concepto,
 --  '8050011572'						Codigo_Concepto,
        '01/'+substring(convert(char(10),a.fcha_crcn,103),4,2)+'/'+substring(convert(char(10),a.fcha_crcn,103),7,4)  Fecha_Ocurrencia,
		convert(char(10),fcha_mxma_pgo,103) Fecha_Liquidacion,
		vlr_cbrdo						   	Valor_Novedad,
		0	nui_afldo
From  	tbestadoscuenta a, tbestadoscuentaContratos b, tbliquidaciones c , tbperiodosliquidacion_vigencias p
Where 	c.cnsctvo_cdgo_lqdcn = 	 @cnsctvo_cdgo_lqdcn
And   	a.cnsctvo_estdo_cnta 	=  b.cnsctvo_estdo_cnta
And	a.cnsctvo_cdgo_lqdcn		=  c.cnsctvo_cdgo_lqdcn
And	c.cnsctvo_cdgo_prdo_lqdcn	=  p.cnsctvo_cdgo_prdo_lqdcn
And a.cnsctvo_scrsl = 4


Update  #tmpcontratoFode
Set	nui_afldo	=	nmro_unco_idntfccn_afldo
From	#tmpcontratoFode a, bdafiliacion..tbcontratos b
Where 	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto

Update  #tmpcontratoFode
Set	Codigo_Empleado		=	nmro_idntfccn
From	#tmpcontratoFode a, bdafiliacion..tbvinculados  b
Where 	a.nui_afldo	=	b.nmro_unco_idntfccn


select	   LTRIM(RTRIM(CONVERT(CHAR(13),0)))+';'+  
 LTRIM(RTRIM(CONVERT(CHAR(13),0)))+';'+  
 LTRIM(RTRIM(CONVERT(CHAR(13),'I')))+';'+  
        LTRIM(RTRIM(CONVERT(CHAR(13),Codigo_Empleado)))+';'+   --Codigo_Empleado,
		LTRIM(RTRIM(CONVERT(CHAR(15),Codigo_Concepto)))+';'+   --Codigo_Concepto,
		LTRIM(RTRIM(CONVERT(CHAR(15),Fecha_Ocurrencia)))+';'+  --Fecha_Ocurrencia, 
		LTRIM(RTRIM(CONVERT(CHAR(15),Fecha_Liquidacion)))+';'+ --Fecha_Liquidacion,
		LTRIM(RTRIM(CONVERT(CHAR(15),Valor_Novedad)))  campos  -- Valor_Novedad
into #tmpcontratoXCedula
from #tmpcontratoFode
Group by Codigo_Empleado, Codigo_Concepto, Fecha_Ocurrencia, Fecha_Liquidacion, Valor_Novedad

select * from #tmpcontratoXCedula

