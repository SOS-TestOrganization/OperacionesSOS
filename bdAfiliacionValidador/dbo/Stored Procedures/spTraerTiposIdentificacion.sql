
/*----------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerTiposIdentificacion
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza la búsqueda de los tipos de identificación de acuerdo a unos parametros  	D\>
				  <\D de entrada.											D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia de el tipo de identificacion 						P\>
				  <\P Codigo del agrupador de tipos de identificacion							P\>
				  <\P Codigo del tipo de identificacion a traer	 							P\>
				  <\P Codigo de la clase de empleador									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/06/20 											FC\>
*
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/20 FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spTraerTiposIdentificacion]

@ldFechaReferencia			datetime		= Null,
@lcCodigoAgrupadorTipoIdentificacion	udtCodigo		= Null,
@lcCodigoTipoIdentificacion		udtTipoIdentificacion	= Null,
@lnClaseEmpleador			udtConsecutivo		= Null,
@lcTraerTodosVisibleUsuario		udtLogico		= 'N'

AS

Set Nocount On

If @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()

If @lnClaseEmpleador Is not Null
Begin
	Select	@lcCodigoAgrupadorTipoIdentificacion = b.cdgo_agrpdr_tpo_idntfccn
	From	tbRelAgrupacionxClaseEmpleador a, tbAgrupadoresTiposIdentificacion_Vigencias b
	Where	a.brrdo					=	'N'
	And 	(@ldFechaReferencia			Between a.inco_vgnca And a.fn_vgnca)
	And	(b.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
	And	(@ldFechaReferencia			Between b.inco_vgnca And b.fn_vgnca)
	And	a.cnsctvo_cdgo_clse_empldr		=	@lnClaseEmpleador
	And	a.cnsctvo_cdgo_agrpdr_tpo_idntfccn	=	b.cnsctvo_cdgo_agrpdr_tpo_idntfccn
End
--select @ldFechaReferencia
If @lcCodigoTipoIdentificacion Is Null
Begin
	IF @lcCodigoAgrupadorTipoIdentificacion IS Not Null
	Begin
		-- si codigo tipo de identificacion no viene se deben seleccionar todos los  tipos de identificacion
		-- que no esten borrados, cumplan las vigencias y pertenezcan al codigo agrupador ingresado
		--Set	@lcTraerTodosVisibleUsuario	='S'
		Select	c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn, 	rngo_infrr,	rngo_sprr, a.cnsctvo_cdgo_tpo_idntfccn a,
			a.cnsctvo_cdgo_agrpdr_tpo_idntfccn
		From	tbRelAgrupacionxTiposIdentificacion_Vigencias a,	tbAgrupadoresTiposIdentificacion_Vigencias b,	tbTiposIdentificacion_Vigencias c
		Where	(b.cdgo_agrpdr_tpo_idntfccn 		= @lcCodigoAgrupadorTipoIdentificacion Or @lcCodigoAgrupadorTipoIdentificacion Is Null)
		And 	(@ldFechaReferencia			Between b.inco_vgnca And b.fn_vgnca)
		And	(b.vsble_usro				= 'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And 	b.cnsctvo_cdgo_agrpdr_tpo_idntfccn 	= a.cnsctvo_cdgo_agrpdr_tpo_idntfccn
		And 	(@ldFechaReferencia			Between a.inco_vgnca And a.fn_vgnca)
		And 	(@ldFechaReferencia			Between c.inco_vgnca And c.fn_vgnca)
		And	(c.vsble_usro				= 'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
		And 	a.cnsctvo_cdgo_tpo_idntfccn		= c.cnsctvo_cdgo_tpo_idntfccn
	End
	Else
	Begin
		--Set	@lcTraerTodosVisibleUsuario	='S'
		Select	cnsctvo_cdgo_tpo_idntfccn,		dscrpcn_tpo_idntfccn, cdgo_tpo_idntfccn,
			inco_vgnca,                                        fn_vgnca,
			fcha_crcn,                                                    usro_crcn,                
			obsrvcns,                                                vsble_usro,  rngo_sprr,
			rngo_infrr,				 edd_sprr,
			edd_infrr,				 0 as cnsctvo_cdgo_agrpdr_tpo_idntfccn
		From 	tbTiposIdentificacion_Vigencias
		Where 	(@ldFechaReferencia			Between inco_vgnca And fn_vgnca)
		And	(vsble_usro				= 'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
	End
End
Else
Begin
	-- si codigo tipo de identificacion viene se deben seleccionar todos los tipos de identificacion
	-- que no esten borrados, cumplan las vigencias y tengan ese codigo tipo de identificacion
	Select	c.cdgo_tpo_idntfccn,	Substring(Ltrim(Rtrim(c.dscrpcn_tpo_idntfccn)),1,50)	dscrpcn_tpo_idntfccn,	c.cnsctvo_cdgo_tpo_idntfccn, 	rngo_infrr,	rngo_sprr, a.cnsctvo_cdgo_tpo_idntfccn a,
		a.cnsctvo_cdgo_agrpdr_tpo_idntfccn
	From 	tbRelAgrupacionxTiposIdentificacion_Vigencias a,	tbAgrupadoresTiposIdentificacion_Vigencias b,	tbTiposIdentificacion_Vigencias c
	Where	(b.cdgo_agrpdr_tpo_idntfccn 		= @lcCodigoAgrupadorTipoIdentificacion Or @lcCodigoAgrupadorTipoIdentificacion Is Null)
	And	cdgo_tpo_idntfccn			= @lcCodigoTipoIdentificacion 
	And 	(@ldFechaReferencia			Between b.inco_vgnca And b.fn_vgnca)
	And	(b.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
	And 	b.cnsctvo_cdgo_agrpdr_tpo_idntfccn 	= a.cnsctvo_cdgo_agrpdr_tpo_idntfccn
	And 	(@ldFechaReferencia			Between a.inco_vgnca And a.fn_vgnca)
	And 	(@ldFechaReferencia			Between c.inco_vgnca And c.fn_vgnca)
	And	(c.vsble_usro				= 'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
	And 	a.cnsctvo_cdgo_tpo_idntfccn		= c.cnsctvo_cdgo_tpo_idntfccn
	Order by c.cdgo_tpo_idntfccn
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [300604 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [300001 Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [970009 Autorizador Validacion Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [970001 Administrador Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [970007 Consultor Atencion al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Glosas Devoluciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [ctc_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [portal_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [qvision]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador Parametros Recobro]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Radicador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Cartera Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposIdentificacion] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

