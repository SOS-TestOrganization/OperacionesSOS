/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPmTraerNombreEmpleadorMasivoPE
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de un empleador en la estructura definitiva de empresa.  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*

exec spPmTraerNombreEmpleadorMasivoPE 9, '800106339',null
exec spPmTraerNombreEmpleadorMasivoPE null, null,100001        


*---------------------------------------------------------------------------------*/
Create  PROCEDURE [dbo].[spPmTraerNombreEmpleadorMasivoPE]
	@lcConsecutivoTipoIdentificacion UdtConsecutivo,
	@lnNumeroIdentificacion	UdtNumeroIdentificacion,
	@lnNui	UdtConsecutivo		
	
As
Set Nocount On

if @lcConsecutivoTipoIdentificacion is not null and @lnNumeroIdentificacion is not null 
begin 
Select	distinct a.nmro_unco_idntfccn_aprtnte,
	a.rzn_scl,
	a.cnsctvo_cdgo_tpo_idntfccn_empldr,
	a.nmro_idntfccn_empldr
From	dbo.tbAportanteValidador a,dbo.tbActividadesEconomicas e
where a.nmro_idntfccn_empldr = @lnNumeroIdentificacion 
	and a.cnsctvo_cdgo_tpo_idntfccn_empldr = @lcConsecutivoTipoIdentificacion 
end

if @lnNui is not null  
begin 
Select	 distinct  a.nmro_unco_idntfccn_aprtnte,
	a.rzn_scl,
	a.cnsctvo_cdgo_tpo_idntfccn_empldr,
	a.nmro_idntfccn_empldr
From	dbo.tbAportanteValidador a,dbo.tbActividadesEconomicas e
where a.nmro_unco_idntfccn_aprtnte =  @lnNui 
end

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorMasivoPE] TO [pe_soa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorMasivoPE] TO [portal_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerNombreEmpleadorMasivoPE] TO [procesope_webusr]
    AS [dbo];

