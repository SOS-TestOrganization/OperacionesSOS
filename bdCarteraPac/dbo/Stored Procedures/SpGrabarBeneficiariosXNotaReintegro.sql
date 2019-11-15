
/*---------------------------------------------------------------------------------
* Metodo o PRG		:  SpGrabarBeneficiariosXNotaReintegro
* Desarrollado por	: <\A Jairo Valencia			A\>
* Descripcion		: <\D Este procedimiento graba una nota debitoCredito para los Beneficiarios D\>
* Observaciones		: <\O  							O\>
* Parametros		: <\P							P\>
* Variables		: <\V  							V\>
* Fecha Creacion	: <\FC 	24/05/2013				FC\>
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION  
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por		              : <\AM  Andres camelo (illustrato ltda) AM\>
* Descripcion			 : <\DM  Se modifica para consulta el iva que le corresponde a cada documento nota debito o estado de cuenta segun la fecha de creacion de estos,
 comparando estas fechas contra el rango en que este segun los campos inicio y fin vigencia de la tabla  tbConceptosLiquidacion_Vigencias   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM  2013/11/21   FM\>
*---------------------------------------------------------------------------------*/



CREATE  PROCEDURE [dbo].[SpGrabarBeneficiariosXNotaReintegro]
@nmro_nta			        Varchar(15),
@TipoNota			        udtConsecutivo,
@lcUsuario					udtUsuario,
@cnsctvo_cdgo_prdo_lqdcn    int = null

As Declare
@ldFechaSistema				Datetime

Set Nocount On

Set @ldFechaSistema			= Getdate()

Begin Tran

    -- calculamos el valor del iba que aplica a los estados de cuenta, basandose en la fecha de creacion contra las vigencia de la tabla parametro tbConceptosLiquidacion_Vigencias 
    update #tmpGrabarBeneficiariosXNota set iva =  d.prcntje 
    from #tmpGrabarBeneficiariosXNota a with (nolock)
    inner join  tbNotasContrato b with (nolock)
    on     (a.consecutivo_documento_origen  = b.cnsctvo_nta_cntrto)
    inner join tbnotasPac c with (nolock)
    on     (c.nmro_nta             =   b.nmro_nta
    and     c.cnsctvo_cdgo_tpo_nta  =  b.cnsctvo_cdgo_tpo_nta)
    inner join  tbConceptosLiquidacion_Vigencias d with (nolock)
    on     (d.cnsctvo_cdgo_cncpto_lqdcn	= 3 aND  c.fcha_crcn_nta Between d.inco_vgnca	And 	d.fn_vgnca)
    where  c.cnsctvo_cdgo_tpo_nta       = 1  --- nota debito 
    and   a.cnsctvo_cdgo_tpo_dcmnto     = 2  -- nota debito  

    -- calculamos el valor del iba que aplica a los estados de cuenta, basandose en la fecha de creacion contra las vigencia de la tabla parametro tbConceptosLiquidacion_Vigencias 
    update #tmpGrabarBeneficiariosXNota set iva =  d.prcntje 
    from #tmpGrabarBeneficiariosXNota a
    inner join  tbEstadosCuentaContratos b 
    on     (a.consecutivo_documento_origen  = b.cnsctvo_estdo_cnta_cntrto)
    inner join tbestadosCuenta c
    on     (b.cnsctvo_estdo_cnta = c.cnsctvo_estdo_cnta)
    inner join  tbConceptosLiquidacion_Vigencias d
    on     (d.cnsctvo_cdgo_cncpto_lqdcn	= 3 aND  c.Fcha_crcn Between d.inco_vgnca	And 	d.fn_vgnca)
    where  a.cnsctvo_cdgo_tpo_dcmnto     = 1  -- estado cuenta  



-- se insertan los registros de las notas debito 
Insert	Into bdCarteraPac.dbo.tbNotasBeneficiariosContratos
		(cnsctvo_nta_cncpto 
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
	Select	c.Cnsctvo_nta_cncpto,
			b.cnsctvo_nta_cntrto,
 		    a.nmro_unco_idntfccn_bnfcro,
            isnull(convert(numeric(12,0), (a.valor * 100))    / convert(numeric(12,0), (100 + a.iva )),0),
			isnull(convert(numeric(12,0), (a.valor * a.iva)) /  convert(numeric(12,0), (100 + a.iva )),0),  --saldo a nivel de contrato
			null, @ldFechaSistema, @lcUsuario,consecutivo_documento_origen,cnsctvo_cdgo_tpo_dcmnto
	From	#tmpGrabarBeneficiariosXNota a with (nolock)
    inner join tbNotasContrato b with (nolock)
    on   (a.nmro_cntrto = b.nmro_cntrto)
    inner join tbNotasConceptos c with (nolock)
    on    (b.nmro_nta = c.nmro_nta
    and   b.cnsctvo_cdgo_tpo_nta = c.cnsctvo_cdgo_tpo_nta
    and   a.cnsctvo_cdgo_cncpto_lqdcn = c.cnsctvo_cdgo_cncpto_lqdcn)
	Where  b.nmro_nta = @nmro_nta
	and   b.cnsctvo_cdgo_tpo_nta = @TipoNota
	and   a.valor > 0
    and   a.cnsctvo_cdgo_tpo_dcmnto  = 2  -- notas debito  
      

-- se insertan los registros de los estados de cuenta
Insert	Into bdCarteraPac.dbo.tbNotasBeneficiariosContratos
		(cnsctvo_nta_cncpto 
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
	Select	d.Cnsctvo_nta_cncpto,
			c.cnsctvo_nta_cntrto,
 		    a.nmro_unco_idntfccn_bnfcro,
            isnull(convert(numeric(12,0), (a.valor * 100))    / convert(numeric(12,0), (100 + a.iva )),0),
			isnull(convert(numeric(12,0), (a.valor * a.iva)) /  convert(numeric(12,0), (100 + a.iva )),0),  --saldo a nivel de contrato
			null, @ldFechaSistema, @lcUsuario,consecutivo_documento_origen,cnsctvo_cdgo_tpo_dcmnto
	From	#tmpGrabarBeneficiariosXNota a
    inner join tbEstadosCuentaContratos b with (nolock)
    on (a.consecutivo_documento_origen  = b.cnsctvo_estdo_cnta_cntrto)
    inner join tbNotasContrato c with (nolock)
    on  (a.nmro_cntrto = c.nmro_cntrto)
    inner join tbNotasConceptos d with (nolock)
    on ( c.nmro_nta                 = d.nmro_nta
    and  c.cnsctvo_cdgo_tpo_nta     = d.cnsctvo_cdgo_tpo_nta
    and a.cnsctvo_cdgo_cncpto_lqdcn = d.cnsctvo_cdgo_cncpto_lqdcn)
	Where c.nmro_nta                 = @nmro_nta
	and   c.cnsctvo_cdgo_tpo_nta     = @TipoNota
	and   a.valor                    > 0
    and   a.cnsctvo_cdgo_tpo_dcmnto  = 1  -- estados cuenta  



	If  @@Error!=0
	Begin
		Rollback Tran
		Return -1
	End

Commit tran

