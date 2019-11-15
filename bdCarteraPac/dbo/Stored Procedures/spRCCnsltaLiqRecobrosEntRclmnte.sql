


/*---------------------------------------------------------------------------------
* Metodo o PRG 	                	:  spRCCnsltaLiqRecobrosEntRclmnte
* Desarrollado por		 	: <\A Ing. Flor Liliana Cobo T.							A\>
* Descripcion			  	: <\D 											D\>
* Observaciones		          		: <\O											O\>
* Parametros			  	: <\P 											P\>
* Variables			  	: <\V  											V\>
* Fecha Creacion	          		: <\FC 2005/06/28									FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  	AM\>
* Descripcion				: <\DM 		DM\>
* Nuevos Parametros			: <\PM  	PM\>
* Nuevas Variables			: <\VM  	VM\>
* Fecha Modificacion			: <\FM  	FM\>
*---------------------------------------------------------------------------------*/
/*
exec spRCCnsltaLiqRecobrosEntRclmnte 1
*/

CREATE procedure spRCCnsltaLiqRecobrosEntRclmnte
@cnsctvocdgoentddrclmnte		udtConsecutivo

		
AS
--Cod.Tipo Evento,Descripción Tipo Evento,No.Factura IPS,Fecha Atención,Id. Paciente,Nombre Paciente,Seleccionar

Declare @dFechaHoy datetime

Set Nocount On

BEGIN


	

Select 	z.cnsctvo_asccn_lqdcn,
	z.cnsctvo_gstn_rcbro,
	isnull(w.nmro_fctra_sos,space(0)) as nmro_fctra_sos,
	n.cdgo_entdd_rclmnte,n.dscrpcn_entdd_rclmnte,
	ltrim(rtrim(p.rzn_scl)) as entArecobrar,
	r.dscrpcn_nvl,
	convert(int,isnull(z.vlr_ttl_lqdccn,0)) as vlr_ttl_lqdccn,
	m.cnsctvo_cdgo_tpo_evnto_rcbro
	/*convert(char(10),z.fcha_ultma_mdfccn,111) as fcha_ultma_mdfccn,
	a.cnsctvo_cdgo_tpo_evnto_rcbro,m.cdgo_tpo_evnto_rcbro,m.dscrpcn_tpo_evnto_rcbro,
	a.cnsctvo_cdgo_tpo_idntfccn_pcnte,c.cdgo_tpo_idntfccn,a.nmro_fctra,a.nmro_rdccn_fctra,convert(int,a.vlr_fctra) as vlr_fctra,convert(char(10),a.fcha_fctra,111) as fcha_atncn,
	a.nmro_idntfccn_pcnte,a.nmro_unco_idntfccn_pcnte,
	a.cnsctvo_cdgo_entdd_rclmnte,
	a.nmro_unco_idntfccn_prstdr,o.rzn_scl,convert(int,q.vlr_lqddo) as vlr_lqddo,t.cnsctvo_cdgo_mdlo_lqdcn_rcbro,s.cdgo_mdlo_lqdcn_rcbro,convert(int,t.vlr_lqddo) as vlr_recobro*/
	 From   bdSISalud.dbo.tbasociacionmodliqrecobro z 
	inner join bdSISalud.dbo.tbGestionRecobro  a 
	on (z.cnsctvo_gstn_rcbro = a.cnsctvo_gstn_rcbro)
	inner join  bdSISalud.dbo.tbTipoEventoRecobro m
	on  (a.cnsctvo_cdgo_tpo_evnto_rcbro 	= 	m.cnsctvo_cdgo_tpo_evnto_rcbro)
	inner join bdSISalud.dbo.tbEntidadReclamante n
	on  (a.cnsctvo_cdgo_entdd_rclmnte 	= 	n.cnsctvo_cdgo_entdd_rclmnte)
	/*inner join bdSISalud.dbo.tbIps o
	on  (a.nmro_unco_idntfccn_prstdr 	= 	o.nmro_unco_idntfccn_prstdr)*/
	inner join bdSISalud.dbo.tbEntidadARecobrar p
	on  (z.cnsctvo_entdd_a_rcbrr 	= 	p.cnsctvo_cdgo_entdd_a_rcbrr)
	/*inner join bdAfiliacionValidador.dbo.tbTiposIdentificacion c
	on  (a.cnsctvo_cdgo_tpo_idntfccn_pcnte 	= 	c.cnsctvo_cdgo_tpo_idntfccn)
	inner join bdSISalud.dbo.tbServiciosXRecobros q
	on  (z.cnsctvo_asccn_lqdcn 	= 	q.cnsctvo_asccn_mdlo_entdd)*/
	inner join bdSISalud.dbo.TbNivelesComplejidad r
	on  (a.cnsctvo_nvl_cmpljdd_atncn 	= 	r.cnsctvo_cdgo_nvl)
	/*inner join bdSISalud.dbo.TbDetFacturacionRecobro t
	on  (z.cnsctvo_asccn_lqdcn 	= 	t.cnsctvo_asccn_lqdcn)
	inner join bdSISalud.dbo.TbModeloLiquidacionRecobro s
	on  (t.cnsctvo_cdgo_mdlo_lqdcn_rcbro 	= 	s.cnsctvo_cdgo_mdlo_lqdcn_rcbro)*/
	left join bdSISalud.dbo.TbFacturaRecobro w
	on  (z.cnsctvo_fctra_rcbro 	= 	w.cnsctvo_fctra_rcbro)
	Where  a.cnsctvo_cdgo_entdd_rclmnte = @cnsctvocdgoentddrclmnte	
	
END
