


/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmConsultaDetConveniosCapitacionAfiliado
* Desarrollado por		: <\A Ing. Yasmin Alexandra Ramirez Cuellar				A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 0000/00/00  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andrés López Ramírez					AM\>
* Descripción			: <\DM 									DM\>
* Nuevos Parámetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificación		: <\FM 2003/09/25							FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure  [dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion]
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo, 
--@nmro_cntrto			UdtNumeroFormulario, 
--@cnsctvo_bnfcro			UdtConsecutivo,
@nui_afldo			UdtConsecutivo,
@fcha_vldcn			datetime = null
AS
-- Declaración y definición de constantes

-- Declaración de variables
Declare
@mes		char(2),
@ano		char(4),
@fecha1	char(10)

Set NoCount On

-- Programa
if @fcha_vldcn is null
	select @fcha_vldcn = getdate()

SET @MES=DATEPART(MONTH,@fcha_vldcn)

IF (CONVERT(INT,@MES)<10)
  	  SET @MES='0'+SUBSTRING(@MES,1,1)

SET @ANO=DATEPART(YEAR,@fcha_vldcn)


-----------GENERA LA TABLA TEMPORAL


--insert 	into  #tmpCapitacionContrato ( cnsctvo_cdgo_tpo_cntrto,  nmro_cntrto, cnsctvo_bnfcro, cdgo_cnvno, estado, capitado, fcha_crte, fcha_dsde, fcha_hsta, fcha_fd)
insert 	into  #tmpCapitacionContrato ( cdgo_cnvno, estdo_cptcn, fcha_crte, fcha_dsde, fcha_hsta, fcha_fd)
select 	distinct
--	a.cnsctvo_cdgo_tpo_cntrto,
--	a.nmro_cntrto,
---	a.cnsctvo_bnfcro,	
 	a.cdgo_cnvno,
--	 'CAPITA'  ,
	'S' ,
	GETDATE(),
	a.fcha_dsde,
	a.fcha_hsta,
	b.fcha_fd
from 	tbMatrizCapitacionValidador a Inner Join tbEscenarios_procesoValidador b On
 	a.cdgo_cnvno 		  = b.cdgo_cnvno
where 	nmro_unco_idntfccn 	  = @nui_afldo
and 	cnsctvo_cdgo_tpo_cntrto = @cnsctvo_cdgo_tpo_cntrto
and 	@fcha_vldcn between 	b.fcha_dsde 	and 	b.fcha_hsta
and 	@fcha_vldcn between 	a.fcha_dsde 	and 	a.fcha_hsta



update 	#tmpCapitacionContrato 
set 	cdgo_ips_cptcn	= 	a.cdgo_ips
from 	#tmpCapitacionContrato c Inner Join tbActuarioCapitacionValidador a On
 	c.fcha_fd between a.fcha_dsde and a.fcha_hsta
Where 	a.nmro_unco_idntfccn 		= 	 @nui_afldo
and	a.cnsctvo_cdgo_tpo_cntrto 	= 	@cnsctvo_cdgo_tpo_cntrto


UPDATE 	#tmpCapitacionContrato 
SET 		cdgo_cdd = b.cdgo_cdd	--,
--		#tmpCapitacionContrato.dscrpcn_cdd = b.dscrpcn_cdd,
--		#tmpCapitacionContrato.dscrpcn_ips = ISNULL(a.nmbre_scrsl,''),
--		#tmpCapitacionContrato.cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd
FROM 	#tmpCapitacionContrato c Inner Join bdAfiliacionValidador..tbIpsPrimarias_vigencias a On
	a.cdgo_intrno = c.cdgo_ips_cptcn
			Inner Join tbCiudades b On
	a.cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd 		
-----------ACTUALIZA LA DESCRIPCION DEL CONVENIO

UPDATE	#tmpCapitacionContrato 	SET	dscrpcn_cnvno			= m.dscrpcn_mdlo_cnvno_cptcn,
	cnsctvo_cdgo_mdlo_cptcn_extrccn	= d.cnsctvo_cdgo_mdlo_cptcn_extrccn
FROM	#tmpCapitacionContrato t Inner Join bdAfiliacionValidador..tbModeloConveniosCapitacion m On
	m.cdgo_mdlo_cnvno_cptcn		= t.cdgo_cnvno
			Inner Join bdAfiliacionValidador..tbDetModeloConveniosCapitacion d On
	m.cnsctvo_cdgo_mdlo_cnvno_cptcn	= d.cnsctvo_cdgo_mdlo_cnvno_cptcn
Where	@fcha_vldcn Between m.inco_vgnca And m.fn_vgnca
And	@fcha_vldcn Between d.inco_vgnca And d.fn_vgnca

If (@@rowcount<>0)
Begin
	-----------ACTUALIZA EL CORTE
	UPDATE 	#tmpCapitacionContrato 
	SET 	da_crte	=	A.da_crte
	FROM 	#tmpCapitacionContrato c Inner Join bdAfiliacionValidador..tbModeloCapitacionExtraccionDetalle A On
		A.cnsctvo_cdgo_mdlo_cptcn_extrccn	= c.cnsctvo_cdgo_mdlo_cptcn_extrccn
	Where	@fcha_vldcn Between inco_vgnca And fn_vgnca

	-----------ACTUALIZA FECHA DE CORTE
	UPDATE #tmpCapitacionContrato SET FCHA_CRTE=LTRIM(RTRIM(@ANO))+LTRIM(RTRIM(@MES))+ LTRIM(RTRIM('0'+SUBSTRING(STR(DA_CRTE),10,1)))
	WHERE DA_CRTE<10 and da_crte>0
	
	UPDATE #tmpCapitacionContrato SET FCHA_CRTE=LTRIM(RTRIM(@ANO))+LTRIM(RTRIM(@MES))+ LTRIM(RTRIM(SUBSTRING(STR(DA_CRTE),9,2)))
	WHERE DA_CRTE>9 
End
Else
Begin
	delete #tmpCapitacionContrato
	insert into #tmpCapitacionContrato (  estdo_cptcn )
	values ( 'N')
End







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliadoValidacion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

