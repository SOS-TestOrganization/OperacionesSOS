
/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpTraerValorIva
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   retorna el valor del iva									.	D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P   													P\>
                                                      :  <\P   													P\>
                                                      :  <\P   													P\>
* Variables			 :  <\V													V\>
* Fecha Creacion		 :  <\FC  2002/06/20											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE         PROCEDURE SpTraerValorIva


	 @lnConsecutivoConcepto		udtConsecutivo	=	Null,
 	 @ldFechaReferencia			Datetime	=	NULL ,
	 @lnValorIva				Numeric(9,3)		output	
         	
AS    
  
Set Nocount On

Select 	@lnValorIva	=	 prcntje 
From 	tbconceptosliquidacion_Vigencias 
Where  cnsctvo_cdgo_cncpto_lqdcn =@lnConsecutivoConcepto
and 	convert(varchar(10),@ldFechaReferencia,111)   between Convert(varchar(10),	inco_vgnca,111)  and           convert(varchar(10),	fn_vgnca,111)
