/*---------------------------------------------------------------------------------
* Metodo o PRG		:  [SpConsultaDatosContratosReintegroReporte]
* Desarrollado por	: <\A Andres Camelo (illustrato ltda)			A\>
* Descripcion		: <\D Este procedimiento se encarga de consultar los datos de los contratos a los cuales se le asociaron reintegros, 
                          se retornara un el conjunto de datos en una sola cadena ya que esta se imprimira en un reporte en un solo campo   D\>
* Observaciones		: <\O  							O\>
* Parametros		: <\P							P\>
* Variables		: <\V  							V\>
* Fecha Creacion	: <\FC 	25/10/2013				FC\>
*---------------------------------------------------------------------------------*/


CREATE  PROCEDURE [dbo].[SpConsultaDatosContratosReintegroReporte]
@nmro_nta			        Varchar(15)



As 

Set Nocount On

Declare @tbContratosReintegros table (
datosContratos            varchar(100)

)


     insert into @tbContratosReintegros(
     datosContratos)
	 select ltrim(rtrim(e.cdgo_tpo_idntfccn)) +' '+ 
            ltrim(rtrim(d.nmro_idntfccn)) +' '+
            ltrim(rtrim(c.prmr_aplldo))  +' '+ isnull(ltrim(rtrim(c.sgndo_aplldo)),'') +' '+  ltrim(rtrim(c.prmr_nmbre))   +' '+ isnull(ltrim(rtrim(c.sgndo_nmbre)),'')
     from  tbNotasContrato a with (nolock)
     inner join  bdAfiliacion.dbo.tbContratos b with (nolock)
     on  (a.nmro_cntrto  = b.nmro_cntrto
          and a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto)
     inner join bdAfiliacion.dbo.tbpersonas c with (nolock)
     on   (b.nmro_unco_idntfccn_afldo  = c.nmro_unco_idntfccn)
     inner join bdAfiliacion.dbo.tbvinculados d with (nolock)
     on   (d.nmro_unco_idntfccn = c.nmro_unco_idntfccn) 
     inner join  bdAfiliacion.dbo.tbTiposIdentificacion_Vigencias  e with (nolock)
     on   (d.cnsctvo_cdgo_tpo_idntfccn =  e.cnsctvo_cdgo_tpo_idntfccn)
     where a.nmro_nta = @nmro_nta
     and b.cnsctvo_cdgo_tpo_aflcn in  (1,2)

	     
      select * from @tbContratosReintegros




