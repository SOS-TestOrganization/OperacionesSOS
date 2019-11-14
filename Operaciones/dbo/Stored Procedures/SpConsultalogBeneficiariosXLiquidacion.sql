
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: SpConsultalogBeneficiariosXLiquidacion
* Desarrollado por		: <\A Ing. Rolando simbaqueva Lasso									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2003/02/10											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 	AM\>
* Descripcion			 : <\DM   Aplicacion de tecnicas de optimizacionDM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   06/09/2005				FM\>
*---------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[SpConsultalogBeneficiariosXLiquidacion] @cnsctvo_cdgo_lqdcn	int
As

Set Nocount On


--drop table #tmpLogBeneficiarios
Create table #tmpLogBeneficiarios(
	nmro_unco_idntfccn_bnfcro	int,
	cnsctvo_cdgo_tpo_cntrto		int,
	nmro_cntrto			char(15),
	nmro_unco_idntfccn_empldr	int,	
	cnsctvo_scrsl			int,
	cnsctvo_cdgo_clse_aprtnte	int,
	cnsctvo_bnfcro			int,
	cnsctvo_cdgo_csa		int,
	Nmbre_Csa			varchar(100),
	Nui_cotizante			int,
	TI_cotizante			varchar(3),
	NI_cotizante			varchar(15),
	TI_Beneficiario			varchar(3),
	NI_Beneficiario			varchar(15),
	TI_Aportante			varchar(3),
	NI_Aportante			varchar(15),
	Nombre_Beneficiario		varchar(200),
	Nombre_Cotizante		varchar(200),
	Nombre_Aportante		varchar(200),
	inco_vgnca_bnfcro		datetime,
	fn_vgnca_bnfcro			datetime,
	Nombre_pln			varchar(50),
	cnsctvo_cdgo_pln		int,
	Responsable			varchar(24),
cnsctvo_cdgo_lqdcn int,
   GrupoActual int,   NombreGrupoActual varchar(500),
 ProductoActual int,  NombreProductoActual varchar(500),
 ModeloActual int,  NombreModeloActual  varchar(500),
 GrupoTarifasActual int,  NombreGrupoTarifasActual varchar(500),
   GrupoAnterior int ,  NombreGrupoAnterior varchar(500),
 ProductoAnterior int, NombreProductoAnterior varchar(500),
  ModeloAnterior int, NombreModeloAnterior varchar(500),
 GrupoTarifasAnterior int,  NombreGrupoTarifasAnterior varchar(500)
)
 
Insert Into #tmpLogBeneficiarios 
(
nmro_unco_idntfccn_bnfcro,
cnsctvo_cdgo_tpo_cntrto,
nmro_cntrto,
nmro_unco_idntfccn_empldr,
cnsctvo_scrsl,
cnsctvo_cdgo_clse_aprtnte,
cnsctvo_bnfcro,
cnsctvo_cdgo_csa,
Nmbre_Csa,
Nui_cotizante,
TI_cotizante,
NI_cotizante,
TI_Beneficiario,
NI_Beneficiario,
TI_Aportante,
NI_Aportante,
Nombre_Beneficiario,
Nombre_Cotizante,
Nombre_Aportante,
inco_vgnca_bnfcro,
fn_vgnca_bnfcro,
Nombre_pln,
cnsctvo_cdgo_pln,
Responsable,
cnsctvo_cdgo_lqdcn
)
Select  nmro_unco_idntfccn_bnfcro,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	nmro_unco_idntfccn_empldr,
	cnsctvo_scrsl,
	cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,
	cnsctvo_cdgo_csa,
	case 	 when cnsctvo_cdgo_csa	 =	1 then 'No Existe Vigencia Cuota del Beneficiario'
		 when cnsctvo_cdgo_csa	 =	2 then 'Vigencia 	Cuota del Bene no vigente para el periodo  a liquidar'
		 when cnsctvo_cdgo_csa	 =	3 then 'Beneficiario Duplicado' 	
		 when cnsctvo_cdgo_csa	 =	4 then 'Beneficiario Con Modelo Diferente al Plan' 	
		 when cnsctvo_cdgo_csa	 =	5 then 'Beneficiario Sin Producto' 	
		 when cnsctvo_cdgo_csa	 =	6 then 'Beneficiario Con Producto y Sin Modelo' 	
		 when cnsctvo_cdgo_csa	 =	7 then 'Igual Plan, difrente grupo modelo'
	Else 	'No Existe Causa' 	end   Nmbre_Csa,
	0			Nui_cotizante,
	space(3)	 	TI_cotizante,
	space(15)	 	NI_cotizante,
	Space(3)	 	TI_Beneficiario,
	Space(15)	 	NI_Beneficiario,
	Space(3)	 	TI_Aportante,
	Space(15)	 	NI_Aportante,
	Space(200)		Nombre_Beneficiario,
	Space(200)		Nombre_Cotizante,
	Space(200)		Nombre_Aportante,
	convert(datetime, NULL)	inco_vgnca_bnfcro,
	convert(datetime, NULL)	fn_vgnca_bnfcro,
	Space(50)		Nombre_pln,
	0			cnsctvo_cdgo_pln,
	right(replicate('0',20)+ltrim(rtrim(nmro_unco_idntfccn_empldr)),20) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_scrsl)),2) + right(replicate('0',2)+ltrim(rtrim(cnsctvo_cdgo_clse_aprtnte)),2)	Responsable,
cnsctvo_cdgo_lqdcn
From 	tbCausasBeneficiariosxLiquidacion
Where 	cnsctvo_cdgo_lqdcn	= 	@cnsctvo_cdgo_lqdcn


---select max(cnsctvo_cdgo_lqdcn) from tbCausasBeneficiariosxLiquidacion 5308

Update #tmpLogBeneficiarios
Set	cnsctvo_cdgo_pln		=	b.cnsctvo_cdgo_pln,
	Nui_cotizante			=	b.nmro_unco_idntfccn_afldo	
From	#tmpLogBeneficiarios a Inner Join  bdafiliacion.dbo.tbcontratos b
On 	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 


Update 	#tmpLogBeneficiarios
Set	inco_vgnca_bnfcro		=	b.inco_vgnca_bnfcro,
	fn_vgnca_bnfcro			=	b.fn_vgnca_bnfcro
From	#tmpLogBeneficiarios a Inner Join bdafiliacion.dbo.tbbeneficiarios b
On 	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto 
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro


Update 	#tmpLogBeneficiarios
Set	Nombre_pln		=	dscrpcn_pln
From	#tmpLogBeneficiarios a Inner Join bdplanbeneficios.dbo.tbplanes b
On 	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln


Update 	#tmpLogBeneficiarios
Set	Nombre_pln		=	dscrpcn_pln
From	#tmpLogBeneficiarios a Inner Join bdplanbeneficios.dbo.tbplanes b
On 	a.cnsctvo_cdgo_pln	=	b.cnsctvo_cdgo_pln


Update	#tmpLogBeneficiarios
Set	NI_cotizante		=	b.nmro_idntfccn,
	TI_cotizante		=	c.cdgo_tpo_idntfccn
FROM	#tmpLogBeneficiarios a INNER JOIN  bdAfiliacion.dbo.tbVinculados b 
ON 	a.Nui_cotizante = b.nmro_unco_idntfccn 
	INNER JOIN bdAfiliacion.dbo.tbTiposIdentificacion c 
ON 	b.cnsctvo_cdgo_tpo_idntfccn = c.cnsctvo_cdgo_tpo_idntfccn


Update	#tmpLogBeneficiarios
Set	Nombre_Cotizante	=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpLogBeneficiarios a Inner Join bdafiliacion.dbo.tbPersonas b
On 	a.Nui_cotizante		=	b.nmro_unco_idntfccn


Update #tmpLogBeneficiarios
Set	NI_Beneficiario		=	b.nmro_idntfccn,
	TI_Beneficiario		=	c.cdgo_tpo_idntfccn
FROM	#tmpLogBeneficiarios a INNER JOIN bdAfiliacion.dbo.tbVinculados b 
ON 	a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn 
	INNER JOIN bdAfiliacion.dbo.tbTiposIdentificacion c 
ON 	b.cnsctvo_cdgo_tpo_idntfccn = c.cnsctvo_cdgo_tpo_idntfccn


Update #tmpLogBeneficiarios
Set	Nombre_Beneficiario		=	convert(varchar(50),ltrim(rtrim(prmr_aplldo)) + ' ' + ltrim(rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre)) + ' '  + ltrim(rtrim(sgndo_nmbre)))
From	#tmpLogBeneficiarios a inner join bdafiliacion.dbo.tbPersonas b
On 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn


Update #tmpLogBeneficiarios
Set	NI_Aportante			=	b.nmro_idntfccn,
	TI_Aportante			=	c.cdgo_tpo_idntfccn
FROM	#tmpLogBeneficiarios a INNER JOIN bdAfiliacion.dbo.tbVinculados b 
ON 	a.nmro_unco_idntfccn_empldr	= b.nmro_unco_idntfccn 
	INNER JOIN bdAfiliacion.dbo.tbTiposIdentificacion c 
ON 	b.cnsctvo_cdgo_tpo_idntfccn	= c.cnsctvo_cdgo_tpo_idntfccn


Update #tmpLogBeneficiarios
Set	Nombre_Aportante		=	ltrim(rtrim(nmbre_scrsl))
From	#tmpLogBeneficiarios a Inner Join bdafiliacion.dbo.tbsucursalesaportante b
On 	a.nmro_unco_idntfccn_empldr	=	b.nmro_unco_idntfccn_empldr
And	a.cnsctvo_scrsl			=	b.cnsctvo_scrsl
And	a.cnsctvo_cdgo_clse_aprtnte	=	b.cnsctvo_cdgo_clse_aprtnte
 

update #tmpLogBeneficiarios
set  GrupoActual = grupo,
ProductoActual = cnsctvo_prdcto,
ModeloActual = cnsctvo_mdlo,
GrupoTarifasActual = grupo_tarificacion
from #tmpLogBeneficiarios a inner join bdcarterapac.dbo.tbhistoricotarificacionxproceso b
on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
and a.nmro_cntrto = b.nmro_cntrto
and a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
and a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
/*
select b.*
from #tmpLogBeneficiarios a inner join bdcarterapac.dbo.tbhistoricotarificacionxproceso b
on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
and a.nmro_cntrto = b.nmro_cntrto
and a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
and a.cnsctvo_cdgo_lqdcn = b.cnsctvo_cdgo_lqdcn
*/


update #tmpLogBeneficiarios
set  GrupoAnterior = c.grupo,
ProductoAnterior = c.cnsctvo_prdcto,
ModeloAnterior = c.cnsctvo_mdlo,
GrupoTarifasAnterior = c.grupo_tarificacion
from #tmpLogBeneficiarios a inner join (
select max(b.cnsctvo_cdgo_lqdcn) cnsctvo_cdgo_lqdcn, b.nmro_cntrto, b.nmro_unco_idntfccn
from   #tmpLogBeneficiarios a inner join bdcarterapac.dbo.tbhistoricotarificacionxproceso b
on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
and a.nmro_cntrto = b.nmro_cntrto
and a.cnsctvo_bnfcro = b.cnsctvo_bnfcro
where b.vlr_upc != 0
group by  b.nmro_cntrto, b.nmro_unco_idntfccn ) b
on a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
and a.nmro_cntrto = b.nmro_cntrto
inner join   bdcarterapac.dbo.tbhistoricotarificacionxproceso  c
on b.nmro_cntrto = c.nmro_cntrto
and b.nmro_unco_idntfccn = c.nmro_unco_idntfccn
and b.cnsctvo_cdgo_lqdcn = c.cnsctvo_cdgo_lqdcn

 
update a
set  NombreGrupoActual = dscrpcn_dtlle_grpo  
from #tmpLogBeneficiarios a inner join bdafiliacion.dbo.tbdetgrupos dg
on a.GrupoActual = dg.cnsctvo_cdgo_dtlle_grpo

update #tmpLogBeneficiarios
set  NombreGrupoAnterior = dscrpcn_dtlle_grpo   
from #tmpLogBeneficiarios a inner join bdafiliacion.dbo.tbdetgrupos dg
on a.GrupoAnterior = dg.cnsctvo_cdgo_dtlle_grpo


update #tmpLogBeneficiarios
set  NombreGrupoTarifasActual = dscrpcn_grpo  
from #tmpLogBeneficiarios a inner join bdafiliacion.dbo.tbgrupos dg
on a.GrupoTarifasActual = dg.cnsctvo_cdgo_grpo

update #tmpLogBeneficiarios
set  NombreGrupoTarifasAnterior = dscrpcn_grpo  
from #tmpLogBeneficiarios a inner join bdafiliacion.dbo.tbgrupos dg
on a.GrupoTarifasAnterior = dg.cnsctvo_cdgo_grpo

update #tmpLogBeneficiarios
set  NombreProductoActual = dscrpcn_prdcto   
from #tmpLogBeneficiarios a inner join bdplanbeneficios.dbo.tbproductos dg
on a.ProductoActual = dg.cnsctvo_prdcto

update #tmpLogBeneficiarios
set  NombreProductoAnterior = dscrpcn_prdcto  
from #tmpLogBeneficiarios a inner join bdplanbeneficios.dbo.tbproductos dg
on a.ProductoAnterior = dg.cnsctvo_prdcto
 

update #tmpLogBeneficiarios
set  NombreModeloActual = dscrpcn_mdlo   
from #tmpLogBeneficiarios a inner join bdplanbeneficios.dbo.tbmodelos dg
on a.ModeloActual = dg.cnsctvo_mdlo

update #tmpLogBeneficiarios
set  NombreModeloAnterior = dscrpcn_mdlo 
from #tmpLogBeneficiarios a inner join bdplanbeneficios.dbo.tbmodelos dg
on a.ModeloAnterior = dg.cnsctvo_mdlo
 

 --select * from  bdplanbeneficios.dbo.tbmodelos 



Select	nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
	nmro_unco_idntfccn_empldr,	cnsctvo_scrsl,			cnsctvo_cdgo_clse_aprtnte,
	cnsctvo_bnfcro,			cnsctvo_cdgo_csa,		Nmbre_Csa,
	Nui_cotizante,			TI_cotizante,			NI_cotizante,
	TI_Beneficiario,		NI_Beneficiario,		TI_Aportante,
	NI_Aportante,			Nombre_Beneficiario,		Nombre_Cotizante,
	Nombre_Aportante,		inco_vgnca_bnfcro,		fn_vgnca_bnfcro,
	Nombre_pln,			cnsctvo_cdgo_pln,		Responsable,
   GrupoActual ,   NombreGrupoActual,
 ProductoActual,  NombreProductoActual,
 ModeloActual,  NombreModeloActual,
 GrupoTarifasActual,  NombreGrupoTarifasActual,
   GrupoAnterior ,  NombreGrupoAnterior,
 ProductoAnterior, NombreProductoAnterior,
  ModeloAnterior, NombreModeloAnterior,
 GrupoTarifasAnterior,  NombreGrupoTarifasAnterior

From #tmpLogBeneficiarios 
Order by Nombre_Aportante,Nombre_Cotizante,Nombre_Beneficiario

/*
   GrupoActual ,   NombreGrupoActual,
 ProductoActual,  NombreProductoActual,
 ModeloActual,  NombreModeloActual,
 GrupoTarifasActual,  NombreGrupoTarifasActual,
   GrupoAnterior ,  NombreGrupoAnterior,
 ProductoAnterior, NombreProductoAnterior,
  ModeloAnterior, NombreModeloAnterior,
 GrupoTarifasAnterior,  NombreGrupoTarifasAnterior,

*/