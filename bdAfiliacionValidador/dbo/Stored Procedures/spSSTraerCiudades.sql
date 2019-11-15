/*---------------------------------------------------------------------------------  
* Metodo o PRG                  :  spTraerCiudades  
* Desarrollado por    : <\A Ing. Yenith Patricia Zubieta S      A\>  
* Descripcion     : <\D Trae la descripcion de las ciudades     D\>  
* Observaciones               : <\O          O\>  
* Parametros     : <\P            P\>  
* Variables     : <\V            V\>  
* Fecha Creacion              : <\FC 2004/12/04        FC\>  
*  
*---------------------------------------------------------------------------------  
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por   : <\AM  AM\>  
* Descripcion   : <\DM  DM\>  
* Nuevos Parametros  : <\PM  PM\>  
* Nuevas Variables  : <\VM  VM\>  
* Fecha Modificacion  : <\FM  FM\>  
*---------------------------------------------------------------------------------*/  
  
CREATE procedure spSSTraerCiudades  
  
@lcCodigoCiudad  udtCiudad = NULL,  
@lcDescripcionCiudad  udtDescripcion = NULL,  
@ldFechaActual   datetime = NULL,  
@vsble_usro   udtLogico = NULL,  
@lnConsecDpto   udtConsecutivo  = NULL  
AS  
  
Set Nocount On  
If  @ldFechaActual Is Null  
    Set @ldFechaActual = GetDate()  
  
  
If @lnConsecDpto is not null  
    Begin   
        If @lcCodigoCiudad is null  
 Begin  
       If  @lcDescripcionCiudad IS NULL or @lcDescripcionCiudad = '+'  
  --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente.  
  
  Select cdgo_cdd,(dscrpcn_cdd) dscrpcn_cdd,(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,(cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,  
   c.cnsctvo_cdgo_sde, c.cdgo_sde, c.dscrpcn_sde  
  From bdAfiliacionValidador.dbo.tbCiudades_Vigencias a,   bdAfiliacionValidador.dbo.tbDepartamentos b,   
   bdAfiliacionValidador.dbo.tbsedes_vigencias c  
  Where (@ldFechaActual  between a.inco_vgnca   And   a. fn_vgnca)  
  And (a.Vsble_Usro  = 'S'  or  @vsble_usro = 'S')  
  And a.cnsctvo_cdgo_dprtmnto  = @lnConsecDpto  
  And a.cnsctvo_cdgo_dprtmnto  = b.cnsctvo_cdgo_dprtmnto  
  And a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
          Else  
  --Selecciona todos los registros de la tabla  tbciudades dentro de un rango vigente y donde el campo descripcionciudad sea el parametro de consulta.  
  Select cdgo_cdd,   dscrpcn_cdd, b.dscrpcn_dprtmnto,  cnsctvo_cdgo_cdd,  
   c.cnsctvo_cdgo_sde, c.cdgo_sde, c.dscrpcn_sde  
  From bdAfiliacionValidador.dbo.tbCiudades_Vigencias a,   bdAfiliacionValidador.dbo.tbDepartamentos b,  
   bdAfiliacionValidador.dbo.tbsedes_vigencias c  
  Where (@ldFechaActual  between a.inco_vgnca        And   a.fn_vgnca)   
  And dscrpcn_cdd like  '%' + ltrim(rtrim(@lcDescripcionCiudad) + '%' )   
  And a.cnsctvo_cdgo_dprtmnto   = @lnConsecDpto  
  And a.cnsctvo_cdgo_dprtmnto  = b.cnsctvo_cdgo_dprtmnto  
  And (a.Vsble_Usro  = 'S'  or  @vsble_usro = 'S')  
        And a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
            End  
         Else   
             --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.  
   Select  cdgo_cdd,   dscrpcn_cdd,    b.dscrpcn_dprtmnto,  cnsctvo_cdgo_cdd,  
  c.cnsctvo_cdgo_sde, c.cdgo_sde, c.dscrpcn_sde  
     From bdAfiliacionValidador.dbo.tbCiudades_Vigencias a,   bdAfiliacionValidador.dbo.tbDepartamentos b,  
  bdAfiliacionValidador.dbo.tbsedes_vigencias c  
     Where (@ldFechaActual  between a.inco_vgnca    And    a. fn_vgnca)  
     And cdgo_cdd  =  @lcCodigoCiudad  
    And (a.Vsble_Usro  = 'S' or @vsble_usro = 'S')  
    And a.cnsctvo_cdgo_dprtmnto  = @lnConsecDpto  
     And a.cnsctvo_cdgo_dprtmnto  = b.cnsctvo_cdgo_dprtmnto  
    And a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
       End   
 Else  
 Begin   
 If @lcCodigoCiudad is null  
  Begin   
    If  @lcDescripcionCiudad IS NULL  
     --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.  
      Select  cdgo_cdd,   dscrpcn_cdd,    b.dscrpcn_dprtmnto,  cnsctvo_cdgo_cdd,  
    c.cnsctvo_cdgo_sde, c.cdgo_sde, c.dscrpcn_sde  
       From bdAfiliacionValidador.dbo.tbCiudades_Vigencias a,   bdAfiliacionValidador.dbo.tbDepartamentos b,  
    bdAfiliacionValidador.dbo.tbsedes_vigencias c  
     Where (@ldFechaActual  between a.inco_vgnca    And    a. fn_vgnca)  
    And cdgo_cdd  =  @lcCodigoCiudad  
    And (a.Vsble_Usro  = 'S' or @vsble_usro = 'S')  
    And a.cnsctvo_cdgo_dprtmnto = b.cnsctvo_cdgo_dprtmnto  
    And a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
                Else   
                     --Selecciona todos los registros de la tabla  tbciudades dentro de un rango vigente y donde el campo descripcionciudad sea el parametro de consulta.  
               Select cdgo_cdd,dscrpcn_cdd, b.dscrpcn_dprtmnto,  cnsctvo_cdgo_cdd,  
    c.cnsctvo_cdgo_sde,c.cdgo_sde,c.dscrpcn_sde  
   From bdAfiliacionValidador.dbo.tbCiudades_Vigencias a,   bdAfiliacionValidador.dbo.tbDepartamentos b,  
    bdAfiliacionValidador.dbo.tbsedes_vigencias c  
   Where (@ldFechaActual  between a.inco_vgnca   And   a.fn_vgnca)   
    And dscrpcn_cdd like  '%' + ltrim(rtrim(@lcDescripcionCiudad) + '%' )   
    And a.cnsctvo_cdgo_dprtmnto  = b.cnsctvo_cdgo_dprtmnto  
    And (a.Vsble_Usro  = 'S'  or  @vsble_usro = 'S')  
    And a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
  End  
    Else  
  --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.  
  SELECT a.cdgo_cdd,   a.dscrpcn_cdd, b.dscrpcn_dprtmnto,  a.cnsctvo_cdgo_cdd,  
    c.cnsctvo_cdgo_sde, c.cdgo_sde, c.dscrpcn_sde  
  FROM  bdAfiliacionValidador.dbo.tbCiudades_Vigencias a  
  INNER JOIN bdAfiliacionValidador.dbo.tbDepartamentos b  
  ON  a.cnsctvo_cdgo_dprtmnto = b.cnsctvo_cdgo_dprtmnto  
  INNER JOIN bdAfiliacionValidador.dbo.tbsedes_vigencias c  
  ON  a.cnsctvo_sde_inflnca   = c.cnsctvo_cdgo_sde  
  WHERE a.cdgo_cdd   = @lcCodigoCiudad  
  AND  (@ldFechaActual  BETWEEN a.inco_vgnca    AND    a. fn_vgnca)  
  AND  (a.Vsble_Usro  = 'S'  OR  @vsble_usro = 'S')  
 End  
  


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auditor Interno de PVS]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spSSTraerCiudades] TO [Consultor Cuentas Medicas PVS]
    AS [dbo];

