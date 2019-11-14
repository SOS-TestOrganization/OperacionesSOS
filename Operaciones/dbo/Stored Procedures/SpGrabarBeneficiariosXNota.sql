
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpGrabarBeneficiariosXNota
* Desarrollado por	: <\A Jairo Valencia			A\>
* Descripcion		: <\D Este procedimiento graba una nota debitoCredito para los Beneficiarios D\>
* Observaciones		: <\O  							O\>
* Parametros		: <\P							P\>
* Variables		: <\V  							V\>
* Fecha Creacion	: <\FC 	24/05/2013				FC\>
*---------------------------------------------------------------------------------*/


create  PROCEDURE [dbo].[SpGrabarBeneficiariosXNota]
@nmro_nta			        Varchar(15),
@TipoNota			        udtConsecutivo,
@lcUsuario					udtUsuario,
@cnsctvo_cdgo_prdo_lqdcn    int

As Declare
@ldFechaSistema				Datetime,
@Valor_Porcentaje_Iva		udtValorDecimales,
@ldFechaEvaluarPeriodo		Datetime

Set Nocount On

Set @ldFechaSistema			= Getdate()
Set	@Valor_Porcentaje_Iva		=	0

select  @ldFechaEvaluarPeriodo = fcha_incl_prdo_lqdcn 
From	bdCarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_prdo_lqdcn = @cnsctvo_cdgo_prdo_lqdcn

-- trae el valor del porcentaje  para aplicar
Select 	@Valor_Porcentaje_Iva		=	prcntje
From	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias
where   cnsctvo_cdgo_cncpto_lqdcn	=	3
And	@ldFechaEvaluarPeriodo  between inco_vgnca	and 	fn_vgnca

 If  @Valor_Porcentaje_Iva	=	0
    Begin 
	 Return -1
	end	

Begin Tran

 Insert	Into bdCarteraPac.dbo.tbNotasBeneficiariosContratos
		(cnsctvo_nta_cncpto 
		 ,cnsctvo_nta_cntrto
		 ,nmro_unco_idntfccn_bnfcro
		 ,vlr_nta_bnfcro
		 ,vlr_iva
		 ,obsrvcns
		 ,fcha_crcn
		 ,usro_crcn
		 )
	Select	c.Cnsctvo_nta_cncpto,
			b.cnsctvo_nta_cntrto,
 		    a.nmro_unco_idntfccn_bnfcro,
            isnull(convert(numeric(12,0), (a.valor * 100))    / convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),
			isnull(convert(numeric(12,0), (a.valor * @Valor_Porcentaje_Iva)) /  convert(numeric(12,0), (100 + @Valor_Porcentaje_Iva )),0),  --saldo a nivel de contrato
			null, @ldFechaSistema, @lcUsuario
	From	#tmpGrabarBeneficiariosXNota a,bdCarteraPac.dbo.tbNotasContrato b,tbNotasConceptos C
	Where	a.nmro_cntrto = b.nmro_cntrto
	  and   b.nmro_nta = @nmro_nta
	  and   b.cnsctvo_cdgo_tpo_nta = @TipoNota
	  and   b.nmro_nta = c.nmro_nta
	  and   b.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta
	  and   a.cnsctvo_cdgo_cncpto_lqdcn = c.cnsctvo_cdgo_cncpto_lqdcn
	  and   a.valor > 0


	If  @@Error!=0
	Begin
		Rollback Tran
		Return -1
	End

Commit tran
