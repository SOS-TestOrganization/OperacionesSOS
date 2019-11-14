/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spInsertarYActualizarResponsablesDePago
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite inserta y actualizar los responsables de pago D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/04/30 FC\>
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
CREATE procedure dbo.spInsertarYActualizarResponsablesDePago
as
begin
	set nocount on;

	Insert	Into #tmpResponsablesPago
	(
		   nmro_unco_idntfccn_aprtnte,	
		   cnsctvo_scrsl_ctznte,
		   cnsctvo_cdgo_clse_aprtnte,	
		   cnsctvo_cdgo_prdcdd_prpgo,
		   Grupo_Conceptos,		
		   nmbre_empldr,
		   nmbre_scrsl,			
		   cnsctvo_cdgo_tpo_idntfccn,
		   nmro_idntfccn_rspnsble_pgo,	
		   dgto_vrfccn,
		   drccn,				
		   tlfno,
		   cnsctvo_cdgo_cdd
	)
	select		nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				cnsctvo_cdgo_clse_aprtnte,	
				cnsctvo_cdgo_prdcdd_prpgo,
				1,				
				'',
				'',				
				0,
				'',				
				0,
				'',				
				'',
				0
	From		#Tmpcontratos
	Group By	nmro_unco_idntfccn_aprtnte,	cnsctvo_scrsl_ctznte,
				cnsctvo_cdgo_clse_aprtnte,	cnsctvo_cdgo_prdcdd_prpgo

	-- se actualiza la direccion , el telefono, nombre de la sucursal, la ciudad y direccion

	Update		#tmpResponsablesPago
	Set			drccn				= b.drccn,
				tlfno				= b.tlfno,
				nmbre_scrsl			= b.nmbre_scrsl,
				cnsctvo_cdgo_cdd	= b.cnsctvo_cdgo_cdd
	From		#tmpResponsablesPago					a 
	Inner Join  bdAfiliacion.dbo.tbSucursalesAportante	b With(NoLock)
		On		a.cnsctvo_cdgo_clse_aprtnte	 = b.cnsctvo_cdgo_clse_aprtnte
		And		a.cnsctvo_scrsl_ctznte		 = b.cnsctvo_scrsl
		And		a.nmro_unco_idntfccn_aprtnte = b.nmro_unco_idntfccn_empldr

	-- se actualiza el tipo y numero de identificacion

	Update		#tmpResponsablesPago
	Set			nmro_idntfccn_rspnsble_pgo	= b.nmro_idntfccn,
				cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn,
				dgto_vrfccn					= b.dgto_vrfccn
	From		#tmpResponsablesPago a 
	Inner Join	bdAfiliacion.dbo.tbvinculados b With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	= b.nmro_unco_idntfccn

	--Actualiza el nombre del empleador si es juridico

	Update		#tmpResponsablesPago
	Set			nmbre_empldr	= c.rzn_scl
	From		#tmpResponsablesPago			a 
	Inner Join	bdAfiliacion.dbo.tbEmpleadores	b With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	= b.nmro_unco_idntfccn
		And		a.cnsctvo_cdgo_clse_aprtnte		= b.cnsctvo_cdgo_clse_aprtnte 
	Inner Join	bdAfiliacion.dbo.tbempresas		c With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	=	c.nmro_unco_idntfccn
	
	--Si no recupera registros se debe buscar como empleador natural

	Update		#tmpResponsablesPago
	Set			nmbre_empldr	=  Ltrim(Rtrim(IsNull(prmr_aplldo,''))) + ' ' + Ltrim(Rtrim(IsNull(sgndo_aplldo,''))) + ' ' + Ltrim(Rtrim(IsNull(prmr_nmbre,''))) + ' ' + Ltrim(Rtrim(IsNull(sgndo_nmbre,'')))
	From		#tmpResponsablesPago			a 
	Inner Join	bdAfiliacion.dbo.tbEmpleadores	b With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	= b.nmro_unco_idntfccn
		And		a.cnsctvo_cdgo_clse_aprtnte	= b.cnsctvo_cdgo_clse_aprtnte 
	Inner Join	bdafiliacion.dbo.tbpersonas		c With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	= c.nmro_unco_idntfccn 

	-- se actualiza al responsable del grupo en la cual le pertenece

	Update		#tmpResponsablesPago
	Set			Grupo_Conceptos		= b.cnsctvo_cdgo_grpo_lqdcn
	From		#tmpResponsablesPago			a 
	Inner Join	dbo.tbGrupoLiquidacionAportante b With(NoLock)
		On		a.nmro_unco_idntfccn_aprtnte	= 	b.nmro_unco_idntfccn_empldr
		And		a.cnsctvo_scrsl_ctznte			=	b.cnsctvo_scrsl
		And		a.cnsctvo_cdgo_clse_aprtnte		=	b.cnsctvo_cdgo_clse_aprtnte

	-- se actualiza el grupo de cada beneficiario asociado al responsable

	Update		#Tmpcontratos
	Set			Grupo_Conceptos = b.Grupo_Conceptos
	From 		#Tmpcontratos			a 
	Inner Join	#tmpResponsablesPago	b
		On		a.nmro_unco_idntfccn_aprtnte	= b.nmro_unco_idntfccn_aprtnte
		And		a.cnsctvo_scrsl_ctznte			= b.cnsctvo_scrsl_ctznte 
		And		a.cnsctvo_cdgo_clse_aprtnte		= b.cnsctvo_cdgo_clse_aprtnte

	-- se actualiza el tipo y numero de identificacion

	Update		#tmpBeneficiarios
	Set			cnsctvo_cdgo_tpo_idntfccn	= b.cnsctvo_cdgo_tpo_idntfccn,
				numero_identificacion		= b.nmro_idntfccn
	From		#tmpBeneficiarios				a 
	Inner Join	bdafiliacion.dbo.tbVinculados	b With(NoLock)
		On		a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn

	-- se actualiza los nombres y apellidos del beneficiario

	Update		#tmpBeneficiarios
	Set			primer_apellido		= b.prmr_aplldo,
				segundo_apellido	= b.sgndo_aplldo,
				primer_nombre		= b.prmr_nmbre,
				segundo_nombre		= b.sgndo_nmbre
	From		#tmpBeneficiarios			a 
	Inner Join  bdafiliacion.dbo.tbpersonas b With(NoLock)
		On		a.nmro_unco_idntfccn_bnfcro	= b.nmro_unco_idntfccn
end