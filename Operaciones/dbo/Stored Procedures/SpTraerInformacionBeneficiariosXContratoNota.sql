
/*---------------------------------------------------------------------------------
* Metodo o PRG 		    :  SpTraerInformacionBeneficiariosXContratoNota
* Desarrollado por		: <\A Jairo Valencia									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de los beneficiarios de un contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013/23/05 											FC\>
*---------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[SpTraerInformacionBeneficiariosXContratoNota]
	@lnConsecutivoClaseAportante	udtconsecutivo,
	@lnNumeroUnicoIdentificacion	udtConsecutivo,
	@lnTipoContrato			udtConsecutivo,
	@lnnmro_estdo_cnta      int =	NULL


As	DECLARE @RC int, 
 @lnValorTotalCotizante numeric(12,0),
 @lnNumeroContrato udtNumeroFormulario,
 @lnlnconsecutivoCobranza udtConsecutivo,
 @ValorTotalCuota numeric(12,0),
 @ldFechasistema			Datetime,
 @cnsctvo_cdgo_prdo_lqdcn		int,
 @ldFecha_Corte			datetime,
 @Poliza_HCU				int,
 @Valor_Porcentaje_Iva		udtValorDecimales

Set Nocount On


Set	@ldFechasistema	=	Getdate()
Set	@Poliza_HCU		=	119
Set	@Valor_Porcentaje_Iva		=	0


CREATE TABLE #tbCobranzas(
 nmro_unco_idntfccn_aprtnte udtConsecutivo
,cnsctvo_cdgo_clse_aprtnte udtConsecutivo
,cnsctvo_cdgo_tpo_cntrto  udtConsecutivo
,nmro_cntrto udtNumeroFormulario
,cnsctvo_cbrnza udtConsecutivo)


CREATE TABLE #VALOR (fecha datetime
,nmro_unco_idntfccn_bnfcro numeric(12)
,vlr int
,nmro_cntrto char(15)
,cnsctvo_cdgo_tpo_cntrto numeric(12)
,cnsctvo_cbrnza int
,cnsctvo_bnfcro	numeric(12))

CREATE TABLE #tmpBeneficiarios (cdgo_tpo_idntfccn	varchar(3)
,nmro_idntfccn	varchar(20)
,nombres	varchar(100)
,dscrpcn_prntsco	varchar(150)
,inco_vgnca_bnfcro	datetime
,fn_vgnca_bnfcro	datetime
,dscrpcn_estdo_bnfcro	varchar(100)
,Fcha_ncmnto	datetime
,Vlr_cta	Int --numeric(12)
,pos	varchar(10)
,inco_drcn_rgstro	datetime
,HCU	varchar(1)
,cnsctvo_cdgo_estdo_bfcro	numeric(12)
,cnsctvo_bnfcro	numeric(12)
,nmro_unco_idntfccn_bnfcro	numeric(12)
,cnsctvo_cdgo_tpo_cntrto	numeric(12)
,nmro_cntrto	char(15)
,cnsctvo_cbrnza	numeric(12)
,Vigente	numeric(12)
,valor	INT
,accn	varchar(15))


-- se trae el periodo de liquidacion
Select 	@cnsctvo_cdgo_prdo_lqdcn		=	cnsctvo_cdgo_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo			=	2	--Asigan el periodo de liquidacion  estado con periodo abierto


--  estado con periodo abierto
Select 	@ldFecha_Corte		=	fcha_incl_prdo_lqdcn
From	tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo	=	2	
And	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn


-- trae el valor del porcentaje  para aplicar
Select 	@Valor_Porcentaje_Iva		=	prcntje
From	bdcarteraPac.dbo.tbconceptosliquidacion_vigencias
where   cnsctvo_cdgo_cncpto_lqdcn	=	3
And	@ldFechasistema  between inco_vgnca	and 	fn_vgnca


IF  isnull(@lnnmro_estdo_cnta,0) = 0
    begin
		
		INSERT into #tbCobranzas
		select nmro_unco_idntfccn_aprtnte,cnsctvo_cdgo_clse_aprtnte,cnsctvo_cdgo_tpo_cntrto,nmro_cntrto,max(cnsctvo_cbrnza) cnsctvo_cbrnza
		from bdafiliacion..tbCobranzas c 
		where c.nmro_unco_idntfccn_aprtnte	= @lnNumeroUnicoIdentificacion
		and  c.cnsctvo_cdgo_clse_aprtnte 	= @lnConsecutivoClaseAportante
		And	c.cnsctvo_cdgo_tpo_cntrto	    = @lnTipoContrato
		group by nmro_unco_idntfccn_aprtnte,cnsctvo_cdgo_clse_aprtnte,cnsctvo_cdgo_tpo_cntrto,nmro_cntrto


		insert into #tmpBeneficiarios
		Select  space(3)	cdgo_tpo_idntfccn,
			space(20)	nmro_idntfccn,
			space(100)	nombres,
			b.dscrpcn_prntsco,
			a.inco_vgnca_bnfcro,
			a.fn_vgnca_bnfcro,
			space(100)	dscrpcn_estdo_bnfcro,
			convert(datetime,null)	Fcha_ncmnto,
			0 	Vlr_cta,
			'N'	pos,
			convert(datetime,null)	inco_drcn_rgstro,
			'N'	HCU,
			0	cnsctvo_cdgo_estdo_bfcro,
			cnsctvo_bnfcro,
			nmro_unco_idntfccn_bnfcro,
			a.cnsctvo_cdgo_tpo_cntrto,
			a.nmro_cntrto,
			c.cnsctvo_cbrnza,
			case when	@ldFechasistema	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente,
			0 valor,
			'NO SELECCIONADO'	accn	
		From	bdafiliacion..tbbeneficiarios a WITH(NOLOCK) INNER JOIN bdafiliacion..tbparentescos b
				ON (a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs)
				INNER JOIN #tbCobranzas c
				ON( c.nmro_cntrto			= a.nmro_cntrto And	c.cnsctvo_cdgo_tpo_cntrto	=	a.cnsctvo_cdgo_tpo_cntrto)



		Update  #tmpBeneficiarios
		Set	Vlr_cta		=	b.vlr_upc,
			inco_drcn_rgstro	=	b.inco_drcn_rgstro
		From	#tmpBeneficiarios a, bdafiliacion..tbdetbeneficiarioAdicional  b 
		Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto		=	b.nmro_cntrto
		And	a.cnsctvo_bnfcro	=	b.cnsctvo_bnfcro
		And	a.cnsctvo_cbrnza	=	b.cnsctvo_cbrnza
		And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
		and	b.estdo_rgstro			=	'S'	
		And	 @ldFecha_Corte	between b.inco_vgnca and b.fn_vgnca -- que sea el siguiente del periodo a evaluar
	end
 else
	begin
        IF @lnTipoContrato = 99
			begin
				insert into 	#tmpBeneficiarios
				Select  space(3) cdgo_tpo_idntfccn,
					space(20)	 nmro_idntfccn,
					space(100)	 nombres,
					d.dscrpcn_prntsco,
					c.inco_vgnca_bnfcro,
					c.fn_vgnca_bnfcro,
					space(100)	dscrpcn_estdo_bnfcro,
					convert(datetime,null)	Fcha_ncmnto,
					(a.vlr_nta_bnfcro + a.vlr_iva) 	Vlr_cta,
					'N'	pos,
					convert(datetime,null)	inco_drcn_rgstro,
					'N'	HCU,
					0	cnsctvo_cdgo_estdo_bfcro,
					c.cnsctvo_bnfcro,
					a.nmro_unco_idntfccn_bnfcro,
					c.cnsctvo_cdgo_tpo_cntrto,
					b.nmro_cntrto,
					0 cnsctvo_cbrnza,
					case when	@ldFechasistema	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente,
					0 valor,
					'NO SELECCIONADO'	accn
				from tbNotasBeneficiariosContratos a  ,tbNotasContrato b,bdafiliacion..tbbeneficiarios c,bdafiliacion..tbparentescos d
				where a.cnsctvo_nta_cntrto = b.cnsctvo_nta_cntrto
				and a.nmro_unco_idntfccn_bnfcro = c.nmro_unco_idntfccn_bnfcro
				and b.cnsctvo_cdgo_tpo_cntrto = c.cnsctvo_cdgo_tpo_cntrto
				and b.nmro_cntrto = c.nmro_cntrto
				and c.cnsctvo_cdgo_prntsco =	d.cnsctvo_cdgo_prntscs
				and b.nmro_nta = @lnnmro_estdo_cnta
				and b.cnsctvo_cdgo_tpo_nta = 1
			end
		ELSE
			begin
				insert into #VALOR
				select a.fcha_gnrcn,c.nmro_unco_idntfccn_bnfcro,c.vlr,b.nmro_cntrto,b.cnsctvo_cdgo_tpo_cntrto,0 cnsctvo_cbrnza,cnsctvo_bnfcro
				from tbEstadosCuenta a,tbEstadosCuentaContratos b,tbCuentasContratosBeneficiarios c
				where a.cnsctvo_estdo_cnta = b.cnsctvo_estdo_cnta
				and b.cnsctvo_estdo_cnta_cntrto = c.cnsctvo_estdo_cnta_cntrto
				and a.nmro_estdo_cnta = @lnnmro_estdo_cnta

				insert into 	#tmpBeneficiarios
				Select  space(3)	cdgo_tpo_idntfccn,
					space(20)	nmro_idntfccn,
					space(100)	nombres,
					b.dscrpcn_prntsco,
					a.inco_vgnca_bnfcro,
					a.fn_vgnca_bnfcro,
					space(100)	dscrpcn_estdo_bnfcro,
					convert(datetime,null)	Fcha_ncmnto,
					c.vlr 	Vlr_cta,
					'N'	pos,
					convert(datetime,null)	inco_drcn_rgstro,
					'N'	HCU,
					0	cnsctvo_cdgo_estdo_bfcro,
					a.cnsctvo_bnfcro,
					c.nmro_unco_idntfccn_bnfcro,
					a.cnsctvo_cdgo_tpo_cntrto,
					a.nmro_cntrto,
					c.cnsctvo_cbrnza	cnsctvo_cbrnza,
					case when	getdate()	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente,
					0 valor,
					'NO SELECCIONADO'	accn	
				From	bdafiliacion..tbbeneficiarios a WITH(NOLOCK) INNER JOIN bdafiliacion..tbparentescos b
						ON (a.cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntscs)
						INNER JOIN #VALOR c
						ON(  c.nmro_cntrto			=	a.nmro_cntrto and c.nmro_unco_idntfccn_bnfcro = a.nmro_unco_idntfccn_bnfcro
							and c.cnsctvo_bnfcro = a.cnsctvo_bnfcro)			 
		End
    END


Update #tmpBeneficiarios
Set	HCU	=	'S'
From	#tmpBeneficiarios a, bdafiliacion..tbafiliados b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_afldo
And	b.cnsctvo_cdgo_plza_antrr	=	@Poliza_HCU


Update #tmpBeneficiarios
Set	pos	=	'S'
From	#tmpBeneficiarios a, bdafiliacion..tbbeneficiarios b
Where	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	b.cnsctvo_cdgo_tpo_cntrto	=	1	
And	estdo				=	'A'
And	@ldFechasistema	between  b.inco_vgnca_bnfcro 	and	b.fn_vgnca_bnfcro


Update #tmpBeneficiarios
Set	nombres	=ltrim(rtrim(prmr_aplldo)) +    ' '  +ltrim(Rtrim(sgndo_aplldo)) + ' ' + ltrim(rtrim(prmr_nmbre))  + ' ' + ltrim(rtrim(sgndo_nmbre)),
	fcha_ncmnto	=	b.Fcha_ncmnto
From	#tmpBeneficiarios a, bdafiliacion..tbpersonas b
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn

Update  #tmpBeneficiarios
Set	nmro_idntfccn		=	b.nmro_idntfccn,
	cdgo_tpo_idntfccn	=	c.cdgo_tpo_idntfccn
From	#tmpBeneficiarios a,	 bdafiliacion..tbVinculados b, bdafiliacion..tbtiposidentificacion c
Where 	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn	

Update  #tmpBeneficiarios
Set	cnsctvo_cdgo_estdo_bfcro	=	b.cnsctvo_cdgo_estdo_bfcro
From	#tmpBeneficiarios a, bdafiliacion..tbhistoricoEstadosBeneficiario  b 
Where	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro
And	@ldFechasistema between b.inco_vgnca_estdo_bnfcro  and b.fn_vgnca_estdo_bnfcro
And	b.hbltdo				=	'S'

                
Update  #tmpBeneficiarios
Set	dscrpcn_estdo_bnfcro		=	b.dscrpcn
From	#tmpBeneficiarios a, bdafiliacion..TbEstados  b 
Where	a.cnsctvo_cdgo_estdo_bfcro	=	b.cnsctvo_cdgo_estdo_afldo


Select	@ValorTotalCuota = isnull(Sum(Vlr_cta),0)
From	#tmpBeneficiarios
Where 	Vigente	=	1


Select  cdgo_tpo_idntfccn
,nmro_idntfccn
,nombres
,dscrpcn_prntsco
,inco_vgnca_bnfcro
,fn_vgnca_bnfcro
,dscrpcn_estdo_bnfcro
,Fcha_ncmnto
,Vlr_cta
,pos
,inco_drcn_rgstro
,HCU
,cnsctvo_cdgo_estdo_bfcro
,cnsctvo_bnfcro
,nmro_unco_idntfccn_bnfcro
,cnsctvo_cdgo_tpo_cntrto
,nmro_cntrto
,cnsctvo_cbrnza
,Vigente
,valor
,accn 

From #tmpBeneficiarios

drop table #tmpBeneficiarios
drop table #VALOR
drop table #tbCobranzas
