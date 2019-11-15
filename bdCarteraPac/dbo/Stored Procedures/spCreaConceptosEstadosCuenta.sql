/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCreaConceptosEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los conceptos  del  estados de cuenta		  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*--------------------------------------------------------------------------------- 
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM Francisco Eduardo Riaño L. - Qvision S.A  AM\>
* Descripcion			: <\DM Ajustes Facturacion Electronica  DM\>
* Nuevos Parametros		: <\PM   PM\>
* Nuevas Variables		: <\VM   VM\>
* Fecha Modificacion	: <\FM 2019-05-08  FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spCreaConceptosEstadosCuenta]
(
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcControlaError		int Output		
)
As 
Begin	
	Set Nocount On;

	Declare		@lnMaximoConsecutivoConceptoEstadoCuenta	udtConsecutivo
          
	Select	@lnMaximoConsecutivoConceptoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta_cncpto) ,0)
	From	dbo.TbEstadosCuentaConceptos



	Insert into	dbo.TbEstadosCuentaConceptos
	(
		cnsctvo_estdo_cnta_cncpto,
		cnsctvo_estdo_cnta,
		cnsctvo_cdgo_cncpto_lqdcn,
		vlr_cbrdo,
		sldo,
		cntdd
	)
	Select 		
			ID_Num +  @lnMaximoConsecutivoConceptoEstadoCuenta ,
			cnsctvo_estdo_cnta,
			cnsctvo_cdgo_cncpto_lqdcn,
			valor_total_concepto,
			valor_total_concepto,
			Cantidad
	From	#TmpConceptosEstadoCuenta


	If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end
End