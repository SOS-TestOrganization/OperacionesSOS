




/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spCMTraerOficinas
* Desarrollado por		: <\A Ing. Francisco J. Gonzalez R.   					A\>
* Descripción			: <\D Trae todos las oficnas						D\>
* Observaciones			: <\O 									O\>
* Parámetros			: <\P @lcCodigo: Código de un tipo de origen novedad en particular	P\>
* 				: <\P @ldFechaReferencia: Fecha para recuperar un tipo determinado	P\>
* 				: <\P  			    de origen contenido en un rango de vigencia	P\>
* 				: <\P @lcCadenaSeleccion: Cadena que permite filtrar los registros de  	P\>
* 				: <\P  			    salida de acuerdo a la descripción		P\>
* 				: <\P @lcTraerTodosVisibleUsuario: Permite filtrar los registros de salida	P\>
* 				: <\P  				    de acuerdo a los administrados por	P\>
* 				: <\P  				    el usuario				P\>
* Variables			: <\V									V\>
* Fecha Creación		: <\FC 2003/04/16  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		              : <\AM  			AM\>
* Descripcion			 : <\DM 	 		DM\>
*				 : <\DM  			DM\>
* Nuevos Parametros	 	 : <\PM   			PM\>
* Nuevas Variables		 : <\VM   			VM\>
* Fecha Modificacion		 : <\FM 				FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/

CREATE procedure  spCMTraerOficinas

@lcCodigo			char(5)		= 	NULL,
@ldFechaReferencia		DATETIME		= 	NULL,
@lcCadenaSeleccion		UdtDescripcion		= 	NULL,
@lcTraerTodosVisibleUsuario	udtLogico		=	'N'

AS

SET Nocount ON

If @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()

If 	@lcCodigo 	IS 	NULL
	If	@lcCadenaSeleccion  =  '+' OR @lcCadenaSeleccion  Is NULL						
		Select		a.cdgo_ofcna,		a.dscrpcn_ofcna,		a.drccn_ofcna,			b.cdgo_sde,
				b.dscrpcn_sde,		a.prncpl,			c.dscrpcn_cdd,			b.cnsctvo_cdgo_sde,
				a.cnsctvo_cdgo_ofcna
		From		tbOficinas_vigencias a,		tbSedes_Vigencias b,	tbCiudades_Vigencias c			
		Where		(@ldFechaReferencia	BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)
		And		(a.Vsble_Usro  			= 	 'S' Or @lcTraerTodosVisibleUsuario ='S')	
		And		a.cnsctvo_cdgo_sde		=	b.cnsctvo_cdgo_sde 
		--And		a.prmte_rdccn = 'S' 
		And a.cnsctvo_cdgo_cdd_rsdnca	=	c.cnsctvo_cdgo_cdd
		order by a.cdgo_ofcna
	Else								
		Select		a.cdgo_ofcna,		a.dscrpcn_ofcna,		a.drccn_ofcna,			b.cdgo_sde,
				b.dscrpcn_sde,		a.prncpl,			c.dscrpcn_cdd,			b.cnsctvo_cdgo_sde,
				a.cnsctvo_cdgo_ofcna
		From		tbOficinas_vigencias a,		tbSedes_Vigencias b,	tbCiudades_Vigencias c			
		Where		a.dscrpcn_ofcna	LIKE	'%' 	+	LTRIM(RTRIM(@lcCadenaSeleccion)) 	+	 '%'
		And		(@ldFechaReferencia	BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)				
		And		(a.Vsble_Usro  =  'S' Or @lcTraerTodosVisibleUsuario ='S')
		And		a.cnsctvo_cdgo_sde		=	b.cnsctvo_cdgo_sde			
		--And		a.prmte_rdccn = 'S'
		 And a.cnsctvo_cdgo_cdd_rsdnca	=	c.cnsctvo_cdgo_cdd
Else									
	Select		a.cdgo_ofcna,		a.dscrpcn_ofcna,		a.drccn_ofcna,			b.cdgo_sde,
			b.dscrpcn_sde,		a.prncpl,			c.dscrpcn_cdd,			b.cnsctvo_cdgo_sde,
			a.cnsctvo_cdgo_ofcna
	From		tbOficinas_vigencias a,		tbSedes_Vigencias b,	tbCiudades_Vigencias c			
	Where	(@ldFechaReferencia	BETWEEN 	a.Inco_vgnca	AND	a.Fn_vgnca)
	And	(a.Vsble_Usro  =  'S' Or @lcTraerTodosVisibleUsuario ='S')						
	And	a.cnsctvo_cdgo_sde		=	b.cnsctvo_cdgo_sde
	And	a.cdgo_ofcna =  @lcCodigo
	--And	 a.prmte_rdccn = 'S'
	And a.cnsctvo_cdgo_cdd_rsdnca	=	c.cnsctvo_cdgo_cdd



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [310002 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCMTraerOficinas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

