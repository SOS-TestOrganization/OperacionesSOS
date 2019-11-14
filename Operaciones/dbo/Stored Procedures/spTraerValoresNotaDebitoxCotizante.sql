
/*---------------------------------------------------------------------------------
* Metodo o PRG 			: spTraerValoresNotaDebitoxCotizante
* Desarrollado por		: <\A Ing. FERNANDO VALENCIA E								A\>
* Descripcion			: <\D Este procedimiento realiza una Consulta de las notas debito por cotizante  	D\>
* Observaciones			: <\O  											O\>
* Parametros			: <\P 											P\>
* Variables			: <\V  											V\>
* Fecha Creacion		: <\FC 2007/05/11 									FC\>
**/

CREATE  PROCEDURE spTraerValoresNotaDebitoxCotizante
	@cnsctvo_dcmnto			udtConsecutivo	=	NULL,
	@cnsctvo_cdgo_tpo_dcmnto	udtConsecutivo	=	NULL




AS
set nocount on	
Select 	space(3)  		tpo_idntfccn_coti,
        space(15)  		nmro_idntfccn_coti,
	space(50)		nmbre_coti,
	space(50)		dscrpcn_prntsco,
	0			cnsctvo_cdgo_prntsco,
	0 			nmro_unco_idntfccn,
	b.nmro_cntrto,
	b.cnsctvo_cdgo_tpo_cntrto,
        a.vlr_nta,
	a.vlr_iva,
	a.vlr_nta+a.vlr_iva  total
into	#tmpCotiValores
From	tbNotasPac 	a, 	tbNotasContrato b
where 	a.nmro_nta=b.nmro_nta
and 	b.cnsctvo_nta_cntrto=@cnsctvo_dcmnto
and     a.cnsctvo_cdgo_tpo_nta=1 


update  #tmpCotiValores
set 	nmro_unco_idntfccn=nmro_unco_idntfccn_afldo
from 	#tmpCotiValores a, bdAfiliacion.dbo.tbContratos b
where  	a.nmro_cntrto=b.nmro_cntrto
and 	a.cnsctvo_cdgo_tpo_cntrto=b.cnsctvo_cdgo_tpo_cntrto

update #tmpCotiValores
set 	tpo_idntfccn_coti = c.cdgo_tpo_idntfccn,
	nmro_idntfccn_coti= b.nmro_idntfccn
from    #tmpCotiValores a,  bdAfiliacion.dbo.tbVinculados b,  bdAfiliacion.dbo.tbTiposIdentificacion c
where   a.nmro_unco_idntfccn=b.nmro_unco_idntfccn
and     b.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn

update #tmpCotiValores
set 	nmbre_coti= ltrim(rtrim(b.prmr_nmbre))+' '+ltrim(rtrim(b.sgndo_nmbre))+' '+ltrim(rtrim(prmr_aplldo))+ ' '+ltrim(rtrim(sgndo_aplldo))
from    #tmpCotiValores a,  bdAfiliacion.dbo.tbPersonas b
where   a.nmro_unco_idntfccn=b.nmro_unco_idntfccn


update #tmpCotiValores
set 	cnsctvo_cdgo_prntsco=b.cnsctvo_cdgo_prntsco 
from    #tmpCotiValores a,  bdAfiliacion.dbo.tbBeneficiarios b
where   a.nmro_unco_idntfccn=b.nmro_unco_idntfccn_bnfcro

update #tmpCotiValores 
set 	dscrpcn_prntsco= b.dscrpcn_prntsco
from    #tmpCotiValores a,  bdAfiliacion.dbo.tbParentescos b
where   a.cnsctvo_cdgo_prntsco=b.cnsctvo_cdgo_prntscs

Select  tpo_idntfccn_coti,
	nmro_idntfccn_coti,
	nmbre_coti,
	dscrpcn_prntsco,
	vlr_nta, 
	vlr_iva,
	total
From 	#tmpCotiValores

