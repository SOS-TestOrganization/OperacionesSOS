/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCreaBeneficiariosContratosEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los beneficiarios de los contratos de  estados de cuenta  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spCreaBeneficiariosContratosEstadosCuenta
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcControlaError		int	output	

As Declare 
@lnMaximoConsecutivoBeneContratoEstadoCuenta	udtConsecutivo
Set Nocount On

               
Select	@lnMaximoConsecutivoBeneContratoEstadoCuenta = isnull(max(cnsctvo_estdo_cnta_cntrto_bnfcro) ,0)
From	TbCuentasContratosBeneficiarios




Update #tmpBeneficiarios
Set	cnsctvo_estdo_cnta_cntrto	=	c.cnsctvo_estdo_cnta_cntrto
From	#tmpBeneficiarios	a, 	 tbEstadosCuenta b, 	TbEstadosCuentaContratos  c
Where	b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	b.cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn
And	a.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	c.nmro_cntrto



Insert into	TbCuentasContratosBeneficiarios
Select 		ID_Num +  @lnMaximoConsecutivoBeneContratoEstadoCuenta ,
		cnsctvo_estdo_cnta_cntrto,
		cnsctvo_bnfcro,
		nmro_unco_idntfccn_bnfcro,
		vlr_ttl_bnfcro,
		Null
From	 	#tmpBeneficiarios

If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end