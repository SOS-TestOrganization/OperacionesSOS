
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCalcularDatosFExNotaPAC
* Desarrollado por	: <\A Ing. Maria Janeth Barrera Vasquez			A\>
* Descripcion		: <\D este procedimiento para calcular los datos cadena QR, CIUUD, 
						estado documento fe y concepto Dian			D\>
* Observaciones		: <\O  O\>
* Parametros		: <\P @cnsctvo_cdgo_tpo_nta (Tipo nota), 
						  @nmro_nta (Numero de la nota)				P\>				 
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019/07/31	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por		: <\AM  Francisco E. Riaño - Qvision S.A AM\>
* Descripcion			: <\DM Ajustes de buenas practicas DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2019-07-31  FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spCalcularDatosFExNotaPAC] (
		@cnsctvo_cdgo_tpo_nta	int,
		@nmro_nta				int
)
As
Begin

	Set NoCount On;

	Declare		@lnValorNota									int, 
				@lnValorFactura									int,
				@ldFechaSistema									datetime		= getdate(),
				@lcNitEmisorDefault								varchar(15)		= '805001157',
				@lcCodigoImpuesto2_default						varchar(2)		= '02',
				@lcValorImpuesto2_defatult						varchar(15)		= '0.00',
				@lcCodigoImpuesto3_default						varchar(2)		= '03',
				@lcValorImpuesto3_defatult						varchar(15)		= '0.00',
				@lnConsecutivoCodigoEstadoDocumentoFeIngresado	udtConsecutivo	= 1,
				@lnConsecutivoCodigoTipoNotaCredito				udtConsecutivo	= 2,
				@lnConsecutivoCodigoTipoNotaDebito				udtConsecutivo	= 1,
				@lnConsecutivoCodigoTipoNotaSaldoFavor			udtConsecutivo	= 3,
				@lnConsecutivoCodigoConceptoDianAnulacion		udtConsecutivo	= 5,
				@lnConsecutivoCodigoConceptoDianOtros			udtConsecutivo	= 9,
				@lnConsecutivoCodigoConceptoDianGastosxCobrar	udtConsecutivo	= 2;

	--Se realiza la actualizacion campo CUFE
	Create Table #tmpParametrosRecibidosCufe
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   FecFac varchar(30),
		   ValFac varchar(30),
		   CodImp1 varchar(10),
		   ValImp1 varchar(30),
		   CodImp2 varchar(10),
		   ValImp2 varchar(30),
		   CodImp3 varchar(10),
		   ValImp3 varchar(30),
		   ValImp varchar(30),
		   NitOFE varchar(30),
		   TipAdq varchar(10),
		   NumAdq varchar(30),
		   CITec varchar(250)
	);

	Create Nonclustered Index IX_#tmpParametrosRecibidosCufe 
		on #tmpParametrosRecibidosCufe
    (
			NumFac
	)

	Insert	#tmpParametrosRecibidosCufe
	(
			NmroCnta,
			NumFac,								   
			FecFac,									
			ValFac,
			CodImp1,								
			ValImp1,								
			CodImp2,
			ValImp2,								
			CodImp3,								
			ValImp3,
			ValImp,									
			NitOFE,									
			TipAdq,
			NumAdq,									
			CITec			
	)
	Select		np.nmro_nta,
				convert(varchar,np.nmro_nta), --NUMFAC
				Format(np.Fcha_crcn_nta,'yyyyMMddhhmmss'), -- FECFAC
				np.vlr_nta, -- VALFAC
				b.cdgo_rslcn_dn, --CODIMP1
				np.vlr_iva, -- VALIMP1
				@lcCodigoImpuesto2_default, -- CODIMP2
				@lcValorImpuesto2_defatult, -- VALIMP2
				@lcCodigoImpuesto3_default, -- CODIMP3
				@lcValorImpuesto3_defatult, -- VALIMP3
				(np.vlr_nta +np.vlr_iva), -- VALIMP 
				@lcNitEmisorDefault, -- NitOFE
				d.cdgo_dn, -- TIPADQ
				rtrim(ltrim(c.nmro_idntfccn_empldr)), -- NUMADQ
				b.clve_tcnca_dn -- CITec
	From		dbo.tbNotasPAC											np With(NoLock)
	Inner Join  dbo.tbNotasEstadoCuenta									nec With(NoLock)
	   On       np.cnsctvo_cdgo_tpo_nta = nec.cnsctvo_cdgo_tpo_nta
	   And      np.nmro_nta				= nec.nmro_nta
	Inner Join  dbo.tbEstadosCuenta										a With(NoLock)
	   On       nec.cnsctvo_estdo_cnta  = a.cnsctvo_estdo_cnta
	Inner Join 	BDAfiliacionValidador.dbo.tbResolucionesDIAN_vigencias	b With(NoLock)
		On		b.cnsctvo_cdgo_rslcn_dn = a.cnsctvo_cdgo_rslcn_dn
	Inner Join  BDAfiliacionValidador.dbo.tbAportanteValidador			c With(NoLock)
		On		a.nmro_unco_idntfccn_empldr = c.nmro_unco_idntfccn_aprtnte
	Inner Join  BDCarteraPAC.dbo.tbCodigosDIAN_Vigencias				d With(NoLock)
		On		d.cnsctvo_cdgo_llve_sos = c.cnsctvo_cdgo_tpo_idntfccn_empldr
	Where		np.nmro_nta				= @nmro_nta 
    And			np.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta
	And         @ldFechaSistema Between b.inco_vgnca And b.fn_vgnca
	And			@ldFechaSistema Between d.inco_vgnca And d.fn_vgnca
	And			d.cnsctvo_cdgo_tpo_cdgo_dn = 1

	Create Table #tmpCUFEGenerado
	(
		   NmroCnta varchar(15),
		   NumFac varchar(30),
		   CUFE varchar(250),
		   cCUFE varchar(250),
	)

	Insert	#tmpCUFEGenerado
	(
		   NmroCnta,
		   NumFac, 
		   CUFE,
		   cCUFE
	) 
	
	Exec	bdafiliacionvalidador.dbo.spFEGenerarCUFE;

	--  Si la nota es credito se recupera valor de la nota y factura 
	If @cnsctvo_cdgo_tpo_nta = @lnConsecutivoCodigoTipoNotaCredito
	Begin
		Select		@lnValorNota	= (np.vlr_nta + np.vlr_iva), 
					@lnValorFactura = (a.ttl_fctrdo + a.vlr_iva)
		From		dbo.tbNotasPAC			np With(NoLock)
		Inner Join  dbo.tbNotasEstadoCuenta nec With(NoLock)
			On      np.cnsctvo_cdgo_tpo_nta = nec.cnsctvo_cdgo_tpo_nta
			And     np.nmro_nta				= nec.nmro_nta
		Inner Join  dbo.tbEstadosCuenta		a With(NoLock)
			On		nec.cnsctvo_estdo_cnta  = a.cnsctvo_estdo_cnta
		Where       np.nmro_nta				= @nmro_nta 
		And			np.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta
	End

   -- El concepto dian de la nota depende del tipo de nota y del valor de la misma
   Update		np 
   Set			cnsctvo_cdgo_estdo_dcmnto_fe  = @lnConsecutivoCodigoEstadoDocumentoFeIngresado,   
				cnsctvo_cdgo_cncpto_dn = Case 
											When @cnsctvo_cdgo_tpo_nta = @lnConsecutivoCodigoTipoNotaCredito And  @lnValorNota = @lnValorFactura Then @lnConsecutivoCodigoConceptoDianAnulacion   
											When @cnsctvo_cdgo_tpo_nta = @lnConsecutivoCodigoTipoNotaCredito And  @lnValorNota != @lnValorFactura Then @lnConsecutivoCodigoConceptoDianOtros	
											When @cnsctvo_cdgo_tpo_nta = @lnConsecutivoCodigoTipoNotaDebito Then @lnConsecutivoCodigoConceptoDianGastosxCobrar
											Else  @lnConsecutivoCodigoConceptoDianOtros 
										  End,   
				cuuid = t.CUFE
   	From		dbo.tbNotasPAC				np 
	Inner Join  dbo.tbNotasEstadoCuenta		nec With(NoLock)
		On      np.cnsctvo_cdgo_tpo_nta = nec.cnsctvo_cdgo_tpo_nta
	   And      np.nmro_nta				= nec.nmro_nta
	Inner Join  dbo.tbEstadosCuenta			a With(NoLock)
		On      nec.cnsctvo_estdo_cnta  = a.cnsctvo_estdo_cnta
	Inner Join	#tmpCUFEGenerado			t
		On		t.NmroCnta				= np.nmro_nta
	Where       np.nmro_nta				= @nmro_nta 
	And			np.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta

	-- Se genera el codigo QR a partir de la informacion del cufe	
    Update		a
	Set			cdna_qr = concat('NumFac:',ltrim(rtrim(t.NumFac)),' ','FecFac:',ltrim(rtrim(t1.FecFac)),' ','NitFac:',ltrim(rtrim(t1.NitOFE)),' ','DocAdq:',ltrim(rtrim(t1.NumAdq)),' ','ValFac:',ltrim(rtrim(t1.ValFac)),' ','ValIva:',ltrim(rtrim(t1.ValImp1)),' ','ValOtroIm:','0.00',' ','ValFacIm:',ltrim(rtrim(t1.ValImp)),' ','CUFE:',t.cufe)
	From		dbo.tbNotasPAC				a 
	Inner Join	#tmpCUFEGenerado			t
		On		t.NmroCnta = a.nmro_nta
	Inner join  #tmpParametrosRecibidosCufe t1
		On      t.NumFac = t1.NumFac
    Where		a.nmro_nta = @nmro_nta 
    And			a.cnsctvo_cdgo_tpo_nta = @cnsctvo_cdgo_tpo_nta

End
  
