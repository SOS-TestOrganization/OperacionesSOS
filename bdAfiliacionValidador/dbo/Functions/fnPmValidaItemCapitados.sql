/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnPmConsultaDetConveniosCapitacionAfiliadoValidacion
* Desarrollado por		 :  <\A    Ing. Nilson Mossos								A\>
* Descripcion			 :  <\D  	 				D\>
* Observaciones		         :  <\O											O\>
* 			         :  <\O El campo @fcha_vldcn no puede ser nulo						O\>
* Parametros			 :  <\P 	Codigo del error  							P\>
** Fecha Creacion		 :  <\FC  2003/09/26									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE   Function dbo.fnPmValidaItemCapitados (@cdgo_cnvno				decimal,
@cnsctvo_cdgo_cdd			UdtConsecutivo,
@nui					UdtConsecutivo,
@cnsctvo_cdgo_tpo_cntrto		UdtConsecutivo, 
@fcha_vldccn				datetime)
Returns   @tmpCondicion table(
	cntdr			int IDENTITY(1,1),
	cdgo_tpo_escnro 	char(2), 
	cdgo_itm_cptcn		char(3),
	cndcn			varchar(1000), 
	accion 			varchar(30)
)  
As
Begin 

Declare @tmpMatriz table(
nmro_unco_idntfccn	int,
cnsctvo_cdgo_tpo_cntrto	int,
fcha_dsde	datetime,
fcha_hsta	datetime,
cdgo_tpo_idntfccn_empldr	char(3),
nmro_idntfccn_empldr	varchar(23),
cdgo_pln_cmplmntro	char(2),
cdgo_sde	char(3),
cdgo_cdd	char(8),
estdo	char(2),
cdgo_tpo_afldo	char(2),
mdco	char,
odntlgo	char,
cdgo_tpo_cntrto	char(2),
cdgo_ips	char(8),
cdgo_brro	char(10),
fcha_mdfccn	datetime
)

insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn)
select 	cdgo_tpo_escnro, cdgo_itm_cptcn, instrccn_whre
from	dbo.tbEscenarios_procesoValidador
where 	cdgo_cnvno 		= 	@cdgo_cnvno
and 	@fcha_vldccn 		between fcha_dsde and fcha_hsta
and 	cnsctvo_cdgo_cdd 	= 	@cnsctvo_cdgo_cdd

update 	@tmpCondicion 
set	accion = 'Capitacion' 
from 	bdSiSalud.dbo.tbItemCapitacion_Vigencias a, @tmpCondicion  b
where	a.cdgo_itm_cptcn= b.cdgo_itm_cptcn
And	@fcha_vldccn between inco_vgnca And fn_vgnca 
--And	getdate() between inco_vgnca And fn_vgnca 
--and    	a.estdo = 'A'



Insert into @tmpMatriz
select 	nmro_unco_idntfccn,
cnsctvo_cdgo_tpo_cntrto,
fcha_dsde,
fcha_hsta,
cdgo_tpo_idntfccn_empldr,
nmro_idntfccn_empldr,
cdgo_pln_cmplmntro,
cdgo_sde,
cdgo_cdd,
estdo,
cdgo_tpo_afldo,
mdco,
odntlgo,
cdgo_tpo_cntrto,
cdgo_ips,
cdgo_brro,
fcha_mdfccn
from 	tbActuarioCapitacionValidador
where 	nmro_unco_idntfccn = @nui
and 	cnsctvo_cdgo_tpo_cntrto  = @cnsctvo_cdgo_tpo_cntrto
and 	convert(char(10) , @fcha_vldccn, 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)
--and 	convert(char(10) , getdate(), 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)



Return
End
