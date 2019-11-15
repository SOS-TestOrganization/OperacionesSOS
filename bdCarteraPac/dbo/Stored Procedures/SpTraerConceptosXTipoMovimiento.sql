/*---------------------------------------------------------------------------------
* Metodo o PRG 	              :   SpTraerConceptosXTipoMovimiento
* Desarrollado por		 :  <\A    Ing. Rolando Simbaqueva									A\>
* Descripcion			 :  <\D   Trae un cursor con los registros de los conceptos segun el tipo de movimiento		.	D\>
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
* Modificado Por	         : <\AM Ing. Fernando Valencia E   AM\>
* Descripcion			 : <\DM Se agrega la pregunta si el tipo de de movimiento es diferente de 5 para las NCI  DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2006/12/30 - 2007/02719   FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE SpTraerConceptosXTipoMovimiento
 	 @lnConsecutivoTipoMovimiento		UdtConsecutivo		=	NULL,
	 @lnConsecutivoPlan			UdtConsecutivo		=	NULL
AS    Declare
@ldFechaSistema	datetime

Set	@ldFechaSistema	=	GetDate()	
  
Set Nocount On

if @lnConsecutivoTipoMovimiento <> 5 --Para los diferentes a nota credito de impuestos

      begin
	Select	cdgo_cncpto_lqdcn, 	  dscrpcn_cncpto_lqdcn,	   convert(numeric(12),0)	Valor,
	   	cnsctvo_cdgo_pln,  	  cnsctvo_cdgo_tpo_mvmnto,	   oprcn     , slcta_atrzdr , 	0 cnsctvo_cdgo_autrzdr_espcl,
	   	cnsctvo_cdgo_cncpto_lqdcn,cnsctvo_cdgo_bse_aplcda
	From    tbconceptosliquidacion_vigencias 
	Where      (@ldFechaSistema  between inco_vgnca   And    fn_vgnca )  
	And (vsble_usro			= 	'S' )
	And cnsctvo_cdgo_tpo_mvmnto		=	@lnConsecutivoTipoMovimiento
	And (cnsctvo_cdgo_pln			=	@lnConsecutivoPlan or @lnConsecutivoPlan is null)
 	And cnsctvo_vgnca_cncpto_lqdcn not in (155,156,157,158)
        --GO  
      end
else  ---Para la notas credito de impuestos 
      begin
	Select	cdgo_cncpto_lqdcn, 	dscrpcn_cncpto_lqdcn,		   convert(numeric(12),0)	Valor,
	   	cnsctvo_cdgo_pln,  	cnsctvo_cdgo_tpo_mvmnto,	   oprcn     , slcta_atrzdr , 	0 cnsctvo_cdgo_autrzdr_espcl,
	   	cnsctvo_cdgo_cncpto_lqdcn,	cnsctvo_cdgo_bse_aplcda
	From       tbconceptosliquidacion_vigencias 
	Where      (@ldFechaSistema  between inco_vgnca   And    fn_vgnca )  
	And          (vsble_usro			= 	'S' )
	And	 cnsctvo_cdgo_tpo_mvmnto		=	@lnConsecutivoTipoMovimiento
	And	  (cnsctvo_cdgo_pln			=	@lnConsecutivoPlan or @lnConsecutivoPlan is null)
        and 	cdgo_cncpto_lqdcn 			<> 3
     end

