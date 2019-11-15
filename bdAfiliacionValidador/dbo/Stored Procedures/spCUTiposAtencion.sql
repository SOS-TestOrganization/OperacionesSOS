






/*---------------------------------------------------------------------------------
* Metodo o PRG 	             	 :   spCUTiposAtencion
* Desarrollado por		 :  <\A   Alvaro Zapata			A\>
* Descripcion			 :  <\D  		D\>
* Descripcion			 :  <\D   				D\>
* Observaciones		              :  <\O					O\>
* Parametros			 :  <\P   					P\>
                                 		:  <\P    				              P\>
                                                      :  <\P   					P\>
* Variables			 :  <\V					V\>
* Fecha Creacion		 :  <\FC 20031104		          	 FC\>
*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------  
* Modificado Por		              : <\AM   AM\>
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   FM\>
*---------------------------------------------------------------------------------*/
Create	Procedure [dbo].[spCUTiposAtencion]
@CodigoTipoAtencion		char(3) = NULL,
@DescripcionTipoAtencion	Char(150) = NULL

AS

/*
If @DescripcionTipoAtencion ='+'
	SELECT	a.cdgo_tpo_atncn,	a.dscrpcn_tpo_atncn,	a.estdo,		a.fcha_crcn,
		a.fcha_trmncn,		a.fcha_ultma_mdfccn,	a.usro_ultma_mdfccn
			
	FROM [Newton].BDPRESTAMEDICAS.DBO.tbTiposAtencion a
	where	estdo='A'	

Else
		SELECT	a.cdgo_tpo_atncn,	a.dscrpcn_tpo_atncn,	a.estdo,		a.fcha_crcn,
		a.fcha_trmncn,		a.fcha_ultma_mdfccn,	a.usro_ultma_mdfccn
		FROM [Newton].BDPRESTAMEDICAS.DBO.tbTiposAtencion a
		where	(cdgo_tpo_atncn = @CodigoTipoAtencion Or @CodigoTipoAtencion is null)
		And	(dscrpcn_tpo_atncn = @DescripcionTipoAtencion Or @DescripcionTipoAtencion is Null)
		And	estdo='A'


*/


If @DescripcionTipoAtencion ='+'
	Select	a.cdgo_tpo_atncn,	a.dscrpcn_tpo_atncn,	0 as estdo,		a.fcha_crcn,
			0 as fcha_trmncn,	0 as fcha_ultma_mdfccn,	a.usro_crcn
			
	From	bdSisalud.dbo.tbTiposAtencion a
	Where	vsble_usro='S'	

Else
		Select	a.cdgo_tpo_atncn,	a.dscrpcn_tpo_atncn,	0 as estdo,		a.fcha_crcn,
				0 as fcha_trmncn,		0 as fcha_ultma_mdfccn,	a.usro_crcn
		From	bdSisalud.dbo.tbTiposAtencion a
		Where	(cdgo_tpo_atncn = @CodigoTipoAtencion Or @CodigoTipoAtencion is null)
		And		(dscrpcn_tpo_atncn = @DescripcionTipoAtencion Or @DescripcionTipoAtencion is Null)
		And		vsble_usro='A'









GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUTiposAtencion] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

