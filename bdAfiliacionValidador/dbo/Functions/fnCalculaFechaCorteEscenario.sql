

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :  fnCalculaFechaCorteEscenario
* Desarrollado por		 :  <\A   Ing. Andres Taborda								A\>
* Descripcion			 :  <\D  Devuelve La fecha de corte del Escenario			D\>
* Observaciones		              :  <\O											O\>
* Parametros			 :  <\P 													P\>
<\P	Ejemplo '				P\>
* Fecha Creacion		 :  <\FC  2012/01/27										FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE function [dbo].[fnCalculaFechaCorteEscenario]  (@nui int ,@cnsctvo_cdgo_tpo_cntrto int,@fcha_vldccn Datetime)
Returns Datetime

As 
Begin
Declare @fechaCorte Datetime

set	@fechaCorte = (select distinct max(b.fcha_fd)
			from 	tbMatrizCapitacionValidador a Inner Join tbEscenarios_procesovalidador b On
			 	a.cdgo_cnvno 		= b.cdgo_cnvno
			where 	nmro_unco_idntfccn 	= @nui
			and 	cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
			and 	@fcha_vldccn between 	b.fcha_dsde 	and 	b.fcha_hsta
			and 	@fcha_vldccn between 	a.fcha_dsde 	and 	a.fcha_hsta)



Return(@fechaCorte)

End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaFechaCorteEscenario] TO [Liquidador Facturas]
    AS [dbo];

