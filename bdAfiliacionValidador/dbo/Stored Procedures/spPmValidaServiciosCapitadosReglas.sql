
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: [spPmValidaServiciosCapitadosReglas]
* Desarrollado por		:  <\A    Ing. Yasmin Ramirez						A\>
* Descripcion		 	:  <\D    Busca los items de capitacion de cada convenio 			D\>
* Observaciones		        :  <\O	Se eval£an las condiciones con los datos del afiliado en una fecha	O\>
* Parametros			:  <\P 	Convenio de capitacion del afiliado 				P\>
* 				:  <\P 	Ciudad de la ips de capitacion del convenio			P\>
* 				:  <\P 	Numero Unico de Identificacion del afiliado 			P\>
* 				:  <\P 	Tipo de Contrato del afiliado 					P\>
* 				:  <\P 	Fecha de la consulta del afiliado					P\>
* Fecha Creacion		:  <\FC  2003/09/01							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andr‚s L¢pez Ram¡rez AM\>
* Descripci¢n			: <\DM  DM\>
* Nuevos Par metros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificaci¢n		: <\FM 2003/10/12 FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
--Exec [spPmValidaServiciosCapitadosReglas] 1,0,31793816,1,'2004/10/06'
CREATE procedure  [dbo].[spPmValidaServiciosCapitadosReglas]
@cdgo_cnvno					decimal,
@cnsctvo_cdgo_cdd			UdtConsecutivo,
@nui						UdtConsecutivo,
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo, 
@fcha_vldccn				datetime,
@fcha_fd					datetime,
@cdgo_ips					char(8)

AS

-- Declaraci¢n y definici¢n de constantes

-- Declaraci¢n de variables
Declare
@cdgo_escnro 		UdtCodigo, 
@cnsctvo_cndcn  	int,
@abrr 			char(10),
@nmbre_cmpo		char(30),
@tpo_oprdr		char(2),
@vlrs_cndcn		varchar(100),
@crr			char(10),
@cnctndr		char(3),
@cdgo_itm_cptcn	char(3),
@Condiciones		varchar(1000),
@Query  		nvarchar(1000),
@Parametros  		nvarchar(1000),
@cdgo_escnro_cptcn	UdtCodigo,
@contador		int--,
--@fcha_fd		datetime,
--@cdgo_ips		char(8)

Set NoCount On


CREATE TABLE #tmpMatriz(
	[nmro_unco_idntfccn] [int] ,
	[cnsctvo_cdgo_tpo_cntrto] [int] ,
	[fcha_dsde] [datetime] ,
	[fcha_hsta] [datetime] ,
	[cdgo_tpo_idntfccn_empldr] [char](3) ,
	[nmro_idntfccn_empldr] [varchar](23) ,
	[cdgo_pln_cmplmntro] [char](2) ,
	[cdgo_sde] [char](3),
	[cdgo_cdd] [char](8),
	[estdo] [char](2) ,
	[cdgo_tpo_afldo] [char](2) ,
	[mdco] [char](1),
	[odntlgo] [char](1) ,
	[cdgo_tpo_cntrto] [char](2) ,
	[cdgo_ips] [char](8),
	[cdgo_brro] [char](10),
	[fcha_mdfccn] [datetime] 
)


--(sisatv01)
--Ajuste el cual los item deben ser igual al convenio del pos (2010/04/21)



if @cnsctvo_cdgo_tpo_cntrto=2
begin
	set @cnsctvo_cdgo_tpo_cntrto=1
end

/*
-- Calculo la fecha fuente de datos para luego calcular el cdgo ips
set	@fcha_fd = (select distinct max(b.fcha_fd)
			from 	tbMatrizCapitacionValidador a Inner Join tbEscenarios_procesovalidador b On
			 	a.cdgo_cnvno 		= b.cdgo_cnvno
			where 	nmro_unco_idntfccn 	= @nui
			and 	cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
			and 	@fcha_vldccn between 	b.fcha_dsde 	and 	b.fcha_hsta
			and 	@fcha_vldccn between 	a.fcha_dsde 	and 	a.fcha_hsta)
*/



--select @fcha_fd
--calculo el codigo ips para calcular el consecutivo de la ciudad
/*select 	@cdgo_ips			= a.cdgo_ips
from 	tbActuarioCapitacionValidador a
Where	@fcha_fd between a.fcha_dsde and a.fcha_hsta
And	a.nmro_unco_idntfccn 		= @nui
and	a.cnsctvo_cdgo_tpo_cntrto 	= @cnsctvo_cdgo_tpo_cntrto
*/

--select @cdgo_ips
--calculo el consecutivo de ciudad de acuerdo al código ips
/*
Select	@cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd
FROM 	tbIPSPrimarias_vigencias a Inner Join tbCiudades b On
	a.cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd 
Where	a.cdgo_intrno			= @cdgo_ips
*/
--select @cnsctvo_cdgo_cdd 		


Declare	@tmpCondicion table
(	cdgo_tpo_escnro 	Char(3), 
	cdgo_itm_cptcn		char(3),
	cndcn			varchar(1000), 
	dscrpcn_itm_cptcn	Varchar(150),
	accion 			varchar(30))

insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,	dscrpcn_itm_cptcn)
select 	cdgo_tpo_escnro, cdgo_itm_cptcn, instrccn_whre,	dscrpcn_itm_cptcn
from	tbEscenarios_procesoValidador
where 	cdgo_cnvno 		= @cdgo_cnvno
and 	@fcha_vldccn 		between fcha_dsde and fcha_hsta
and 	cnsctvo_cdgo_cdd 	= @cnsctvo_cdgo_cdd


Insert into 	#tmpMatriz 
select 	* 
from 	tbActuarioCapitacionValidador
where 	nmro_unco_idntfccn = @nui
and 	cnsctvo_cdgo_tpo_cntrto  = @cnsctvo_cdgo_tpo_cntrto
and 	convert(char(10) , @fcha_fd, 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)


DECLARE crCapitados CURSOR FOR
SELECT    cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn
FROM        @tmpCondicion 

OPEN crCapitados

FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones

WHILE @@FETCH_STATUS = 0
begin
	if ltrim(rtrim(@condiciones)) != ''
	Begin 
		set @query	= 'Select @contador_in = count(*) from #tmpMatriz where ' + ltrim(rtrim(@condiciones)) 
		Set @Parametros	= '@contador_in int output'
		exec sp_executesql @query,@Parametros,@contador_in = @contador output


		if @contador > 0 
			update @tmpCondicion  set accion = 'Capitacion'
			where cdgo_itm_cptcn = @cdgo_itm_cptcn

		else
			update @tmpCondicion  set accion = 'Actividad'
			where cdgo_itm_cptcn = @cdgo_itm_cptcn	
	End
	Else
			update @tmpCondicion  set accion = 'Capitacion'
			where cdgo_itm_cptcn = @cdgo_itm_cptcn	

	FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones
end

deallocate crCapitados
select distinct * from @tmpCondicion



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosReglas] TO [Liquidador Facturas]
    AS [dbo];

