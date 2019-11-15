


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 		:  fnCalcularCausaNovedad
* Desarrollado por		:  <\A    Ing. Maribel Valencia Herrera							A\>
* Descripcion			:  <\D  Calcular la Causa de la Novedad					 		D\>
* Observaciones			:  <\O											O\>
* Parametros			:  <\P 	Tipo Contrato									P\>
*				:  <\P 	Numero Contrato								P\>
*				:  <\P 	Numero unico identifcacion afiliado						P\>
*				:  <\P 	Causa Novedad									P\>
*				:  <\P 	Fecha Inicio Aportante								P\>
*				:  <\P 	Fecha Trapaso									P\>
* Fecha Creacion		:  <\FC  2003/06/24									FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function dbo.fnCalcularCausaNovedad (@cnsctvo_cdgo_tpo_cntrto 	UdtConsecutivo ,  
					     @nmro_cntrto 			udtNumeroFormulario, 
					     @Nui				UdtConsecutivo,	
					     @cnsctvo_cdgo_csa_nvdd 		udtConsecutivo,
					     @fcha_inco_aprtnte			datetime  ,
					     @FechaTraspaso			datetime)

Returns  udtConsecutivo   

As
  
Begin 

--> Obtener el Maximo Consecutivo de Vigencias por Contrato y Tipo de Contrato						
	Declare
	@lnResultado		UdtConsecutivo,
	@lnTipoAfiliado		UdtConsecutivo,
	@FechaEvaluar 	datetime


	--> Obtener de tbBeneficiarios el tipo de Afiliado y el fin de Vigencia del Beneficiario
	select 	@lnTipoAfiliado 	=cnsctvo_cdgo_tpo_afldo,
		@FechaEvaluar =fn_vgnca_bnfcro
	from tbBeneficiarios
	where 	nmro_cntrto			=	@nmro_cntrto
	and 	cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
	and	nmro_unco_idntfccn_bnfcro 	=	@Nui
	and 	cnsctvo_bnfcro			=	1


	-->Validar si el  contrato se encuentra vigente
	if CONVERT(VARCHAR(10),@FechaEvaluar,111) >CONVERT(VARCHAR(10),@FechaTraspaso,111)
	
	  begin
	      if @cnsctvo_cdgo_csa_nvdd=5 	--> Cambio de Empleador
		set @lnResultado =50		--> Cambio de Empleador del Periodo 
	    
	      if  @cnsctvo_cdgo_csa_nvdd=6	--> Reingreso
		set @lnResultado =49   		--> Reingreso del Periodo 

	      Return @lnResultado 
	  end

	-->Como el contrato no se encuentra vigente se obtiene de tbUltimasNovedadesContratos la fecha de aplicación
	-->del tipo de novedad =	8 Desafiliación  por concepto novedad = 4 Beneficiarios
	
	select @FechaEvaluar	=	fcha_aplcn
	from 	tbUltimasNovedadesContratos
	where	cnsctvo_cdgo_cncpto_nvdd 	=	4	 -->Beneficiarios
	and	cnsctvo_cdgo_tpo_nvdd		=	8 	-->Desafiliacion
	and	cnsctvo_cdgo_tpo_cntrto	=	@cnsctvo_cdgo_tpo_cntrto
	and	nmro_cntrto			=	@nmro_cntrto
	and	nmro_unco_idntfccn		=	@Nui
	and	cnsctvo_cdgo_csa_nvdd	=	@cnsctvo_cdgo_csa_nvdd

	--> Validar si la fecha de desafiliación contrato es diferente a la fecha de Inicio del aportante en el formulario
	if convert(varchar(7),@FechaEvaluar,111)<>convert(varchar(7),@fcha_inco_aprtnte,111)
	begin

	      if @cnsctvo_cdgo_csa_nvdd=5	--> Cambio de Empleador
		set @lnResultado =52		--> Cambio de Empleador Diferente Periodo 

	      if  @cnsctvo_cdgo_csa_nvdd=6	--> Reingreso
		set @lnResultado =51		--> Reingreso Diferente Periodo 

		      Return @lnResultado 
	  end

	 Return @lnResultado 
End







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCausaNovedad] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCausaNovedad] TO [Auditor Central Notificaciones]
    AS [dbo];

