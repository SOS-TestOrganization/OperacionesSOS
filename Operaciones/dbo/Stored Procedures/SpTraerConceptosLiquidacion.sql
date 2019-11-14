/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpTraerConceptosLiquidacion
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   Trae un cursor con los registros de los conceptos de liquidacion segun la base que aplique	.	D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P    Fecha a la cual se valida la vigencia de la sede							P\>
                                                      :  <\P    Caracteres ingresados por el usuario para realizar la busqueda					P\>
                                                      :  <\P    Codigo de la sede a traer										P\>
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
CREATE        PROCEDURE SpTraerConceptosLiquidacion

 	 @lcCodigoConcepto			char(5)		=	NULL,        
 	 @ldFechaReferencia			Datetime	=	NULL ,
         	 @lcCadenaSeleccion			udtDescripcion	=	NULL,
	 @lnConsecutivoBaseAplicada		udtconsecutivo	=	NULL,
	 @vsble_usro				udtLogico	=	Null
AS    
  
Set Nocount On
	If @vsble_usro is null
		set @vsble_usro='S' 
 
		If   @lcCodigoConcepto  is NULL
                               Begin
		    	 If @lcCadenaSeleccion  = '+'	or   @lcCadenaSeleccion is null

                                                     --Selecciona todos los registros de  la tabla  tbconceptosliquidacion  donde el campo borrado sea 'N' y este
                                                     --dentro de un rango vigente. 		
				Select	   cdgo_cncpto_lqdcn,  Max(dscrpcn_cncpto_lqdcn) dscrpcn_cncpto_lqdcn,	max(cnsctvo_cdgo_cncpto_lqdcn) cnsctvo_cdgo_cncpto_lqdcn,
					   max(cnsctvo_cdgo_pln)  cnsctvo_cdgo_pln,  max(cnsctvo_cdgo_tpo_mvmnto)  cnsctvo_cdgo_tpo_mvmnto,
					   max(oprcn)        oprcn     
 				From       tbconceptosliquidacion_vigencias 
                                                     Where      ((@ldFechaReferencia  between inco_vgnca   And    fn_vgnca )   Or     @ldFechaReferencia  Is NULL)  
				And          (vsble_usro			= 	@vsble_usro or @vsble_usro='S')
				And	   cnsctvo_cdgo_bse_aplcda  	=           @lnConsecutivoBaseAplicada
                                         	Group by cdgo_cncpto_lqdcn                                         
  		               Else
                                                     --Selecciona todos los registros de  la tabla  tbconceptosliquidacion donde el campo borrado sea 'N'  y este
                                                     --dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion

		                       Select	   cdgo_cncpto_lqdcn, 	  dscrpcn_cncpto_lqdcn,	 cnsctvo_cdgo_cncpto_lqdcn,
					   cnsctvo_cdgo_pln,  cnsctvo_cdgo_tpo_mvmnto     ,       oprcn     
 				From       tbconceptosliquidacion_vigencias 
                                                     Where       ((@ldFechaReferencia  between inco_vgnca        And   fn_vgnca )   Or      @ldFechaReferencia  Is NULL) 
                                                    	And       dscrpcn_cncpto_lqdcn	     like  '%' +    ltrim(rtrim(@lcCadenaSeleccion) + '%' ) 
				And       (vsble_usro		= 	@vsble_usro or @vsble_usro='S')
				And	   cnsctvo_cdgo_bse_aplcda  	=           @lnConsecutivoBaseAplicada
                                   End 
 	       Else
			             --Selecciona todos los registros de  la tabla  tbconceptosliquidacion  donde el campo borrado sea 'N'  y este
                                                     --dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoconcepto
			              Select	   cdgo_cncpto_lqdcn, 	  dscrpcn_cncpto_lqdcn,	 cnsctvo_cdgo_cncpto_lqdcn,
					   cnsctvo_cdgo_pln,  cnsctvo_cdgo_tpo_mvmnto     ,       oprcn     
 				From       tbconceptosliquidacion_vigencias 
                                                     Where      ((@ldFechaReferencia  between inco_vgnca    And     fn_vgnca )    Or     @ldFechaReferencia  Is NULL) 
                                                     And          cdgo_cncpto_lqdcn  =  @lcCodigoConcepto
				And         (vsble_usro		= 	@vsble_usro or @vsble_usro='S')
				And	   cnsctvo_cdgo_bse_aplcda  	=           @lnConsecutivoBaseAplicada