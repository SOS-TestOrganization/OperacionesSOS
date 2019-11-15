


/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spcmTraerValidacionesEspeciales 
* Desarrollado por		: <\A Ing. Alvaro Zapata						A\>
* Descripción			: <\D Consulta los bonos electronicos utilizados del afiliado consultado D\>
* Observaciones			: <\O									O\>
* Parámetros			: <\P  									P\>
* Variables			: <\V  									V\>
* Fecha Creación		: <\FC 2006/12/20  							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM 				*					AM\>
* Descripción			: <\DM									DM\>
* 				: <\DM									DM\>
* Nuevos Parámetros		: <\PM  							>
* Nuevas Variables		: <\VM  									VM\>
* Fecha Modificación		: <\FM									FM\>
*-----------------------------------------------------------------------------------------------------------------------------------*/
--exec spcmTraerValidacionesEspeciales 1,'123456',1,'20410409'
CREATE procedure  [dbo].[spcmTraerValidacionesEspeciales]
@cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn			Varchar(23),
@cnsctvo_cdgo_pln 		udtConsecutivo, 
@fcha_atncn 			datetime

AS


/*
Declare @cnsctvo_cdgo_tpo_idntfccn 	udtConsecutivo, 
@nmro_idntfccn			Varchar(23),
@cnsctvo_cdgo_pln 		udtConsecutivo, 
@fcha_atncn 			datetime

set @cnsctvo_cdgo_tpo_idntfccn=2
set @nmro_idntfccn='95022220323'
set @cnsctvo_cdgo_pln=1
set @fcha_atncn='20130701'
*/



Set Nocount On

Declare @tbValidacionesEspeciales Table(dscrpcn_pln	                 Varchar(150), 
                                        cdgo_tpo_idntfccn            Char(3)     , 
                                        nmro_idntfccn	             Varchar(23) ,
										nmbre		                 Varchar(200), 
                                        tpo_afldo	                 Varchar(150),
										estdo_drcho		             Varchar(150),
										ofcna_vldcn		             Varchar(150),
										nmro_vrfccn		             Numeric,
										fcha_vldcn		             Datetime,
										inco_vgnca_bnfcro            Datetime,
										fn_vgnca_bnfcro	             Datetime,
										dscrpcn_rngo_slrl            Varchar(150),
										pln_cmplmntro	             Varchar(150),
										dscrpcn_drcho	             Varchar(150),
										edd				             Int,
										dscrpcn_prntsco		 	     Varchar(150),
										nmro_idntfccn_aprtnte		 Varchar(23),
										cnsctvo_cdgo_ofcna		     Int,
										cnsctvo_cdgo_pln		     Int,
										cnsctvo_tpo_idntfccn_aprtnte Int,
										cnsctvo_cdgo_estdo_afldo	 Int,
										cnsctvo_cdgo_rngo_slrl		 Int,
										cnsctvo_cdgo_prntscs		 Int,
										nmro_unco_idntfccn_aprtnte	 Int,
										cnsctvo_cdgo_tpo_idntfccn	 Int,
										cnsctvo_cdgo_tpo_afldo		 Int,
										cnsctvo_cdgo_pln_pc		     Int,
										prmr_nmbre			         Char(20),
										sgndo_nmbre			         Char(20),
										prmr_aplldo			         Char(50),
										sgndo_aplldo			     Char(50),
										mnsje				         Varchar(50), --default 'VALIDACIÓN ESPECIAL'	
										orgn				         Char(1),
										--Adicion Campo para soportar calculo Sede (sisatv01)
										cdgo_ips_prmra               Char(8),
										cnsctvo_cdgo_sde_ips         Int Default 0,
										cnsctvo_cdgo_tpo_undd        Int,
										--adicion de campos 2010/10/20 cargar log convenios
										nmro_unco_idntfccn_afldo     Int,
										cnsctvo_cdgo_tpo_cntrto      Int,
										nmro_cntrto                  Char(15),
										cnsctvo_bnfcro               Int,
										cnsctvo_cdgo_sxo             Int,
										dscrpcn_sxo                  Varchar(150),
										fcha_ncmnto                  Datetime,
										smns_ctzds                   Int,
										dscrpcn_orgn                 Varchar(150),
                                        --Se adiciona la informacion del aportante                                        
                                        rzn_scl	                     Varchar(200),
										tpo_autrzn					 int default 0
									   )

--Sisatv01 Junio/06/2008  AJuste Validacion Especial
Insert 
Into   @tbValidacionesEspeciales(nmro_idntfccn            , nmbre                 , nmro_vrfccn                 , fcha_vldcn                  ,
	                             inco_vgnca_bnfcro        , fn_vgnca_bnfcro       , dscrpcn_drcho               , edd                         ,				
	                             nmro_idntfccn_aprtnte    , cnsctvo_cdgo_ofcna    , cnsctvo_cdgo_pln            , cnsctvo_tpo_idntfccn_aprtnte,	
	                             cnsctvo_cdgo_estdo_afldo , cnsctvo_cdgo_rngo_slrl, cnsctvo_cdgo_prntscs        , nmro_unco_idntfccn_aprtnte  ,	
	                             cnsctvo_cdgo_tpo_idntfccn, cnsctvo_cdgo_tpo_afldo, cnsctvo_cdgo_pln_pc         , prmr_nmbre                  ,			
	                             sgndo_nmbre              , prmr_aplldo           , sgndo_aplldo                , orgn                        , 
	                             cdgo_ips_prmra           , cnsctvo_cdgo_sde_ips  , cnsctvo_cdgo_tpo_undd       , nmro_unco_idntfccn_afldo    ,
	                             cnsctvo_cdgo_tpo_cntrto  , nmro_cntrto           , cnsctvo_bnfcro              , cnsctvo_cdgo_sxo            ,
	                             fcha_ncmnto              , smns_ctzds            , rzn_scl
                                )
Select b.nmro_idntfccn            , ltrim(rtrim(b.prmr_nmbre)) + ' ' + ltrim(rtrim(b.sgndo_nmbre)) + ' ' + ltrim(rtrim(b.prmr_aplldo)) + ' ' + ltrim(rtrim(b.sgndo_aplldo)),
	   b.nmro_vrfccn              , Convert(char(10),b.fcha_vldcn,111),	
	   b.inco_vgnca_bnfcro        , b.fn_vgnca_bnfcro                 , b.drcho                       , b.edd                         ,				
	   b.nmro_idntfccn_aprtnte    , b.cnsctvo_cdgo_ofcna              , b.cnsctvo_cdgo_pln            , b.cnsctvo_tpo_idntfccn_aprtnte,	
	   b.cnsctvo_cdgo_estdo_afldo , b.cnsctvo_cdgo_rngo_slrl          , b.cnsctvo_cdgo_prntscs        , b.nmro_unco_idntfccn_aprtnte  ,	
	   b.cnsctvo_cdgo_tpo_idntfccn, b.cnsctvo_cdgo_tpo_afldo          , b.cnsctvo_cdgo_pln_pc         , b.prmr_nmbre                  ,			
	   b.sgndo_nmbre              , b.prmr_aplldo                     , b.sgndo_aplldo                , orgn                          ,	
	   b.cdgo_ips_prmra           , b.cnsctvo_cdgo_sde                , b.cnsctvo_cdgo_tpo_undd       , b.nmro_unco_idntfccn_afldo    ,
	   b.cnsctvo_cdgo_tpo_cntrto  , b.nmro_cntrto                     , b.cnsctvo_bnfcro              , b.cnsctvo_cdgo_sxo            ,
	   b.fcha_ncmnto              , b.smns_ctzds                      , b.rzn_scl
From   bdSisalud.dbo.tbLog b with(nolock)
Where	b.cnsctvo_cdgo_tpo_idntfccn	= @cnsctvo_cdgo_tpo_idntfccn
And	b.nmro_idntfccn			= @nmro_idntfccn
And	b.cnsctvo_cdgo_pln		= @cnsctvo_cdgo_pln	
And	convert(char(10),b.fcha_vldcn,111)	<= @fcha_atncn

update @tbValidacionesEspeciales
set tpo_autrzn=1
from @tbValidacionesEspeciales d1 inner join bdSisalud.dbo.tbAutorizaciones d2 with(nolock)
on d1.cnsctvo_cdgo_ofcna = d2.cnsctvo_cdgo_ofcna
and d1.nmro_vrfccn=d2.nmro_vrfccn


Update @tbValidacionesEspeciales
Set mnsje = 'VALIDACIÓN ESPECIAL INEXISTENTE'
Where orgn				= 'I'

Update @tbValidacionesEspeciales
Set mnsje = 'VALIDACIÓN ESPECIAL RETIRADO'
Where orgn = 'S'

Update @tbValidacionesEspeciales
Set mnsje  = 'VALIDACIÓN ESPECIAL FORMULARIO'
Where orgn = 'F'
	

Update	@tbValidacionesEspeciales
Set	    ofcna_vldcn			= o.dscrpcn_ofcna
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbOficinas_Vigencias o with(nolock)
ON	    t.cnsctvo_cdgo_ofcna = o.cnsctvo_cdgo_ofcna
Where	@fcha_atncn >= o.inco_vgnca And @fcha_atncn <= o.fn_vgnca
--o.vsble_usro			= 'S'


Update	@tbValidacionesEspeciales
Set   	dscrpcn_pln	= p.dscrpcn_pln
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbPlanes p with(nolock)
On      t.cnsctvo_cdgo_pln = p.cnsctvo_cdgo_pln


Update	@tbValidacionesEspeciales
Set	    pln_cmplmntro 			= p.dscrpcn_pln
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbPlanes p with(nolock)
On	    t.cnsctvo_cdgo_pln_pc = p.cnsctvo_cdgo_pln


Update	@tbValidacionesEspeciales
Set	    cdgo_tpo_idntfccn = i.cdgo_tpo_idntfccn
From	bdAfiliacionValidador.dbo.tbTiposIdentificacion i with(nolock) 
Inner Join @tbValidacionesEspeciales t
On      i.cnsctvo_cdgo_tpo_idntfccn	= t.cnsctvo_cdgo_tpo_idntfccn


Update	@tbValidacionesEspeciales
Set	    dscrpcn_prntsco = p.dscrpcn_prntsco
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbParentescos p with(nolock) 
On      t.cnsctvo_cdgo_prntscs 	= p.cnsctvo_cdgo_prntscs


/*Se actualiza la descripcion del tipo afiliado para la informacion que se consulta de tbLog*/
Update	@tbValidacionesEspeciales
Set	    tpo_afldo = a.dscrpcn
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbTiposAfiliado a with(nolock) 
On      t.cnsctvo_cdgo_tpo_afldo	= a.cnsctvo_cdgo_tpo_afldo
Where  (t.tpo_afldo Is Null Or t.tpo_afldo = '')

/*Se actualiza la descripcion del origen del afiliado para la informacion que se consulta de tbLog*/
Update	@tbValidacionesEspeciales
Set	    dscrpcn_orgn = Case When orgn = '1' Then 'CONTRATOS'
			                When orgn = '2' Then 'FORMULARIOS'
			                When orgn = '3' Then 'FAMISANAR'
                            Else ''
                       End       
Where  (dscrpcn_orgn Is Null Or dscrpcn_orgn = '')

/*Se actualiza la edad del beneficiario*/
Update @tbValidacionesEspeciales
Set    edd 	= IsNull(bdAfiliacionValidador.dbo.fnCalcularTiempo(fcha_ncmnto, @fcha_atncn,1,2),0)
Where (edd Is Null Or edd = 0)


Update	@tbValidacionesEspeciales
Set 	estdo_drcho			= edv.dscrpcn_estdo_drcho
From	bdAfiliacionValidador.dbo.tbEstadosDerechoValidador edv with(nolock)
Inner Join @tbValidacionesEspeciales a 
On   	a.cnsctvo_cdgo_estdo_afldo 	= edv.cnsctvo_cdgo_estdo_drcho


Update	@tbValidacionesEspeciales
Set 	dscrpcn_rngo_slrl 	= r.dscrpcn_rngo_slrl
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbRangosSalariales r with(nolock)
On      t.cnsctvo_cdgo_rngo_slrl  = r.cnsctvo_cdgo_rngo_slrl


Update	@tbValidacionesEspeciales
Set	    dscrpcn_sxo = p.dscrpcn_sxo
From	@tbValidacionesEspeciales t 
Inner Join bdAfiliacionValidador.dbo.tbsexos p with(nolock)
On	    t.cnsctvo_cdgo_sxo = p.cnsctvo_cdgo_sxo


Select * From @tbValidacionesEspeciales
where tpo_autrzn!=1



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [330004 Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [330001 Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [330002 Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [SOS\330008 Auditor Interno de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spcmTraerValidacionesEspeciales] TO [Liquidador Facturas]
    AS [dbo];

