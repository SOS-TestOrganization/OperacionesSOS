/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spActualizaEncabezadoEstadosCuenta
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento realiza la actualizacion de los valores del encabezado del estado de cuenta	  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
**/

CREATE PROCEDURE spActualizaEncabezadoEstadosCuenta
	@cnsctvo_cdgo_lqdcn		udtconsecutivo,
	@lcControlaError		int	output	
As  

Set Nocount On


--Se actualiza el valor de la totalidad de la facturacion para cada estado de cuenta
Update TbEstadosCuenta
Set	ttl_fctrdo = acum_total_facturado
From   	TbEstadosCuenta  a ,(select a.cnsctvo_estdo_cnta , sum(vlr_cbrdo) acum_total_facturado
	 		  From tbEstadosCuenta a, TbEstadosCuentaConceptos b , tbconceptosliquidacion_vigencias c
			  Where a.cnsctvo_estdo_cnta 		= 	b.cnsctvo_estdo_cnta
  		 	  And   b.cnsctvo_cdgo_cncpto_lqdcn	=	c.cnsctvo_cdgo_cncpto_lqdcn
			  And   c.cnsctvo_cdgo_tpo_mvmnto 	= 	1   -- Total movimientos de facturacion
			  And  (getdate()  between c.inco_vgnca   And    c.fn_vgnca ) 			
	 		  Group by a.cnsctvo_estdo_cnta) tmpTotalFacturacion
Where a.cnsctvo_estdo_cnta	=	tmpTotalFacturacion.cnsctvo_estdo_cnta
And     cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn


If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end



--Se actualiza el valor del iva para cada estado  de  cuenta
Update TbEstadosCuenta
Set	vlr_iva = vlr_cbrdo
From   	TbEstadosCuenta  a , TbEstadosCuentaConceptos b 
Where   a.cnsctvo_estdo_cnta 		= 	b.cnsctvo_estdo_cnta
And     b.cnsctvo_cdgo_cncpto_lqdcn	=	3
And     cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn

If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end


--Se Actualiza el valor total apagar y el saldo del estado de cuenta y el numero de cuotas a  cancelar dependiendo de la periodicidad
Update	TbEstadosCuenta
Set	ttl_pgr			=	ttl_fctrdo	+	 vlr_iva	+	 sldo_antrr	 -   sldo_fvr,
	sldo_estdo_cnta		=	ttl_fctrdo	+	 vlr_iva,
	Cts_Cnclr		=	case when  cnsctvo_cdgo_prdcdd_prpgo  =  1 then  1
					        when  cnsctvo_cdgo_prdcdd_prpgo   =  2 then  2
					        when  cnsctvo_cdgo_prdcdd_prpgo   =  3 then  3
					        when  cnsctvo_cdgo_prdcdd_prpgo   =  4 then  4
					        when  cnsctvo_cdgo_prdcdd_prpgo   =  5 then  6
					        when  cnsctvo_cdgo_prdcdd_prpgo   =  6 then  12	end							
Where   cnsctvo_cdgo_lqdcn	=	@cnsctvo_cdgo_lqdcn


If  @@error!=0  
	Begin 
		Set	@lcControlaError	=	1
		Return -1
	end