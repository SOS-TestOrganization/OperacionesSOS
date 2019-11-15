
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spQuitarclaseaportante
* Desarrollado por		: <\A Ing. FERNANDO VALENCIA ECHEVEERY								A\>
* Descripcion			: <\D Este procedimiento realiza la consulta del pago a borrar						  	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/05/03 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM  Ing. Diana Lorena Gomez Betancourt AM\>
* Descripcion			 : <\DM  Se cambio el cnsctvo_incdnca por un identity , por eso no se debe enviar en el insert 
                           Tambien se agrego el @nmro_pgo cuando se inserta en la tabla de tbincidenciascarterapac
													 ya que se enviaba en cero , a la final no se sabia cual registro habia sido modificado DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM  2008/06/13 FM\>
*---------------------------------------------------------------------------------*/

CREATE  PROCEDURE spQuitarclaseaportante
@nmro_pgo	udtConsecutivo,
@lgn_usro	udtUsuario

As  declare 			
@cnsctvo_incdnca 		int, 
@cnsctvo_scrsl			int,
@cnsctvo_cdgo_clse_aprtnte 	int,
@nmro_unco_idntfccn_empldr	int

set nocount on		

begin tran


select cnsctvo_scrsl, cnsctvo_cdgo_clse_aprtnte, nmro_unco_idntfccn_empldr
into #tmp1
from  bdcarteraPac.dbo.tbPagos 
where cnsctvo_cdgo_pgo=@nmro_pgo

Select 	@cnsctvo_scrsl =  isnull(cnsctvo_scrsl,0)	 
From	#tmp1

Select 	@cnsctvo_cdgo_clse_aprtnte =  isnull(cnsctvo_cdgo_clse_aprtnte,0)	 
From	#tmp1 

Select 	@nmro_unco_idntfccn_empldr =  isnull(nmro_unco_idntfccn_empldr,0)	 
From	#tmp1



update bdcarteraPac.dbo.tbPagos 
set 	nmro_unco_idntfccn_empldr =0,
    	cnsctvo_scrsl = 0,
    	cnsctvo_cdgo_clse_aprtnte = 0
where  cnsctvo_cdgo_pgo= @nmro_pgo

If @@ROWCOUNT = 1
	commit tran
else
	rollback	

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


insert  into bdCarteraPac.dbo.tbIncidenciasCarteraPac
( bse_dts, nmbre_tbla, nmbre_cmpo, cnsctvo_vgnca, vlr_antrr, vlr_nvo, usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo)
values('bdCarteraPac','tbPagos','cnsctvo_scrsl', 0,@cnsctvo_scrsl, 0,@lgn_usro,getdate(),@nmro_pgo)

insert  into bdCarteraPac.dbo.tbIncidenciasCarteraPac
( bse_dts, nmbre_tbla, nmbre_cmpo, cnsctvo_vgnca, vlr_antrr, vlr_nvo, usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo)
values('bdCarteraPac','tbPagos','cnsctvo_cdgo_clse_aprtnte', 0,@cnsctvo_cdgo_clse_aprtnte, 0,@lgn_usro,getdate(),@nmro_pgo)

insert  into bdCarteraPac.dbo.tbIncidenciasCarteraPac
( bse_dts, nmbre_tbla, nmbre_cmpo, cnsctvo_vgnca, vlr_antrr, vlr_nvo, usro_incdnca, fcha_incdnca, cnsctvo_rgstro_afctdo)
values('bdCarteraPac','tbPagos','nmro_unco_idntfccn_empldr', 0,@nmro_unco_idntfccn_empldr, 0,@lgn_usro,getdate(),@nmro_pgo)

select * from #tmp_pago

