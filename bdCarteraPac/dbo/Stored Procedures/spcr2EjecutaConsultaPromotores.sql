

/*---------------------------------------------------------------------------------
* Metodo o PRG		: spEjecutaConsultaPromotores
* Desarrollado por	: <\A Ing. Rolando simbaqueva Lasso				A\>
* Descripcion		: <\D Este procedimiento arma y ejecuta la cadena donde se	D\>
*			: <\D tiene los criterios para seleccionar los promotoresr 	D\>
* Observaciones		: <\O  								O\>
* Parametros		: <\P								P\>
* Variables		: <\V  								V\>
* Fecha Creacion	: <\FC 2003/02/10						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por	: <\AM	Ing. Jorge Ivan Rivera Gallego				AM\>
* Descripcion		: <\DM	Aplicación proceso optimización técnica			DM\>
* Nuevos Parametros	: <\PM	Consecutivo tipo promotor				PM\>
* Nuevas Variables	: <\VM	VM\>
* Fecha Modificacion	: <\FM	2005/08/29						FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE spcr2EjecutaConsultaPromotores
@lnTiPromotor Int,
@lcNiPromotor udtNumeroIdentificacionLargo


As

Set Nocount On

-- Contador de condiciones

Select	c.cdgo_prmtr,			d.cdgo_tpo_idntfccn,
	c.nmro_idntfccn_prmtr,		Convert(varchar(200) , (Ltrim(Rtrim(Isnull(c.prmr_aplldo,' '))) + ' ' + Ltrim(Rtrim(IsNull(c.sgndo_aplldo,' ')))  +  ' ' + Ltrim(Rtrim(Isnull(c.prmr_nmbre,' '))) + ' ' +  Ltrim(Rtrim(Isnull(c.sgndo_nmbre,' '))) + ' ' + Ltrim(Rtrim(Isnull(c.rzn_scl,' ')))) ) nombre ,
	c.inco_vgnca,			c.fn_vgnca,
	Convert(Char(20),Replace(convert(Char(20),c.fcha_crcn,120),'-','/' )) fcha_crcn_hra,
	c.usro_crcn,			c.cnsctvo_cdgo_tpo_idntfccn,
	c.cnsctvo_cdgo_cdd,		c.tlfno,
	c.drccn,			c.eml,
	c.cnsctvo_cdgo_estdo_prmtr,	c.cnsctvo_cdgo_tpo_prmtr ,
	c.dgto_vrfccn,			b.dscrpcn_tpo_prmtr,
	a.dscrpcn_estdo_prmtr,		c.cnsctvo_cdgo_prmtr,
	'NO SELECCIONADO' accn
From	bdCarteraPac.dbo.tbPromotores_Vigencias c Inner Join
	bdCarteraPac.dbo.tbEstadosPromotor a
On	c.cnsctvo_cdgo_estdo_prmtr	= a.cnsctvo_cdgo_estdo_prmtr Inner Join
	bdCarteraPac.dbo.tbTiposPromotor b
On	c.cnsctvo_cdgo_tpo_prmtr	= b.cnsctvo_cdgo_tpo_prmtr Inner Join
	bdafiliacion.dbo.tbtiposidentificacion d
On	c.cnsctvo_cdgo_tpo_idntfccn 	= d.cnsctvo_cdgo_tpo_idntfccn
Where	c.cnsctvo_cdgo_tpo_idntfccn	= @lnTiPromotor
And	c.nmro_idntfccn_prmtr		= @lcNiPromotor




