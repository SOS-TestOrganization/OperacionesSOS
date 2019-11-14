/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spObtenerEstadosCuentaYContratos
* Desarrollado por		: <\A	Ing. Jean Paul Villaquiran Madrigal	A\>
* Descripción			: <\D	Se consultan los estados de cuenta y sus respectivos contratos D\>
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
CREATE procedure spObtenerEstadosCuentaYContratos
(
@numeroEstadoCuenta varchar(20),
@fechaCorte datetime,
@consecutivoCodigoPlan int
)
as
begin
	set nocount on;

	insert into		#tmpEstadosDeCuentaConContrato
					(
					cnsctvo_estdo_cnta,
					cnsctvo_cdgo_tpo_cntrto,
					nmro_cntrto
					)
	select			a.cnsctvo_estdo_cnta,
					b.cnsctvo_cdgo_tpo_cntrto,
					b.nmro_cntrto
	from			BDCarteraPAC.dbo.tbEstadosCuenta a with(nolock)
	inner join		BDCarteraPAC.dbo.tbEstadosCuentaContratos b with(nolock)
	on				a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
	inner join		BDAfiliacion.dbo.tbContratos c with(nolock)
	on				b.nmro_cntrto = c.nmro_cntrto
	and				b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
	where			a.nmro_estdo_cnta = @numeroEstadoCuenta
	and				c.cnsctvo_cdgo_pln = isnull(@consecutivoCodigoPlan,c.cnsctvo_cdgo_pln);

	insert into    	#tmpEstadosCuentaContratos  
	Select			a.nmro_unco_idntfccn_empldr, a.cnsctvo_scrsl, a.cnsctvo_cdgo_clse_aprtnte,
					a.nmro_estdo_cnta,
					c.cnsctvo_estdo_cnta_cntrto,
					c.cnsctvo_estdo_cnta,
					c.cnsctvo_cdgo_tpo_cntrto,
					c.nmro_cntrto,
					c.vlr_cbrdo,
					c.sldo
	From			bdcarteraPac.dbo.TbEstadosCuenta a with(nolock)
	inner join		bdcarterapac.dbo.tbliquidaciones b with(nolock)
	on				(a.cnsctvo_cdgo_lqdcn		=	b.cnsctvo_cdgo_lqdcn)
    inner join		dbo.tbEstadosCuentaContratos c with(nolock)
	on				(a.cnsctvo_estdo_cnta		=	c.cnsctvo_estdo_cnta)
	inner join		BDAfiliacion.dbo.tbContratos d with(nolock)
	on				c.nmro_cntrto = d.nmro_cntrto
	and				c.cnsctvo_cdgo_tpo_cntrto = d.cnsctvo_cdgo_tpo_cntrto
	where			a.nmro_estdo_cnta = @numeroEstadoCuenta
	and				d.cnsctvo_cdgo_pln = isnull(@consecutivoCodigoPlan,d.cnsctvo_cdgo_pln);

	exec			dbo.spObtenerCobranzas @fechaCorte;

	insert into		#Tmpcontratos				
					(					
					cnsctvo_cdgo_tpo_cntrto		,
					nmro_cntrto					,
					cnsctvo_cdgo_pln			,
					inco_vgnca_cntrto			,
					fn_vgnca_cntrto				,
					nmro_unco_idntfccn_afldo	,
					cnsctvo_cbrnza				,
					nmro_unco_idntfccn_aprtnte  ,
					cnsctvo_vgnca_cbrnza		,
					cnsctvo_scrsl_ctznte		,
					inco_vgnca_cbrnza			,
					fn_vgnca_cbrnza				,
					cta_mnsl					,
					cnsctvo_cdgo_prdcdd_prpgo	,
					cnsctvo_estdo_cnta			,
					cnsctvo_cdgo_clse_aprtnte	,
					vlr_ttl_cntrto				,
					vlr_ttl_cntrto_sn_iva		,
					cntdd_ttl_bnfcrs			,
					Grupo_Conceptos				,
					Activo						,
					Cntrto_igual_cro			
					)
	select			a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,b.cnsctvo_cdgo_pln,b.inco_vgnca_cntrto,b.fn_vgnca_cntrto,b.nmro_unco_idntfccn_afldo,c.cnsctvo_cbrnza,
					c.nmro_unco_idntfccn_aprtnte,d.cnsctvo_vgnca_cbrnza,d.cnsctvo_scrsl_ctznte,d.inco_vgnca_cbrnza,d.fn_vgnca_cbrnza,
					d.cta_mnsl,c.cnsctvo_cdgo_prdcdd_prpgo,a.cnsctvo_estdo_cnta,c.cnsctvo_cdgo_clse_aprtnte,0 as valor_criterio, 
					0 as valor_criterio_sin_iva,0 cantidad_beneficiarios,1 as grupo_conceptos,0 as activo,0 as criterio_igual_cero
	from			#tmpEstadosDeCuentaConContrato a
	inner join		BDAfiliacion.dbo.tbContratos b with(nolock)
	on				a.nmro_cntrto = b.nmro_cntrto
	and				a.cnsctvo_cdgo_tpo_cntrto	 = b.cnsctvo_cdgo_tpo_cntrto
	inner join		#tmpCobranzasPac c
	on				b.nmro_cntrto = c.nmro_cntrto
	and				b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
	inner join		#tmpVigenciasCobranzasPac d
	on				c.nmro_cntrto = d.nmro_cntrto
	and				c.cnsctvo_cdgo_tpo_cntrto = d.cnsctvo_cdgo_tpo_cntrto
	and				c.cnsctvo_cbrnza = d.cnsctvo_cbrnza
	where			b.cnsctvo_cdgo_pln = isnull(@consecutivoCodigoPlan,b.cnsctvo_cdgo_pln);
end