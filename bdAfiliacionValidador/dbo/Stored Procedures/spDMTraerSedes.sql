/*---------------------------------------------------------------------------------
* Metodo o PRG:			spDMTraerSedes
* Desarrollado por:		<\A Ing. Jorge Marcos Rincon Ardila A\>
* Descripcion:			<\D	Trae las SEDES para la consulta del Directorio Medico	D\>
* Fecha Creacion:		<\FC	02/11/2010	FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por:		<\AM  AM\>
* Descripcion:			<\DM  DM\>
* Nuevos Parametros:	<\PM  PM\>
* Nuevas Variables:		<\VM  VM\>
* Fecha Modificacion:	<\FM  FM\>
*---------------------------------------------------------------------------------*/
--exec spDMTraerSedes
CREATE procedure [dbo].[spDMTraerSedes] 
As 
Begin
	Set Nocount On;
	
	Declare @dFechaHoy   datetime
	
	Select @dFechaHoy = convert(varchar(10), getdate(), 111)
	
	Select a.cnsctvo_cdgo_sde, a.cdgo_sde, a.dscrpcn_sde 
  	From dbo.tbSedes a 
	Inner Join dbo.tbSedes_Vigencias b On (a.cnsctvo_cdgo_sde = b.cnsctvo_cdgo_sde)
	Where a.vsble_usro = 'S' 
	And @dFechaHoy between Convert(Varchar(10), b.inco_vgnca, 111) And Convert(Varchar(10), b.fn_vgnca, 111)
	And a.cnsctvo_cdgo_sde Not In (13, 14, 15, 16) 
	Order by a.dscrpcn_sde
	
End

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spDMTraerSedes] TO [ServicioClientePortal]
    AS [dbo];

