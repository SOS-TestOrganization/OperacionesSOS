



/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spPlanoPropal
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso	 									A\>
* Descripcion			: <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para el informe produccion digitador 	D\>
* Observaciones			: <\O  														O\>
* Parametros			: <\P													 	P\>
* Variables			: <\V  														V\>
* Fecha Creacion		: <\FC 2003/07/01												FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM 2012/01/20 FM\>

QUICK				Analista		Descripcion
2013-001-004958		sismpr01		se cambia valor fijo, por parametro general para tarifa de empresa y tarifa trabajador 2013/02/26
*---------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spPlanoPropal]

AS


SET NOCOUNT ON

Declare

@nmro_estdo_cnta		varchar(20),
@lcParametros			varchar(1000),
@lncnsctvo_cdgo_lqdcn	int,
@trfa_emprsa_plno_prpl	numeric(7,2),
@trfa_trbjdr_plno_prpl	numeric(7,2)


Set @lcParametros = ''

-- Recupero los parametros del cursor de criterios
--Fecha paso definitivo
Select 	@nmro_estdo_cnta 	=	 vlr
From 	#tbCriteriosTmp
Where 	cmpo_rlcn 		= 	'nmro_estdo_cnta' 


Select @lncnsctvo_cdgo_lqdcn	=	cnsctvo_cdgo_lqdcn
From	tbestadoscuenta
where	nmro_estdo_cnta		=	@nmro_estdo_cnta



Declare @tmpBenePropal 	table 	(cnsctvo_cdgo_lqdcn 			int,
					cnsctvo_cdgo_tpo_cntrto 		int ,
					nmro_cntrto 				char(30),
					cnsctvo_bnfcro 				int,
					nmro_unco_idntfccn_bnfcro 		int ,
					nmro_unco_idntfccn_ctznte		int,
					vlr_cta					numeric(12,2),
					vlr_iva					numeric(12,2),
					cnsctvo_estdo_cnta_cntrto_bnfcro	int,
					Grupos_tarifas				int,
					tipo_grupo				char(1),
					tpo_idntfccn_bene			char(3),
					nmro_idntfccn_bene			char(15),
					tpo_idntfccn_coti			char(3),
					nmro_idntfccn_coti			char(15),
					nmbre_bene				char(50),
					nmbre_coti				char(50),
					dscrpcn_prntsco				char(50),
					cnsctvo_cdgo_prntscs			int )


Insert Into @tmpBenePropal
Select  	cnsctvo_cdgo_lqdcn,		cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,
	cnsctvo_bnfcro,			nmro_unco_idntfccn_bnfcro,	0	,
	0,				0,				cnsctvo_estdo_cnta_cntrto_bnfcro,
	0,				space(1),			space(3),
	space(15),  			space(3),			space(15),
	space(50),			space(50),			space(50),
	0
From tbestadoscuenta a, tbestadoscuentacontratos b , tbcuentascontratosbeneficiarios c
Where 	nmro_estdo_cnta 			= 	@nmro_estdo_cnta
And 	a.cnsctvo_estdo_cnta 			= 	b.cnsctvo_estdo_cnta
And	b.cnsctvo_estdo_cnta_cntrto 		= 	c.cnsctvo_estdo_cnta_cntrto



update @tmpBenePropal
Set	vlr_cta = vlr
From	@tmpBenePropal a, tbCuentasBeneficiariosConceptos b
Where  	a.cnsctvo_estdo_cnta_cntrto_bnfcro 	= b.cnsctvo_estdo_cnta_cntrto_bnfcro
and	cnsctvo_cdgo_cncpto_lqdcn 	=	4

update @tmpBenePropal
Set	vlr_iva = vlr
From	@tmpBenePropal a, tbCuentasBeneficiariosConceptos b
Where  	a.cnsctvo_estdo_cnta_cntrto_bnfcro 	= b.cnsctvo_estdo_cnta_cntrto_bnfcro
and	cnsctvo_cdgo_cncpto_lqdcn 	=	3

update @tmpBenePropal
Set	nmro_unco_idntfccn_ctznte = nmro_unco_idntfccn_afldo
From    @tmpBenePropal a, bdafiliacion..tbcontratos b
Where   a.nmro_cntrto  		  = b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto = b.cnsctvo_cdgo_tpo_cntrto


Update @tmpBenePropal
Set	cnsctvo_cdgo_prntscs		=	b.cnsctvo_cdgo_prntsco
From	@tmpBenePropal a, bdafiliacion..tbbeneficiarios b
Where   a.nmro_cntrto			=	b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn_bnfcro


Update @tmpBenePropal
Set	dscrpcn_prntsco		=	b.dscrpcn_prntsco
From	@tmpBenePropal a, bdafiliacion..tbparentescos b
Where   a.cnsctvo_cdgo_prntscs	=	b.cnsctvo_cdgo_prntscs



Update @tmpBenePropal
Set	tpo_idntfccn_bene		=	c.cdgo_tpo_idntfccn,
       	nmro_idntfccn_bene		=	b.nmro_idntfccn
From	@tmpBenePropal a, 	bdafiliacion..tbvinculados  b ,	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn


Update @tmpBenePropal
Set	tpo_idntfccn_coti		=	c.cdgo_tpo_idntfccn,
       	nmro_idntfccn_coti		=	b.nmro_idntfccn
From	@tmpBenePropal	 a, 	bdafiliacion..tbvinculados  b ,	bdafiliacion..tbtiposidentificacion 	c
Where   a.nmro_unco_idntfccn_ctznte	=	b.nmro_unco_idntfccn
And	b.cnsctvo_cdgo_tpo_idntfccn	=	c.cnsctvo_cdgo_tpo_idntfccn


Update  @tmpBenePropal
Set	nmbre_bene			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	@tmpBenePropal a,  bdAfiliacion..tbpersonas e
Where	a.nmro_unco_idntfccn_bnfcro	=            e.nmro_unco_idntfccn


Update  @tmpBenePropal
Set	nmbre_coti			=	  ltrim(rtrim(e.prmr_aplldo))  + ' ' + ltrim(rtrim(e.sgndo_aplldo)) + ' ' + ltrim(rtrim(e.prmr_Nmbre )) + ' ' + ltrim(rtrim(e.sgndo_nmbre)) 
From	@tmpBenePropal a,  BDAfiliacion..tbpersonas e
Where	a.nmro_unco_idntfccn_ctznte	=            e.nmro_unco_idntfccn



Update @tmpBenePropal
Set	Grupos_tarifas		 = grupo
From    @tmpBenePropal a, bdcarteraPac..tbhistoricotarificacionxproceso b
Where   a.nmro_cntrto  		    = b.nmro_cntrto
And	a.cnsctvo_cdgo_tpo_cntrto   = b.cnsctvo_cdgo_tpo_cntrto
and	a.cnsctvo_bnfcro	    = b.cnsctvo_bnfcro
And	a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn	
and	b.cnsctvo_cdgo_lqdcn	    =@lncnsctvo_cdgo_lqdcn




update @tmpBenePropal
Set	tipo_grupo		 = 'B' -- Grupo basico
where  Grupos_tarifas in(202,203,204,205,206,207,208,209,306)   

---sisdgb01 Se adiciona el grupo 455 para que se genere en el archivo de Adicionales
update @tmpBenePropal
Set	tipo_grupo		 = 'A' --Adicionales
where  Grupos_tarifas in(210,211,212,213,214,215,307,308,455,460)


select	@trfa_emprsa_plno_prpl = vlr_prmtro_nmrco
from	[bdCarteraPac].[dbo].[tbParametrosGenerales_Vigencias] 
where	cnsctvo_cdgo_prmtro_gnrl = 3 	--TARIFA EMPRESA PLANO PROPAL
and		getdate()	between inco_vgnca and fn_vgnca

select	@trfa_trbjdr_plno_prpl = vlr_prmtro_nmrco
from	[bdCarteraPac].[dbo].[tbParametrosGenerales_Vigencias] 
where	cnsctvo_cdgo_prmtro_gnrl = 4 	--TARIFA TRABAJADOR PLANO PROPAL
and		getdate()	between inco_vgnca and fn_vgnca


Select   tpo_idntfccn_coti,
	nmro_idntfccn_coti,
	nmbre_coti,
	nmbre_bene,
	tpo_idntfccn_bene,
	nmro_idntfccn_bene,
	dscrpcn_prntsco,
	convert(numeric(12,0),vlr_cta) vlr_cta,
	convert(numeric(12,0),vlr_iva) vlr_iva,
	convert(numeric(12,0),vlr_cta * convert(numeric(12,6),@trfa_emprsa_plno_prpl/ 100)) vlr_cta_40807174,
	convert(numeric(12,0),vlr_iva * convert(numeric(12,6),@trfa_emprsa_plno_prpl/ 100)) vlr_iva_40807174, --42.733
	convert(numeric(12,0),vlr_cta * convert(numeric(12,6),@trfa_trbjdr_plno_prpl/ 100)) vlr_cta_59192825, --57.266
	convert(numeric(12,0),vlr_iva * convert(numeric(12,6),@trfa_trbjdr_plno_prpl/ 100)) vlr_iva_59192825,
	/*
	convert(numeric(12,0),vlr_cta * convert(numeric(12,6),43.38/ 100)) vlr_cta_40807174,
	convert(numeric(12,0),vlr_iva * convert(numeric(12,6),43.38/ 100)) vlr_iva_40807174, --42.733
	convert(numeric(12,0),vlr_cta * convert(numeric(12,6),56.62/ 100)) vlr_cta_59192825, --57.266
	convert(numeric(12,0),vlr_iva * convert(numeric(12,6),56.62/ 100)) vlr_iva_59192825,*/
	tipo_grupo,
	nmro_cntrto,
	@nmro_estdo_cnta num
From	 @tmpBenePropal




