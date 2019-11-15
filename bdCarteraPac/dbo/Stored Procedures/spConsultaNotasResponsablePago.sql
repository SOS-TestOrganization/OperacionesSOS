
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spConsultaNotasResponsablePago
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Retorna las notas credito por responsable							 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia									P\>
				  <\P consecutivo del promotor que se desea localizar							P\>				 
				  <\P cadena de busqueda por descripcion								P\>				 
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/10/01											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE	spConsultaNotasResponsablePago


@lcEstadoNota			udtConsecutivo		= Null,
@lnTipoNota			udtConsecutivo		= Null,
@nmro_unco_idntfccn_empldr	udtConsecutivo		= Null,
@cnsctvo_scrsl			udtConsecutivo		= Null,	
@cnsctvo_cdgo_clse_aprtnte	udtConsecutivo		= Null



As	


Set Nocount On


SELECT   a.nmro_nta,	     	fcha_crcn_nta,		a.vlr_nta 	
FROM       tbNotasPac a
Where	nmro_unco_idntfccn_empldr	=	@nmro_unco_idntfccn_empldr
And	cnsctvo_scrsl			=	@cnsctvo_scrsl
And	cnsctvo_cdgo_clse_aprtnte	=	@cnsctvo_cdgo_clse_aprtnte
And	cnsctvo_cdgo_estdo_nta		=	@lcEstadoNota
and	cnsctvo_cdgo_tpo_nta		=	@lnTipoNota
