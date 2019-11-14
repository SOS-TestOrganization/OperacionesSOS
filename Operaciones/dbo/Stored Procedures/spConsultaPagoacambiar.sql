/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaPagoaeliminar
* Desarrollado por		: <\A Ing. FERNANDO VALENCIA ECHEVEERY								A\>
* Descripcion			: <\D Este procedimiento realiza la consulta del pago a borrar						  	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/05/03 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/

CREATE  PROCEDURE spConsultaPagoacambiar
@nmro_pgo	udtConsecutivo

As  			

set nocount on		

select a.cnsctvo_cdgo_pgo, a.fcha_crcn, a.nmro_dcmnto, a.vlr_dcmnto, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte, a.nmro_unco_idntfccn_empldr, a.cnsctvo_cdgo_estdo_pgo, b.dscrpcn_clse_aprtnte,  space(200) as rzn_scl,
         space(3) as tpo_idntfccn, space(13) as nmro_idntfccn	
into #tmp_pago
from  bdcarteraPac.dbo.tbPagos a inner join bdAfiliacion.dbo.tbClasesAportantes b
on a.cnsctvo_cdgo_pgo=@nmro_pgo
and a.cnsctvo_cdgo_clse_aprtnte=b.cnsctvo_cdgo_clse_aprtnte


update #tmp_pago
set rzn_scl=ltrim(rtrim(a.rzn_scl))
from bdAfiliacion.dbo.tbEmpresas a inner join #tmp_pago b
On  a.nmro_unco_idntfccn=b.nmro_unco_idntfccn_empldr


update #tmp_pago
set 	tpo_idntfccn	=c.cdgo_tpo_idntfccn,
	nmro_idntfccn	=b.nmro_idntfccn
from #tmp_pago a inner join  bdAfiliacion.dbo.tbVinculados b
on a.nmro_unco_idntfccn_empldr=b.nmro_unco_idntfccn
inner join    bdAfiliacion.dbo.tbtiposidentificacion c
On b.cnsctvo_cdgo_tpo_idntfccn= c.cnsctvo_cdgo_tpo_idntfccn

select * from #tmp_pago
