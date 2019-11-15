
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spEjecutaConsPagosAplicadosxusuario
* Desarrollado por		: <\A Ing. Fernando Valencia E								A\>
* Descripcion			: <\D Este procedimiento para generar archivo con  registros de pagos aplicados x usuario	 	D\>
* Observaciones		: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/07/05											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spEjecutaConsPagosAplicadosxusuario]

As

Set nocount on

Create Table #tbpagosxusuario	(
	usro_aplccn					udtUsuario,
	fcha_aplccn					Char(10),
	vlr_dcmnto					udtValorGrande,
	cnsctvo_cdgo_pgo			udtConsecutivo,
	cdgo_tpo_idntfccn			udtTipoIdentificacion,
	nmro_idntfccn				udtNumeroIdentificacionLargo,
	nmro_unco_idntfccn_empldr	udtConsecutivo,
	nmbre_scrsl					udtDescripcion,
	cnsctvo_cdgo_tpo_pgo		udtConsecutivo,
	fcha_rcdo					datetime,
	cnsctvo_cdgo_estdo_pgo		udtConsecutivo,
	dscrpcn_estdo_pgo			udtDescripcion,
	extmprno					udtLogico )


Declare @fcha_crcn_ini 	datetime,
	@fcha_crcn_fn		datetime,
	@usro_aplccn		char(20)
	
--Set @fcha_crcn_ini = '2013-06-01'
--Set @fcha_crcn_fn = '2013-06-30'

Select 	@fcha_crcn_ini 	=	vlr	+' 00:00:00' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 	 	= 	'fcha_crcn' 
And		oprdr	   	 	= 	'>='


Select	@fcha_crcn_fn 		=	vlr	+' 23:59:59' 
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 			= 	'fcha_crcn' 
And		oprdr	    		= 	'<='


Select	@usro_aplccn 		=	vlr	
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 			= 	'usro_crcn' 
And		oprdr	    		= 	'='



/*

tbEstadosPago
dbo.tbAbonos

Select	*
From	tbabonos
Where	cnsctvo_cdgo_pgo = 1033260

-- Truncate table #tbpagosxusuario

Select * From #tbpagosxusuario Where cnsctvo_cdgo_pgo = 1058790

Select extmprno, Count(*) From #tbpagosxusuario Group by extmprno

*/


Insert Into #tbpagosxusuario 	(
	usro_aplccn,									fcha_aplccn,
	vlr_dcmnto,										cnsctvo_cdgo_pgo,
	cdgo_tpo_idntfccn,								nmro_idntfccn,
	nmro_unco_idntfccn_empldr,						cnsctvo_cdgo_tpo_pgo,
	cnsctvo_cdgo_estdo_pgo,							fcha_rcdo
	)
select 	usro_aplccn,								convert(char(10),fcha_aplccn,111) as fcha_aplccn,
		vlr_dcmnto,									cnsctvo_cdgo_pgo, 
		c.cdgo_tpo_idntfccn,						b.nmro_idntfccn, 
		nmro_unco_idntfccn_empldr,					a.cnsctvo_cdgo_tpo_pgo,
		a.cnsctvo_cdgo_estdo_pgo,					a.fcha_rcdo
from	dbo.tbpagos a 	inner join bdAfiliacion.dbo.tbvinculados b
			On a.nmro_unco_idntfccn_empldr=b.nmro_unco_idntfccn
		inner join bdAfiliacion.dbo.tbtiposidentificacion c
			On b.cnsctvo_cdgo_tpo_idntfccn=c.cnsctvo_cdgo_tpo_idntfccn
Where	(@usro_aplccn  is null or  usro_aplccn	=	@usro_aplccn )
And  	(@fcha_crcn_ini is not null and fcha_aplccn  between @fcha_crcn_ini and @fcha_crcn_fn)
And		cnsctvo_cdgo_tpo_pgo		=	2		 ---Manuales
Order by 2
 


-- Actualiza el campo extemporaneo
 
Update a
set		nmbre_scrsl=ltrim(rtrim(b.nmbre_scrsl))
From	#tbpagosxusuario a Inner Join  bdAfiliacion.dbo.tbsucursalesaportante b
		on  a.nmro_unco_idntfccn_empldr=b.nmro_unco_idntfccn_empldr


-- Actualiza el campo extemporaneo

Update	a
Set		extmprno		= b.extmprno
-- Select b.*
From	#tbpagosxusuario a Inner Join bdCarteraPac.dbo.tbAbonos b
			On a.cnsctvo_cdgo_pgo	= b.cnsctvo_cdgo_pgo


-- Actualiza el estado del pago

Update	a
Set		dscrpcn_estdo_pgo		= b.dscrpcn_estdo_pgo
From	#tbpagosxusuario a Inner Join bdCarteraPac.dbo.tbEstadosPago b
			On a.cnsctvo_cdgo_estdo_pgo	= b.cnsctvo_cdgo_estdo_pgo


Select 	usro_aplccn, 
	fcha_aplccn, 
	vlr_dcmnto, 
	cnsctvo_cdgo_pgo, 
	cdgo_tpo_idntfccn,   
	nmro_idntfccn, 
	nmbre_scrsl as rspnsble_pgo,
	fcha_rcdo,
	extmprno,
	dscrpcn_estdo_pgo
From #tbpagosxusuario 


Drop table #tbpagosxusuario
