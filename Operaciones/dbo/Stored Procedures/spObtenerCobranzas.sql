/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spObtenerCobranzas
* Desarrollado por		: <\A	Ing. Jean Paul Villaquiran Madrigal	A\>
* Descripción			: <\D	Se consultan las cobrans y sus respectivas vigencias D\>
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
CREATE procedure spObtenerCobranzas
(
@fechaCorte datetime
)
as
begin
	
	declare			@ESTADO_REGISTRADO_SI varchar(1) = 'S',
					@CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC smallint = 2; 

	set nocount on;

	insert into 	#tmpVigenciasCobranzasPac
	Select			max(cnsctvo_vgnca_cbrnza) cnsctvo_vgnca_cbrnza,
					max(inco_vgnca_cbrnza) inco_vgnca_cbrnza,
					max(fn_vgnca_cbrnza) fn_vgnca_cbrnza ,
					max(cta_mnsl)  cta_mnsl,
					a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,
					max(cnsctvo_cbrnza) cnsctvo_cbrnza,
					max(cnsctvo_scrsl_ctznte) cnsctvo_scrsl_ctznte
	From			bdafiliacion.dbo.tbVigenciasCobranzas a with(nolock)
	inner join		#tmpEstadosDeCuentaConContrato b
	on				a.nmro_cntrto = b.nmro_cntrto
	and				a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto
	where			a.cnsctvo_cdgo_tpo_cntrto =	@CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC
	And				estdo_rgstro = @ESTADO_REGISTRADO_SI
	And				datediff(dd,inco_vgnca_cbrnza,@fechaCorte) >= 0 
	And				datediff(dd,@fechaCorte,fn_vgnca_cbrnza) >= 0
	Group by		a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto;

	Insert into		#tmpCobranzasPac
					(
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto,
					cnsctvo_cbrnza,
					nmro_unco_idntfccn_aprtnte,
					cnsctvo_cdgo_clse_aprtnte,
					cnsctvo_cdgo_prdcdd_prpgo,
					lsto_fcttr
					)
	Select			c.cnsctvo_cdgo_tpo_cntrto,
					c.nmro_cntrto,
					c.cnsctvo_cbrnza,
					c.nmro_unco_idntfccn_aprtnte,
					c.cnsctvo_cdgo_clse_aprtnte,
					c.cnsctvo_cdgo_prdcdd_prpgo,
					0	lsto_fcttr
	From			bdafiliacion.dbo.tbcobranzas c with(nolock)
	inner join		BDAfiliacion.dbo.tbVigenciasCobranzas vc With (Nolock)	
	on				c.cnsctvo_cdgo_tpo_cntrto	= vc.cnsctvo_cdgo_tpo_cntrto
	and				c.nmro_cntrto = vc.nmro_cntrto
	and				c.cnsctvo_cbrnza = vc.cnsctvo_cbrnza
	inner join		#tmpEstadosDeCuentaConContrato d
	on				c.nmro_cntrto = d.nmro_cntrto
	and				c.cnsctvo_cdgo_tpo_cntrto = d.cnsctvo_cdgo_tpo_cntrto
	Where			c.cnsctvo_cdgo_tpo_cntrto =	@CONSECUTIVO_CODIGO_TIPO_CONTRATO_PAC
	And				c.cnsctvo_cdgo_prdcdd_prpgo >=	1 
	and				vc.estdo_rgstro = @ESTADO_REGISTRADO_SI
    and				@fechaCorte between vc.inco_vgnca_cbrnza and vc.fn_vgnca_cbrnza;	

end