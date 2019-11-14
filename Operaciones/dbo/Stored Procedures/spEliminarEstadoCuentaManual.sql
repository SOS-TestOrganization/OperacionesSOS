/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spCalcularConsecutivoParaEstadoCuentaManual
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Sp que elimina un estado de cuenta manual D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/05/02 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------

--------------------------------------------------------------------------------*/
CREATE procedure dbo.spEliminarEstadoCuentaManual
(
	@numeroEstadoCuenta int
)
as
begin
		set nocount on;

		Delete		a
		From		dbo.tbCuentasManualesBeneficiarioxConceptos a 
		Inner Join  dbo.tbCuentasManualesBeneficiario			b With(NoLock)
			On		a.cnsctvo_cnta_mnls_cntrto	= b.cnsctvo_cnta_mnls_cntrto
			And		a.cnsctvo_bnfcro		= b.cnsctvo_bnfcro 
		Inner Join	dbo.tbCuentasManualesContrato				c With(NoLock)
			On		b.cnsctvo_cnta_mnls_cntrto	= c.cnsctvo_cnta_mnls_cntrto
		Where		c.nmro_estdo_cnta			= @numeroEstadoCuenta

		If @@Error!= 0
		Begin
			;throw 51000,'Error eliminando los conceptos de los beneficiarios del estado de cuenta manual',1
		End

		Delete		a
		From		dbo.tbCuentasManualesBeneficiario	a 
		Inner Join	dbo.tbCuentasManualesContrato		b With(NoLock)
			On		a.cnsctvo_cnta_mnls_cntrto	= b.cnsctvo_cnta_mnls_cntrto
		Where		b.nmro_estdo_cnta			= @numeroEstadoCuenta

		If @@Error!= 0
		Begin
			;throw 51000,'Error eliminando los  beneficiarios del estado de cuenta manual',1
		End

		Delete	dbo.tbCuentasManualesContrato
		Where	nmro_estdo_cnta	= @numeroEstadoCuenta

		If @@Error!= 0
		Begin
			;throw 51000,'Error eliminando los  contratos  del estado de cuenta manual',1
		End

		Delete	dbo.tbCuentasManualesConcepto
		Where 	nmro_estdo_cnta	= @numeroEstadoCuenta

		If @@Error!= 0
		Begin
			;throw 51000,'Error eliminando los  conceptos del estado  de cuenta manual',1
		End
end