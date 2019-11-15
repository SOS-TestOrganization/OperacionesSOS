

/*----------------------------------------------------------------------------------
* Metodo o PRG 		: spPmTraerTiposIdentificacion
* Desarrollado por		: <\A Ing. Álvaro Zapata  										A\>
* Descripcion			: <\D Este procedimiento realiza la búsqueda de los tipos de identificación de acuerdo a unos parametros  	D\>
				  <\D de entrada.											D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia de el tipo de identificacion 						P\>
				  <\P Codigo del agrupador de tipos de identificacion							P\>
				  <\P Codigo del tipo de identificacion a traer	 							P\>
				  <\P Codigo de la clase de empleador									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2006/09/04 											FC\>
*
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM AM\>
* Descripcion			 : <\DM DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM FM\>
*---------------------------------------------------------------------------------*/
--exec spPmConsultaBonosxAuxiliar 1, null, '2006-08-03', '2006-08-25', 0
CREATE  procedure  spPmConsultaBonosxAuxiliar
@cdgo_ofcna	Char(5) ,
@cdgo_usro	varchar(30) = Null,
@fcha_dsde	Datetime = Null,
@fcha_hsta	Datetime = Null,
@tds		int = 0

As
Set Nocount On

/*
Declare
@cdgo_ofcna	Char(5) ,
@cdgo_usro		varchar(30),
@fcha_dsde		Datetime,
@fcha_hsta		Datetime,
@tds			char(1)

Set	@cdgo_ofcna	= '01'
Set	@cdgo_usro	= 'sisazr01'
Set	@fcha_dsde	= '2006-08-03'
Set	@fcha_hsta	= '2006-09-07'
set	@tds 		= 0
*/

Declare
@cnsctvo_cdgo_ofcna Int

select  @cnsctvo_cdgo_ofcna = cnsctvo_cdgo_ofcna 
from 	tbOficinas
where 	cdgo_ofcna = @cdgo_ofcna

Declare 
@tb_ConsultaBonosxAuxiliar Table (
nmro_dcmnto			char(50),
fcha_utlzcn_bno			Datetime,
nmro_vldcn			Numeric,
ofcna_vldcn			Varchar(150),
cdgo_idntfccn			Char(3),
nmro_idntfccn			Char(23),
nmbrs				Varchar(150),
cdgo_usro			Char(30),
cnsctvo_cdgo_ofcna		Int,
nmro_vrfccn			Numeric,
cnsctvo_cdgo_tpo_idntfccn	Int,
cnsctvo_dcmnto_gnrdo		Int)

IF @tds = 1 And (@fcha_dsde is not null and @fcha_hsta is not null)

 Begin
 
	--Consulta los Bonos de todos los auxiliares
	Insert	Into @tb_ConsultaBonosxAuxiliar (fcha_utlzcn_bno, cnsctvo_cdgo_ofcna, nmro_vldcn, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmbrs, cdgo_usro, cnsctvo_dcmnto_gnrdo) 
	Select	Convert(char(10),lb.fcha_utlzcn_bno,111), lb.cnsctvo_cdgo_ofcna, CAST(lb.nmro_vrfccn AS int), l.cnsctvo_cdgo_tpo_idntfccn, l.nmro_idntfccn,
		Ltrim(Rtrim(l.prmr_nmbre)) + ' ' + Ltrim(rtrim(l.sgndo_nmbre)) + ' ' +  Ltrim(Rtrim(l.prmr_aplldo)) + ' ' + Ltrim(Rtrim(l.sgndo_aplldo)) as nmbrs,
		l.cdgo_usro,	cnsctvo_dcmnto_gnrdo
	From	bdSisalud.dbo.tblog l inner join bdSiSalud.dbo.tbLogBonos lb
	ON	l.cnsctvo_cdgo_ofcna	= lb.cnsctvo_cdgo_ofcna
	And	l.nmro_vrfccn		= lb.nmro_vrfccn
	Where	l.cnsctvo_cdgo_ofcna	= @cnsctvo_cdgo_ofcna
	And	(l.fcha_vldcn Between @fcha_dsde And @fcha_hsta)
	And	@tds			= 1 --consulta todos los log grabados en una fecha determinada


 End

Else
	IF (@cdgo_usro is not null) And (@fcha_dsde is not null and @fcha_hsta is not null) And @tds = 0 

	  Begin
		--Consulta los Bonos entregados por los auxiliares XXXX con oficina YYYY
		Insert	Into @tb_ConsultaBonosxAuxiliar (fcha_utlzcn_bno, cnsctvo_cdgo_ofcna, nmro_vldcn, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmbrs, cdgo_usro, cnsctvo_dcmnto_gnrdo) 
		Select	Convert(char(10),lb.fcha_utlzcn_bno,111), lb.cnsctvo_cdgo_ofcna, CAST(lb.nmro_vrfccn AS int), l.cnsctvo_cdgo_tpo_idntfccn, l.nmro_idntfccn,
			Ltrim(Rtrim(l.prmr_nmbre)) + ' ' + Ltrim(rtrim(l.sgndo_nmbre)) + ' ' +  Ltrim(Rtrim(l.prmr_aplldo)) + ' ' + Ltrim(Rtrim(l.sgndo_aplldo)) as nmbrs,
			l.cdgo_usro,	cnsctvo_dcmnto_gnrdo
		From	bdSiSalud.dbo.tblog l inner join bdSiSalud.dbo.tbLogBonos lb
		ON	l.cnsctvo_cdgo_ofcna	= lb.cnsctvo_cdgo_ofcna
		And	l.nmro_vrfccn		= lb.nmro_vrfccn
		Where	l.cnsctvo_cdgo_ofcna 	= @cnsctvo_cdgo_ofcna
		And	l.cdgo_usro		= @cdgo_usro
		And	(l.fcha_vldcn Between @fcha_dsde And @fcha_hsta)
	  End

/*
If (@cnsctvo_cdgo_ofcna is not null And @cdgo_usro is null) And @tds = 0 And (@fcha_dsde is not null and @fcha_hsta is not null)	

  Begin
	--Consulta los Bonos entregados por los auxiliares en una determinada fecha
	Insert	Into @tb_ConsultaBonosxAuxiliar (fcha_utlzcn_bno, cnsctvo_cdgo_ofcna, nmro_vrfccn, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmbrs, cnsctvo_dcmnto_gnrdo) 
	Select	Convert(char(10),lb.fcha_utlzcn_bno,111), lb.cnsctvo_cdgo_ofcna, lb.nmro_vrfccn, l.cnsctvo_cdgo_tpo_idntfccn, l.nmro_idntfccn,
		Ltrim(Rtrim(l.prmr_nmbre)) + ' ' + Ltrim(rtrim(l.sgndo_nmbre)) + ' ' +  Ltrim(Rtrim(l.prmr_aplldo)) + ' ' + Ltrim(Rtrim(l.sgndo_aplldo)) as nmbrs,
		cnsctvo_dcmnto_gnrdo
	From	bdSiSalud.dbo.tblog l inner join bdSiSalud.dbo.tbLogBonos lb
	ON	l.cnsctvo_cdgo_ofcna	= lb.cnsctvo_cdgo_ofcna
	And	l.nmro_vrfccn		= lb.nmro_vrfccn
	Where	(l.fcha_vldcn Between @fcha_dsde And @fcha_hsta)
	And	l.cnsctvo_cdgo_ofcna 	= @cnsctvo_cdgo_ofcna
  End
	
If (@cnsctvo_cdgo_ofcna is not null And @cdgo_usro is not null) And @tds = 0 And (@fcha_dsde is not null and @fcha_hsta is not null)	

  Begin
	--Consulta los Bonos entregados por los auxiliares para una determinada fecha y Auxiliar determinado
	Insert	Into @tb_ConsultaBonosxAuxiliar (fcha_utlzcn_bno, cnsctvo_cdgo_ofcna, nmro_vrfccn, cnsctvo_cdgo_tpo_idntfccn, nmro_idntfccn, nmbrs, cnsctvo_dcmnto_gnrdo) 
	Select	Convert(char(10),lb.fcha_utlzcn_bno,111), lb.cnsctvo_cdgo_ofcna, lb.nmro_vrfccn, l.cnsctvo_cdgo_tpo_idntfccn, l.nmro_idntfccn,
		Ltrim(Rtrim(l.prmr_nmbre)) + ' ' + Ltrim(rtrim(l.sgndo_nmbre)) + ' ' +  Ltrim(Rtrim(l.prmr_aplldo)) + ' ' + Ltrim(Rtrim(l.sgndo_aplldo)) as nmbrs,
		cnsctvo_dcmnto_gnrdo
	From	bdSiSalud.dbo.tblog l inner join bdSiSalud.dbo.tbLogBonos lb
	ON	l.cnsctvo_cdgo_ofcna	= lb.cnsctvo_cdgo_ofcna
	And	l.nmro_vrfccn		= lb.nmro_vrfccn
	Where	l.cnsctvo_cdgo_ofcna 	= @cnsctvo_cdgo_ofcna
	And	l.cdgo_usro		= @cdgo_usro
	And	(l.fcha_vldcn Between @fcha_dsde And @fcha_hsta)
  End	
*/
	Update	@tb_ConsultaBonosxAuxiliar
	Set	nmro_dcmnto		= dv.nmro_dcmnto
	From	@tb_ConsultaBonosxAuxiliar cba Inner Join bdAfiliacionValidador.dbo.tbDocumentosAfiliacionValidador dv
	On	cba.cnsctvo_dcmnto_gnrdo	= dv.cnsctvo_dcmnto_gnrdo
	
	Update	@tb_ConsultaBonosxAuxiliar
	Set	ofcna_vldcn		= Ltrim(Rtrim(ov.dscrpcn_ofcna))
	From	@tb_ConsultaBonosxAuxiliar cba inner join bdAfiliacionValidador.dbo.tbOficinas_Vigencias ov
	On	cba.cnsctvo_cdgo_ofcna	= ov.cnsctvo_cdgo_ofcna
	
	Update	@tb_ConsultaBonosxAuxiliar
	Set	cdgo_idntfccn		= ti.cdgo_tpo_idntfccn	
	From	@tb_ConsultaBonosxAuxiliar cba inner join bdAfiliacionValidador.dbo.tbTiposIdentificacion ti
	On	cba.cnsctvo_cdgo_tpo_idntfccn	= ti.cnsctvo_cdgo_tpo_idntfccn

Select	nmro_dcmnto,	fcha_utlzcn_bno,	nmro_vldcn,
	ofcna_vldcn,	cdgo_idntfccn,		nmro_idntfccn,		
	nmbrs,		cdgo_usro
From	@tb_ConsultaBonosxAuxiliar



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaBonosxAuxiliar] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

