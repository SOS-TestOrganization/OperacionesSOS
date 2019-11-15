


/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerParametrosProgramacion
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento permite recuperar la lista de los parametros  de programacion de un grupo especifico.	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo del grupo de parametros programacion que se desea recuperar 				P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/04 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andrés López Ramírez  AM\>
* Descripcion			: <\DM Se añade un campo, cdgo_crto_prmtro_prgrmcn, al final a la instrucción select  	DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2003/11/03 FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure  spTraerParametrosProgramacion
@lnGrupoParametroProgramacion	UdtConsecutivo	= Null
As
Set Nocount On
-- Selecciona el codigo y la descripcion del(os) parametro(s) de programacion que hace(n) parte del grupo
Select	b.cdgo_prmtro_prgrmcn,		Ltrim(Rtrim(b.dscrpcn_prmtro_prgrmcn)) dscrpcn_prmtro_prgrmcn,		b.cnsctvo_cdgo_prmtro_prgrmcn,		a.cnsctvo_agrpcn_tpo_prmtro_prgrmcn,	substring(b.cdgo_prmtro_prgrmcn,1,1) as cdgo_crto_prmtro_prgrmcn
From	tbRelAgrupacionxParametrosProgramacion a,	
	tbParametrosProgramacion b,	
	tbAgrupadoresparametrosProgramacion c
Where	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),a.inco_vgnca,111) And Convert(Varchar(10),a.fn_vgnca,111)
And	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),b.inco_vgnca,111) And Convert(Varchar(10),b.fn_vgnca,111)
And	a.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn	= @lnGrupoParametroProgramacion
And	a.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn	= c.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn
And	a.cnsctvo_cdgo_prmtro_prgrmcn		= b.cnsctvo_cdgo_prmtro_prgrmcn
--And	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),c.inco_vgnca,111) And Convert(Varchar(10),c.fn_vgnca,111)






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [300002 Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [300003 Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [300005 Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [300004 Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Consultor Auxiliar Sedes Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Aprendiz Red de Servicios Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Coordinador Parametros RedSalud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Consultor Cuentas Medicas Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auditor Interno Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auxiliar Parametros Red Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auxiliar Parametros Cuentas Medicas Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Auxiliar Parametros Convenios Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerParametrosProgramacion] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

