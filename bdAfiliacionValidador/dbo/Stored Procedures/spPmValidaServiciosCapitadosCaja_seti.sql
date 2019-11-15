
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmValidaServiciosCapitadosCaja
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
--Exec spPmValidaServiciosCapitadosCaja 1,0,31793816,1,'2004/10/06'
CREATE    procedure  [dbo].[spPmValidaServiciosCapitadosCaja_seti]
@cdgo_cnvno				decimal,
@cnsctvo_cdgo_cdd			UdtConsecutivo,
@nui					UdtConsecutivo,
@cnsctvo_cdgo_tpo_cntrto		UdtConsecutivo, 
@fcha_vldccn				datetime

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
@contador		int,
@fcha_fd		datetime,
@cdgo_ips		char(8)
Set NoCount On

--(sisatv01)
--Ajuste el cual los item deben ser igual al convenio del pos (2010/04/21)

if @cnsctvo_cdgo_tpo_cntrto=2
begin
	set @cnsctvo_cdgo_tpo_cntrto=1
end


-- Calculo la fecha fuente de datos para luego calcular el cdgo ips
set	@fcha_fd = (select distinct max(b.fcha_fd)
			from 	tbMatrizCapitacionValidador a Inner Join tbEscenarios_procesovalidador b On
			 	a.cdgo_cnvno 		= b.cdgo_cnvno
			where 	nmro_unco_idntfccn 	= @nui
			and 	cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
			and 	@fcha_vldccn between 	b.fcha_dsde 	and 	b.fcha_hsta
			and 	@fcha_vldccn between 	a.fcha_dsde 	and 	a.fcha_hsta)

--select @fcha_fd
--calculo el codigo ips para calcular el consecutivo de la ciudad
select 	@cdgo_ips			= a.cdgo_ips
from 	tbActuarioCapitacionValidador a
Where	@fcha_fd between a.fcha_dsde and a.fcha_hsta
And	a.nmro_unco_idntfccn 		= @nui
and	a.cnsctvo_cdgo_tpo_cntrto 	= @cnsctvo_cdgo_tpo_cntrto

--select @cdgo_ips
--calculo el consecutivo de ciudad de acuerdo al código ips
Select	@cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd
FROM 	tbIPSPrimarias_vigencias a Inner Join tbCiudades b On
	a.cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd 
Where	a.cdgo_intrno			= @cdgo_ips

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


/*
update 	@tmpCapitacionContrato 
set 	cdgo_ips	= 	a.cdgo_ips
from 	@tmpCapitacionContrato c Inner Join tbActuarioCapitacionValidador a On
 	c.fcha_fd between a.fcha_dsde and a.fcha_hsta
Where 	a.nmro_unco_idntfccn 		= 	 @nui_afldo
and	a.cnsctvo_cdgo_tpo_cntrto 	= 	@cnsctvo_cdgo_tpo_cntrto

UPDATE 	@tmpCapitacionContrato 
SET 		cdgo_cdd = b.cdgo_cdd,
		dscrpcn_cdd = b.dscrpcn_cdd,
		dscrpcn_ips = ISNULL(a.nmbre_scrsl,''),
		cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd
FROM 	@tmpCapitacionContrato c Inner Join bdSiSalud..tbIPSPrimarias_vigencias a On
	a.cdgo_intrno = c.cdgo_ips
		Inner Join tbCiudades b On
	a.cnsctvo_cdgo_cdd = b.cnsctvo_cdgo_cdd 
*/


/*
select	@fcha_fd = fcha_fd
from	tbEscenarios_procesoValidador
where 	cdgo_cnvno 		= 	@cdgo_cnvno
and 	@fcha_vldccn 		between fcha_dsde and fcha_hsta
and 	cnsctvo_cdgo_cdd 	= 	@cnsctvo_cdgo_cdd
*/
/*
-- 2012/07/05 se trae la informacion de escenarios, esta tabla actualmente no se replica

update 	@tmpCondicion 
set	dscrpcn_itm_cptcn = rtrim(ltrim(a.dscrpcn_itm_cptcn)),
	accion = 'Capitacion' 
from 	dbo.tbitemcapitacion_vigencias a INNER JOIN @tmpCondicion  b
   	On a.cdgo_itm_cptcn= b.cdgo_itm_cptcn
where	@fcha_vldccn between a.inco_vgnca And a.fn_vgnca
--and    	a.estdo = 'A'
*/
/*
Declare	@tmpMatriz table (nmro_unco_idntfccn	int,
cnsctvo_cdgo_tpo_cntrto	int,
fcha_dsde		datetime,
fcha_hsta		datetime,
cdgo_tpo_idntfccn_empldr	char(3),
nmro_idntfccn_empldr	varchar	(23),
cdgo_pln_cmplmntro	char(2),
cdgo_sde		char(3),
cdgo_cdd		char(8),
estdo			char(2),
cdgo_tpo_afldo		char(2),
mdco			char(1),
odntlgo			char(1),
cdgo_tpo_cntrto		char(2),
cdgo_ips		char(8),
cdgo_brro		char(10),
fcha_mdfccn		datetime)

Insert Into @tmpMatriz
select 	* 
from 	tbActuarioCapitacionValidador
where 	nmro_unco_idntfccn = @nui
and 	cnsctvo_cdgo_tpo_cntrto  = @cnsctvo_cdgo_tpo_cntrto
and 	convert(char(10) , @fcha_fd, 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)
*/


select 	* 
into 	#tmpMatriz 
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
--		set @query = 'Select * into #servicioscapitados from #tmpMatriz where ' + ltrim(rtrim(@condiciones)) 
--		exec sp_executesql @query
		set @query	= 'Select @contador_in = count(*) from #tmpMatriz where ' + ltrim(rtrim(@condiciones)) 
--		set @query	= 'Select @contador_in = count(*) from @tmpMatriz_in where ' + ltrim(rtrim(@condiciones)) 
--		Set @Parametros	= '@contador_in int output,@tmpMatriz_in table (nmro_unco_idntfccn int,cnsctvo_cdgo_tpo_cntrto int,fcha_dsde datetime, fcha_hsta datetime,cdgo_tpo_idntfccn_empldr char(3),nmro_idntfccn_empldr varchar (23),cdgo_pln_cmplmntro char(2),cdgo_sde char(3),cdgo_cdd char(8),estdo char(2), cdgo_tpo_afldo char(2),mdco char,odntlgo char(1),cdgo_tpo_cntrto char(2),cdgo_ips char(8),cdgo_brro char(10),fcha_mdfccn datetime)'
		Set @Parametros	= '@contador_in int output'

--		exec sp_executesql @query,@Parametros,@tmpMatriz_in = null,@contador_in = @contador output
		exec sp_executesql @query,@Parametros,@contador_in = @contador output

--		if @@rowcount > 0 
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


