
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   spTraerCamposCriterioMejorado 
* Desarrollado por		 :  <\A    Ing. Francisco J Gonzalez R									A\>
* Descripcion			 :  <\D  Recupera de la base de datos un cursor con los campos criterio dependiendo del parámetro opcion D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Opcion desde la cual se llama la clase								P\>
*				 :  <\P													P\>
* Fecha Creacion		 :  <\FC  2005/03/03											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE spTraerCamposCriterioMejorado

@lcOpcion char(10),
@ldFechaReferencia Datetime = Null


AS 

Set Nocount On 

If @ldFechaReferencia is null 
	Set @ldFechaReferencia = GetDate()


Select 	c.nmbre_sp_ejcn,	a.ordn_cmps,			e.dscrpcn_crtro_cnslta,
	d.nmbre_sp_prmtro,	d.prmtrs_sp,		d.clse_lgca,		
	d.tpo_dts,		d.lngtd_cmpo,		d.dscrpcn_cmpo_cnslta,
	d.nmbre_cmpo_cdgo,	d.nmbre_cmpo_cnsctvo,	d.nmbre_cmpo_dscrpcn,	
	d.nmro_crctrs_dscrpcn,	d.nmbrs_clmns_grd,	d.dscrpcn_bsqda,
	d.tpo_aplccn,		d.nmbre_cmpo_prncpl,	d.envr_cmo_prmtro,
	d.ordn_prmtro_adcnl,
	c.tpo_cnxn, 
	c.prmtrs_adcnls
	
From 	bdSeguridad.dbo.tbDetOpcionesxModulo b,
	bdcarteraPac.dbo.tbCriteriosConsultaxOpcion_Vigencias c, 
	bdcarteraPac.dbo.tbCampoConsultaxCriterioConsultas_Vigencias a,
	bdcarteraPac.dbo.tbCamposConsultas_Vigencias d,
	bdcarteraPac.dbo.tbCriteriosConsultas e
Where  	b.cdgo_opcn			= @lcOpcion
And	b.cnsctvo_cdgo_opcn		= c.cnsctvo_cdgo_opcn
And	(Convert(char(10),@ldFechaReferencia,111)  between Convert(char(10),c.inco_vgnca,111)  And    Convert(char(10),c.fn_vgnca,111) )
And 	c.cnsctvo_cdgo_crtro_cnslta	= a.cnsctvo_cdgo_crtro_cnslta
And	(Convert(char(10),@ldFechaReferencia,111)  between Convert(char(10),a.inco_vgnca,111)  And    Convert(char(10),a.fn_vgnca,111) )
And	a.cnsctvo_cdgo_cnslta_cmpo	= d.cnsctvo_cdgo_cmpo_cnslta
And	(Convert(char(10),@ldFechaReferencia,111)  between Convert(char(10),d.inco_vgnca,111)  And    Convert(char(10),d.fn_vgnca,111) )
And	d.vsble_usro			= 'S'
And	c.cnsctvo_cdgo_crtro_cnslta	= e.cnsctvo_cdgo_crtro_cnslta
Order By a.ordn_cmps

