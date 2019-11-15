
/*---------------------------------------------------------------------------------
* Metodo o PRG 		    :  SpTraerInformacionBeneficiariosXContratoNotaReintegro
* Desarrollado por		: <\A Jairo Valencia									A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de los beneficiarios de un contrato			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2013/23/05 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
* Modificado Por		 : <\AM   Ing. Andres Camelo 	AM\>
* Descripcion			 : <\DM   se modifica para que consulte los reintegros aplicados y autorizados  DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion		 : <\FM   02/12/2013				FM\>
*---------------------------------------------------------------------------------*/

-- exec [SpTraerInformacionBeneficiariosXContratoNotaReintegro] 4,31902440,2,2078203,19697,1
CREATE  PROCEDURE [dbo].[SpTraerInformacionBeneficiariosXContratoNotaReintegro]
    @lnConsecutivoClaseAportante	udtconsecutivo = null,
	@lnNumeroUnicoIdentificacion	udtConsecutivo = null,
	@lnTipoContrato			udtConsecutivo = null,
	@lnnmro_estdo_cnta      int =	NULL,
	@lnNumContrato			udtConsecutivo = NULL,
	@lnTipoDocumento		int = null


As	DECLARE @RC int,
 @ValorNotaCredito   int,
 @NotaCredito   udtConsecutivo, 
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

set @lnNumContrato = isnull(@lnNumContrato,0)
Set	@ldFechasistema	=	Getdate()
Set	@Poliza_HCU		=	119
Set	@Valor_Porcentaje_Iva		=	0


CREATE TABLE #tmpAcumuladoNotas(
cnsctvo_estdo_cnta_cntrto udtConsecutivo
,cnsctvo_prdo	udtConsecutivo
,nmro_cntrto	udtNumeroFormulario
,Acumulado_reintegro	numeric
,nmro_unco_idntfccn_bnfcro udtConsecutivo)


CREATE TABLE #tmpBeneficiarios (cdgo_tpo_idntfccn	varchar(3)
,nmro_idntfccn	varchar(20)
,nombres	varchar(100)
,dscrpcn_prntsco	varchar(150)
,inco_vgnca_bnfcro	datetime
,fn_vgnca_bnfcro	datetime
,dscrpcn_estdo_bnfcro	varchar(100)
,Fcha_ncmnto	datetime
,Vlr_cta	Int --numeric(12)
,Total_notas_credito Int
,Total_reintegro Int
,Valor_disponible Int
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
,nmro_estdo_cnta varchar(20)
,accn	varchar(15)
,Consecutivo_documento_origen	udtConsecutivo
,nmro_dcto udtConsecutivo
,cnsctvo_cdgo_tpo_dcmnto int)


if isnull(@lnTipoDocumento,0) = 1
	begin
		insert into 	#tmpBeneficiarios
		Select      space(3)	cdgo_tpo_idntfccn,
					space(20)	nmro_idntfccn,
					space(100)	nombres,
					h.dscrpcn_prntsco,
					g.inco_vgnca_bnfcro,
					g.fn_vgnca_bnfcro,
					space(100)	dscrpcn_estdo_bnfcro,
					convert(datetime,null)	Fcha_ncmnto,
					f.vlr 	Vlr_cta,
					0 Total_notas_credito,
					0 Total_reintegro, 
					0 Valor_disponible,
					'N'	pos,
					convert(datetime,null)	inco_drcn_rgstro,
					'N'	HCU,
					0	cnsctvo_cdgo_estdo_bfcro,
					g.cnsctvo_bnfcro,
					g.nmro_unco_idntfccn_bnfcro,
					g.cnsctvo_cdgo_tpo_cntrto,
					g.nmro_cntrto,
					0	cnsctvo_cbrnza,
					case when	getdate()	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente,
					0 valor,
					a.nmro_estdo_cnta,
					'NO SELECCIONADO'	accn,
					b.cnsctvo_estdo_cnta_cntrto  Consecutivo_documento_origen,
					a.nmro_estdo_cnta,
					1 cnsctvo_cdgo_tpo_dcmnto
		From    tbestadosCuenta a, 	tbEstadosCuentaContratos b , tbtipodocumentos  c
		,tbliquidaciones l, tbperiodosliquidacion_vigencias p,tbCuentasContratosBeneficiarios f,bdafiliacion..tbbeneficiarios g
		,bdafiliacion..tbparentescos h
		Where	a.cnsctvo_estdo_cnta			=	b.cnsctvo_estdo_cnta
		and b.cnsctvo_estdo_cnta_cntrto		=   f.cnsctvo_estdo_cnta_cntrto
		And c.cnsctvo_cdgo_tpo_dcmnto			=	1
		And a.cnsctvo_cdgo_lqdcn				=	l.cnsctvo_cdgo_lqdcn
		And l.cnsctvo_cdgo_prdo_lqdcn			=	p.cnsctvo_cdgo_prdo_lqdcn
		And b.nmro_cntrto						=   g.nmro_cntrto
		and f.nmro_unco_idntfccn_bnfcro		=   g.nmro_unco_idntfccn_bnfcro
		And b.cnsctvo_cdgo_tpo_cntrto			=   g.cnsctvo_cdgo_tpo_cntrto	
		and g.cnsctvo_cdgo_prntsco			=	h.cnsctvo_cdgo_prntscs
		And b.cnsctvo_cdgo_tpo_cntrto			=	2
		And b.nmro_cntrto						=	@lnNumContrato
		and a.nmro_estdo_cnta					=   @lnnmro_estdo_cnta
		And (b.sldo <=	0 or a.cnsctvo_cdgo_estdo_estdo_cnta	= 3) --- Cancelado total
		--And (CASE WHEN ISNULL(@lnNumContrato,0) = 0 THEN 0 ELSE a.nmro_cntrto END) = (CASE WHEN ISNULL(@lnNumContrato,0) = 0 THEN 0 ELSE @lnNumContrato END)
		--And p.fcha_incl_prdo_lqdcn	between	  @Fecha_Inicial	and @Fecha_Final
	end
 else
    begin
		insert into 	#tmpBeneficiarios
		Select      space(3)	cdgo_tpo_idntfccn,
					space(20)	nmro_idntfccn,
					space(100)	nombres,
					f.dscrpcn_prntsco,
					e.inco_vgnca_bnfcro,
					e.fn_vgnca_bnfcro,
					space(100)	dscrpcn_estdo_bnfcro,
					convert(datetime,null)	Fcha_ncmnto,
					(d.vlr_nta_bnfcro + d.vlr_iva) 	Vlr_cta,
					0 Total_notas_credito,
					0 Total_reintegro, 
					0 Valor_disponible,
					'N'	pos,
					convert(datetime,null)	inco_drcn_rgstro,
					'N'	HCU,
					0	cnsctvo_cdgo_estdo_bfcro,
					e.cnsctvo_bnfcro,
					e.nmro_unco_idntfccn_bnfcro,
					e.cnsctvo_cdgo_tpo_cntrto,
					e.nmro_cntrto,
					0	cnsctvo_cbrnza,
					case when	getdate()	between  inco_vgnca_bnfcro 	and	fn_vgnca_bnfcro then  1 else 0 end  Vigente,
					0 valor,
					a.nmro_nta,
					'NO SELECCIONADO'	accn,
					b.cnsctvo_nta_cntrto  Consecutivo_documento_origen,
					a.nmro_nta nmro_dcto,
					2 cnsctvo_cdgo_tpo_dcmnto
		from	tbNotasPac a INNER JOIN tbNotasContrato  b on( a.nmro_nta =	b.nmro_nta And	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta ) 
				INNER JOIN tbperiodosliquidacion_vigencias p on(a.cnsctvo_prdo	=	p.cnsctvo_cdgo_prdo_lqdcn) 
				LEFT OUTER JOIN tbNotasBeneficiariosContratos d on (b.cnsctvo_nta_cntrto =  d.cnsctvo_nta_cntrto) 
				LEFT JOIN bdafiliacion..tbbeneficiarios e on (d.nmro_unco_idntfccn_bnfcro = e.nmro_unco_idntfccn_bnfcro
															 and b.cnsctvo_cdgo_tpo_cntrto = e.cnsctvo_cdgo_tpo_cntrto
															 and b.nmro_cntrto = e.nmro_cntrto)
				LEFT JOIN bdafiliacion..tbparentescos f on (e.cnsctvo_cdgo_prntsco = f.cnsctvo_cdgo_prntscs)
		Where a.cnsctvo_cdgo_estdo_nta	=	3	--cancelada total
		  And b.cnsctvo_cdgo_tpo_cntrto	=	2
		  And b.nmro_cntrto				=	@lnNumContrato
		  And a.nmro_nta				    =   @lnnmro_estdo_cnta
		  And a.cnsctvo_cdgo_tpo_nta = 1
		--And	p.fcha_incl_prdo_lqdcn	between	@Fecha_Inicial and @Fecha_Final
	end


INSERT into	#tmpAcumuladoNotas
SELECT a.cnsctvo_estdo_cnta_cntrto,0 'periodo',b.nmro_cntrto, isnull(sum(d.vlr_nta_bnfcro + d.vlr_iva),0) Acumulado_reintegro,d.nmro_unco_idntfccn_bnfcro
FROM tbCuentasContratoReintegro a 
	  INNER JOIN tbnotascontrato b ON ( a.cnsctvo_nta_cntrto   =  b.cnsctvo_nta_cntrto)
      INNER JOIN tbnotasPac c on (b.cnsctvo_cdgo_tpo_nta =  c.cnsctvo_cdgo_tpo_nta  And   b.nmro_nta   =  c.nmro_nta)
	  INNER JOIN tbNotasBeneficiariosContratos d on (b.cnsctvo_nta_cntrto =  d.cnsctvo_nta_cntrto and a.cnsctvo_estdo_cnta_cntrto = d.cnsctvo_dcmnto and a.cnsctvo_cdgo_tpo_dcmnto = d.cnsctvo_cdgo_tpo_dcmnto)
	  INNER JOIN #tmpBeneficiarios e on (a.cnsctvo_estdo_cnta_cntrto =  e.Consecutivo_documento_origen and d.nmro_unco_idntfccn_bnfcro = e.nmro_unco_idntfccn_bnfcro)     
WHERE   b.cnsctvo_cdgo_tpo_nta =  3  -- NOTA REINTEGRO
  And   c.cnsctvo_cdgo_estdo_nta in  (4,8)   --APLICADO - AUTORIZADA
GROUP BY  a.cnsctvo_estdo_cnta_cntrto,b.nmro_cntrto,d.nmro_unco_idntfccn_bnfcro




Update #tmpBeneficiarios
Set	#tmpBeneficiarios.total_Reintegro	=	b.Acumulado_reintegro
From	#tmpAcumuladoNotas  b
Where  rtrim(ltrim(#tmpBeneficiarios.nmro_cntrto)) = rtrim(ltrim(b.nmro_cntrto))
And	    #tmpBeneficiarios.Consecutivo_documento_origen	=	b.cnsctvo_estdo_cnta_cntrto
and #tmpBeneficiarios.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro
--and #tmpBeneficiarios.cnsctvo_cdgo_tpo_dcmnto = 1




truncate table #tmpAcumuladoNotas

if isnull(@lnTipoDocumento,0) = 1
 begin
	INSERT into	#tmpAcumuladoNotas
	select b.Consecutivo_documento_origen,0,c.nmro_cntrto,sum(d.vlr_iva+d.vlr_nta_bnfcro)Acumulado_reintegro,b.nmro_unco_idntfccn_bnfcro
	from tbEstadosCuentaContratos a
	inner join #tmpBeneficiarios b
	on a.cnsctvo_estdo_cnta_cntrto=b.Consecutivo_documento_origen
	inner join dbo.tbNotasEstadoCuenta e
	on a.cnsctvo_estdo_cnta=e.cnsctvo_estdo_cnta
	inner join tbNotasContrato c
	on e.nmro_nta=c.nmro_nta
	and e.cnsctvo_cdgo_tpo_nta=c.cnsctvo_cdgo_tpo_nta
	and c.cnsctvo_estdo_cnta_cntrto=a.cnsctvo_estdo_cnta_cntrto
	inner join tbNotasBeneficiariosContratos d
	on  d.nmro_unco_idntfccn_bnfcro=b.nmro_unco_idntfccn_bnfcro
	and c.cnsctvo_nta_cntrto  =d.cnsctvo_nta_cntrto
	where e.cnsctvo_cdgo_tpo_nta=2 --- NOTAS CREDITO
	group by b.nmro_unco_idntfccn_bnfcro,b.Consecutivo_documento_origen,c.nmro_cntrto
end
else
begin
	-- se calcula el valor acumulado de reintegros para los documentos
	INSERT into	#tmpAcumuladoNotas
	Select b.cnsctvo_estdo_cnta_cntrto,0 'a.cnsctvo_prdo',b.nmro_cntrto, isnull(sum(d.vlr_nta_bnfcro + d.vlr_iva),0) Acumulado_reintegro,d.nmro_unco_idntfccn_bnfcro
	from	tbNotasPac a, tbNotasContrato  b,#tmpBeneficiarios c,tbNotasBeneficiariosContratos d
	Where   a.nmro_nta    			=	b.nmro_nta
	and	a.cnsctvo_cdgo_tpo_nta		=	b.cnsctvo_cdgo_tpo_nta
	and b.cnsctvo_nta_cntrto =  d.cnsctvo_nta_cntrto
	and a.cnsctvo_cdgo_tpo_nta      =   2  -- NOTA CREDITO
	and b.cnsctvo_estdo_cnta_cntrto =   c.Consecutivo_documento_origen
	and d.nmro_unco_idntfccn_bnfcro =  c.nmro_unco_idntfccn_bnfcro
	--and c.cnsctvo_cdgo_lqdcn      =   a.cnsctvo_prdo
	and b.nmro_cntrto               =   c.nmro_cntrto 
	and a.cnsctvo_cdgo_estdo_nta in  (4,7) 
	--and @lnTipoDocumento = 2 
	Group by   d.nmro_unco_idntfccn_bnfcro,b.cnsctvo_estdo_cnta_cntrto,b.nmro_cntrto
	union all
	select b.Consecutivo_documento_origen,0,c.nmro_cntrto,sum(d.vlr_iva + d.vlr_nta_bnfcro) Acumulado_reintegro,d.nmro_unco_idntfccn_bnfcro
	from tbNotasCreditoContratosxNotasDebito a
	inner join #tmpBeneficiarios b 
	on a.cnsctvo_nta_cntrto_dbto = b.Consecutivo_documento_origen  
	inner join tbNotasContrato c
	on  a.cnsctvo_nta_cntrto_cdto  = c.cnsctvo_nta_cntrto
	inner join tbNotasBeneficiariosContratos d
	on  d.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn_bnfcro
	and c.cnsctvo_nta_cntrto   = d.cnsctvo_nta_cntrto
	inner join  tbNotasAplicadas e
	on  c.nmro_nta              = e.nmro_nta
	and c.cnsctvo_cdgo_tpo_nta  = e.cnsctvo_cdgo_tpo_nta
	and e.cnsctvo_cdgo_tpo_nta  = 2
	group by d.nmro_unco_idntfccn_bnfcro,b.Consecutivo_documento_origen,c.nmro_cntrto

end


Update #tmpBeneficiarios
Set	#tmpBeneficiarios.Total_notas_credito	=	b.Acumulado_reintegro
From	#tmpAcumuladoNotas  b
Where rtrim(ltrim(#tmpBeneficiarios.nmro_cntrto)) = rtrim(ltrim(b.nmro_cntrto))
And	  #tmpBeneficiarios.Consecutivo_documento_origen	=	b.cnsctvo_estdo_cnta_cntrto
and   b.nmro_unco_idntfccn_bnfcro =  #tmpBeneficiarios.nmro_unco_idntfccn_bnfcro


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

UPDATE #tmpBeneficiarios
SET Valor_disponible = Vlr_cta - Total_notas_credito - Total_reintegro


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
,Total_notas_credito
,Total_reintegro 
,Valor_disponible 
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
,nmro_estdo_cnta
,accn 
From #tmpBeneficiarios


drop table #tmpAcumuladoNotas

drop table #tmpBeneficiarios

