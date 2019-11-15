

/*------------------------------------------------------------------------------------------------------------------------------------------
* Método o PRG		:		spConsultarLogLiquidacionPLUSFase2							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* Descripción		: <\D	Permite consultar el log de la liquidación D\>
* Observaciones		: <\O 	O\>	
* Parámetros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha Creación	: <\FC	2019/06/10	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE Procedure [dbo].[spConsultarLogLiquidacionPLUSFase2]
	@lnConsecutivoCodigoLiquidacion udtConsecutivo
As

DECLARE 	@mnsje_slda	varchar(750)

Begin
	Set Nocount On


	Begin Try 
	
		Set @mnsje_slda	= '';

		--Imprimimos el log de liquidaciones
			Select 
				cnsctvo_cdgo_lqdcn NumLiquidacion,
				cdgo_tpo_idntfccn TipoIdent,
				nmro_idntfccn NumIdent,
				nombre Nombre,
				causa Causa,
				nmro_cntrto NumContrato,
				convert(varchar, inco_vgnca_cntrto, 101) IniVigContrato,
				convert(varchar, fn_vgnca_cntrto, 101) FinVigContratro,
				nmro_unco_idntfccn_afldo NumIdentUnicoAfiliado,
				cdgo_pln CodigoPlan,
				dscrpcn_pln DescPlan,
				nmro_unco_idntfccn_aprtnte NumUnicoIdentAportante,
				nmbre_scrsl NombreSucursal,
				dscrpcn_clse_aprtnte DescClaseAportante,
				tpo_idntfccn_scrsl TipoIdentSucursal,
				nmro_idntfccn_scrsl NumIdentSucursal,
				cdgo_sde CodigoSede,
				dscrpcn_sde DescSede 
			From BDCarteraPAC.dbo.tbLogliquidacionesContratos With(NoLock) 
			Where cnsctvo_cdgo_lqdcn = @lnConsecutivoCodigoLiquidacion 


	End Try
	Begin Catch
		Set @mnsje_slda	= 'ERROR:' + ERROR_PROCEDURE()+'-'+Concat(ERROR_MESSAGE(), ' ', ERROR_PROCEDURE(), ' ', ERROR_LINE());
		SELECT @mnsje_slda

	End Catch
	
End
