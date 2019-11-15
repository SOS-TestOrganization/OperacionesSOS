
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmConsultaAfiliadoCuentas 
* Desarrollado por		: <\A Ing. Samuel Muñoz							A\>
* Descripción			: <\D									D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2003/00/00  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM 				*					AM\>
* Descripción			: <\DM									DM\>
* 				: <\DM									DM\>
* Nuevos Parámetros		: <\PM  							>
* Nuevas Variables		: <\VM  									VM\>
* Fecha Modificación		: <\FM									FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE      procedure  [dbo].[spPmConsultaAfiliadoCuentas]
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn			Varchar(23), 	--udtNumeroIdentificacion,
@cnsctvo_cdgo_pln 		udtConsecutivo, 
@fcha_vldccn			datetime			= NULL,
@mnsje				varchar(80)  output,
@Bd 				char(1) ,
--@origen				char(1),
@lfFechaReferencia		datetime output--,
--@lFlag				char output
AS
-- Declaración de variables
Declare
@fechaHstrco	datetime

Set @fechaHstrco = getdate()

select @fechaHstrco = isnull(Cast(rtrim(ltrim(a.vlr_prmtro)) as datetime),getdate())
from tbTablaParametros a
where cnsctvo_prmtro = 3

--Set @lFlag	= 'N'
If datediff(dd,@fcha_vldccn,getdate()) = 0 Or datediff(dd,@fechaHstrco,getdate()) = 0
	Exec dbo.spPmConsultaAfiliadoCuentas_AlDia @cnsctvo_cdgo_tpo_idntfccn,@nmro_idntfccn,@cnsctvo_cdgo_pln,@mnsje output,@Bd,@lfFechaReferencia output
Else
	Exec dbo.spPmConsultaAfiliadoCuentas_Historico @cnsctvo_cdgo_tpo_idntfccn,@nmro_idntfccn,@cnsctvo_cdgo_pln,@fcha_vldccn,@mnsje output,@lfFechaReferencia output

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Auditor Interno de Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Liquidador Recobros]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaAfiliadoCuentas] TO [Radicador Recobros]
    AS [dbo];

