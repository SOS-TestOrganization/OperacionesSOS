    /*---------------------------------------------------------------------------------------------------------------------------------------  
* Procedimiento   : spPMTraerOficinasUsuariosWeb  
* Desarrollado por  : <\A Ing. Adriana Cifuentes          A\>  
* Descripción   : <\D Trae todos las oficnas de acuerdo a la sede enviada como parametro D\>  
* Observaciones  : <\O           O\>  
* Parámetros   : <\P @lcCodigoOficina: Código de la oficina                                P\>  
*     : <\P @ldFechaReferencia: Fecha para recuperar un tipo determinado  P\>  
*     : <\P         de origen contenido en un rango de vigencia  P\>  
*     : <\P @lcCadenaSeleccion: Cadena que permite filtrar los registros de    P\>  
*     : <\P         salida de acuerdo a la descripción   P\>  
*    : <\P @lcConsecutivoSede:  consecutivo de la ses    P\>  
*     : <\P @lcTraerTodosVisibleUsuario: Permite filtrar los registros de salida P\>  
*     : <\P          de acuerdo a los administrados por  P\>  
*     : <\P          el usuario     P\>  
* Variables   : <\V          V\>  
* Fecha Creación  : <\FC 2003/04/25          FC\>  
*  
*---------------------------------------------------------------------------------------------------------------------------------------  
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------------------------------------------------------------  
* Modificado Por   : <\AM     AM\>  
* Descripcion    : <\DM     DM\>  
*     : <\DM     DM\>  
* Nuevos Parametros    : <\PM     PM\>  
* Nuevas Variables   : <\VM     VM\>  
* Fecha Modificacion   : <\FM   FM\>  
*-------------------------------------------------------------------------------------------------------------------------------------*/  
CREATE Procedure [dbo].[spPMTraerOficinasUsuariosWeb]  
@lcCodigoOficina  Char(5)   =  NULL,  
@ldFechaReferencia  DATETIME  =  NULL,  
@lcCadenaSeleccion  UdtDescripcion  =  NULL,  
@lnConsecutivoSede  UdtConsecutivo  = NULL,  
@lnLlamado   udtLogico  = 'N',  
@usro_sstma   char(30)    
  
AS  
SET Nocount ON   
  
IF @ldFechaReferencia Is Null  
 Set @ldFechaReferencia = GetDate()  
  
If Exists ( Select 1     
  From bdSeguridad..tbPerfilesWeb b , bdSeguridad..tbUsuariosxPerfilWeb c   
  Where  b.cnsctvo_cdgo_prfl = c.cnsctvo_cdgo_prfl   
  And  c.lgn_usro  = @usro_sstma  
  And  b.cnsctvo_cdgo_prfl > 1 --Administrador IPS  
  And  b.cnsctvo_cdgo_mdlo  =  1)   
Begin    
 If @lcCodigoOficina Is Null  
 Begin  
  If @lcCadenaSeleccion = '+' Or @lcCadenaSeleccion Is Null  
  Begin  
   -- Si codigo de la oficina es nulo y cadena de seleccion es nula  
   -- Se seleccionan todos las oficinas que no hayan sido borrados y cumplan la vigencia   
   Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
   From  tbOficinas_Vigencias a, tbSedes_Vigencias b , bdSeguridad..tbUsuariosWeb c   
   Where a.cnsctvo_cdgo_ofcna = c.cnsctvo_cdgo_ofcna  
   And c.lgn_usro  = @usro_sstma  
   And (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)  
   And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
   And       (a.vsble_usro    = 'S' Or @lnLlamado = 'S')  
   And       a.cnsctvo_cdgo_sde   = b.cnsctvo_cdgo_sde  
   And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
  End   
  Else  
  Begin  
   -- Si codigo de oficina es nulo y cadena de seleccion no es nula   
   -- Se seleccionan todos las oficinas que no hayan sido borrados, cumplan la vigencia y   
   -- tengan esa descripcion    
   Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
   From  tbOficinas_Vigencias a, tbSedes_Vigencias b , bdSeguridad..tbUsuariosWeb c   
   Where a.cnsctvo_cdgo_ofcna = c.cnsctvo_cdgo_ofcna   
   And c.lgn_usro  = @usro_sstma  
   And (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)   
   And      (a.vsble_usro   = 'S'Or @lnLlamado = 'S')  
   And ltrim(rtrim(a.dscrpcn_ofcna)) Like '%'+ltrim(rtrim(@lcCadenaSeleccion))+'%'   
   And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
   And       a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde  
   And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
  End   
    
 End  
 Else  
 Begin  
  -- Si codigo de oficina no es nulo se seleccionan todos las oficinas que no hayan sido borrados,   
  -- cumplan la vigencia y tengan el codigo de sede que se ingreso  
  Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
  From  tbOficinas_Vigencias a, tbSedes_Vigencias b , bdSeguridad..tbUsuariosWeb c   
  Where a.cnsctvo_cdgo_ofcna = c.cnsctvo_cdgo_ofcna   
  And c.lgn_usro  = @usro_sstma  
  And (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)  
  And       (a.vsble_usro   = 'S' Or @lnLlamado = 'S')  
  And a.cdgo_ofcna   = @lcCodigoOficina  
  And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
  And      a.cnsctvo_cdgo_sde   = b.cnsctvo_cdgo_sde  
  And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
 End  
End   
Else   
Begin   
   
 If @lcCodigoOficina Is Null  
 Begin  
  If @lcCadenaSeleccion = '+' Or @lcCadenaSeleccion Is Null  
  Begin  
   -- Si codigo de la oficina es nulo y cadena de seleccion es nula  
   -- Se seleccionan todos las oficinas que no hayan sido borrados y cumplan la vigencia   
   Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
   From tbOficinas_Vigencias a, tbSedes_Vigencias b  
   Where (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)  
   And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
   And       (a.vsble_usro    = 'S' Or @lnLlamado = 'S')  
   And       a.cnsctvo_cdgo_sde   = b.cnsctvo_cdgo_sde  
   And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
  End   
  Else  
  Begin  
   -- Si codigo de oficina es nulo y cadena de seleccion no es nula   
   -- Se seleccionan todos las oficinas que no hayan sido borrados, cumplan la vigencia y   
   -- tengan esa descripcion    
   Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
   From tbOficinas_Vigencias a, tbSedes_Vigencias b  
   Where (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)   
   And      (a.vsble_usro   = 'S'Or @lnLlamado = 'S')  
   And ltrim(rtrim(a.dscrpcn_ofcna)) Like '%'+ltrim(rtrim(@lcCadenaSeleccion))+'%'  
   And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
   And       a.cnsctvo_cdgo_sde  = b.cnsctvo_cdgo_sde  
   And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
  End   
    
 End  
 Else  
 Begin  
  -- Si codigo de oficina no es nulo se seleccionan todos las oficinas que no hayan sido borrados,   
  -- cumplan la vigencia y tengan el codigo de sede que se ingreso  
  Select a.cdgo_ofcna, a.dscrpcn_ofcna, a.cnsctvo_cdgo_ofcna,   
           a.cnsctvo_cdgo_sde, b.cdgo_sde  
  From tbOficinas_Vigencias a, tbSedes_Vigencias b  
  Where (@ldFechaReferencia Between a.inco_vgnca And a.fn_vgnca)  
  And       (a.vsble_usro   = 'S' Or @lnLlamado = 'S')  
  And a.cdgo_ofcna   = @lcCodigoOficina  
  And ((a.cnsctvo_cdgo_sde = @lnConsecutivoSede) Or @lnConsecutivoSede Is Null)  
  And      a.cnsctvo_cdgo_sde   = b.cnsctvo_cdgo_sde  
  And (@ldFechaReferencia Between b.inco_vgnca And b.fn_vgnca)  
 End  
End   
  

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasUsuariosWeb] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasUsuariosWeb] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPMTraerOficinasUsuariosWeb] TO [Consultor Servicio al Cliente]
    AS [dbo];

