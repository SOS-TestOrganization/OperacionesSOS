CREATE TABLE [dbo].[tbIPSPrimarias_vigencias] (
    [cnsctvo_vgnca_drccn_prstdr] INT           NOT NULL,
    [cdgo_intrno]                CHAR (8)      NOT NULL,
    [nmbre_scrsl]                VARCHAR (150) NOT NULL,
    [inco_vgnca]                 DATETIME      NOT NULL,
    [fn_vgnca]                   DATETIME      NOT NULL,
    [cnsctvo_cdgo_sde_ips]       INT           NOT NULL,
    [obsrvcns]                   VARCHAR (250) NOT NULL,
    [cnsctvo_cdgo_cdd]           INT           NOT NULL,
    [fcha_mdfccn]                DATETIME      NOT NULL,
    [usro_mdfccn]                CHAR (30)     NOT NULL,
    [inco_drcn_rgstro]           DATETIME      NOT NULL,
    [fn_drcn_rgstro]             DATETIME      NOT NULL,
    [tme_stmp]                   ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tbIPSPrimarias_vigencias] PRIMARY KEY CLUSTERED ([cnsctvo_vgnca_drccn_prstdr] ASC) WITH (FILLFACTOR = 98)
);


GO
CREATE NONCLUSTERED INDEX [idx_cdgo_intrno]
    ON [dbo].[tbIPSPrimarias_vigencias]([cdgo_intrno] ASC, [cnsctvo_cdgo_cdd] ASC)
    ON [FG_INDEXES];


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 :	TrReferencia_Usuario_tbIPSPrimarias_vigencias
* Desarrollado por	: <\A	Ing. Jorge Meneses			  A\>
* Descripcion	 	: <\D	Garantiza integridad referencial con una tabla en otra base de Datos D\>
* Observaciones     	: <\O	O\>
* Parametros		: <\P	P\>
* Variables		: <\V	V\>
* Fecha Creacion	: <\FC 2002/07/01	FC\>
*--------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------------------------------
* Modificado Por	: <\AM Ing. Maribel Valencia Herrera		AM\>
* Descripcion		: <\DM El mensaje no corresponde a la validacion del trigger y es muy técnico para el usuario  DM\>
			  <\DM Error, Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn	 DM\>
			  <\DM el trigger valida que el usuario se encuentrecreado  en  bdSeguridad.tbUsuarios.usro_crcn	 DM\>			 DM\>
* Nuevos Parametros	: <\PM		PM\>
* Nuevas Variables	: <\VM		VM\>
* Fecha Modificacion	: <\FM		FM\>
*------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbIPSPrimarias_vigencias] ON    [dbo].[tbIPSPrimarias_vigencias]
FOR  INSERT--,UPDATE
AS
Begin
	Declare 	@lcmnsje	varchar(400),
			@lcusro		varchar(10)
	Set Nocount On
	
	If Not Exists (	Select	 p.lgn_usro From	[bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
			Where	p.lgn_usro = i.usro_mdfccn)
	Begin
		Select	@lcusro=  i.usro_mdfccn From	 Inserted i
		Rollback Transaction
		Select 	@lcmnsje  =  'Error, El Usuario '+  @lcusro+' no se encuentra creado en  bdSeguridad..tbUsuarios'
		Raiserror (999902,0, @lcmnsje)
		Return
	End
End


GO
/*--------------------------------------------------------------------------------------------------------
* Nombre                 :	TrReferencia_Usuario_tbIPSPrimarias_vigencias
* Desarrollado por	: <\A	Ing. Jorge Meneses			  A\>
* Descripcion	 	: <\D	Garantiza integridad referencial con una tabla en otra base de Datos D\>
* Observaciones     	: <\O	O\>
* Parametros		: <\P	P\>
* Variables		: <\V	V\>
* Fecha Creacion	: <\FC 2002/07/01	FC\>
*--------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*--------------------------------------------------------------------------------------------------------
* Modificado Por	: <\AM Ing. Maribel Valencia Herrera		AM\>
* Descripcion		: <\DM El mensaje no corresponde a la validacion del trigger y es muy técnico para el usuario  DM\>
			  <\DM Error, Violación de Integridad Referencial con bdSeguridad.tbUsuarios.usro_crcn	 DM\>
			  <\DM el trigger valida que el usuario se encuentrecreado  en  bdSeguridad.tbUsuarios.usro_crcn	 DM\>			 DM\>
* Nuevos Parametros	: <\PM		PM\>
* Nuevas Variables	: <\VM		VM\>
* Fecha Modificacion	: <\FM		FM\>
*------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrReferencia_Usuario_tbIPSPrimarias_vigenciasU] ON    [dbo].[tbIPSPrimarias_vigencias]
FOR  UPDATE
AS
Begin
	Declare 	@lcmnsje	varchar(400),
			@lcusro		varchar(10)
	Set Nocount On
	
	If Not Exists (	Select	 p.lgn_usro From	[bdSeguridad].[dbo].[tbUsuarios] p, Inserted i
			Where	p.lgn_usro = i.usro_mdfccn)
	Begin
		Select	@lcusro=  i.usro_mdfccn From	 Inserted i
		Select 	@lcmnsje  =  'Error, El Usuario '+  @lcusro+' no se encuentra creado en  bdSeguridad..tbUsuarios'
		Rollback Transaction
		Raiserror (999902,0, @lcmnsje)
		Return
	End

End


GO
/*---------------------------------------------------------------------------------
* Nombre		: TrValidaTraslapeCodigo_tbEntidades_Vigencias
* Desarrollado por	: <\A Ing. Antonio José Fajardo Macías				A\>
* Descripcion		: <\D Valida que no se traslape  la Vigencia Nueva con Alguna existente para el mismo parametro D\>
* Observaciones		: <\O		O\>
* Parametros		: <\P   P\>
* Variables		: <\V	Fecha Inicial Nueva					V\>
*			: <\V   Fecha Final Nueva					V\>
*			: <\V   Fecha Inicial Traslape					V\>
*			: <\V   Fecha Final Traslape					V\>
*			: <\V   Mensaje de Error						V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Consectivo del Parametro Nuevo				V\>
*			: <\V   Codigo del Parametro Nuevo				V\>
*			: <\V   Consecutivo de la Vigencia				V\>
*			: <\V   Descripción del parámetro Nuevo				V\>
* Fecha Creacion	: <\FC 2003/08/06						FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaTraslapeCodigo_tbipsPrimariasr_Vigencias] ON   [dbo].[tbIPSPrimarias_vigencias]
FOR  INSERT
AS
Begin
SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca		datetime,     
			@tfn_vgnca		datetime,      
			@mnsje			varchar(400), 
			@contador		int,
			@Codigo_Consecutivo	udtCodigoIps,
		  	@cdgo_ara		udtcodigo,
			@cdgo_vgnca		udtconsecutivo,
			@dscrpcn		udtDescripcion
-->Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca = inco_vgnca,
		@fn_vgnca	= fn_vgnca,
		@Codigo_Consecutivo = cdgo_intrno	,
		--@cdgo_ara = cdgo_entdd		,
		@cdgo_vgnca	= cnsctvo_vgnca_drccn_prstdr  --,
		--@dscrpcn = dscrpcn_entdd
FROM   INSERTED
	
-->Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM tbIPSPrimarias_vigencias p --tbEntidades_Vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cdgo_intrno= @Codigo_Consecutivo
-->Hay traslape de fechas
--set @contador=2
	IF @contador > 1
          
	Begin   
-->Para Indicar al usuario contra que fecha hay traslape
		SELECT @tinco_vgnca = inco_vgnca,@tfn_vgnca = fn_vgnca
		FROM tbIPSPrimarias_vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cdgo_intrno = @Codigo_Consecutivo
		--and 	cnsctvo_vgnca_drccn_prstdr != @cdgo_vgnca	
		
		
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con   '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		Raiserror (999905,0, @mnsje)
		RETURN
	End
--update tbEntidades set dscrpcn_entdd = @dscrpcn
--where cnsctvo_cdgo_entdd = @Codigo_Consecutivo
End


GO
/*---------------------------------------------------------------------------------
* Nombre		: TrValidaUpdateTraslapeCodigo_tbDireccionesPrestador_Vigencias
* Desarrollado por	: <\A Ing. Antonio José Fajardo Macías					A\>
* Descripcion		: <\D Valida que no se traslape  las fechas Modificadas con una exitente		D\>
* Observaciones		: <\O								O\>
* Parametros		: <\P	P\>
* Variables		: <\V   Fecha Inicial Nueva					V\>
*			: <\V   Fecha Final Nueva				
*			: <\V   Fecha Inicial Traslape					V\>
*			: <\V   Fecha Final Traslape					V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Consectivo del Parametro Nuevo			V\>
*			: <\V   Mensaje de Error					V\>
*			: <\V   Contador  de registros					V\>
*			: <\V   Fecha Inicial Modificada				V\>
*			: <\V   Fecha Final Modificada				V\>
*			: <\V   Consecutivo del Parametro Modificado		V\>
*			: <\V   Codigo del Parametro Nuevo				V\>
*			: <\V   Consecutivo de la Vigencia Modificado		V\>							V\>
* Fecha Creacion		: <\FC 2002/08/06				FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripcion		: <\DM  DM\>
* Nuevos Parametros	: <\PM  PM\>
* Nuevas Variables	: <\VM  VM\>
* Fecha Modificacion	: <\FM  FM\>
-----------------------------------------------------------------------------------*/
CREATE TRIGGER  [dbo].[TrValidaUpdateTraslapeCodigo_tbIPSPrimarias_vigencias] ON   [dbo].[tbIPSPrimarias_vigencias]
FOR  UPDATE
AS
Begin
SET NOCOUNT ON
	DECLARE	@inco_vgnca		datetime,     
			@fn_vgnca		datetime,      
			@tinco_vgnca		datetime,     
			@tfn_vgnca		datetime,      
			@mnsje			varchar(400), 
			@contador		int,
			@Codigo_Consecutivo	udtCodigoIps,
			@dinco_vgnca		datetime,     
      		  	@dfn_vgnca		datetime,
      			@dcnsctvo_tbla		char(8),
			@cdgo_ara		udtCodigo,
			@cnsctvo_vgnca	udtConsecutivo--,
			--@dcnsctvo_vgnca	udtConsecutivo
/*
--> Se capturan las variables que se estan tratando de insertar
SELECT	@inco_vgnca = inco_vgnca,
		@fn_vgnca	= fn_vgnca,
		@Codigo_Consecutivo = cdgo_intrno,
		@cnsctvo_vgnca = cnsctvo_vgnca_drccn_prstdr	
FROM   INSERTED
-->    Se capturan las variables que se estan modificando
SELECT     @dinco_vgnca   =  inco_vgnca,
	      @dfn_vgnca     =  fn_vgnca,
     	      @dcnsctvo_tbla  =  cdgo_intrno--,
	   --   @dcnsctvo_vgnca = cnsctvo_vgnca_drccn_prstdr			     
FROM	deleted
 
-->Obtener la imagen de los registros Modificados (Deleted) e Insertados (Inserted)
select * into #tbValoresAnteriores From Deleted
select * into #tbValoresNuevos From Inserted
-->valida que los campos que se estan modificando sean los campos de fecha de vigencia 
if  Exists (select * from #tbValoresAnteriores d,  #tbValoresNuevos n
              where   (convert(varchar(10),d.inco_vgnca,111)<>convert(varchar(10),n.inco_vgnca,111)
             		or convert(varchar(10),d.fn_vgnca,111)<>convert(varchar(10),n.fn_vgnca,111))
              and d.cnsctvo_vgnca_drccn_prstdr = n.cnsctvo_vgnca_drccn_prstdr )
begin
     
--> Valida que el parametro a modificar sea vigente
		if  (convert(varchar(10),@dfn_vgnca,111) < convert(varchar(10),getDate(),111)  and 
                                convert(varchar(10),@inco_vgnca,111) <= convert(varchar(10),@dfn_vgnca,111) and
                                convert(varchar(10),@fn_vgnca,111) >=  convert(varchar(10),@dinco_vgnca,111)  )
		    	 begin
				Drop Table #tbValoresAnteriores
				Drop Table #tbValoresNuevos
  				ROLLBACK TRANSACTION
				select @mnsje  =  'Error,  No se puede Modificar la Vigencia de un Parámetro no Vigente'
				RAISERROR 999909   @mnsje
				RETURN
		                end
--> Valida que si el parametro es vigente no pueda incrementar inicio vigencia
		if convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
          	     	   convert(varchar(10),@dinco_vgnca,111)<=convert(varchar(10),getDate(),111)  and
		   convert(varchar(10),@dinco_vgnca,111) <  convert(varchar(10),@inco_vgnca,111) and
		   convert(varchar(10),@inco_vgnca,111) <  convert(varchar(10),@dfn_vgnca,111)					
			begin 
				Drop Table #tbValoresAnteriores
				Drop Table #tbValoresNuevos
				ROLLBACK TRANSACTION
				select @mnsje  =  'Error, No se permite Incrementar el Inicio de Vigencia de un Parámetro Vigente '
				RAISERROR 999908   @mnsje
				RETURN
 			end
	
-->Valida que el fin de vigencia no sea inferior a fecha actual  para un parametro vigente
	 if  convert(varchar(10),@dfn_vgnca,111) >=convert(varchar(10),getDate(),111)  and 
      				   convert(varchar(10),@fn_vgnca,111) <  convert(varchar(10),getDate(),111) and
                  convert(varchar(10),@dinco_vgnca,111) < =convert(varchar(10),@fn_vgnca,111)  
			
				begin 
					Drop Table #tbValoresAnteriores
					Drop Table #tbValoresNuevos
					ROLLBACK TRANSACTION
					select @mnsje  =  'Error, El  Fin de Vigencia debe ser Superior  a  la Fecha Actual para un Parámetro Vigente'
					RAISERROR 999907   @mnsje
					RETURN
 				end
-->Se Calcula si hay  traslape de fechas
	SELECT @contador=count(*)
	FROM  tbIPSPrimarias_vigencias p
	WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
	And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
	And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
	And	p.cdgo_intrno = @Codigo_Consecutivo
    
	IF @contador > 1
-->Hay traslape de fechas
	Begin
		SELECT @tinco_vgnca=inco_vgnca,@tfn_vgnca=fn_vgnca
		FROM tbIPSPrimarias_vigencias p
		WHERE ( (convert(varchar(10),p.inco_vgnca,111)  >= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@fn_vgnca,111))   Or
			(convert(varchar(10),p.fn_vgnca,111)    >= convert(varchar(10),@inco_vgnca,111) 
		And	 convert(varchar(10),p.fn_vgnca,111)    <= convert(varchar(10),@fn_vgnca,111))   Or
		(convert(varchar(10),p.inco_vgnca,111)  <= convert(varchar(10),@inco_vgnca,111) 
		And	convert(varchar(10),p.fn_vgnca,111)     >= convert(varchar(10),@fn_vgnca,111)))  
		And	p.cdgo_intrno = @Codigo_Consecutivo
  	      	and       p.cnsctvo_vgnca_drccn_prstdr != @cnsctvo_vgnca
		Drop Table #tbValoresAnteriores
		Drop Table #tbValoresNuevos
		ROLLBACK TRANSACTION
		select @mnsje  =  'Error, Insertando, Existe  Traslape con  '+  convert(varchar(10),@tinco_vgnca,111) + '  ' + convert(varchar(10),@tfn_vgnca,111)
		Raiserror (999905,0, @mnsje)
		RETURN
	End
end
*/
End


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Analistas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [900002 Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [900011 Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [330007 Liquidador Facturas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [cna_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [ServicioClientePortal]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [aut_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [cna_espusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [portal_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [proceso3047_webusr]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [autsalud_rol]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [envioops_webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor de Prestaciones Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador Parametros Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auxiliar Parametros Capitacion Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auxiliar Parametros Incapacidades Vision Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auxiliar Parametros Notificaciones Vision Salud]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auditor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor Salud]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Inteligencia]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [webusr]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consulta]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor Administrador]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[tbIPSPrimarias_vigencias] TO [Consultor Auditor]
    AS [dbo];

