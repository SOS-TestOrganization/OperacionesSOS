
/*----------------------------------------------------------------------------------------
* Metodo o PRG : spGrabarNotaSaldoaFavor
* Desarrollado por : <\A Ing. Juan Manuel Victoria A\>
* Descripcion  : <\D Procedimiento para grabar nota tipo saldo a favor D\>    
* Observaciones : <\O O\>    
* Parametros  : <\P P\>
* Variables   : <\V V\>
* Fecha Creacion : <\FC 2019/09/10 FC\>
* Ejemplo: 
    <\EJ
        Incluir un ejemplo de invocacion al procedimiento almacenado
        EXEC spGrabarNotaSaldoaFavor ...
    EJ\>
*-----------------------------------------------------------------------------------------*/
CREATE PROCEDURE dbo.spGrabarNotaSaldoaFavor

@cnsctvo_cdgo_pgo udtConsecutivo,
@ln_sldo_pgo udtValorGrande,
@ln_cnsctvo_cdgo_tpo_dcmnto udtConsecutivo,
@ln_cnsctvo_cdgo_tpo_nta udtConsecutivo,
@ln_errr char(1)

AS
BEGIN
	SET NOCOUNT ON;
	
	begin try

	declare @usr_nme varchar(30), @nmro_unco_idntfccn_empldr int, @cnsctvo_scrsl int, @cnsctvo_cdgo_clse_aprtnte int

	select @usr_nme = replace(SUSER_NAME(),'SOS\','')

	declare @ln_nw_sldo_pgo udtValorGrande

	begin tran
	
	if @ln_cnsctvo_cdgo_tpo_dcmnto = 4
	begin
	
		update a
		set sldo_pgo = sldo_pgo - @ln_sldo_pgo,
		cnsctvo_cdgo_estdo_pgo = 3 /*Aplicado total*/
		--select @ln_sldo_pgo = sldo_pgo
		From 	dbo.TbPagos		  a	with(nolock)
		Where 	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo	

		select @ln_nw_sldo_pgo = sldo_pgo,
		@nmro_unco_idntfccn_empldr = nmro_unco_idntfccn_empldr, 
		@cnsctvo_scrsl = cnsctvo_scrsl, 
		@cnsctvo_cdgo_clse_aprtnte = cnsctvo_cdgo_clse_aprtnte
		From 	dbo.TbPagos		  a	with(nolock)
		Where 	a.cnsctvo_cdgo_pgo		=	@cnsctvo_cdgo_pgo	

		if @ln_nw_sldo_pgo < 0
			begin
				set @ln_errr = '1'
				rollback tran
				return -1
			end
	end
		else
		begin
			if @ln_cnsctvo_cdgo_tpo_dcmnto in (3,7) /*NC NSF*/
			begin
				update a
				set sldo_nta = sldo_nta - @ln_sldo_pgo,
				cnsctvo_cdgo_estdo_nta = 3 /*Aplicado total*/
				--select @ln_sldo_pgo = sldo_pgo
				From 	dbo.tbNotasPac		  a	with(nolock)
				Where 	a.nmro_nta		=	@cnsctvo_cdgo_pgo
				and	a.cnsctvo_cdgo_tpo_nta = @ln_cnsctvo_cdgo_tpo_nta

				select @ln_nw_sldo_pgo = sldo_nta,
				@nmro_unco_idntfccn_empldr = nmro_unco_idntfccn_empldr, 
				@cnsctvo_scrsl = cnsctvo_scrsl, 
				@cnsctvo_cdgo_clse_aprtnte = cnsctvo_cdgo_clse_aprtnte
				From 	dbo.tbNotasPac		  a	with(nolock)
				Where 	a.nmro_nta		=	@cnsctvo_cdgo_pgo
				and	a.cnsctvo_cdgo_tpo_nta = @ln_cnsctvo_cdgo_tpo_nta	

				if @ln_nw_sldo_pgo < 0
					begin
						set @ln_errr = '1'
						rollback tran
						return -1
					end
			end
		end

Declare	@nmro_nta_sldo_fvr Int, @ln_cnsctvo_cdgo_tpo_nta_sldo_fvr int, @cnsctvo_cdgo_prdo_lqdcn int, @fcha_sstma datetime, @cnsctvo_cdgo_estdo_nta int,
		@cnsctvo_cdgo_tpo_aplccn_nta int, @fcha_incl_prdo_lqdcn datetime, @cnsctvo_cdgo_estdo_dcmnto_fe int, @cnsctvo_cdgo_tpo_dcmnto_orgn int,
		@cnsctvo_cdgo_cncpto_lqdcn int

set @cnsctvo_cdgo_cncpto_lqdcn = 351 /*Saldo a Favor*/
set @cnsctvo_cdgo_tpo_dcmnto_orgn = @ln_cnsctvo_cdgo_tpo_dcmnto /*PAGOS, NC, N Saldo a Favor*/
set @cnsctvo_cdgo_estdo_dcmnto_fe = 1 /*Ingresado*/
set @cnsctvo_cdgo_tpo_aplccn_nta = 2 /*Proximo periodo*/
set @cnsctvo_cdgo_estdo_nta = 1 /*Ingresada*/
set @fcha_sstma = getdate()
set @ln_cnsctvo_cdgo_tpo_nta_sldo_fvr = 7 /*Saldo a Favor*/



Select	@cnsctvo_cdgo_prdo_lqdcn = cnsctvo_cdgo_prdo_lqdcn,
@fcha_incl_prdo_lqdcn = fcha_incl_prdo_lqdcn
-- select *
From	dbo.tbPeriodosliquidacion_Vigencias with(nolock)
Where	cnsctvo_cdgo_estdo_prdo = 2

SELECT @nmro_nta_sldo_fvr = NEXT VALUE FOR dbo.SeqNumeroNotasSaldoaFavor



if @nmro_nta_sldo_fvr > 0
begin
	if @ln_cnsctvo_cdgo_tpo_dcmnto = 4
	begin
		INSERT INTO [dbo].[tbNotasPac]
				   ([nmro_nta], [cnsctvo_cdgo_tpo_nta], [vlr_nta], [vlr_iva], [sldo_nta], [cnsctvo_prdo], [fcha_crcn_nta], [cnsctvo_cdgo_estdo_nta],
					[cnsctvo_cdgo_tpo_aplccn_nta], [usro_crcn], [nmro_unco_idntfccn_empldr], [cnsctvo_scrsl], [cnsctvo_cdgo_clse_aprtnte], 
					[fcha_prdo_nta], [cnsctvo_cdgo_estdo_dcmnto_fe], [cnsctvo_cdgo_tpo_dcmnto_orgn], [obsrvcns], [cnsctvo_cdgo_pgo])
		values (@nmro_nta_sldo_fvr, @ln_cnsctvo_cdgo_tpo_nta_sldo_fvr, @ln_sldo_pgo, 0, @ln_sldo_pgo, @cnsctvo_cdgo_prdo_lqdcn, @fcha_sstma, @cnsctvo_cdgo_estdo_nta,
				@cnsctvo_cdgo_tpo_aplccn_nta, @usr_nme, @nmro_unco_idntfccn_empldr, @cnsctvo_scrsl, @cnsctvo_cdgo_clse_aprtnte,
				@fcha_incl_prdo_lqdcn, @cnsctvo_cdgo_estdo_dcmnto_fe, @cnsctvo_cdgo_tpo_dcmnto_orgn, 'Nota Saldo a Favor', @cnsctvo_cdgo_pgo
			   )
	end
		else
		begin
			if @ln_cnsctvo_cdgo_tpo_dcmnto in (3,7) /*NC NSF*/
				begin
					INSERT INTO [dbo].[tbNotasPac]
				   ([nmro_nta], [cnsctvo_cdgo_tpo_nta], [vlr_nta], [vlr_iva], [sldo_nta], [cnsctvo_prdo], [fcha_crcn_nta], [cnsctvo_cdgo_estdo_nta],
					[cnsctvo_cdgo_tpo_aplccn_nta], [usro_crcn], [nmro_unco_idntfccn_empldr], [cnsctvo_scrsl], [cnsctvo_cdgo_clse_aprtnte], 
					[fcha_prdo_nta], [cnsctvo_cdgo_estdo_dcmnto_fe], [cnsctvo_cdgo_tpo_dcmnto_orgn], [obsrvcns], nmro_nta_orgn, cnsctvo_cdgo_tpo_nta_orgn)
					values (@nmro_nta_sldo_fvr, @ln_cnsctvo_cdgo_tpo_nta_sldo_fvr, @ln_sldo_pgo, 0, @ln_sldo_pgo, @cnsctvo_cdgo_prdo_lqdcn, @fcha_sstma, @cnsctvo_cdgo_estdo_nta,
							@cnsctvo_cdgo_tpo_aplccn_nta, @usr_nme, @nmro_unco_idntfccn_empldr, @cnsctvo_scrsl, @cnsctvo_cdgo_clse_aprtnte,
							@fcha_incl_prdo_lqdcn, @cnsctvo_cdgo_estdo_dcmnto_fe, @cnsctvo_cdgo_tpo_dcmnto_orgn, 'Nota Saldo a Favor', @cnsctvo_cdgo_pgo, @ln_cnsctvo_cdgo_tpo_nta
						   )
				end
		end


declare @cnsctvo_nta_cncpto int

select @cnsctvo_nta_cncpto = max(Cnsctvo_nta_cncpto)+1 from [dbo].[tbNotasConceptos] with(nolock)

INSERT INTO [dbo].[tbNotasConceptos]
           ([Cnsctvo_nta_cncpto]
           ,[nmro_nta]
           ,[cnsctvo_cdgo_tpo_nta]
           ,[cnsctvo_cdgo_cncpto_lqdcn]
           ,[vlr_nta])
     VALUES
           (@cnsctvo_nta_cncpto
           ,@nmro_nta_sldo_fvr
           ,@ln_cnsctvo_cdgo_tpo_nta_sldo_fvr
           ,@cnsctvo_cdgo_cncpto_lqdcn
           ,@ln_sldo_pgo)


end
else
begin
	set @ln_errr = '3'
	rollback tran
	return -1
end

	commit tran
		
	end try
	begin catch
		declare @mensajeError varchar(max)
		set @ln_errr = '2'
		set @mensajeError = 'Ocurrio error en la creacion de la nota saldo a favor '+error_message();
		throw 51000, @mensajeError, 1;  
		rollback tran
	end catch

end