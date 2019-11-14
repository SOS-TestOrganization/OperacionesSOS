
/*---------------------------------------------------------------------------------
* Metodo o PRG   : spPTLConsultaNumeroCuentaXEmpleador
* Desarrollado por  : <\A Ing. Warner Valencia -  SEIT Consultores        A\>
* Descripcion   : <\D Este procedimiento permite consultar el número de cuenta de un afiliado  D\>
* Observaciones   : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2015/09/24           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	Ing. Cesar Garcia				AM\>
* Descripcion			: <\DM	Se adicionan hints a las tablas  DM\> 
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2017-03-14						FM\>

*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	Ing y Psic. Carlos Vela			AM\>
* Descripcion			: <\DM	Se elimina restricción de recuperar solo registros de independientes,
								se agregan empleadores.  DM\> 
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019-07-17						FM\>
*---------------------------------------------------------------------------------*/
--exec spPTLConsultaNumeroCuentaXEmpleador 32237736
CREATE   PROCEDURE [dbo].[spPTLConsultaNumeroCuentaXEmpleador]
@nmro_unco_idntfccn_empldr   udtConsecutivo

As
Set Nocount On

Begin 
		Declare		@AFILIADO_INDEPENDIENTE int

		Create Table #tmpEstadosCuentaConsultar(
					 nmro_estdo_cnta varchar(15),
					 cnsctvo_cdgo_tpo_dcmnto int)

		Create Table #tmpEstadosCuentaSinPagar(
					 cnsctvo_estdo_cnta int,
					 cnsctvo_cdgo_tpo_dcmnto int)

	    Create Table #tmpLiquidaciones(
					cnsctvo_cdgo_lqdcn udtConsecutivo )

		Set @AFILIADO_INDEPENDIENTE =4

		Insert into #tmpLiquidaciones	(cnsctvo_cdgo_lqdcn )
		select		l.cnsctvo_cdgo_lqdcn 
		From		bdcarterapac.dbo.tbLiquidaciones l	With(NoLock)
		where		l.cnsctvo_cdgo_estdo_lqdcn  = 3 -- finalizada

		Insert into #tmpEstadosCuentaSinPagar
		Select		max(IsNull(b.cnsctvo_estdo_cnta,0)) cnsctvo_estdo_cnta, 
					1 as cnsctvo_cdgo_tpo_dcmnto
		From		#tmpLiquidaciones				a	With(NoLock)
		Inner Join	dbo.tbestadoscuenta				b	With(NoLock)	On a.cnsctvo_cdgo_lqdcn			= b.cnsctvo_cdgo_lqdcn
		Inner Join	dbo.tbEstadosCuentaContratos	ecc	With(NoLock)	On b.cnsctvo_estdo_cnta			= ecc.cnsctvo_estdo_cnta
		Inner Join	bdafiliacion.dbo.tbcontratos	c	With(NoLock)	On ecc.nmro_cntrto				= c.nmro_Cntrto
																		And ecc.cnsctvo_Cdgo_tpo_cntrto = c.cnsctvo_Cdgo_tpo_cntrto
		Where		b.nmro_unco_idntfccn_empldr = @nmro_unco_idntfccn_empldr--32726187 -- Nui
		And			b.cnsctvo_cdgo_clse_aprtnte  in (1,4) -- Empleadores e Independientes
		And			b.cnsctvo_cdgo_estdo_estdo_cnta < 3

		--drop table #tmpEstadosCuentaConsultar
		Insert Into #tmpEstadosCuentaConsultar
		Select		ec.nmro_estdo_cnta,		b.cnsctvo_cdgo_tpo_dcmnto 
		From		dbo.tbEstadosCuenta			ec	With(NoLock)
		Inner Join	#tmpEstadosCuentaSinPagar	b	With(NoLock)	On	ec.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
		Where		b.cnsctvo_estdo_cnta != 0

		Select		nmro_estdo_cnta,		cnsctvo_cdgo_tpo_dcmnto
		From		#tmpEstadosCuentaConsultar	With(NoLock)

		Drop Table	#tmpEstadosCuentaConsultar
		Drop table	#tmpEstadosCuentaSinPagar
		Drop Table	#tmpLiquidaciones
End
