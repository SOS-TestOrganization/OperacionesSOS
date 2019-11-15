




/*---------------------------------------------------------------------------------

* Metodo o PRG                 :   spCUSeleccionaContingencias

* Desarrollado por   :  <\A   Alvaro Zapata   A\>

* Descripcion    :  <\D    D\>

* Descripcion    :  <\D       D\>

* Observaciones                :  <\O     O\>

* Parametros    :  <\P        P\>

                                   :  <\P                      P\>

                                                      :  <\P        P\>

* Variables    :  <\V     V\>

* Fecha Creacion   :  <\FC 20031031              FC\>

*  

*---------------------------------------------------------------------------------

* DATOS DE MODIFICACION 

*---------------------------------------------------------------------------------  

* Modificado Por                : <\AM   AM\>

* Descripcion    : <\DM   DM\>

* Nuevos Parametros    : <\PM   PM\>

* Nuevas Variables   : <\VM   VM\>

* Fecha Modificacion   : <\FM   FM\>

*---------------------------------------------------------------------------------*/

Create Procedure [dbo].[spCUSeleccionaContingencias]

@CodigoContingencia  char(3) = null,

@DescripcionContingencia Char(35) = null

As





If @DescripcionContingencia ='+'

 Select cdgo_cntngnca, dscrpcn_cntngnca, fcha_crcn,

   usro_crcn

 From bdSisalud.dbo.tbContingencias 

 Where vsble_usro = 'S' 



Else



  Select cdgo_cntngnca, dscrpcn_cntngnca, fcha_crcn,

    usro_crcn

  From bdSisalud.dbo.tbContingencias

  where (cdgo_cntngnca = @CodigoContingencia Or @CodigoContingencia is null)

  And  (dscrpcn_cntngnca = @DescripcionContingencia Or @DescripcionContingencia is Null)

  And  vsble_usro = 'S'

















GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [310010 Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spCUSeleccionaContingencias] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

