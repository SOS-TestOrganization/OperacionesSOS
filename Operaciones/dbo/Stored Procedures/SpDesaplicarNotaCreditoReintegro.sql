
/*---------------------------------------------------------------------------------
* Metodo o PRG 		:  SpDesaplicarNotaCreditoReintegro
* Desarrollado por		: <\A Ing. Andres Camelo (illustrato ltda) 								A\>
* Descripcion			: <\D Este procedimiento  permite desaplicar el pago de una nota reintegro y  la nota Reintegro asociada	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013/11/22											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM   DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM   FM\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[SpDesaplicarNotaCreditoReintegro]
	
	@lcTipoNota					udtConsecutivo,
	@nmro_nta					Varchar(15),	
	@nmro_unco_idntfccn_empldr			udtconsecutivo,
	@cnsctvo_scrsl					udtconsecutivo,
	@cnsctvo_cdgo_clse_aprtnte			udtconsecutivo,	
	@lcUsuario					udtUsuario,
	@lnProcesoExitoso				int		output,
	@lcMensaje					char(200)	output
	
 

As	Declare
@ldFechaSistema			        Datetime,
@lnConsecutivoTipoNotaDebito	udtconsecutivo,
@lnConsecutivoEstadoActualNota	udtconsecutivo,
@lnMax_cnsctvo_nta_aplcda		udtconsecutivo,
@lnMax_cnsctvo_estdo_nta		udtconsecutivo,
@valor_nota				        udtValorGrande,
@Valor_iva_nota			        udtValorGrande,
@Valor_saldo_nota			    udtValorGrande,
@lnTotalValorNotasDebito		numeric(12,0),
@lntotalValorEstadosCuenta		numeric(12,0),
@TotalValorNota			        udtValorGrande,
@numeroNotaRei                  Varchar(15),
@lcTipoNotaRei                  udtConsecutivo

Set  nocount on 

-- Creacion de tablas temporales

Create table #tmpNotasEstadoCuenta
(nmro_nta  varchar(15)  ,
 cnsctvo_cdgo_tpo_nta int,
 cnsctvo_estdo_cnta int,
 vlr numeric(12,0))

Create table #tmpNotasAplicadas
(nmro_nta_aplcda varchar(15),
 cnsctvo_cdgo_tpo_nta_aplcda int,
 vlr_aplcdo numeric(12,0))

Create table #tmpAbonosContratoCredito
(cnsctvo_estdo_cnta_cntrto int ,
 vlr numeric(12,0)    , 
 vlr_iva numeric(12,0) ,
 cnsctvo_nta_cntrto int)

Create table #tmpcontratosEstadocuenta
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto varchar(20),
 vlr numeric(12,0),
 vlr_iva numeric(12,0))

Create table 	#TmpNotasDebito
(nmro_rgstro int IDENTITY(1,1), 
 nmro_nta varchar(20),		
 cnsctvo_cdgo_tpo_nta int,
 cnsctvo_cdgo_estdo_nta int,
 vlr_nta numeric(12,0), 
 vlr_iva numeric(12,0),
 sldo_nta numeric(12,0))


Set	@ldFechaSistema		=	Getdate()

Set	@lnConsecutivoTipoNotaDebito	=	1
Set	@lnProcesoExitoso		=	0


Select	@lnConsecutivoEstadoActualNota	=	cnsctvo_cdgo_estdo_nta
From	bdcarteraPac.dbo.TbnotasPac a 
Where 	a.nmro_nta				= 	@nmro_nta
And	a.cnsctvo_cdgo_tpo_nta			=	@lcTipoNota



				
If  (@lnConsecutivoEstadoActualNota	=	5	or 	@lnConsecutivoEstadoActualNota	=	6) -- sin aplicar o anulada
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'No se puede desaplicar la nota Reintegro su estado no lo permite'
		Return -1
	end	



Begin	Tran	


--trae informacion de las notas credito que tiene asociado los estados de cuenta
Insert into 	#tmpNotasEstadoCuenta
Select  nmro_nta   ,     cnsctvo_cdgo_tpo_nta , cnsctvo_estdo_cnta,  vlr 
From 	bdcarteraPac.dbo.tbnotasestadocuenta
where  	nmro_nta			=	@nmro_nta
And      cnsctvo_cdgo_tpo_nta		=	@lcTipoNota


		

--Trae la informacion de los notas debito asociadas a la nota credito
insert into 	#tmpNotasAplicadas
Select 	nmro_nta_aplcda, 	cnsctvo_cdgo_tpo_nta_aplcda, 	 vlr_aplcdo 
From   	bdcarteraPac.dbo.tbnotasaplicadas
where  	nmro_nta			=	@nmro_nta
And    	cnsctvo_cdgo_tpo_nta		=	@lcTipoNota


--calcula el valor total por estadoa de cuenta asociadas ala nota credito que  se va reversar
Select	@lntotalValorEstadosCuenta	=isnull(sum(vlr),0)
From	#tmpNotasEstadoCuenta

--Se calcula el valor total por notas debito asociadas ala nota credito  pago
Select	@lnTotalValorNotasDebito	=isnull(sum(vlr_aplcdo),0)
From	#tmpNotasAplicadas


--se actualiza para los estados de cuenta
Update  bdcarteraPac.dbo.TbestadosCuenta
Set	sldo_estdo_cnta	=	sldo_estdo_cnta  + vlr
From	bdcarteraPac.dbo.TbestadosCuenta a inner join  #tmpNotasEstadoCuenta b
	on (a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el saldo del estado de cuenta'
		Rollback tran 
		Return -1
	end	

--si es igual a su estado original queda en 1
-- con el saldo del documento
Update  bdcarteraPac.dbo.TbestadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	1
From	bdcarteraPac.dbo.TbestadosCuenta a inner join   #tmpNotasEstadoCuenta b
	on (a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
Where 	(a.ttl_fctrdo + vlr_iva)	=	a.sldo_estdo_cnta  
      

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el estado del estado de cuenta'
		Rollback tran 
		Return -1
	end	

--queda en dos si tiene algun valor que disminuya el saldo..
-- con el saldo del documento
Update  bdcarteraPac.dbo.TbestadosCuenta
Set	cnsctvo_cdgo_estdo_estdo_cnta	=	2
From	bdcarteraPac.dbo.TbestadosCuenta a inner join  #tmpNotasEstadoCuenta b
	on (a.cnsctvo_estdo_cnta	=	b.cnsctvo_estdo_cnta)
Where 	(a.ttl_fctrdo + vlr_iva)	!=	a.sldo_estdo_cnta  
      

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el estado del estado de cuenta'
		Rollback tran 
		Return -1
	end	



--se actualiza para las notas debito
update  bdcarteraPac.dbo.TbNotasPac
Set	sldo_nta	=	sldo_nta  + vlr_aplcdo
From	bdcarteraPac.dbo.TbNotasPac a  inner join  #tmpNotasAplicadas b
	on (	a.nmro_nta			=	b.nmro_nta_aplcda
	And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta_aplcda)


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el saldo de la nota'
		Rollback tran 
		Return -1
	end	

--Actualiza el estado de las notas debito

Update  bdcarteraPac.dbo.TbNotasPac
Set	cnsctvo_cdgo_estdo_nta	=	1
From	bdcarteraPac.dbo.TbNotasPac a inner join  #tmpNotasAplicadas b
	on (	a.nmro_nta		=	b.nmro_nta_aplcda
	And	a.cnsctvo_cdgo_tpo_nta	=	b.cnsctvo_cdgo_tpo_nta_aplcda)
Where	a.vlr_nta +   a.vlr_iva  	=	    a.sldo_nta





If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el estado de la nota'
		Rollback tran 
		Return -1
	end	




--actualiza el saldo del estado  a los contratos asociados al pago
insert into	#tmpAbonosContratoCredito
select  	cnsctvo_estdo_cnta_cntrto ,	vlr     ,       vlr_iva ,cnsctvo_nta_cntrto
from	 bdcarteraPac.dbo.tbnotasContrato a
where	 a.nmro_nta			=	@nmro_nta
And	 a.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota





Insert into #tmpcontratosEstadocuenta
Select	a.cnsctvo_cdgo_tpo_cntrto,
	a.nmro_cntrto,
	b.vlr,
	b.vlr_iva
From	TbEstadosCuentaContratos a inner join 	#tmpAbonosContratoCredito  b
	on (a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)


--Se crea una tabla temporal con todos los contratos del estado de cuenta asociados al pago
--para actualizar el saldo a nivel del contrato

Update  bdcarteraPac.dbo.TbEstadosCuentaContratos
Set	sldo			=	sldo + 	b.vlr	+	b.vlr_iva,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	bdcarteraPac.dbo.TbEstadosCuentaContratos a inner join #tmpAbonosContratoCredito  b
	on (a.cnsctvo_estdo_cnta_cntrto	=	b.cnsctvo_estdo_cnta_cntrto)



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando los contratos del estado de cuenta'
		Rollback tran 
		Return -1
	end	


Update	bdcarteraPac.dbo.tbnotasContrato
Set	sldo_nta_cntrto	=	sldo_nta_cntrto +  b.vlr    +       b.vlr_iva ,
	fcha_ultma_mdfccn	=	@ldFechaSistema,
	usro_ultma_mdfccn	=	@lcUsuario
From	bdcarteraPac.dbo.tbnotasContrato a inner join   #tmpAbonosContratoCredito b
	on (a.cnsctvo_nta_cntrto			=	b.cnsctvo_nta_cntrto)



If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error Actualizando el saldo de los contratos de la nota credito'
		Rollback tran 
		Return -1
	end	

--Selecciona las notas debito afectadas por la nota credito para actualizar el saldo
Update 	bdcarteraPac.dbo.tbnotascontrato
Set	sldo_nta_cntrto	=	sldo_nta_cntrto	+	valor_aplicado
From	bdcarteraPac.dbo.tbnotascontrato a, (	Select      b.cnsctvo_nta_cntrto_dbto, sum(vlr_aplcdo) valor_aplicado
				from	   #tmpAbonosContratoCredito a , tbNotasCreditoContratosxNotasDebito b
				where	   a.cnsctvo_nta_cntrto	=	b.cnsctvo_nta_cntrto_cdto
				Group by   b.cnsctvo_nta_cntrto_dbto)  TmpNotasDebito
Where	a.cnsctvo_nta_cntrto	=	TmpNotasDebito.cnsctvo_nta_cntrto_dbto


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error eliminando las notas del estado cuenta'
		Rollback tran 
		Return -1
	end	



Delete From	bdcarteraPac.dbo.tbnotasestadocuenta
where    nmro_nta			=	@nmro_nta
And      cnsctvo_cdgo_tpo_nta		=	@lcTipoNota

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error eliminando las notas del estado cuenta'
		Rollback tran 
		Return -1
	end	





--actualiza el estado el el valor de la nota
Insert into  	#TmpNotasDebito
Select	a.nmro_nta,		
	a.cnsctvo_cdgo_tpo_nta,
	a.cnsctvo_cdgo_estdo_nta,
	a.vlr_nta, 
	a.vlr_iva,
        a.sldo_nta
From	bdcarteraPac.dbo.TbnotasPac a 	inner join  #tmpNotasAplicadas b
	on	(a.nmro_nta			= 	b.nmro_nta_aplcda
	And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta_aplcda)

-- se valida que sea una nota debito lo que este asociado
if exists(select 1 from #TmpNotasDebito)
  begin
	-- se consulta el maximo consecutivo que siguie para el estado por nota
	-- se guardan todos los estado por nota
	Select 	@lnMax_cnsctvo_estdo_nta	=	 isnull(max(cnsctvo_estdo_nta),0)	 
	From	bdcarteraPac.dbo.tbestadosXnota


	Insert into bdcarteraPac.dbo.TbestadosXnota
	Select	nmro_rgstro + @lnMax_cnsctvo_estdo_nta,
		nmro_nta,	
		cnsctvo_cdgo_tpo_nta,
		cnsctvo_cdgo_estdo_nta,
		vlr_nta,		
		vlr_iva,
		sldo_nta,
		@ldFechaSistema,
		@lcUsuario,
		Null
	From	#TmpNotasDebito



	If  @@error!=0  
		Begin 
			Set	@lnProcesoExitoso	=	1
			Set	@lcMensaje		=	'Error insertando los estados por el tipo de nota'
			Rollback tran 
			Return -1
		end	
  end

-- se actualiza el saldo del valor de la nota credito
-- y  se actualiza el estado de la nota a sin aplicar
Update 	bdcarteraPac.dbo.TbnotasPac
Set	sldo_nta				=	sldo_nta  + @lntotalValorEstadosCuenta + @lnTotalValorNotasDebito ,
	cnsctvo_cdgo_estdo_nta		=	8	-- AUTORIZADO
From	bdcarteraPac.dbo.TbnotasPac a 
Where 	a.nmro_nta			= 	@nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error borrando las notas aplicadas'
		Rollback tran 
		Return -1
	end	



-- calcula los valores actuales de la nota credito
Select 	@valor_nota		=	vlr_nta,
	@Valor_iva_nota	=       	vlr_iva,
	@Valor_saldo_nota	=	sldo_nta
From	bdcarteraPac.dbo.tbnotasPac a
Where 	a.nmro_nta			= 	@nmro_nta
And	a.cnsctvo_cdgo_tpo_nta		=	@lcTipoNota



-- se inserta el estado de la nota credito


Select 	@lnMax_cnsctvo_estdo_nta	=	 isnull(max(cnsctvo_estdo_nta),0)	 
From	tbestadosXnota

Insert into bdcarteraPac.dbo.TbestadosXnota
		(cnsctvo_estdo_nta,		nmro_nta,		cnsctvo_cdgo_tpo_nta,
		cnsctvo_cdgo_estdo_nta,		vlr_nta,			vlr_iva,
		sldo_nta,			fcha_cmbo_estdo,	usro_cmbo_estdo)
	Values  (@lnMax_cnsctvo_estdo_nta+1,	@nmro_nta,		@lcTipoNota,
		5,		@valor_nota,		@Valor_iva_nota,	-- que da sin aplicar
		@Valor_saldo_nota,		@ldFechaSistema,	@lcUsuario)
		


Delete	 From bdcarteraPac.dbo.tbnotasaplicadas
Where	 nmro_nta		=	    @nmro_nta
And	 cnsctvo_cdgo_tpo_nta	=	    @lcTipoNota	

If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error borrando las notas aplicadas'
		Rollback tran 
		Return -1
	end	

-- Seliminan los valores aplicados a la nota credito, ya que se maneja directamente de las tablas
--    transaccionales

--Selecciona las notas debito afectadas por la nota credito para actualizar el saldo
Delete  From bdcarteraPac.dbo.tbNotasCreditoContratosxNotasDebito
From	   #tmpAbonosContratoCredito a inner join tbNotasCreditoContratosxNotasDebito b
	   on (a.cnsctvo_nta_cntrto	=	b.cnsctvo_nta_cntrto_cdto)


If  @@error!=0  
	Begin 
		Set	@lnProcesoExitoso	=	1
		Set	@lcMensaje		=	'Error borrando las notas aplicadas'
		Rollback tran 
		Return -1
	end	





Commit 	Tran

