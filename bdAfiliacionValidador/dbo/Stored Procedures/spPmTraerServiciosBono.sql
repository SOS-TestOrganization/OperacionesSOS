
/*----------------------------------------------------------------------------------
* Metodo o PRG 		: spPmTraerTiposIdentificacion
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza la búsqueda de los tipos de identificación de acuerdo a unos parametros  	D\>
				  <\D de entrada.											D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia de el tipo de identificacion 						P\>
				  <\P Codigo del agrupador de tipos de identificacion							P\>
				  <\P Codigo del tipo de identificacion a traer	 							P\>
				  <\P Codigo de la clase de empleador									P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2004/08/05 											FC\>
*
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		              : <\AM Ing. Carlos Andrés López Ramírez AM\>
* Descripcion			 : <\DM Por cambios en las estructuras de las tablas, se ajusta el sp DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM 2003/03/20 FM\>
*---------------------------------------------------------------------------------*/
CREATE  procedure  spPmTraerServiciosBono
As
Set Nocount On

Declare 
@tb_ServiciosBono Table (
cdgo_itm_prspsto		char(3),
dscrpcn_itm_prspsto		Varchar(150),
cnsctvo_cdgo_itm_prspsto	Int)

Insert	Into @tb_ServiciosBono(cdgo_itm_prspsto, dscrpcn_itm_prspsto, cnsctvo_cdgo_itm_prspsto)
Select	c.cdgo_itm_prspsto, Ltrim(Rtrim(c.dscrpcn_itm_prspsto)) dscrpcn_itm_prspsto, c.cnsctvo_cdgo_itm_prspsto --, Space(12) as 
From	bdSisalud.dbo.tbItemsPresupuesto_Vigencias c
Where	c.aplca_bno	 	= 'S'
Order by c.cdgo_itm_prspsto

Insert	Into @tb_ServiciosBono(cdgo_itm_prspsto, dscrpcn_itm_prspsto, cnsctvo_cdgo_itm_prspsto)
Select	'000', 'NO APLICA SERVICIO', 0 

select * from @tb_ServiciosBono

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [300202 Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmTraerServiciosBono] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

