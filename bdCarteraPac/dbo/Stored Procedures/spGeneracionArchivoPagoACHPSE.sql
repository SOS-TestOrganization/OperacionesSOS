

/*---------------------------------------------------------------------------------
* Metodo o PRG		: spGeneracionArchivoPagoACHPSE
* Desarrollado por  : <\A Ing. Francisco Javier Gonzalez Ruano									A\>
* Descripcion		: <\D Este procedimiento genera la información de los estados 
						 de cuenta que son enviados para pago por cajeros ACH - PSE.		D\>
* Observaciones		: <\O                O\>
* Parametros		: <\P  @lnPeriodo    P\>
* Variables			: <\V                V\>
* Fecha Creacion	: <\FC 2013/12/10   FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
SAU Analista Descripcion
Se requiere parametrizar en el aplicativo CARTERA PAC, un archivo plano de la facturación PAC donde su criterio 
de generación sea PERIODO LIQUIDACIÓN (igual que el archivo plano ath), pero con la siguiente estructura:

Ruta: Procesos -> Generación de Estados de Cuenta -> Planos del Estado de Cuenta.
Nombre: Archivo Plano ACH - PSE.
Salida de información: Archivo Plano (. TXT), separado por PIPE | (Alt + 124).

Estructura de salida: 14 Campos obligatorios que se enviaran por Lotus.
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spGeneracionArchivoPagoACHPSE]

As

Declare 

@ltFechaLiquidacion datetime,
@lnPeriodoEvaluar	int 

Set nocount on


Set	@lnPeriodoEvaluar	= 0

Select	@lnPeriodoEvaluar	= Convert(Int,vlr)
From	#tbCriteriosTmp
Where 	cdgo_cmpo		= 'fcha_incl_prdo_lqdcn'

Select @ltFechaLiquidacion = bdRecaudos.dbo.fnConviertePeriodoFecha(@lnPeriodoEvaluar,1)

-- drop table #tmpLiquidaciones
-- drop table #tmpEstadosCuenta

Create Table #tmpLiquidaciones
(cnsctvo_cdgo_lqdcn			int,
fcha_pgo					datetime,
dscrpcn_prdo_lqdcn			udtDescripcion,
fcha_mxma_pgo				datetime)

Create Table #tmpEstadosCuenta
(nmro_estdo_cnta			varchar(13),
ttl_pgr						int,
nombre						varchar(50),
cdgo_idntfccn				char(30),
nmro_idntfccn				char(30),
nmro_unco_idntfccn_empldr	int,
prdo_evlr					int,
fcha_pgo					datetime,
vlr_iva						int,
cnsctvo_scrsl				int,
cnsctvo_cdgo_clse_aprtnte	int,
drccn						udtDireccion,
tlfno						udtTelefono,
tlfno_cllr					udtTelefono,
eml							udtEmail,
fcha_mxma_pgo				datetime
)


Insert Into #tmpLiquidaciones
Select	l.cnsctvo_cdgo_lqdcn,				pv.fcha_pgo,				p.dscrpcn_prdo_lqdcn,
		pv.fcha_mxma_pgo
from	dbo.tbLiquidaciones l Inner Join tbPeriodosliquidacion p
			On l.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
		Inner Join tbPeriodosliquidacion_vigencias pv
			On pv.cnsctvo_cdgo_prdo_lqdcn = p.cnsctvo_cdgo_prdo_lqdcn
where	pv.fcha_incl_prdo_lqdcn		= @ltFechaLiquidacion
And		l.cnsctvo_cdgo_estdo_lqdcn	= 3


Insert Into #tmpEstadosCuenta
Select	e.nmro_estdo_cnta,						e.ttl_pgr,						space(50) As nombre, 
		space(30) As cdgo_idntfccn,
		space(30) As nmro_idntfccn,				nmro_unco_idntfccn_empldr,		@lnPeriodoEvaluar,
		fcha_pgo,								e.vlr_iva,						e.cnsctvo_scrsl,
		e.cnsctvo_cdgo_clse_aprtnte,			Space(1) As drccn,				Space(1) As tlfno,
		Space(1) As tlfno_cllr,					Space(1) As eml,				l.fcha_mxma_pgo
From	#tmpLiquidaciones l inner join dbo.tbEstadosCuenta e
			On l.cnsctvo_cdgo_lqdcn = e.cnsctvo_cdgo_lqdcn
Where	cnsctvo_cdgo_estdo_estdo_cnta in (1,2)


Update	#tmpEstadosCuenta 
set			nmro_idntfccn	= v.nmro_idntfccn,
			cdgo_idntfccn	= ti.cdgo_tpo_idntfccn
From	#tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbVinculados v
			On e.nmro_unco_idntfccn_empldr = v.nmro_unco_idntfccn
		inner join bdAfiliacion.dbo.tbTiposIdentificacion ti
			On ti.cnsctvo_cdgo_tpo_idntfccn	= v.cnsctvo_cdgo_tpo_idntfccn


Update	#tmpEstadosCuenta 
Set		nombre = substring(rtrim(ltrim(nmbre_scrsl)),1,50),
		drccn		= p.drccn,
		tlfno		= p.tlfno,
		tlfno_cllr	= '',
		eml			= p.eml
From	#tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbSucursalesAportante p
			On	e.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn_empldr
			And	e.cnsctvo_scrsl				= p.cnsctvo_scrsl
			And	e.cnsctvo_cdgo_clse_aprtnte	= p.cnsctvo_cdgo_clse_aprtnte


Update	#tmpEstadosCuenta 
Set		nombre = substring(rtrim(ltrim(rzn_scl)),1,50)
From	#tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbEmpresas p
			On e.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn
Where IsNull(e.nombre,'') = ''


Update	#tmpEstadosCuenta 
Set		nombre		= substring(rtrim(ltrim(prmr_nmbre)) + ' ' + rtrim(ltrim(sgndo_nmbre))+ ' ' + rtrim(ltrim(prmr_aplldo)) + ' ' + rtrim(ltrim(sgndo_aplldo)),1,50),
		drccn		= p.drccn_rsdnca,
		tlfno		= p.tlfno_rsdnca,
		tlfno_cllr	= p.tlfno_cllr,
		eml			= p.eml
From	#tmpEstadosCuenta e inner join bdAfiliacion.dbo.tbPersonas p
			On e.nmro_unco_idntfccn_empldr = p.nmro_unco_idntfccn
Where IsNull(e.nombre,'') = ''


Select *, 'PLAN DE ATENCIÓN COMPLEMENTARIO SOS' As cncpto_pgo from #tmpEstadosCuenta



