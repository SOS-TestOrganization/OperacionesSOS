/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spCreaConceptosBeneficiariosContratosEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza una la creacion de los beneficiarios de los contratos de  estados de cuenta  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spCreaConceptosBeneficiariosContratosEstadosCuenta
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcControlaError		int	output	

As  

Set Nocount On

   

Select  cnsctvo_estdo_cnta  , cnsctvo_cdgo_lqdcn
into #tmpEstadoscuenta1
from tbEstadosCuenta where cnsctvo_cdgo_lqdcn = @cnsctvo_cdgo_lqdcn


Select  cnsctvo_estdo_cnta_cntrto , b.cnsctvo_estdo_cnta, c.nmro_cntrto
into 	#tmpEstadosCuentaContratos
From	TbEstadosCuentaContratos c , #tmpEstadoscuenta1 b
Where	b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta


Select d.cnsctvo_estdo_cnta_cntrto_bnfcro, 
       d.cnsctvo_estdo_cnta_cntrto,
       d.cnsctvo_bnfcro,
       d.nmro_unco_idntfccn_bnfcro
into #tmpCuentasContratosBeneficiarios
From  #tmpEstadoscuenta1 b, #tmpEstadosCuentaContratos c, 
	TbCuentasContratosBeneficiarios  d
where	b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	c.cnsctvo_estdo_cnta_cntrto	=	d.cnsctvo_estdo_cnta_cntrto



Update  #tmpBeneficiariosConceptos
Set	cnsctvo_estdo_cnta_cntrto_bnfcro =	d.cnsctvo_estdo_cnta_cntrto_bnfcro
From	#tmpBeneficiariosConceptos	a, 	 #tmpEstadoscuenta1  b, 	#tmpEstadosCuentaContratos  c ,  #tmpCuentasContratosBeneficiarios d
Where	b.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta
And	c.cnsctvo_estdo_cnta_cntrto	=	d.cnsctvo_estdo_cnta_cntrto
And	b.cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn
And	a.cnsctvo_bnfcro			=	d.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	d.nmro_unco_idntfccn_bnfcro
And	a.nmro_cntrto			=	c.nmro_cntrto


Insert into	TbCuentasBeneficiariosConceptos
Select 		cnsctvo_estdo_cnta_cntrto_bnfcro,
		cnsctvo_cdgo_cncpto_lqdcn,
		valor,
		Null
From	 	#tmpBeneficiariosConceptos


If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end