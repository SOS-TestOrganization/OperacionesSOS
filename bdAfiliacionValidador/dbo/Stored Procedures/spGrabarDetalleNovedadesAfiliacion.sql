

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   spGrabarDetalleNovedadesAfiliacion
* Desarrollado por		 :  <\A    Ing. Francisco J. Gonzalez R.   									A\>
* Descripcion			 :  <\D  Permite Grabar los detalles de la novedad nueva o sus cambios		D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P   													P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2002/02/08											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM    				AM\>
* Descripcion			 : <\DM   						DM\>
* Nuevos Parametros	 	 : <\PM  	PM\>
* 				 : <\PM   			PM\>
* Nuevas Variables		 : <\VM   						VM\>
* Fecha Modificacion		 : <\FM  		 			FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE spGrabarDetalleNovedadesAfiliacion
@cConsecutivoNovedad		udtNumeroFormulario,
@nConsecutivoTipoNovedad		udtConsecutivo,
@nConsecutivoCausaNovedad		udtConsecutivo,
@nConsecutivoSubCausaNovedad	udtConsecutivo,
@cNumeroUnicoIdentificacion		udtConsecutivo,
@nConsecutivoClaseAportante		udtConsecutivo,
@nConsecutivoTipoContrato		udtConsecutivo,
@cNumeroContrato			udtNumeroFormulario,
@cUsuario				udtUsuario,
@lcAccion				udtLogico,
@nConsecutivoEstado			udtConsecutivo=null,
@lnError				udtConsecutivo				=Null Output

AS

Set nocount On

Declare @nConsecutivoDetalleNovedad		udtConsecutivo,
	@nConsecutivoConceptoAfecatodo	udtConsecutivo,
	@nConsecutivoIdentificadorUno		udtConsecutivo,
	@nConsecutivoIdentificadorDos		udtConsecutivo,
	@cEstadoRegistro			udtLogico,
	@cUsuarioUltimaModificacion		udtUsuario,
	@nConsecutivoValorDetalle		udtConsecutivo,
	@nConsecutivoCampo			udtConsecutivo,
	@cValorNuevo				varchar(250),
	@nConsecutivoEstadoNovedad 		udtConsecutivo,
	@nConsecutivoRol			udtConsecutivo,
	@nConsecutivoRolNovedad 		udtConsecutivo 
	

Set	@lnError			= 	0


Begin Tran

	
--Calcula el maximo consecutivo en tbDetallesNovedad
Select 	@nConsecutivoDetalleNovedad = Max(cnsctvo_dtlle_nvdd) 
From tbDetallesNovedad 
Where 	cnsctvo_nvdd	=	@cConsecutivoNovedad

--Incrementa el consecutivo del detalle Novedad
If @nConsecutivoDetalleNovedad is Null
	Set @nConsecutivoDetalleNovedad	= 1
Else
	Set @nConsecutivoDetalleNovedad	= @nConsecutivoDetalleNovedad + 1

If @nConsecutivoTipoNovedad != 0
Begin
--Inactiva los Detalles Anterios
	Update tbDetallesNovedad
	Set estdo_rgstro	= 'I'
	Where cnsctvo_nvdd = @cConsecutivoNovedad
	And estdo_rgstro	= 'A' 

--Inserta el nuevo detalle novedad
	INSERT INTO tbDetallesNovedad 
		(cnsctvo_dtlle_nvdd,	 	cnsctvo_nvdd,			cnsctvo_cdgo_tpo_nvdd,
		 cnsctvo_cdgo_csa_nvdd,	cnsctvo_cdgo_sb_csa_nvdd, 	nmro_unco_idntfccn,
		 cnsctvo_cdgo_clse_aprtnte,	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto)
		 VALUES
		(@nConsecutivoDetalleNovedad,	@cConsecutivoNovedad,		@nConsecutivoTipoNovedad,
		@nConsecutivoCausaNovedad,	@nConsecutivoSubCausaNovedad,	@cNumeroUnicoIdentificacion,
		@nConsecutivoClaseAportante,	@nConsecutivoTipoContrato,		@cNumeroContrato)
	
	If  @@error != 0 -- OR @@Rowcount = 0	
	Begin
		Set @lnError = 1
		RollBack Tran 
		Return 	-1
	End	
End

--> Crea la tabla Temporal  #tmpConceptoAfectados  donde se guardan los Registros de los conceptos agrupados por empresa, clase Aportante y sucursal
Create Table #tmpConceptoAfectados
	(cnsctvo_cncpto_afctdo_tmprl	udtConsecutivo IDENTITY(1,1),		nmro_unco_idntfccn_ctznte		udtNumeroIdentificacionLargo,
	 cnsctvo_cdgo_tpo_cntrto 	udtConsecutivo,				nmro_cntrto				udtNumeroFormulario,	 
	 cnsctvo_idntfccdr_uno		udtNumeroIdentificacionLargo,		nmro_unco_idntfccn_bnfcro		udtNumeroIdentificacionLargo,
	cnsctvo_cdgo_cncpto		udtConsecutivo )			


-->Inserta en la Tabla Temporal #tmpConceptoAfectados  los conceptos agrupados por empresa, clase Aportante y sucursal
Insert Into	#tmpConceptoAfectados 	
			(nmro_unco_idntfccn_ctznte,	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_idntfccdr_uno,
			 nmro_unco_idntfccn_bnfcro,	cnsctvo_cdgo_cncpto)
Select Distinct 	 nmro_unco_idntfccn_ctznte,	cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_idntfccdr_uno,
  		 nmro_unco_idntfccn,		cnsctvo_cdgo_cncpto
From	#tmpDetallesNovedadGlobal	


Select 	@nConsecutivoConceptoAfecatodo = Max(cnsctvo_cncpto_afctdo) From tbConceptosAfectados 
Where 	cnsctvo_nvdd		=	@cConsecutivoNovedad
And	cnsctvo_dtlle_nvdd	=	@nConsecutivoDetalleNovedad

--Si el consecutivo se Nulo se le asigna el valor de cero 0
Set @nConsecutivoConceptoAfecatodo = ISNULL(@nConsecutivoConceptoAfecatodo,0)


--Crea una tabla temporal con los consecutivo finales
Select 	cnsctvo_cncpto_afctdo_tmprl + @nConsecutivoConceptoAfecatodo	As cnsctvo_cncpto_afctdo,
	@nConsecutivoDetalleNovedad						As cnsctvo_dtlle_nvdd,						
	@cConsecutivoNovedad						As cnsctvo_nvdd,
	nmro_unco_idntfccn_bnfcro						As nmro_unco_idntfccn,	
	cnsctvo_idntfccdr_uno,
	0									As cnsctvo_idntfccdr_ds,
 	'A'									As estdo_rgstro,
	GetDate()								As fcha_ultma_mdfccn,
	@cUsuario								As usro_ultma_mdfccn,
	nmro_unco_idntfccn_ctznte,
	cnsctvo_cdgo_tpo_cntrto,
	nmro_cntrto,
	cnsctvo_cdgo_cncpto
Into #tmpConceptoAfectadosFinal
From #tmpConceptoAfectados


--Inactiva los Conceptos afectados Anterios
Update tbConceptosAfectados
Set estdo_rgstro	= 'I'
Where cnsctvo_nvdd = @cConsecutivoNovedad
And estdo_rgstro	= 'A' 

--Inserta los conceptos afectados del detalle novedad
Insert Into tbConceptosAfectados 
	(cnsctvo_cncpto_afctdo,		cnsctvo_dtlle_nvdd,		cnsctvo_nvdd,
	nmro_unco_idntfccn, 		cnsctvo_idntfccdr_uno, 		cnsctvo_idntfccdr_ds,
	estdo_rgstro, 			fcha_ultma_mdfccn, 		usro_ultma_mdfccn,
	cnsctvo_cdgo_cncpto)
Select	cnsctvo_cncpto_afctdo,		cnsctvo_dtlle_nvdd,		cnsctvo_nvdd,
	nmro_unco_idntfccn, 		cnsctvo_idntfccdr_uno, 		cnsctvo_idntfccdr_ds,
	estdo_rgstro, 			fcha_ultma_mdfccn, 		usro_ultma_mdfccn,
	cnsctvo_cdgo_cncpto
From #tmpConceptoAfectadosFinal

If  @@error != 0 -- OR @@Rowcount = 0	
Begin
	--Elimnia la tabla temporal
	Drop Table #tmpConceptoAfectados

	Set @lnError = 1
	RollBack Tran 
	Return 	-1
End	

--Elimnia la tabla temporal
Drop Table #tmpConceptoAfectados


--> Crea la tabla Temporal  #tmpValoresConceptosAfectados  donde se guardan los Registros de los conceptos agrupados por empresa, clase Aportante y sucursal
Create Table #tmpValoresConceptosAfectados
	(cnsctvo_vlr_dtlle_tmprl		udtConsecutivo IDENTITY(1,1),	cnsctvo_cncpto_afctdo		udtConsecutivo, 
	 cnsctvo_nvdd			udtNumeroFormulario,		cnsctvo_dtlle_nvdd		udtConsecutivo,
	 cnsctvo_cmpo			udtConsecutivo,			vlr_nvo				varchar(250),
	 dscrpcn_vlr_nvo		udtDescripcion,			cnsctvo_cmpo_agrpdr		udtConsecutivo,
	 vlr_nvo_agrpdr			varchar(50),			cnsctvo_cdgo_cncpto		udtConsecutivo,
	 cnsctvo_cdgo_agrpdr_cmpo	udtConsecutivo,			agrpdr_vlrs			udtConsecutivo,
	 sb_agrpdr_vlrs			udtConsecutivo,			cnsctvo_idntfcdr_rgstro		udtConsecutivo)			

-->Inserta en la Tabla Temporal #tmpValoresConceptosAfectados  los conceptos agrupados por empresa, clase Aportante y sucursal
Insert Into	#tmpValoresConceptosAfectados
	(cnsctvo_cncpto_afctdo,		cnsctvo_nvdd,			cnsctvo_dtlle_nvdd,	cnsctvo_cmpo,		
	vlr_nvo,				dscrpcn_vlr_nvo,		cnsctvo_cmpo_agrpdr,	vlr_nvo_agrpdr,
	cnsctvo_cdgo_cncpto,		cnsctvo_cdgo_agrpdr_cmpo,	agrpdr_vlrs,		sb_agrpdr_vlrs,
	cnsctvo_idntfcdr_rgstro)
Select	Distinct b.cnsctvo_cncpto_afctdo,	b.cnsctvo_nvdd	,		b.cnsctvo_dtlle_nvdd,		a.cnsctvo_cmpo, 	
		a.vlr_nvo,			a.dscrpcn_vlr_nvo,		a.cnsctvo_cmpo_agrpdr,		a.vlr_nvo_agrpdr,
		a.cnsctvo_cdgo_cncpto,		a.cnsctvo_cdgo_agrpdr_cmpo,	a.agrpdr_vlrs,			a.sb_agrpdr_vlrs,
		a.cnsctvo_idntfcdr_rgstro
From	#tmpDetallesNovedadGlobal a, #tmpConceptoAfectadosFinal b
Where	a.nmro_unco_idntfccn_ctznte	=	b.nmro_unco_idntfccn_ctznte
And	a.cnsctvo_cdgo_tpo_cntrto	= 	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_idntfccdr_uno		=	b.cnsctvo_idntfccdr_uno
And	a.cnsctvo_cdgo_cncpto		=	b.cnsctvo_cdgo_cncpto


--Inactiva los Valores Conceptos Afectados Anterios
Update tbValoresConceptosAfectados
Set estdo_rgstro	= 'I'
Where cnsctvo_nvdd = @cConsecutivoNovedad
And estdo_rgstro	= 'A' 

--Inserta los Nuevos conceptos afectados
Declare
@nConsecutivoConcepto			udtConsecutivo,
@nConsecutivoDetalleNovedades		udtConsecutivo,
@nConsecutivoCampoAgrupador		udtConsecutivo,
@cValorNuevoAgrupador			varchar(50),
@cDescripcionValorNuevo			udtDescripcion,
@nConsecutivoCodigoAgrupadorCampo	udtConsecutivo,
@nAgrupadorValores			udtConsecutivo,
@nSubAgrupadorValores			udtConsecutivo,
@nConsecutivoIdentificadorRegistro	udtConsecutivo,
@nMaximoDetalle				udtConsecutivo
	
DECLARE crValoresConceptosAfectados CURSOR FOR 
Select	cnsctvo_cncpto_afctdo, 		cnsctvo_dtlle_nvdd, 		cnsctvo_cmpo,
	vlr_nvo, 			dscrpcn_vlr_nvo, 		cnsctvo_cmpo_agrpdr, 
	vlr_nvo_agrpdr, 		cnsctvo_cdgo_agrpdr_cmpo,	agrpdr_vlrs, 
	sb_agrpdr_vlrs, 		cnsctvo_idntfcdr_rgstro
From #tmpValoresConceptosAfectados

OPEN crValoresConceptosAfectados
FETCH NEXT FROM crValoresConceptosAfectados
INTO	@nConsecutivoConcepto, 		@nConsecutivoDetalleNovedades, 	@nConsecutivoCampo,
	@cValorNuevo, 			@cDescripcionValorNuevo, 	@nConsecutivoCampoAgrupador,
	@cValorNuevoAgrupador, 		@nConsecutivoCodigoAgrupadorCampo, @nAgrupadorValores, 
	@nSubAgrupadorValores,		@nConsecutivoIdentificadorRegistro


WHILE @@FETCH_STATUS = 0
BEGIN
--Inserta los Nuevos conceptos afectados

	INSERT INTO tbValoresConceptosAfectados 
		(cnsctvo_vlr_dtlle,		cnsctvo_cncpto_afctdo,		cnsctvo_nvdd,
		 cnsctvo_dtlle_nvdd,		cnsctvo_cmpo,			vlr_nvo,
		 estdo_rgstro,			dscrpcn_vlr_nvo,		cnsctvo_cmpo_agrpdr,
		 vlr_nvo_agrpdr,		cnsctvo_cdgo_agrpdr_cmpo,	agrpdr_vlrs,
		 sb_agrpdr_vlrs,		cnsctvo_idntfcdr_rgstro)
		Select	bdAfiliacion.dbo.fnCalcularMaximoConsecutivoValorDetalle (@cConsecutivoNovedad,  @nConsecutivoDetalleNovedades, @nConsecutivoConcepto),
			@nConsecutivoConcepto,		@cConsecutivoNovedad,		@nConsecutivoDetalleNovedades,
			@nConsecutivoCampo,		@cValorNuevo,			'A',
			@cDescripcionValorNuevo,	@nConsecutivoCampoAgrupador,	@cValorNuevoAgrupador,	@nConsecutivoCodigoAgrupadorCampo,
			@nAgrupadorValores,		@nSubAgrupadorValores,		@nConsecutivoIdentificadorRegistro

	If  @@error != 0  --OR @@Rowcount = 0	
	Begin
		CLOSE crValoresConceptosAfectados
		DEALLOCATE crValoresConceptosAfectados
		Set @lnError = 1
		RollBack Tran 
		Return 	-1
	End	

	FETCH NEXT FROM crValoresConceptosAfectados
	INTO	@nConsecutivoConcepto, 		@nConsecutivoDetalleNovedades, 	@nConsecutivoCampo,
		@cValorNuevo, 			@cDescripcionValorNuevo, 	@nConsecutivoCampoAgrupador,
		@cValorNuevoAgrupador, 		@nConsecutivoCodigoAgrupadorCampo, @nAgrupadorValores, 
		@nSubAgrupadorValores,		@nConsecutivoIdentificadorRegistro
END

CLOSE crValoresConceptosAfectados
DEALLOCATE crValoresConceptosAfectados

--INSERT INTO tbValoresConceptosAfectados 
--	(cnsctvo_vlr_dtlle,		cnsctvo_cncpto_afctdo,		cnsctvo_nvdd,
--	 cnsctvo_dtlle_nvdd,		cnsctvo_cmpo,			vlr_nvo,
--	 estdo_rgstro,			dscrpcn_vlr_nvo,		cnsctvo_cmpo_agrpdr,	
--	 vlr_nvo_agrpdr,			cnsctvo_cdgo_agrpdr_cmpo,	agrpdr_vlrs,
--	 sb_agrpdr_vlrs,			cnsctvo_idntfcdr_rgstro)
--	Select	bdAfiliacion.dbo.fnCalcularMaximoConsecutivoValorDetalle (b.cnsctvo_nvdd,  b.cnsctvo_dtlle_nvdd, b.cnsctvo_cncpto_afctdo),
--		b.cnsctvo_cncpto_afctdo,		b.cnsctvo_nvdd,		b.cnsctvo_dtlle_nvdd,
--		b.cnsctvo_cmpo,			b.vlr_nvo,			'A',
--		b.dscrpcn_vlr_nvo,			b.cnsctvo_cmpo_agrpdr,		b.vlr_nvo_agrpdr,	cnsctvo_cdgo_agrpdr_cmpo,
--		b.agrpdr_vlrs,				b.sb_agrpdr_vlrs,		b.cnsctvo_idntfcdr_rgstro
--	From #tmpValoresConceptosAfectados b

--If  @@error != 0  --OR @@Rowcount = 0	
--Begin
--	Set @lnError = 1
--	RollBack Tran 
--	Return 	-1
--End	

Drop Table #tmpValoresConceptosAfectados
Drop Table #tmpConceptoAfectadosFinal


--Graba los documentos soporte de la novedad
--Exec spGrabarDocumentosSoportexBeneficiarioNovedades		@lcAccion,
--									@cConsecutivoNovedad,
--									@nConsecutivoDetalleNovedad 
--If @@Error !=0 
--	Begin 
--		Set @lnError = 1
--		Rollback Transaction 
--		Return 	-1
--	End 


-- Grabar el Estado de la Novedad.
	Exec spGrabarEstadosNovedad	@cConsecutivoNovedad,
					@cUsuario,
					@nConsecutivoEstado,
					@nConsecutivoEstadoNovedad Output,
					@lnError Output
	
	If  @lnError != 0	Or	 @@Error !=0 
	Begin
		rollback tran
             		Return -1
	End


--Graba en roles x novedad
	if @nConsecutivoEstadoNovedad=2
	   set @nConsecutivoRol=2
	else
	   set @nConsecutivoRol=6	

	Exec spGrabarRolNovedad	@cConsecutivoNovedad, 
					@cUsuario,
					@nConsecutivoRol,
					@nConsecutivoRolNovedad Output, 
					@lnError Output
	
	If  @lnError != 0	Or	 @@Error !=0 
	Begin
		rollback tran
             		Return -1
	End


	Update  tbNovedades
	Set	cnsctvo_rl_nvdd			=	@nConsecutivoRolNovedad,
		cnsctvo_cdgo_estdo_nvdd	=	@nConsecutivoEstadoNovedad
	From 	tbNovedades a
	Where 	a.cnsctvo_nvdd			= 	@cConsecutivoNovedad

	If  @@Error!=0
	Begin
		rollback tran
             		Return -1
	end
Commit tran