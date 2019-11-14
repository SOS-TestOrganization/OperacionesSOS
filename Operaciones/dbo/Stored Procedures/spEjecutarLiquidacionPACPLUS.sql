
/*------------------------------------------------------------------------------------------------------------------------------------------
* MÃ©todo o PRG		:		spEjecutarLiquidacionPBSPLUS							
* Desarrollado por	: <\A	Carlos Vela - Qvision	A\>	
* DescripciÃ³n		: <\D	Ejecuta la liquidacion de planes PAC PLUS D\>
* Observaciones		: <\O 	O\>	
* ParÃ¡metros		: <\P 	P\>	
* Variables			: <\V	V\>	
* Fecha CreaciÃ³n	: <\FC	2019/05/31	FC\>
*------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE Procedure [dbo].[spEjecutarLiquidacionPACPLUS]
As
DECLARE @lnConceptoLiquidacion [dbo].[udtConsecutivo]=346
Begin
	Set Nocount On

	EXEC dbo.spEjecutarLiquidacionPLUS @lnConceptoLiquidacion

End



