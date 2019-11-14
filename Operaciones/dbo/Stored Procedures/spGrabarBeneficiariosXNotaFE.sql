
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  spGrabarBeneficiariosXNotaFE
* Desarrollado por	: <\A Francisco E. Riaño L. - Qvision S.A	A\>
* Descripcion		: <\D Este procedimiento graba una nota debito/Credito de facturación eléctronica
						 para los Beneficiarios D\>
* Observaciones		: <\O	O\>
* Parametros		: <\P	P\>
* Variables			: <\V  	V\>
* Fecha Creacion	: <\FC 2019-08-22	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM	FM\>
*---------------------------------------------------------------------------------

*/

CREATE  PROCEDURE [dbo].[spGrabarBeneficiariosXNotaFE] (
	@nmro_nta			        Varchar(15),
	@TipoNota			        udtConsecutivo,
	@lcUsuario					udtUsuario,
	@cnsctvo_cdgo_prdo_lqdcn    int
)
As 
Begin
	Set Nocount On;

	Declare		@ldFechaSistema				Datetime = Getdate(),
				@Valor_Porcentaje_Iva		udtValorDecimales =	0,
				@ldFechaEvaluarPeriodo		Datetime,
				@lnConsecutivoDocumento		udtConsecutivo,
				@lnConsecutivoTipoDocumento	udtConsecutivo,
				@lnConceptoLiquidacionIva	udtConsecutivo = 3;

	Select  @ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
	From	dbo.tbPeriodosliquidacion_Vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn
	And		@ldFechaSistema between inco_vgnca and fn_vgnca

	-- trae el valor del porcentaje  para aplicar
	Select 	@Valor_Porcentaje_Iva		=	prcntje
	From	dbo.tbconceptosliquidacion_vigencias with(nolock)
	where   cnsctvo_cdgo_cncpto_lqdcn	=	@lnConceptoLiquidacionIva
	And		@ldFechaEvaluarPeriodo  between inco_vgnca	and fn_vgnca

	If  @Valor_Porcentaje_Iva	=	0
    Begin 
		Return -1
	end	

	Begin Tran
	
		Insert	Into dbo.tbNotasBeneficiariosContratos
		(
			cnsctvo_nta_cncpto 
			,cnsctvo_nta_cntrto
			,nmro_unco_idntfccn_bnfcro
			,vlr_nta_bnfcro
			,vlr_iva
			,obsrvcns
			,fcha_crcn
			,usro_crcn
			,cnsctvo_dcmnto
			,cnsctvo_cdgo_tpo_dcmnto
		)
		Select		c.Cnsctvo_nta_cncpto,
					b.cnsctvo_nta_cntrto,
 					a.nmro_unco_idntfccn_bnfcro,
					isnull(convert(numeric(12,0), (a.valor * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
					isnull(convert(numeric(12,0), (a.valor * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),  --saldo a nivel de contrato
					null,
					@ldFechaSistema, 
					@lcUsuario,
					h.cnsctvo_estdo_cnta,
					h.cnsctvo_cdgo_tpo_dcmnto_orgn
		From		#tmpGrabarBeneficiariosXNota a 		    
		Inner Join	dbo.tbNotasContrato b with(nolock)
			On		a.nmro_cntrto = b.nmro_cntrto 
		Inner Join	dbo.tbNotasConceptos c with(nolock)
			On		b.nmro_nta = c.nmro_nta
			and		b.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta
			and		a.cnsctvo_cdgo_cncpto_lqdcn = c.cnsctvo_cdgo_cncpto_lqdcn
		Inner Join	dbo.tbNotasPac h with(nolock)
			On		h.nmro_nta = b.nmro_nta
			And		h.cnsctvo_cdgo_tpo_nta = b.cnsctvo_cdgo_tpo_nta
		Where		b.nmro_nta = @nmro_nta
		  and		b.cnsctvo_cdgo_tpo_nta = @TipoNota
		  and		a.valor > 0

		If  @@Error!=0
		Begin
			Rollback Tran
			Return -1
		End

	Commit tran
End