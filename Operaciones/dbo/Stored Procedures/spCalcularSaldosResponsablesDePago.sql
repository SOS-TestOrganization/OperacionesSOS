/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spCalcularSaldosResponsablesDePago
* Desarrollado por		: <\A	Ing. Jean Paul Villaquiran Madrigal	A\>
* Descripción			: <\D	Se calculan los saldos de los responsables de pago D\>
* Observaciones			: <\O	O\>
* Parámetros			: <\P  	P\>
* Variables				: <\V  	V\>
* Fecha Creación		: <\FC	17/09/2019 FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM	AM\>
* Descripción				: <\DM	DM\>
* Nuevos Parámetros			: <\PM	PM\>
* Nuevas Variables			: <\VM	VM\>
* Fecha Modificación		: <\FM	FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE procedure spCalcularSaldosResponsablesDePago
(
@fechaCorte datetime
)
as
begin
	
	declare			@lndiasdesafiliacion int; 

	set nocount on;

	Select			@lndiasdesafiliacion = vlr_prmtro_nmrco
	From			bdCarteraPac.dbo.tbParametrosGenerales_Vigencias
	Where			cnsctvo_vgnca_prmtro_gnrl	= 1
	And				getdate()	Between inco_vgnca And 	fn_vgnca;
	
	Insert  Into	#tmpSaldoContratoResponsable
	Select			a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,  
					a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto ,
					Sum(sldo) sldo,
					count(nmro_estdo_cnta) cuotas,
					@lndiasdesafiliacion nmro_cts_prmtdas,
					0	Vldo_pra_fctrr
	From			#tmpEstadosCuentaContratos a
	Where 			sldo  > 0
	Group by		a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
					a.cnsctvo_cdgo_tpo_cntrto,   a.nmro_cntrto;

	--Se Suman El Numero De Cuotas Para La Suspencion que existen en productos convirtiendo a entero
	Update			#tmpSaldoContratoResponsable
	Set				nmro_cts_prmtdas = 	nmro_cts_prmtdas + convert(int,(b.ds_pra_sspnsn/30))  
	From 			#tmpSaldoContratoResponsable a 
	inner join      bdAfiliacion.dbo.tbDatosComercialesSucursal b
	on 				(a.nmro_unco_idntfccn_empldr =	b.nmro_unco_idntfccn_empldr
	And				a.cnsctvo_scrsl = b.cnsctvo_scrsl
	And				a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte);
	
	Update			#tmpSaldoContratoResponsable
	Set				Vldo_pra_fctrr	=	1
	Where			cuotas	<  @lndiasdesafiliacion;
	
	Update			#tmpSaldoContratoResponsable
	Set				Vldo_pra_fctrr	 =	1
	Where			cuotas 		 < 	nmro_cts_prmtdas
	And				Vldo_pra_fctrr	 =	0;

	insert into		#tmpContratosSuspenConUnacuota
	Select   		cnsctvo_cdgo_tpo_cntrto, 	nmro_cntrto 
	From			#tmpSaldoContratoResponsable 
	Where 			Vldo_pra_fctrr	=	1
	Group by 		cnsctvo_cdgo_tpo_cntrto, nmro_cntrto;

end