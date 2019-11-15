
/*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM	 Ing. Darling Liliana Dorado sisddm01					AM\>
* Descripcion			 : <\DM  se cambia bdAfiliacionValidador.dbo.tbModeloConveniosCapitacion
								 por bdipsparametros.dbo.tbModeloConveniosCapitacion							 
							DM\>
* Nuevos Parametros	 	 : <\PM   					PM\>
* Nuevas Variables		 : <\VM   					VM\>
* Fecha Modificacion	 : <\FM	2018-09-06					FM\>
*-----------------------------------------------------------------------------------------*/

CREATE procedure  [dbo].[spPmConsultaDetConveniosCapitacionAfiliado]
@cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo,
@nmro_cntrto				UdtNumeroFormulario,
@cnsctvo_bnfcro				UdtConsecutivo,
@nui_afldo					UdtConsecutivo,
@fcha_vldcn					datetime --= null

As
Set NoCount On

-- Declaración y definición de constantes

-- Declaración de variables
Declare		@mes			char(2),
			@ano			char(4),
			@fecha1			char(10),
			@hst_nme		VarChar(50)

Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

-- Programa
if @fcha_vldcn is null
	select @fcha_vldcn = getdate()

SET @MES	=	DATEPART(MONTH,@fcha_vldcn)

IF (CONVERT(INT,@MES)<10)
  	  SET @MES	=	'0'+SUBSTRING(@MES,1,1)

SET @ANO	=	DATEPART(YEAR,@fcha_vldcn)

Declare @tmpCapitacionContrato table
		(	dscrpcn_cnvno					varchar(150) null,
			cdgo_cnvno						numeric null,
			estado							varchar(20) not null,
			capitado						char not null,
			fcha_crte						datetime null,
			da_crte							int null,
			fcha_dsde						datetime null,
       		fcha_hsta						datetime null,
       		cnsctvo_cdgo_mdlo_cptcn_extrccn	int null,
       		cdgo_cdd						char(8) null,
       		cdgo_ips 						char(8) null,
       		dscrpcn_cdd						varchar(150) null, 
			dscrpcn_ips						varchar(150) null,
			cnsctvo_cdgo_cdd				int null,
			cnsctvo_cdgo_tpo_cntrto			int,
			nmro_cntrto						char(15),
			cnsctvo_bnfcro					int,
			fcha_fd							datetime,
			nmro_unco_idntfccn				Int,
			nmro_idntfccn_ips				VarChar(30)
		)

-----------GENERA LA TABLA TEMPORAL
/*
Se suprime la realción tbEscenarios_procesovalidador para validar solamente si el afiliado capita o no.
El campo fcha_fd será calculado en el sp
*/
--insert 	into  @tmpCapitacionContrato ( cnsctvo_cdgo_tpo_cntrto,  nmro_cntrto, cnsctvo_bnfcro, cdgo_cnvno, estado, capitado, fcha_crte, fcha_dsde, fcha_hsta, fcha_fd)
Insert Into	@tmpCapitacionContrato
			(		cnsctvo_cdgo_tpo_cntrto,  	nmro_cntrto, 		cnsctvo_bnfcro,
					cdgo_cnvno, 				estado, 			capitado,
					fcha_crte, 					fcha_dsde, 			fcha_hsta,
					cdgo_cdd,					cdgo_ips,			dscrpcn_cdd,
					dscrpcn_ips,				cnsctvo_cdgo_cdd,	nmro_unco_idntfccn,
					nmro_idntfccn_ips
			)
Select Distinct		cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_bnfcro,
 					cdgo_cnvno,					'CAPITA',			'S',
					GETDATE(),					fcha_dsde,			fcha_hsta,
					Null,						'',					null,
					'',							0,					nmro_unco_idntfccn,
					''
--	b.fcha_fd
From 				bdAfiliacionValidador.dbo.tbMatrizCapitacionValidador	With(NoLock) --With(index(IX_tbMatrizCapitacionValidador_NUI))
Where 				nmro_unco_idntfccn 	= @nui_afldo 
And 				fcha_dsde			<= @fcha_vldcn
And					fcha_hsta			>= @fcha_vldcn

if @@rowcount = 0
	begin
		insert into @tmpCapitacionContrato ( dscrpcn_cnvno,estado, capitado,dscrpcn_ips,cdgo_ips )
		values		('',  'NO CAPITA', 'N','','')
	end
else
	begin
		If Exists	(	Select	1
						From	bdAfiliacionValidador.dbo.tbtablaParametros  With(NoLock)
						Where	vlr_prmtro	= @hst_nme
					)
			begin

				--sisddm01 20180906 se cambia bdAfiliacionValidador.dbo.tbModeloConveniosCapitacion por bdipsparametros.dbo.tbModeloConveniosCapitacion
				Update		@tmpCapitacionContrato
				Set			dscrpcn_cnvno		=	m.dscrpcn_mdlo_cnvno_cptcn,
							cdgo_ips			=	IsNull(Ltrim(Rtrim(b.cdgo_intrno)),'')
				From		@tmpCapitacionContrato									a
				Inner Join	bdipsparametros.dbo.tbModeloConveniosCapitacion	m	With(NoLock)	On	m.cdgo_mdlo_cnvno_cptcn		=	a.cdgo_cnvno
				Inner Join	bdipsparametros.dbo.tbAsociacionModeloActividad			b	With(NoLock)	On	b.cnsctvo_mdlo_cnvno_pln	=	m.cnsctvo_cdgo_mdlo_cnvno_cptcn
				Where 		b.inco_vgnca <= @fcha_vldcn
				And			b.fn_vgnca >= @fcha_vldcn
				And			b.cnsctvo_cdgo_tpo_mdlo IN (4,10)

				Update		@tmpCapitacionContrato
				Set			nmro_idntfccn_ips	=	c.nmro_idntfccn
				From		@tmpCapitacionContrato						a
				Inner Join	bdipsparametros.dbo.tbDireccionesPrestador	b	With(NoLock)	On	b.cdgo_intrno				=	a.cdgo_ips
				Inner Join	bdipsparametros.dbo.tbPrestadores			c	With(NoLock)	On	c.nmro_unco_idntfccn_prstdr	=	b.nmro_unco_idntfccn_prstdr
			end
		else
			begin
				Update		@tmpCapitacionContrato
				Set			cdgo_ips		=	IsNull(Ltrim(Rtrim(b.cdgo_intrno)),''),
							dscrpcn_cnvno	=	m.dscrpcn_mdlo_cnvno_cptcn
				From		@tmpCapitacionContrato						a
				Inner Join	bdsisalud.dbo.tbModeloConveniosCapitacion	m	With(NoLock)	On	m.cdgo_mdlo_cnvno_cptcn		=	a.cdgo_cnvno
				Inner Join	bdsisalud.dbo.tbAsociacionModeloActividad	b	With(NoLock)	On	b.cnsctvo_mdlo_cnvno_pln	=	m.cnsctvo_cdgo_mdlo_cnvno_cptcn
				Where 		b.inco_vgnca <= @fcha_vldcn
				And			b.fn_vgnca >= @fcha_vldcn
				And			b.cnsctvo_cdgo_tpo_mdlo IN (4,10)

				Update		@tmpCapitacionContrato
				Set			nmro_idntfccn_ips	=	c.nmro_idntfccn
				From		@tmpCapitacionContrato					a
				Inner Join	bdsisalud.dbo.tbDireccionesPrestador	b	With(NoLock)	On	b.cdgo_intrno				=	a.cdgo_ips
				Inner Join	bdsisalud.dbo.tbPrestadores				c	With(NoLock)	On	c.nmro_unco_idntfccn_prstdr	=	b.nmro_unco_idntfccn_prstdr
			end
	end
-----------DESPLIEGA LA TABLA
SELECT		dscrpcn_cnvno,				estado,				dscrpcn_ips,					cdgo_cnvno,					capitado,
       		fcha_crte,					cdgo_cdd,			dscrpcn_cdd,					cdgo_ips,					cnsctvo_cdgo_cdd,
			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_bnfcro,					nmro_idntfccn_ips
FROM		@tmpCapitacionContrato


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [at3047_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmConsultaDetConveniosCapitacionAfiliado] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

