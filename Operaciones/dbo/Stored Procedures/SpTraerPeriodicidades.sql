/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpTraerPeriodicidades
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   Trae un cursor con los registros de sedes los cuales corresponden a los parametros ingresados.	D\>
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
CREATE        PROCEDURE SpTraerPeriodicidades  

 	 @lcCodigoPeriodo	udtcodigo	=	NULL,        
 	 @ldFechaReferencia	Datetime	=	NULL ,
         	 @lcCadenaSeleccion	udtDescripcion	=	NULL,
	@vsble_usro		udtLogico	=	Null
AS    
  
Set Nocount On
	If @vsble_usro is null
		set @vsble_usro='S' 
 
		If   @lcCodigoPeriodo  is NULL
                               Begin
		    	 If @lcCadenaSeleccion  = '+'	or   @lcCadenaSeleccion is null

                                                     --Selecciona todos los registros de  la tabla  tbperiodos  donde el campo borrado sea 'N' y este
                                                     --dentro de un rango vigente. 		
			             Select	    cdgo_prdo,	 max(dscrpcn_prdo) dscrpcn_prdo,	 max(cnsctvo_cdgo_prdo) cnsctvo_cdgo_prdo
 				From         bdafiliacion..TbPeriodos_vigencias                
                                                     Where        	    ((@ldFechaReferencia  between inco_vgnca   And    fn_vgnca )   Or     @ldFechaReferencia  Is NULL)  
				And          (vsble_usro		= 	@vsble_usro or @vsble_usro='T')
                                         	Group by cdgo_prdo                                         
  		               Else
                                                     --Selecciona todos los registros de  la tabla  tbperiodos donde el campo borrado sea 'N'  y este
                                                     --dentro de un rango vigente  ademas que   el campo descripcion  contenga el parametro de seleccion

		                          Select      cdgo_prdo,	 dscrpcn_prdo,	 cnsctvo_cdgo_prdo
                                                    From        bdafiliacion..TbPeriodos_vigencias           
	    		            Where         ((@ldFechaReferencia  between inco_vgnca        And   fn_vgnca )   Or      @ldFechaReferencia  Is NULL) 
                                                    	And       dscrpcn_prdo     like  '%' +    ltrim(rtrim(@lcCadenaSeleccion) + '%' ) 
				And       (vsble_usro		= 	@vsble_usro or @vsble_usro='T')
                                   End 
 	       Else
			             --Selecciona todos los registros de  la tabla  tbperiodos  donde el campo borrado sea 'N'  y este
                                                     --dentro de un rango vigente  ademas  donde el codigo sea igual al parametro  @lcCodigoPeriodo
			             Select      cdgo_prdo,	 dscrpcn_prdo,	 cnsctvo_cdgo_prdo
	                                        From         bdafiliacion..TbPeriodos_vigencias           
				Where         ((@ldFechaReferencia  between inco_vgnca    And     fn_vgnca )    Or     @ldFechaReferencia  Is NULL) 
                                                     And          cdgo_prdo  =  @lcCodigoPeriodo
				And         (vsble_usro		= 	@vsble_usro or @vsble_usro='T')