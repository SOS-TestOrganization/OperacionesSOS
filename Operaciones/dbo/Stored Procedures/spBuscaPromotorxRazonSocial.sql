/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spBuscaPromotorxRazonSocial
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento almacenado realiza la busqueda de la razon social de una empresa por una cadena	D\>
				  <\D que se le digito.  											D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Caracteres ingresados por el usuario para realizar la busqueda 					P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/03 											FC\>
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
CREATE PROCEDURE spBuscaPromotorxRazonSocial

@lcCadenaSeleccion	UdtDescripcion = Null

As

Set Nocount On

-- Selecciona tipo, numero de identificacion y digito de verificacion de las empresas que contengan dentro 
-- de su razon social la cadena ingresada
Select	c.cdgo_tpo_idntfccn,	a.nmro_idntfccn_prmtr  nmro_idntfccn,		ltrim(rtrim(a.rzn_scl)) dscrpcn, 	a.dgto_vrfccn, 0  nmro_unco_idntfccn
From 	bdafiliacion..tbTiposIdentificacion c,	tbpromotores_vigencias   a
Where	(ltrim(rtrim(a.rzn_scl))		like '%' + Ltrim(Rtrim(@lcCadenaSeleccion))+'%' Or @lcCadenaSeleccion Is Null Or @lcCadenaSeleccion = '+')
And	a.cnsctvo_cdgo_tpo_idntfccn 	= c.cnsctvo_cdgo_tpo_idntfccn