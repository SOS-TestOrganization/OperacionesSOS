


/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   spTraerTiposCotizante
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   Recupera todos los tipos de cotizante que aplican para un tipo de formulario			.	D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P    Codigo del cotizante										P\>
                                                      :  <\P   	Fecha de referencia										P\>
                                                      :  <\P	Consecutivo codigo tipo de formulario								P\>
                                                      :  <\P    Cadena de  seleccion										P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2002/06/20											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*----------------------------------------------------------------------------------  
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/19 FM\>
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*----------------------------------------------------------------------------------  
* Modificado Por		 : <\AM Yasmin Ramirez AM\>
* Descripcion			 : <\DM Se grabo el procedimiento en Red de Servicios para quitar las tablas que no utilizamos en Salud, ya que no van a ser enviadas a las cajas DM\>
* Nuevos Parametros	 	 : <\PM   Para no modificar fuentes quedan los mismo parametros PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/10/07 FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  spTraerTiposCotizante
@lcCodigoCotizante			udtCodigo	=   	NULL,
@ldFechaReferencia			Datetime	=   	NULL,
@lnConsecutivoCodigoTipoFormulario	udtconsecutivo	=	NULL,
@lcCadenaSeleccion			udtDescripcion	=	NULL,
@lcTraerTodosVisibleUsuario		udtLogico	=	'N'
AS
Set Nocount On
If @ldFechaReferencia Is Null
	Set @ldFechaReferencia = GetDate()

If 	@lcTraerTodosVisibleUsuario	 is null
  	set @lcTraerTodosVisibleUsuario	='S' 

If @lcCodigoCotizante IS NULL
Begin
	If @lcCadenaSeleccion  = '+'	or   @lcCadenaSeleccion is null
	Begin
--		If @lnConsecutivoCodigoTipoFormulario Is Null
--		Begin
                                     --Selecciona  el codigo , descripcion y numero del tipo de cotizante dentro de un rango vigente.
			Select	a.cdgo_tpo_ctznte ,			a.dscrpcn_tpo_ctznte,		a.cnsctvo_cdgo_tpo_ctznte,
				a.cnsctvo_cdgo_tpo_Cbrnza,		a.cnsctvo_cdgo_clse_aprtnte
			From	tbTiposCotizante_Vigencias a
			Where	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
--		End
--		Else
--		Begin
--			--Selecciona  el codigo , descripcion y numero del tipo de cotizante dentro de un rango vigente.
--			Select	a.cdgo_tpo_ctznte ,	a.dscrpcn_tpo_ctznte,		a.cnsctvo_cdgo_tpo_ctznte,	b.cnsctvo_cdgo_tpo_frmlro
--			From	tbTiposCotizante_Vigencias  a,	tbTiposCotizantexFormulario_Vigencias b
--			Where	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
--			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
--			And	a.Cnsctvo_cdgo_tpo_ctznte	= b.Cnsctvo_cdgo_tpo_ctznte
--			And	b.cnsctvo_cdgo_tpo_frmlro	= @lnConsecutivoCodigoTipoFormulario
--			And	(@ldFechaReferencia  between	b.inco_vgnca   And   b.fn_vgnca)
--		End		                                         
	End
        	Else
	Begin
--		If @lnConsecutivoCodigoTipoFormulario Is Null
--		Begin
			--Selecciona  el codigo , descripcion y numero del tipo de cotizante
			--dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion
			Select	distinct (a.cdgo_tpo_ctznte) ,	a.dscrpcn_tpo_ctznte,	a.cnsctvo_cdgo_tpo_ctznte,cnsctvo_cdgo_tpo_cbrnza,cnsctvo_cdgo_clse_aprtnte
			From	tbTiposCotizante_Vigencias  a
			Where	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
			And	dscrpcn_tpo_ctznte 		Like '%' +Ltrim(Rtrim(@lcCadenaSeleccion))+'%'
--		End
--		Else
--		Begin
			--Selecciona  el codigo , descripcion y numero del tipo de cotizante
			--dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion
--			Select	distinct (a.cdgo_tpo_ctznte) ,	a.dscrpcn_tpo_ctznte,	a.Cnsctvo_cdgo_tpo_ctznte,	b.cnsctvo_cdgo_tpo_frmlro,cnsctvo_cdgo_tpo_Cbrnza,cnsctvo_cdgo_Clse_aprtnte
--			From	tbTiposCotizante_Vigencias  a,	tbTiposCotizantexFormulario_Vigencias b
--			Where	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
--			And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
--			And	a.dscrpcn_tpo_ctznte 		Like '%' +Ltrim(Rtrim(@lcCadenaSeleccion))+'%'
--			And	a.Cnsctvo_cdgo_tpo_ctznte	= b.Cnsctvo_cdgo_tpo_ctznte
--			And	(b.cnsctvo_cdgo_tpo_frmlro	= @lnConsecutivoCodigoTipoFormulario	OR 	@lnConsecutivoCodigoTipoFormulario iS NULL)
--			And	(@ldFechaReferencia  between	b.inco_vgnca   And   b.fn_vgnca)
--		End
	End
End
Else
Begin
--	If @lnConsecutivoCodigoTipoFormulario Is Null
--	Begin
		--Selecciona  el codigo , descripcion y numero del tipo de cotizante
		--dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoCotizante
		Select	a.cdgo_tpo_ctznte ,	a.dscrpcn_tpo_ctznte,	a.cnsctvo_cdgo_tpo_ctznte,cnsctvo_cdgo_tpo_cbrnza,cnsctvo_cdgo_clse_aprtnte
		From	tbTiposCotizante_Vigencias a
		Where	a.cdgo_tpo_ctznte		= @lcCodigoCotizante
		And	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
		And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
--	End
--	Else
--	Begin
		--Selecciona  el codigo , descripcion y numero del tipo de cotizante
		--dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoCotizante
--		Select   	a.cdgo_tpo_ctznte ,	a.dscrpcn_tpo_ctznte,	a.cnsctvo_cdgo_tpo_ctznte,	b.cnsctvo_cdgo_tpo_frmlro,cnsctvo_cdgo_tpo_cbrnza,cnsctvo_cdgo_clse_aprtnte
--		From	tbTiposCotizante_Vigencias  a ,	 tbTiposCotizantexFormulario_Vigencias b
--		Where	a.cdgo_tpo_ctznte		= @lcCodigoCotizante
--		And	(@ldFechaReferencia  between	a.inco_vgnca   And   a.fn_vgnca)
--		And	(a.vsble_usro				=	'S'	OR	@lcTraerTodosVisibleUsuario	=	'S')
--		And	(a.Cnsctvo_cdgo_tpo_ctznte	= b.Cnsctvo_cdgo_tpo_ctznte	OR	@lcCodigoCotizante = '99' 	OR 	@lcCodigoCotizante='00')
--		And	(@ldFechaReferencia  between 	b.inco_vgnca   And   b.fn_vgnca)
--		And	(b.cnsctvo_cdgo_tpo_frmlro	= @lnConsecutivoCodigoTipoFormulario	OR 	@lnConsecutivoCodigoTipoFormulario Is Null)
--	End
End




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerTiposCotizante] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

