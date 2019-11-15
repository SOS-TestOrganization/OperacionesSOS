/*---------------------------------------------------------------------------------------------------------------------------------------  
* Procedimiento   : spTraerOficinas  
* Desarrollado por  : <\A Ing. Francisco J. Gonzalez R.        A\>  
* Descripción   : <\D Trae todos las oficnas      D\>  
* Observaciones   : <\O          O\>  
* Parámetros   : <\P @lcCodigo: Código de un tipo de origen novedad en particular P\>  
*     : <\P @ldFechaReferencia: Fecha para recuperar un tipo determinado P\>  
*     : <\P         de origen contenido en un rango de vigencia P\>  
*     : <\P @lcCadenaSeleccion: Cadena que permite filtrar los registros de   P\>  
*     : <\P         salida de acuerdo a la descripción  P\>  
*     : <\P @lcTraerTodosVisibleUsuario: Permite filtrar los registros de salida P\>  
*     : <\P          de acuerdo a los administrados por P\>  
*     : <\P          el usuario    P\>  
* Variables   : <\V         V\>  
* Fecha Creación  : <\FC 2003/04/16         FC\>  
*  
*---------------------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por                : <\AM     AM\>  
* Descripcion    : <\DM     DM\>  
*     : <\DM     DM\>  
* Nuevos Parametros    : <\PM      PM\>  
* Nuevas Variables   : <\VM      VM\>  
* Fecha Modificacion   : <\FM     FM\>  
*-------------------------------------------------------------------------------------------------------------------------------------*/  
  
CREATE procedure spTraerOficinas  
  
@lcCodigo   char(5)  =  NULL,  
@ldFechaReferencia  DATETIME  =  NULL,  
@lcCadenaSeleccion  UdtDescripcion  =  NULL,  
@lcTraerTodosVisibleUsuario udtLogico  = 'N'  
  
AS  
  
SET Nocount ON  
  
If @ldFechaReferencia Is Null  
 Set @ldFechaReferencia = GetDate()  
  
If  @lcCodigo  IS  NULL  
 If @lcCadenaSeleccion  =  '+' OR @lcCadenaSeleccion  Is NULL        
  Select  a.cdgo_ofcna,  a.dscrpcn_ofcna,  a.drccn_ofcna,   b.cdgo_sde,  
    b.dscrpcn_sde,  a.prncpl,   c.dscrpcn_cdd,   b.cnsctvo_cdgo_sde,  
    a.cnsctvo_cdgo_ofcna  
  From  tbOficinas_vigencias a inner join  tbSedes_Vigencias b on
  a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde   inner join  tbCiudades_Vigencias c     
  on   a.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd  
  Where  (@ldFechaReferencia BETWEEN  a.Inco_vgnca AND a.Fn_vgnca)  
  And  (a.Vsble_Usro     =   'S' Or @lcTraerTodosVisibleUsuario ='S')   
  order by a.cdgo_ofcna  
 Else          
  Select  a.cdgo_ofcna,  a.dscrpcn_ofcna,  a.drccn_ofcna,   b.cdgo_sde,  
    b.dscrpcn_sde,  a.prncpl,   c.dscrpcn_cdd,   b.cnsctvo_cdgo_sde,  
    a.cnsctvo_cdgo_ofcna  
  From  tbOficinas_vigencias a inner join  tbSedes_Vigencias b on
  a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde   inner join  tbCiudades_Vigencias c     
  on   a.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd  
  Where  a.dscrpcn_ofcna LIKE '%'  + LTRIM(RTRIM(@lcCadenaSeleccion))  +  '%'  
  And  (@ldFechaReferencia BETWEEN  a.Inco_vgnca AND a.Fn_vgnca)      
  And  (a.Vsble_Usro  =  'S' Or @lcTraerTodosVisibleUsuario ='S')  
Else           
 Select  a.cdgo_ofcna,  a.dscrpcn_ofcna,  a.drccn_ofcna,   b.cdgo_sde,  
   b.dscrpcn_sde,  a.prncpl,   c.dscrpcn_cdd,   b.cnsctvo_cdgo_sde,  
   a.cnsctvo_cdgo_ofcna  
  From  tbOficinas_vigencias a inner join  tbSedes_Vigencias b on
  a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde   inner join  tbCiudades_Vigencias c     
  on   a.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd  
 Where (@ldFechaReferencia BETWEEN  a.Inco_vgnca AND a.Fn_vgnca)  
 And (a.Vsble_Usro  =  'S' Or @lcTraerTodosVisibleUsuario ='S')        
 And a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde  
 And a.cdgo_ofcna =  @lcCodigo  
 And a.cnsctvo_cdgo_cdd_rsdnca = c.cnsctvo_cdgo_cdd  
  


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spTraerOficinas] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

