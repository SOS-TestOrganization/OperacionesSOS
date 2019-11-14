


/*--------------------------------------------------------------------------------- 
* Metodo o PRG 		: spEjecutaConsCertificados 
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\> 
* Descripcion			: <\D Este procedimiento para generar el reporte de la cartera por edades				 	D\> 
* Observaciones			: <\O  													O\> 
* Parametros			: <\P													P\> 
* Variables			: <\V  													V\> 
* Fecha Creacion		: <\FC 2003/02/10											FC\> 
* 
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------- 
* Modificado Por		: <\AM  Ing. Fernando Valencia E  AM\> 
* Descripcion			: <\DM  DM\> 
* Nuevos Parametros		: <\PM  PM\> 
* Nuevas Variables		: <\VM  VM\> 
* Fecha Modificacion		: <\FM  FM\> 

Quick 2013-001-008412 Sisdgb01 04/04/2013 Se ajusta agregando la validacion de que el estado de los EC sea diferente de 4 ANULADO

*---------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[spEjecutaConsCertificados]
 
As 
 
Declare 
@tbla			varchar(128), 
@cdgo_cmpo 		varchar(128), 
@oprdr 			varchar(2), 
@vlr 			varchar(250), 
@cmpo_rlcn 		varchar(128), 
@cmpo_rlcn_prmtro 	varchar(128), 
@cnsctvo		Numeric(4), 
@IcInstruccion		Nvarchar(4000), 
@IcInstruccion1		Nvarchar(4000), 
@IcInstruccion2		Nvarchar(4000), 
@lcAlias		char(2), 
@lnContador		Int, 
@nmro_rdcn_incl		Int, 
@nmro_rdcn_fnl		Int, 
@ldFechaSistema		Datetime, 
@Fecha_ini		datetime, 
@Fecha_fin		datetime, 
@Fcha_Crtro_incl	Datetime, 
@Fcha_Crtro_fnl		Datetime, 
@cdgo_tpo_idntfccn	Char(15), 
@nmro_idntfccn		Char(20),
@nuiResponsablePago int
 


Set Nocount On 

Select	@ldFechaSistema	=	Getdate() 
 -- Contador de condiciones 
Select @lnContador = 1 
 
  
--Se cruzan los contratos asociados a las sucursales y se traer las sucursales finales para liquidar 
 
 
Select 	@Fcha_Crtro_incl  	=	vlr+' 00:00:00'  
From 	 #tbCriteriosTmp 
Where 	cmpo_rlcn 		= 	'fcha_crcn'  
And	oprdr	           	= 	'>=' 
 
 
Select  @Fcha_Crtro_fnl 	=	vlr+' 23:59:59'  
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		= 	'fcha_crcn'  
And	oprdr	    		= 	'<=' 
 
 
Select 	@cdgo_tpo_idntfccn	 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'cdgo_tpo_idntfccn'  
 
Select 	@nmro_idntfccn		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_idntfccn'  
 
 
Select 	@nmro_rdcn_incl		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_rdcn'  
and 	oprdr			 = '>=' 
 
Select 	@nmro_rdcn_fnl		 =	vlr 
From 	#tbCriteriosTmp 
Where 	cmpo_rlcn 		 = 'nmro_rdcn'  
and 	oprdr			 =	'<=' 
 
  
Set  @nuiResponsablePago = (select v.nmro_unco_idntfccn
from bdafiliacion.dbo.tbVinculados v inner join bdafiliacion.dbo.tbTiposIdentificacion ti
on v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
where ltrim(rtrim(v.nmro_idntfccn)) = ltrim(rtrim(@nmro_idntfccn)) 
and ti.cdgo_tpo_idntfccn = ltrim(rtrim(@cdgo_tpo_idntfccn)) 	
and v.vldo = 'S')

 	
	

-- se crea la tabla temporal con la infromacion de las sucursales que s epuedan liquidar 
				 
			 
select  a.fcha_incl_prdo_lqdcn 	fcha_crcn,	b.cnsctvo_cdgo_prdo_lqdcn, 
	cnsctvo_cdgo_lqdcn 
into 	#tmpLiquidacionesFinalizadas 
from 	tbperiodosliquidacion_vigencias a, tbliquidaciones b 
Where   a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn 
And	b.cnsctvo_cdgo_estdo_lqdcn	=	3 
And a.fcha_incl_prdo_lqdcn between @Fcha_Crtro_incl and @Fcha_Crtro_fnl		 
      
				 
-- primero se hace para estados de cuenta 
Select  nmro_unco_idntfccn_empldr, 
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
     	cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, round((Vlr/1.1),0) as  vlr_abno_cta  , round((Vlr-Vlr/1.1),0) as  vlr_abno_iva, 
	0		cnsctvo_cdgo_pln, 
	0		nmro_unco_idntfccn_afldo, 
	0		nmro_unco_idntfccn_bnfcro, 
	b.fcha_crcn, 
	' ' pgo,---sera marcado para ver si pago o no	 
	'  ' tpo_dcmnto --sera marcado con el tipo de documento  
into    #tmpCertificadosAux	 
From 	Tbperiodosliquidacion_vigencias a, 
     	#tmpLiquidacionesFinalizadas 		b, 
     	Tbestadoscuenta 		c, 
     	Tbestadoscuentacontratos   	d, 
	tbCuentasContratosBeneficiarios f,  
     	Tbabonoscontrato  		e		 
where   1	=	2 
 
 
--Insterta registtos de los pagos realizados a estados de cuenta 
Insert	into	 #tmpCertificadosAux 
SELECT    DISTINCT 
	  nmro_unco_idntfccn_empldr, 
	  cnsctvo_scrsl, 
 	  cnsctvo_cdgo_clse_aprtnte, 
	  cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, round((f.Vlr/1.1),0) , round((f.Vlr-f.Vlr/1.1),0), 
	  0	cnsctvo_cdgo_pln, 
  	  0	nmro_unco_idntfccn_afldo, 
	  f.nmro_unco_idntfccn_bnfcro, 
	  b.fcha_crcn, 
	  ' ' pgo,  
	  'PD' tpo_dcmnto --P Pago 	 
FROM    	  #tmpLiquidacionesFinalizadas 		b
inner join       	  dbo.tbEstadosCuenta 			c
on 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
inner join      	  Tbestadoscuentacontratos   		d 
on 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
inner join  	  tbCuentasContratosBeneficiarios	f
on d.cnsctvo_estdo_cnta_cntrto	=	f.cnsctvo_estdo_cnta_cntrto
inner join      	  Tbabonoscontrato  			e
on d.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto  
Where  c.nmro_unco_idntfccn_empldr =  @nuiResponsablePago
and c.cnsctvo_cdgo_estdo_estdo_cnta != 4
 
 
----Inserta registros de los pagos realizados a las Notas  
Insert	into	 #tmpCertificadosAux 
 SELECT    DISTINCT 
	  nmro_unco_idntfccn_empldr, 
	  cnsctvo_scrsl, 
 	  cnsctvo_cdgo_clse_aprtnte, 
	  cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, round((vlr_nta_cta),0) , round((vlr_nta_iva),0), 
	  0	cnsctvo_cdgo_pln, 
  	  0	nmro_unco_idntfccn_afldo, 
	  0     nmro_unco_idntfccn_bnfcro, 
 	  c.fcha_crcn_nta, 
          ' ' pgo, 
	  'ND' tpo_dcmnto --Nota Debito 	 
FROM      TbnotasPac	 				      c
inner join      	  Tbnotascontrato		  		      d
on    c.nmro_nta			=	d.nmro_nta 
and c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta
inner join   	  TbAbonosNotasContrato  			      e
on  d.cnsctvo_nta_cntrto		=	e.cnsctvo_nta_cntrto
Where 	  c.nmro_unco_idntfccn_empldr	= @nuiResponsablePago	    
And	  Convert(varchar(10), c.fcha_crcn_nta,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And 	  d.cnsctvo_cdgo_tpo_nta		= 1 --Notas debito  			 
 
 
----- 
Insert	into	 #tmpCertificadosAux 
SELECT    DISTINCT 
 	  nmro_unco_idntfccn_empldr, 
	  cnsctvo_scrsl, 
 	  cnsctvo_cdgo_clse_aprtnte, 
	  cnsctvo_cdgo_tpo_cntrto ,nmro_cntrto, round((d.vlr)*(-1),0) , round((d.vlr_iva)*(-1),0), 
	  0	cnsctvo_cdgo_pln, 
  	  0	nmro_unco_idntfccn_afldo, 
	  0     nmro_unco_idntfccn_bnfcro, 
 	  c.fcha_crcn_nta, 
          ' ' pgo, 
	  'NC' tpo_dcmnto --Nota Credito 
FROM      TbnotasPac	 				      c
inner join      	  Tbnotascontrato		  		      d 
on c.nmro_nta				=	d.nmro_nta 
and c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta
Where 	  c.nmro_unco_idntfccn_empldr		=	 @nuiResponsablePago	       
And	  Convert(varchar(10), c.fcha_crcn_nta,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And 	 c.cnsctvo_cdgo_tpo_nta			= 2 --Notas Credito	 
and 	  c.cnsctvo_cdgo_estdo_nta 		= 4 --Aplicadas  		 
		 		 
		 
  
update #tmpCertificadosAux 
set pgo='S' 
from #tmpCertificadosAux where vlr_abno_cta > 0 
						 
		   			 
Update  #tbCriteriostmp 
Set	tbla		=	' #tmpLiquidacionesFinalizadas' 
Where cdgo_cmpo		=	'fcha_crcn' 
 
				   			 
---Se actualiza el codigo del plan  
 
update  #tmpCertificadosAux 
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo 
From	#tmpCertificadosAux a, bdafiliacion..tbcontratos b 
where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			=	b.nmro_cntrto 
 
 
 
 
---Se agrupan por contrato y plan 
Select   nmro_unco_idntfccn_afldo, 
	 cnsctvo_cdgo_tpo_cntrto, 
       	 nmro_cntrto, 
	 cnsctvo_cdgo_pln 
into  	  #tmpContratosPac 
From      #tmpCertificadosAux 
group by nmro_unco_idntfccn_afldo , 
	 cnsctvo_cdgo_tpo_cntrto, 
	 nmro_cntrto, 
	 cnsctvo_cdgo_pln 
 
---Se crea una tabla de beneficiarios 
select  a.nmro_unco_idntfccn_afldo ,b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_cdgo_prntsco ,  
	a.cnsctvo_cdgo_pln, 
	a.cnsctvo_cdgo_tpo_cntrto, 
	a.nmro_cntrto 
into    #tmpBeneficiarios 
from	#tmpContratosPac a, bdafiliacion..tbbeneficiarios b 
where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			=	b.nmro_cntrto 
And	b.cnsctvo_cdgo_prntsco 		!= 4 --Cotizante, Conygue    COLOCAR (1,2,3) 
And	(Convert(varchar(10), b.fn_vgnca_bnfcro,111)	>=  	Convert(varchar(10),@Fcha_Crtro_incl,111) ) 
And	(Convert(varchar(10), b.inco_vgnca_bnfcro,111)	<  	Convert(varchar(10),@Fcha_Crtro_Fnl,111) ) 
 
-------------------------------------------------------------- 
--Adecuaciones realizdas para el año 2007 sau 59924 
-------------------------------------------------------------- 
 
---Se crea una tabla con los beneficiarios hijos  
select  a.nmro_unco_idntfccn_afldo ,b.nmro_unco_idntfccn_bnfcro,	b.cnsctvo_cdgo_prntsco ,  
	a.cnsctvo_cdgo_pln, 
	a.cnsctvo_cdgo_tpo_cntrto, 
	a.nmro_cntrto, 
	b.cnsctvo_bnfcro, 
	0 cnsctvo_bnfcro_aux, 
	0 cantidad, 
	2 prsnta_pgs --no presenta pagos   
into    #tmpBeneficiariosHijos 
from	#tmpContratosPac a, bdafiliacion..tbbeneficiarios b 
where   a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			=	b.nmro_cntrto 
And	b.cnsctvo_cdgo_prntsco 		= 	4 
And	(Convert(varchar(10), b.fn_vgnca_bnfcro,111)	>=  	Convert(varchar(10),@Fcha_Crtro_incl,111) ) 
And	(Convert(varchar(10), b.inco_vgnca_bnfcro,111)	<  	Convert(varchar(10),@Fcha_Crtro_Fnl,111) ) 
 
 
--Se actualiza si tiene pagos--------------------  
 
update #tmpBeneficiariosHijos 
set prsnta_pgs=1 
from  #tmpBeneficiariosHijos a inner join #tmpCertificadosAux b 
on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro 
and pgo='S' 
----------------------------------------------- 
 
select *  
into #tmpBeneficiariosHijos_def 
from #tmpBeneficiariosHijos 
order by nmro_unco_idntfccn_afldo, prsnta_pgs, nmro_unco_idntfccn_bnfcro, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto asc  
------------------------------------------------------------------------- 
 
--se crea una estructura que contenga registros agrupados por nui 
select 	nmro_unco_idntfccn_afldo, IDENTITY(int, 1,1) AS ID_Num 
into 	 #afiliados  
from 	 #tmpBeneficiariosHijos_def 
group by nmro_unco_idntfccn_afldo 
 
 
--Se recalcula el cosncutivo de beneficiario 
declare @contador  int,  
	@contador2 int, 
	@nui	   int	 
select 	@contador = count(*) from   #afiliados 
 
set 	@contador2= 1 
 
while 	@contador2 <= @contador 
	 
   begin  
 
	select @nui=nmro_unco_idntfccn_afldo 
	From   	  #afiliados       
 	Where   ID_Num    		= @contador2     
 
	CREATE TABLE dbo. #tmpBeneficiariosHijos_aux ( 
	nmro_unco_idntfccn_afldo 	int NOT NULL , 
	nmro_unco_idntfccn_bnfcro 	int NOT NULL , 
	cnsctvo_cdgo_prntsco 		int NOT NULL , 
	cnsctvo_cdgo_pln 		int NOT NULL , 
	cnsctvo_cdgo_tpo_cntrto 	udtConsecutivo NOT NULL , 
	nmro_cntrto 			udtNumeroFormulario NOT NULL , 
	cnsctvo_axlr 			int IDENTITY(1,1)  
	) 
	insert into   #tmpBeneficiariosHijos_aux  
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
 
	select 	nmro_unco_idntfccn_afldo,  
		nmro_unco_idntfccn_bnfcro,  
		cnsctvo_cdgo_prntsco, 
		cnsctvo_cdgo_pln,  
		cnsctvo_cdgo_tpo_cntrto, nmro_cntrto  
	from     #tmpBeneficiariosHijos_def 
	where 	nmro_unco_idntfccn_afldo=@nui 
 
	update  #tmpBeneficiariosHijos_def 
	set cnsctvo_bnfcro_aux 		= cnsctvo_axlr 
	from  #tmpBeneficiariosHijos_def a  
	inner join  #tmpBeneficiariosHijos_aux b 
	on  a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn_afldo 
	and a.nmro_unco_idntfccn_bnfcro = 	b.nmro_unco_idntfccn_bnfcro 
	where a.nmro_unco_idntfccn_afldo=	@nui 
	set @contador2 =@contador2+1 
	drop table  #tmpBeneficiariosHijos_aux 
 
   end 
 
 
--para contar la cantidad de beneficiarios 
-------------------------------------------------------------------------------------------------------- 
select count(*) as cntdd_bnfcrs, nmro_unco_idntfccn_afldo, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto 
into #tmpCantidad 
from #tmpBeneficiariosHijos_def 
group by  nmro_unco_idntfccn_afldo, cnsctvo_cdgo_pln, cnsctvo_cdgo_tpo_cntrto, nmro_cntrto 
--------------------------------------------------------------------------------------------------------- 
 
update #tmpBeneficiariosHijos_Def 
set cantidad = cntdd_bnfcrs 
from #tmpBeneficiariosHijos_def a inner join #tmpCantidad b 
On 	a.nmro_unco_idntfccn_afldo	=b.nmro_unco_idntfccn_afldo 
And	a.cnsctvo_cdgo_pln		=b.cnsctvo_cdgo_pln 
And	a.cnsctvo_cdgo_tpo_cntrto	=b.cnsctvo_cdgo_tpo_cntrto 
And	a.nmro_cntrto			=b.nmro_cntrto 
 
---------------------20/02/2009 SISDGB01 --------------------------------- 
/*delete from #tmpBeneficiariosHijos_def 
where (cnsctvo_bnfcro_aux > 2 and prsnta_pgs=2) --Borra los mayoes del consecutivo 2 que no tiene pagos  */
--------------------------------------------------------------------------------------------------------- 
 
---se crea una tabal temporal para que guarde los registros que finalmetne se van a almecenar 
CREATE TABLE dbo. #tmpBeneficiariosHijos_aux1 ( 
nmro_unco_idntfccn_afldo 	int NOT NULL , 
nmro_unco_idntfccn_bnfcro 	int NOT NULL , 
cnsctvo_cdgo_prntsco 		int NOT NULL , 
cnsctvo_cdgo_pln 		int NOT NULL , 
cnsctvo_cdgo_tpo_cntrto 	udtConsecutivo NOT NULL , 
nmro_cntrto 			udtNumeroFormulario NOT NULL , 
) 
 
 
select 	@contador = count(*) from   #afiliados 
set 	@contador2= 1 
while 	@contador2 <= @contador 
   begin  
	select @nui=nmro_unco_idntfccn_afldo 
	From   	  #afiliados       
 	Where   ID_Num    		= @contador2     
	insert into  #tmpBeneficiariosHijos_aux1 
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
	select	---- Top 2 Para insertar solo los dos hijos que se necesita que salgan
 	nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto 
	from 	 #tmpBeneficiariosHijos_def 
	where 	nmro_unco_idntfccn_afldo=@nui 
	set @contador2 =@contador2+1 
   end 
 
--Se insertan los beneficiarios Hijos  
insert into  #tmpBeneficiarios 
	(nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto) 
 
select	nmro_unco_idntfccn_afldo,  
	nmro_unco_idntfccn_bnfcro,  
	cnsctvo_cdgo_prntsco, 
	cnsctvo_cdgo_pln,  
	cnsctvo_cdgo_tpo_cntrto,  
	nmro_cntrto 
from 	#tmpBeneficiariosHijos_aux1 
-- Se adiciona la linea solo para parentezcos cotizante , conyuge , compañero e hijos 
 
----------------------- 
 
update #tmpCertificadosAux 
set nmro_unco_idntfccn_bnfcro=nmro_unco_idntfccn_afldo 
from #tmpCertificadosAux 
where nmro_unco_idntfccn_bnfcro=0 
and tpo_dcmnto in ('NC','ND') 
 
/* 
select *  
into tmpCertificadosAux 
from #tmpCertificadosAux 
 
select *  
into tmpBeneficiarios 
from #tmpBeneficiarios 
*/ 
 
-- En un cursor meto los registros que necesito copiar despues del proximo borrado 
 
Select * 
into  #tmpCertificadosAux_1 
from #tmpCertificadosAux    
where tpo_dcmnto in ('NC','ND') 
 
 
Delete from  #tmpCertificadosAux 
From	     #tmpCertificadosAux 
Where 	     #tmpCertificadosAux.nmro_unco_idntfccn_bnfcro not in (Select nmro_unco_idntfccn_bnfcro from  #tmpBeneficiarios) 
 
 
insert into #tmpCertificadosAux 
select * from #tmpCertificadosAux_1 
 
 
drop table #tmpCertificadosAux_1 
 
 
 select nmro_unco_idntfccn_empldr, 
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
     	cnsctvo_cdgo_tpo_cntrto ,
			nmro_cntrto, 
			vlr_abno_cta  , 
			vlr_abno_iva, 
	cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_bnfcro, 
fcha_crcn, 
 pgo,
 tpo_dcmnto
into #tmpAgruparNotas
from #tmpCertificadosAux   
where tpo_dcmnto in ('NC','ND') 
group by  nmro_unco_idntfccn_empldr, 
	cnsctvo_scrsl, 
	cnsctvo_cdgo_clse_aprtnte, 
     	cnsctvo_cdgo_tpo_cntrto ,
			nmro_cntrto, 
			vlr_abno_cta  , 
			vlr_abno_iva, 
	cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_bnfcro, 
fcha_crcn, 
 pgo,
 tpo_dcmnto

 delete from #tmpCertificadosAux  where  tpo_dcmnto in ('NC','ND') 
 
 Insert into #tmpCertificadosAux   
  Select * from #tmpAgruparNotas
	
 
/*select * into tmpCertificadosAux 
from #tmpCertificadosAux 
 */
 
---Se agrupa por nui de beneficiario, parentesco y plan Beneficiario x Plan 
select   nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco ,  
	 cnsctvo_cdgo_pln, 
	 0	cantidad_bene 
into     #tmpBeneficiariosXPlan 
from	 #tmpBeneficiarios a 
Group by nmro_unco_idntfccn_afldo ,nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_prntsco ,  
	 cnsctvo_cdgo_pln 

 
----Se agrupan cotizantes x plan  
Select  cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_empldr, 
	Sum(vlr_abno_cta + vlr_abno_iva) Valor_total_plan 
into	 #tmpTotalCotizantePlan 
From	 #tmpCertificadosAux 
Group by cnsctvo_cdgo_pln, 
	nmro_unco_idntfccn_afldo, 
	nmro_unco_idntfccn_empldr 
 
Select  @Fecha_ini	=	min(fcha_crcn)  from  #tmpCertificadosAux 
Select  @Fecha_fin	=	max(fcha_crcn)  from  #tmpCertificadosAux 
 
 
Select  @Fecha_fin 	= 	Dateadd(month,1,@Fecha_fin) 
 
Select	@Fecha_fin	=	Dateadd(day,-1,Convert(varchar(6),bdRecaudos.dbo.fncalculaperiodo(@Fecha_fin))+'01') 
 
----Beneficairios x abonos  
select  a.cnsctvo_cdgo_pln, 
	a.nmro_unco_idntfccn_afldo, 
	a.nmro_unco_idntfccn_empldr, 
	a.Valor_total_plan, 
	space(3)	TI_coti, 
	space(15)	NI_coti, 
	space(100)	nombre_Coti, 
	space(3)	TI_bene, 
	space(15)	NI_bene, 
	space(100)	nombre_bene, 
	space(30)	dscrpcn_prntsco, 
	space(30)	dscrpcn_pln, 
	@Fecha_ini	Fecha_ini, 
	@Fecha_fin	Fecha_fin, 
	b.nmro_unco_idntfccn_bnfcro, 
	b.cnsctvo_cdgo_prntsco, 
	0	estado 
into 	 #tmpbeneficiariosXabonos 
from 	 #tmpTotalCotizantePlan a,   #tmpBeneficiariosXPlan b 
where   a.cnsctvo_cdgo_pln 		= b.cnsctvo_cdgo_pln 
and	a.nmro_unco_idntfccn_afldo	= b.nmro_unco_idntfccn_afldo 
 
----Se actualizan los datos de los beneficiarios x abonos  
Update 	 #tmpbeneficiariosXabonos 
Set	TI_coti		=	c.cdgo_tpo_idntfccn, 
	NI_coti		=	b.nmro_idntfccn 
From	 #tmpbeneficiariosXabonos a, bdafiliacion..tbvinculados  b , bdafiliacion..tbtiposidentificacion c 
where   a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn 
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn 
 
Update 	 #tmpbeneficiariosXabonos 
Set	TI_bene		=	c.cdgo_tpo_idntfccn, 
	NI_bene		=	b.nmro_idntfccn 
From	 #tmpbeneficiariosXabonos a, bdafiliacion..tbvinculados  b , bdafiliacion..tbtiposidentificacion c 
where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn 
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn 
 
Update  #tmpbeneficiariosXabonos 
Set	nombre_Coti	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))) 
From	 #tmpbeneficiariosXabonos a, bdafiliacion..tbPersonas b 
Where 	a.nmro_unco_idntfccn_afldo	=	b.nmro_unco_idntfccn 
 
Update  #tmpbeneficiariosXabonos 
Set	nombre_bene	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre))) 
From	 #tmpbeneficiariosXabonos a, bdafiliacion..tbPersonas b 
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn 
 
Update  #tmpbeneficiariosXabonos 
Set	dscrpcn_prntsco	=	b.dscrpcn_prntsco 
From	 #tmpbeneficiariosXabonos a, bdafiliacion..tbparentescos b 
Where 	a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs 
 
 
Update  #tmpbeneficiariosXabonos 
Set	dscrpcn_pln		=	b.dscrpcn_pln 
From	 #tmpbeneficiariosXabonos a, bdplanbeneficios..tbplanes b 
Where 	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln 
 
 
update  #tmpbeneficiariosXabonos 
set	estado = 1 
--where   cnsctvo_cdgo_prntsco in (1,2,3,4)  --- VOLVER A COLOCAR PARA CONDICION DE QUE SALGAN SOLO DOS HIJOS
 
 
select  0 nmro_rdcn, 
	TI_coti, 
	NI_coti, 
	nombre_Coti, 
	convert(varchar(10),Fecha_ini,111)	Fecha_ini, 
	convert(varchar(10),Fecha_fin,111)	Fecha_fin, 
        convert(int,Valor_total_plan)		Valor_total_plan, 
        TI_bene, 
	NI_bene, 
        nombre_bene, 
        dscrpcn_prntsco, 
        dscrpcn_pln, 
	cnsctvo_cdgo_pln, 
	right(replicate('0',20)+ltrim(rtrim(NI_coti)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_pln)),2) 	AfiliadoPlan 
Into	#tmpbeneficiariosXabonosFinal 
From 	#tmpbeneficiariosXabonos  
Where 	estado = 1 
 
--select *  into tmpbeneficiariosXabonos 
--from #tmpbeneficiariosXabonos 
 
 
delete #tmpbeneficiariosXabonosFinal 
where valor_total_plan <= 0 
 
------------------Para el numero de radicación del Centro de documentación---------------- 
 
select  ti_coti, ni_coti, cnsctvo_cdgo_pln, 0 as nmro_rdcn, IDENTITY(int, 1,1) as cnsctvo   
into #tmpConsecutivoRadicacion 
from #tmpbeneficiariosXabonosFinal  
group by ti_coti, ni_coti, cnsctvo_cdgo_pln 
 
create table #tmpconsecutivos ( 
nmro_rdcn int, 
cnsctvo	  int IDENTITY)	 
 
 
--set @nmro_rdcn_incl=@nmro_rdcn_incl-1 
 
while 	@nmro_rdcn_incl <= @nmro_rdcn_fnl 
   begin  
	insert into #tmpconsecutivos 
	(nmro_rdcn) 
	values  
	(@nmro_rdcn_incl) 
	set @nmro_rdcn_incl =@nmro_rdcn_incl+1 
   end 
 
 
Update  #tmpConsecutivoRadicacion 
Set	nmro_rdcn	=	b.nmro_rdcn 
From	#tmpConsecutivoRadicacion a, dbo.#tmpconsecutivos b 
Where 	a.cnsctvo	=	b.cnsctvo 
 
 
Update  #tmpbeneficiariosXabonosFinal 
Set	nmro_rdcn	=	b.nmro_rdcn 
From	#tmpbeneficiariosXabonosFinal a, dbo.#tmpConsecutivoRadicacion b 
Where 	a.ti_coti	=	b.ti_coti 
and 	a.ni_coti	=	b.ni_coti	 
and	a.cnsctvo_cdgo_pln=	b.cnsctvo_cdgo_pln 
 
------------------------------------------- 
--select  *  
--into tmpConsecutivoRadicacion 
--from #tmpConsecutivoRadicacion  
 
--select  * 
--into tmpbeneficiariosXabonosFinal 
--from  #tmpbeneficiariosXabonosFinal 
--where valor_total_plan > 0 
--order by TI_coti, NI_coti, dscrpcn_pln 
------------------------------------------ ---------------------------------------------------------------------------------------------
  /*MODIFICACION PARA REALIZAR LA SUMATORIA CORRECTAMENTE */
----------------------------------------------------------------------------------------------------------------------------------------

--- Se seleccionan los pagos que se han recibido para los estados de cuenta generados dentro del periodo digitado por el usuario 
SELECT    DISTINCT 
c.nmro_unco_idntfccn_empldr, 
d.cnsctvo_cdgo_tpo_cntrto ,
d.nmro_cntrto, 
sum(e.vlr_abno_cta) vlr_cnta, 
sum(e.vlr_abno_iva)vlr_iva, 
sum(e.vlr_abno_cta + e.vlr_abno_iva) ttl_pgo,
ct.cnsctvo_cdgo_pln, 
ct.nmro_unco_idntfccn_afldo 
into #PagosRealizados
FROM    	  #tmpLiquidacionesFinalizadas 		b
inner join       	  dbo.tbEstadosCuenta 			c
on 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
inner join      	  Tbestadoscuentacontratos   		d 
on 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
inner join      	  Tbabonoscontrato  			e
on d.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto  
inner join bdafiliacion.dbo.tbContratos ct
on d.nmro_cntrto = ct.nmro_cntrto
and d.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
Where  c.nmro_unco_idntfccn_empldr =  @nuiResponsablePago	   
group by c.nmro_unco_idntfccn_empldr, 
d.cnsctvo_cdgo_tpo_cntrto ,
d.nmro_cntrto,
 ct.cnsctvo_cdgo_pln, 
ct.nmro_unco_idntfccn_afldo 
 
 
 -- Se buscan las notas debito creadas dentro del rango de fechas digitado por el usuario segun el responsable de pago
  SELECT    DISTINCT 
	  c.nmro_unco_idntfccn_empldr, 
	  c.cnsctvo_scrsl, 
 	  c.cnsctvo_cdgo_clse_aprtnte, 
	  d.cnsctvo_cdgo_tpo_cntrto ,
		d.nmro_cntrto, 
		sum(e.vlr_nta_cta) vlr_nta_cta , 
		sum(e.vlr_nta_iva) vlr_nta_iva, 
		sum(e.vlr_nta_cta + e.vlr_nta_iva ) ttl_nd,
	  ct.cnsctvo_cdgo_pln, 
  	ct.nmro_unco_idntfccn_afldo
INTO #tmpNotasDebitos
FROM      TbnotasPac	 				      c
inner join      	  Tbnotascontrato		  		      d
on    c.nmro_nta			=	d.nmro_nta 
and c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta
inner join   	  TbAbonosNotasContrato  			      e
on  d.cnsctvo_nta_cntrto		=	e.cnsctvo_nta_cntrto
inner join bdafiliacion.dbo.tbContratos ct
on d.nmro_cntrto = ct.nmro_cntrto
and d.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
Where 	  c.nmro_unco_idntfccn_empldr	= @nuiResponsablePago	       
And	  Convert(varchar(10), c.fcha_crcn_nta,111) between Convert(varchar(10),@Fcha_Crtro_incl,111) And Convert(varchar(10),@Fcha_Crtro_Fnl,111) 
And 	  d.cnsctvo_cdgo_tpo_nta		= 1 --Notas debito  		
group by c.nmro_unco_idntfccn_empldr, 
	  c.cnsctvo_scrsl, 
 	  c.cnsctvo_cdgo_clse_aprtnte, 
	  d.cnsctvo_cdgo_tpo_cntrto ,
		d.nmro_cntrto, 
	  ct.cnsctvo_cdgo_pln, 
  	ct.nmro_unco_idntfccn_afldo
 

--- Se buscan las notas credito de impuestos aplicadas a los estados de cuenta generados para los empleadores, no requiere que tenga pago en ese estado de cuenta.
SELECT    DISTINCT 
	c.nmro_unco_idntfccn_empldr, 
	  c.cnsctvo_scrsl, 
 	  c.cnsctvo_cdgo_clse_aprtnte, 
	  d.cnsctvo_cdgo_tpo_cntrto ,
		d.nmro_cntrto, 
		sum(d.vlr) vlr_nci , 
		sum(d.vlr_iva) vlr_iva_nci, 
		sum(d.vlr + d.vlr_iva) ttl_nci,
	  ct.cnsctvo_cdgo_pln, 
  	ct.nmro_unco_idntfccn_afldo
INTO	#tmpNCI 
FROM      TbnotasPac	 				      c
inner join      	  Tbnotascontrato		  		      d 
on c.nmro_nta				=	d.nmro_nta 
and c.cnsctvo_cdgo_tpo_nta = d.cnsctvo_cdgo_tpo_nta
inner join bdafiliacion.dbo.tbContratos ct
on d.nmro_cntrto = ct.nmro_cntrto
and d.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
Where 	  c.nmro_unco_idntfccn_empldr		=	 @nuiResponsablePago	    	       
And d.cnsctvo_estdo_cnta_cntrto in (SELECT    
d.cnsctvo_estdo_cnta_cntrto
FROM    	  #tmpLiquidacionesFinalizadas 		b
inner join       	  dbo.tbEstadosCuenta 			c
on 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
inner join      	  Tbestadoscuentacontratos   		d 
on 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
Where  c.nmro_unco_idntfccn_empldr =  @nuiResponsablePago	
group by d.cnsctvo_estdo_cnta_cntrto
)
And 	 c.cnsctvo_cdgo_tpo_nta			= 4 --Notas Credito	Impuestos
and 	  c.cnsctvo_cdgo_estdo_nta 		= 4 --Aplicadas  		 
group by 	c.nmro_unco_idntfccn_empldr, 
	  c.cnsctvo_scrsl, 
 	  c.cnsctvo_cdgo_clse_aprtnte, 
	  d.cnsctvo_cdgo_tpo_cntrto ,
		d.nmro_cntrto, 
			  ct.cnsctvo_cdgo_pln, 
  	ct.nmro_unco_idntfccn_afldo

--- Se crea una tabla donde se van a guardar los datos consolidados por contrato sobre los pagos y notas

SELECT    DISTINCT 
c.nmro_unco_idntfccn_empldr, 
d.cnsctvo_cdgo_tpo_cntrto ,
d.nmro_cntrto, 
ct.cnsctvo_cdgo_pln, 
ct.nmro_unco_idntfccn_afldo ,
v.nmro_idntfccn,
ti.cdgo_tpo_idntfccn,
0 ttl_nci,
0 ttl_nd,
0 ttl_pgs,
0 ttl_fnl
into #TotalPorAfiliado
FROM    	  #tmpLiquidacionesFinalizadas 		b
inner join       	  dbo.tbEstadosCuenta 			c
on 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
inner join      	  Tbestadoscuentacontratos   		d 
on 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
inner join bdafiliacion.dbo.tbContratos ct
on d.nmro_cntrto = ct.nmro_cntrto
and d.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
inner join bdafiliacion.dbo.tbVinculados v
on ct.nmro_unco_idntfccn_afldo = v.nmro_unco_idntfccn
inner join bdafiliacion.dbo.tbTiposIdentificacion ti
on ti.cnsctvo_cdgo_tpo_idntfccn = v.cnsctvo_cdgo_tpo_idntfccn
Where  c.nmro_unco_idntfccn_empldr =  @nuiResponsablePago	    
group by c.nmro_unco_idntfccn_empldr, 
d.cnsctvo_cdgo_tpo_cntrto ,
d.nmro_cntrto,
 ct.cnsctvo_cdgo_pln, 
ct.nmro_unco_idntfccn_afldo ,
v.nmro_idntfccn,
ti.cdgo_tpo_idntfccn
	
-- Se actualiza el total de pagos para el contrato 
	update ta
	set  ta.ttl_pgs = p.ttl_pgo
	from  #TotalPorAfiliado ta
	inner join  #PagosRealizados p
	on ta.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn_empldr
	and ta.nmro_unco_idntfccn_afldo = p.nmro_unco_idntfccn_afldo
	where ta.nmro_cntrto = p.nmro_cntrto
	and ta.cnsctvo_cdgo_tpo_cntrto = p.cnsctvo_cdgo_tpo_cntrto

-- se actualiza el total de notas debito para el contrato
	update ta
	set  ta.ttl_nd = p.ttl_nd
	from  #TotalPorAfiliado ta
	inner join   #tmpNotasDebitos p
	on ta.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn_empldr
	and ta.nmro_unco_idntfccn_afldo = p.nmro_unco_idntfccn_afldo
	where ta.nmro_cntrto = p.nmro_cntrto
	and ta.cnsctvo_cdgo_tpo_cntrto = p.cnsctvo_cdgo_tpo_cntrto

-- Se actualiza el total de notas credito de impuestos para el contrato
	update ta
	set  ta.ttl_nci = p.ttl_nci
	from  #TotalPorAfiliado ta
	inner join   #tmpNCI p
	on ta.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn_empldr
	and ta.nmro_unco_idntfccn_afldo = p.nmro_unco_idntfccn_afldo
	where ta.nmro_cntrto = p.nmro_cntrto
	and ta.cnsctvo_cdgo_tpo_cntrto = p.cnsctvo_cdgo_tpo_cntrto
	
	-- Se actualiza el total sumando los pagos, notas debito mas notas credito de impuestos
update #TotalPorAfiliado
set ttl_fnl = ttl_pgs + ttl_nd + ttl_nci 


-- Se actualiza segun codigo del plan el total, ya que una persona puede tener dos contratos diferentes ej: dos contratos plan familiar.
		
update #tmpbeneficiariosXabonosFinal 
set valor_total_plan = ttl_fnl
from 	#tmpbeneficiariosXabonosFinal f  inner join (select sum(ttl_fnl) ttl_fnl, cnsctvo_cdgo_pln,cdgo_tpo_idntfccn, nmro_idntfccn 
																			from 			#TotalPorAfiliado ta
																			group by cnsctvo_cdgo_pln,cdgo_tpo_idntfccn, nmro_idntfccn ) det
on f.cnsctvo_cdgo_pln = det.cnsctvo_cdgo_pln
 and ltrim(rtrim(f.TI_coti)) = ltrim(rtrim(det.cdgo_tpo_idntfccn))
 and ltrim(rtrim(f.NI_coti)) = ltrim(rtrim(det.nmro_idntfccn))
----------------------------------------- FIN MODIFICACION SUMATORIA---------------------------------------------------------------------


Select  * 
from  #tmpbeneficiariosXabonosFinal 
where valor_total_plan > 0 
order by nmro_rdcn, TI_coti, NI_coti, dscrpcn_pln 
--order by TI_coti, NI_coti, dscrpcn_pln


