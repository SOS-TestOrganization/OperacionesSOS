/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerNombrePromotor
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de un empleador en la estructura definitiva de empresa.  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo tipo Identificacion Empresa								P\>
				  <\P Numero Identificacion Empresa 									P\>
				  <\P Clase empleador											P\>
				  <\P Descripcion											P\>
				  <\P Digito Verficacion			 								P\>
				  <\P Numero Unico de Identificacion 	 								P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2002/09/10	 FM\>
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE spTraerNombrePromotor

	@lcConsecutivoTipoIdentificacion		UdtConsecutivo,
	@lnNumeroIdentificacion			UdtNumeroIdentificacion,
	@lcDescripcion				Varchar(200)		= Null Output,
	@lnDigitoVerificacion			Int			= Null Output,
	@lnNui					UdtConsecutivo		= Null Output
--	@lcCodigoClaseEmpleador		UdtCodigo		= Null Output  no se necesita este parametro 

As

Set Nocount On

-- Inicializacion de variables
Select 	@lcDescripcion	 	= NULL,
	@lnDigitoVerificacion 	= NULL,
	@lnNui 			= NULL

Set @lnNui = 0
set @lnDigitoVerificacion 	= 0

Select   @lcDescripcion = convert(varchar(200)  ,   ltrim(rtrim(isnull(c.prmr_aplldo,'')))  +  ' ' +  ltrim(rtrim(isnull(c.sgndo_aplldo,' ')))  +  ' '  +  ltrim(rtrim(isnull(c.prmr_nmbre,'')))   +  ' '  +   ltrim(rtrim(isnull(c.sgndo_nmbre,'')))  +  '' +   ltrim(rtrim(isnull(c.rzn_scl,' ')))) ,
	@lnDigitoVerificacion = c.dgto_vrfccn   
from tbpromotores_vigencias  c
Where   cnsctvo_cdgo_tpo_idntfccn	=	@lcConsecutivoTipoIdentificacion
And	nmro_idntfccn_prmtr			=	@lnNumeroIdentificacion