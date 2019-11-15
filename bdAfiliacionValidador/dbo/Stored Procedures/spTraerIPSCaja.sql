


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              :   spTraerIPSCaja
* Desarrollado por		 :  <\A    Ing. Alexander Yela Reyes									A\>
* Descripcion			 :  <\D   trae los barrios de una ciudad.									D\>
* Observaciones		              :  <\O													O\>
* Parametros			 :  <\P 	Consecutivo Codigo Ciudad									P\>
*				 :  <\P					EE								P\>
* Fecha Creacion		 :  <\FC  2002/31/10											FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   Yasmin RamirezAM\>
* Descripcion			 : <\DM   Consulta la nueva estructura de prestadores	DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM  2003/08/12  FM\>
*---------------------------------------------------------------------------------*/
CREATE procedure [dbo].[spTraerIPSCaja]
@lcCodigoIps		Udtcodigoips			= NULL,
@lcCadenaSeleccion	UdtDescripcion		= NULL
AS
Set Nocount On

-- Crea una estructura vacia donde se almacenara el resultado de la consulta
Select	a.cdgo_intrno,	a.nmbre_scrsl,	--a.nmro_unco_idntfccn_prstdr as nmro_unco_idntfccn,	
	Space(150) as dscrpcn_cdd,	Space(150) as dscrpcn_dprtmnto,
	a.cnsctvo_cdgo_cdd,		Space(3) as cdgo_dprtmnto, 
	a.cnsctvo_cdgo_sde_ips as cnsctvo_cdgo_sde
Into	#tmpIps
From	tbIPSPrimarias_vigencias a
Where	1=2

If @lcCodigoIps Is NULL
Begin
	If @lcCadenaSeleccion = '+'	OR	@lcCadenaSeleccion is NULL
	Begin
		Insert Into #tmpIps	
		Select	a.cdgo_intrno,	a.nmbre_scrsl,	--a.nmro_unco_idntfccn_prstdr ,
			Space(150) as dscrpcn_cdd,	Space(150) as dscrpcn_dprtmnto,
			a.cnsctvo_cdgo_cdd,		Space(3) as cdgo_dprtmnto,
			a.cnsctvo_cdgo_sde_ips as cnsctvo_cdgo_sde
		From	tbIPSPrimarias_vigencias a
	End
	Else
	Begin
		Insert Into #tmpIps
		Select	a.cdgo_intrno,	a.nmbre_scrsl,	--a.nmro_unco_idntfccn_prstdr,	
			Space(150) as dscrpcn_cdd,	Space(150) as dscrpcn_dprtmnto,
			a.cnsctvo_cdgo_cdd,		Space(3) as cdgo_dprtmnto,
			a.cnsctvo_cdgo_sde_ips as cnsctvo_cdgo_sde
		From	tbIPSPrimarias_vigencias a
		Where	a.nmbre_scrsl	Like 	'%' + ltrim(rtrim(@lcCadenaSeleccion)) + '%'
	End
End
Else
Begin
	Insert Into #tmpIps
	Select	a.cdgo_intrno,	a.nmbre_scrsl,	--a.nmro_unco_idntfccn_prstdr as nmro_unco_idntfccn,	
		Space(150) as dscrpcn_cdd,	Space(150) as dscrpcn_dprtmnto,
		a.cnsctvo_cdgo_cdd,		Space(3) as cdgo_dprtmnto,
		a.cnsctvo_cdgo_sde_ips as cnsctvo_cdgo_sde
	From	tbIPSPrimarias_vigencias a
	Where	 a.cdgo_intrno = @lcCodigoIps
End

-- Actualiza la ciudad y el departamento de la de la IPS
Update	#tmpIps
Set	dscrpcn_cdd		=	b.dscrpcn_cdd,
	dscrpcn_dprtmnto	=	c.dscrpcn_dprtmnto,
	cdgo_dprtmnto		=	c.cdgo_dprtmnto
From	#tmpIps a, 	bdAfiliacionValidador..tbCiudades_Vigencias b, 		bdAfiliacionValidador..tbDepartamentos_Vigencias c
Where	a.cnsctvo_cdgo_cdd		=	b.cnsctvo_cdgo_cdd
And	b.cnsctvo_cdgo_dprtmnto	=	c.cnsctvo_cdgo_dprtmnto
And	GetDate()		Between	b.inco_vgnca	And	b.fn_vgnca
And	GetDate()		Between	c.inco_vgnca	And	c.fn_vgnca

-- Recupera en una sola consulta la informacion de las IPS
Select	a.cdgo_intrno,	a.nmbre_scrsl,	dscrpcn_cdd,	dscrpcn_dprtmnto,
	a.cnsctvo_cdgo_cdd,	cdgo_dprtmnto,		--a.nmro_unco_idntfccn, 
	a.cnsctvo_cdgo_sde
From 	#tmpIps a




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerIPSCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

