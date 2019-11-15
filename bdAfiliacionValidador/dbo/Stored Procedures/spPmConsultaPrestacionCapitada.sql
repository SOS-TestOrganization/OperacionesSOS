/*---------------------------------------------------------------------------------------------------------------------------------------  
* Procedimiento   : [spPmConsultaPrestacionCapitada]  
* Desarrollado por  :  <\A    Ing. Alexander Lopez     A\>  
* Descripcion    :  <\D    Busca los items de capitacion de cada convenio y prestacion    D\>  
* Observaciones          :  <\O Se evaluan las condiciones con los datos del afiliado a la fecha Solictu medica O\>  
* Parametros   :  <\P  Convenio de capitacion del afiliado     P\>  
*     :  <\P  Ciudad de la ips de capitacion del convenio   P\>  
*     :  <\P  Numero Unico de Identificacion del afiliado    P\>  
*     :  <\P  Fecha de la consulta del afiliado     P\>  
*---------------------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		: <\AM	Ing. Cesar García															AM\>  
* Descripci¢n			: <\DM  Se ajusta validación de prestaciones capitadas en los modelos de capitación	DM\>  
						: <\DM	generados de manera manual													DM\>  
* Nuevos Par metros		: <\PM  PM\>  
* Nuevas Variables		: <\VM  VM\>  
* Fecha Modificacion	: <\FM	2016-03-17																	FM\>  
*-------------------------------------------------------------------------------------------------------------------------------------*/  
-- Exec [spPmConsultaPrestacionCapitada] 34088351,null,65613
-- Exec [spPmConsultaPrestacionCapitada] 31793816,null,1

CREATE    procedure  [dbo].[spPmConsultaPrestacionCapitada]  
-- declare   
@nui			UdtConsecutivo,  
@fechaConsulta  datetime,  
@cnsctvo_prstcn	int -- parametro nuevo   

As

Set NoCount On

--------------- Caso pruebas afiliado tipo Conv capita -- 
--set @nui				         = 34088351
--set @fechaConsulta		     = '20170210'
----set @cnsctvo_prstcn        =   65613  -- prestacion dentro del modelo de prestaciones Capita cdgo_cnvno 93 
--set @cnsctvo_prstcn        =  29676 -- prestacion dentro del modelo de prestaciones Capita cdgo_cnvno Pgp 187
--------------------------------------------------------------

Declare  
@fcha_fd			datetime,  
@cdgo_ips			char(8),
@ldfechaReferencia	datetime,
@cnsctvo_cdgo_cdd	int

-- Cursor de prestaciones por convenios de capitacion 
Create Table #tmpPrestacionesCapitacion
(
	cdgo_intrno					VarChar(8),
	cnsctvo_cdgo_cdd			Int,
	cnsctvo_prstcn				Int,
	nmro_unco_idntfccn_prstdr	Int,
	nmbre_scrsl					VarChar(250),
	dscrpcn_prstcn				VarChar(150),
    dscrpcn_tpo_mdlo VarChar(150)
)

Set	@fechaConsulta = isnull(@fechaConsulta,getdate())
 
DECLARE @ConvCapitaxTpMdlo TABLE (
cdgo_cnvno char(3),
cnsctvo_cdgo_tpo_mdlo int,
fechaReferencia datetime,
cnsctvo_cdgo_cdd int,
fechaConsulta datetime,
nmro_unco_idntfccn int,
cnsctvo_cdgo_mdlo_cnvno_cptcn int
)

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- En esta consulta se inserta los tipo modelo capitacion 4 se validan a la fecha de la generacion del escenario proceso de la cual, se toma 
-- la fecha en que se genero la capita del convenio del afiliado. El distinc se incluye debido a que solo requiero la fecha fte dts 
-- unica para cada n registros del escenario generado.
-- El unio se realiza para los tipos de convenio 10 Pagos fijos teniendo en cuenta que la fecha en que se genera el proceso es tomada 
-- de la fecha en que carga la información en el sistema, ya qeu este tipo de capitas aun no genera escenarios.
---------------------------------------------------------------------------------------------------------------------------------------------------------
Insert Into @ConvCapitaxTpMdlo (            cdgo_cnvno, cnsctvo_cdgo_tpo_mdlo, fechaReferencia, fechaConsulta, nmro_unco_idntfccn, cnsctvo_cdgo_mdlo_cnvno_cptcn)
select                                          distinct a.cdgo_cnvno, c.cnsctvo_cdgo_tpo_mdlo, fcha_fd, @fechaConsulta,  @nui, c.cnsctvo_cdgo_mdlo_cnvno_cptcn
from 	bdafiliacionvalidador.dbo.tbMatrizCapitacionValidador a with(nolock)
Inner Join bdafiliacionvalidador.dbo.tbEscenarios_procesovalidador b with(nolock) On a.cdgo_cnvno = b.cdgo_cnvno
Inner Join bdSisalud..tbModeloConveniosCapitacion c On  c.cdgo_mdlo_cnvno_cptcn  = a.cdgo_cnvno
where 	@fechaConsulta between 	b.fcha_dsde 	and 	b.fcha_hsta
and 	@fechaConsulta between a.fcha_dsde 	and 	a.fcha_hsta
and a.nmro_unco_idntfccn = @nui
and c.cnsctvo_cdgo_tpo_mdlo = 4 -- Capita
Union
select a.cdgo_cnvno, c.cnsctvo_cdgo_tpo_mdlo, fcha_dsde, @fechaConsulta,  @nui, c.cnsctvo_cdgo_mdlo_cnvno_cptcn
from 	bdafiliacionvalidador.dbo.tbMatrizCapitacionValidador a with(nolock)
Inner Join bdSisalud..tbModeloConveniosCapitacion c On  c.cdgo_mdlo_cnvno_cptcn  = a.cdgo_cnvno
where @fechaConsulta between 	a.fcha_dsde 	and 	a.fcha_hsta
and a.nmro_unco_idntfccn = @nui
and c.cnsctvo_cdgo_tpo_mdlo = 10  -- Pgp


-------------------------------------------------------------------------------------------------------------------------------------
-- Actualizo la Ciudad del afiliado, tomando la ciudad de la Ips primaria del afiliado calculada anteriormente
-------------------------------------------------------------------------------------------------------------------------------------
Update @ConvCapitaxTpMdlo set cnsctvo_cdgo_cdd = d.cnsctvo_cdgo_cdd
from 	bdafiliacionvalidador.dbo.tbActuarioCapitacionValidador a with(nolock)
inner join bdSisalud.dbo.tbdireccionesprestador b with(nolock) on a.cdgo_ips = b.cdgo_intrno
inner join @ConvCapitaxTpMdlo c on a.nmro_unco_idntfccn = c.nmro_unco_idntfccn
inner join bdSisalud.dbo.tbdireccionesprestador d with(nolock) on a.cdgo_ips = d.cdgo_intrno
Where c.fechaReferencia between a.fcha_dsde and a.fcha_hsta


Insert Into		#tmpPrestacionesCapitacion
Select distinct f.cdgo_intrno, g.cnsctvo_cdgo_cdd, c.cnsctvo_prstcn, g.nmro_unco_idntfccn_prstdr, g.nmbre_scrsl , h.dscrpcn_cdfccn, i.dscrpcn_tpo_mdlo
From  @ConvCapitaxTpMdlo aa
Inner join		bdsisalud.dbo.tbAsociacionModeloActividad					f	with(nolock)	On aa.cnsctvo_cdgo_mdlo_cnvno_cptcn = f.cnsctvo_mdlo_cnvno_pln and                                                                                                                               aa.cnsctvo_cdgo_tpo_mdlo = f.cnsctvo_cdgo_tpo_mdlo
Inner join		bdSisalud.dbo.tbdetModeloConveniosCapitacion				b	with(nolock)	On aa.cnsctvo_cdgo_mdlo_cnvno_cptcn = b.cnsctvo_cdgo_mdlo_cnvno_cptcn
Inner join		bdSisalud.dbo.tbDetModeloConveniosCapitacionPrestaciones	c	with(nolock)	On b.cnsctvo_cdgo_mdlo_cnvno_cptcn_prstcn = c.cnsctvo_cdgo_mdlo_cnvno_cptcn_prstcn
Inner join		bdsisalud.dbo.tbdireccionesprestador						g	with(nolock)	On f.cdgo_intrno = g.cdgo_intrno
Inner join		bdsisalud.dbo.tbcodificaciones								h	with(nolock)	On c.cnsctvo_prstcn = h.cnsctvo_cdfccn
Inner join		bdsisalud..TbTipomodelo i on                                    f.cnsctvo_cdgo_tpo_mdlo = i.cnsctvo_cdgo_tpo_mdlo
--Inner join		bdsisalud..tbDetModeloCapitacionCiudades J          on  j.cnsctvo_cdgo_mdlo_cptcn_cdd = b.cnsctvo_cdgo_mdlo_cptcn_cdd 
Where			c.cnsctvo_prstcn =  @cnsctvo_prstcn
And			@fechaConsulta Between f.inco_vgnca And f.fn_vgnca
And				@fechaConsulta Between b.inco_vgnca And b.fn_vgnca
And				@fechaConsulta Between c.inco_vgnca And c.fn_vgnca
--and               aa.cnsctvo_cdgo_cdd = j.cnsctvo_cdgo_cdd 


--select * from @ConvCapitaxTpMdlo
select * from #tmpPrestacionesCapitacion

drop table #tmpPrestacionesCapitacion








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [310008 Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [310001 Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [310009 Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [310019 Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaPrestacionCapitada] TO [Analista Seguros Asistenciales]
    AS [dbo];

