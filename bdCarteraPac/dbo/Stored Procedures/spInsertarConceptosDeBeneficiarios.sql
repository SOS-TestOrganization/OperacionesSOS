/*---------------------------------------------------------------------------------
* Metodo o PRG			:  spInsertarConceptosDeBeneficiarios
* Desarrollado por		: <\A Ing. Jean Paul Villaquiran Madrigal A\> 
* Descripcion			: <\D Permite calcula el conseuctivo que sera utilizado en un nuevo estado de cuenta manual D\>
* Observaciones			: <\O O\>
* Parametros			: <\P P\>
* Variables				: <\VV\>
* Fecha Creacion		: <\FC 2019/04/30 FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM	AM\>
* Descripcion			: <\DM	DM\>
* Nuevos Parametros		: <\PM	PM\>
* Nuevas Variables		: <\VM	VM\>
* Fecha Modificacion	: <\FM FM\>
*---------------------------------------------------------------------------------
* Scritp's de pruebas
*---------------------------------------------------------------------------------
--------------------------------------------------------------------------------*/
CREATE procedure dbo.spInsertarConceptosDeBeneficiarios
as
begin
		set nocount on;

		-- 4 e el consecutivo del concepto valor de la cuota.
		Insert Into	#tmpBeneficiariosConceptos
		(	
				nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				Valor,
				cnsctvo_cdgo_cncpto_lqdcn,	
				cnsctvo_cnta_mnls_cntrto
		)
		Select	nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				vlr_cta,
				4,				
				0
		From	#tmpBeneficiarios

		--Segundo se inserta el valor del descuento comercial de cada  beneficiario
		-- 5 e el consecutivo del concepto del descuento comercial.

		Insert Into	#tmpBeneficiariosConceptos
		(
				nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				Valor,
				cnsctvo_cdgo_cncpto_lqdcn,	
				cnsctvo_cnta_mnls_cntrto
		)
		Select	nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				vlr_dcto_comercial,
				5,				
				0
		From	#tmpBeneficiarios

		--Tercero se inserta el valor de otros descuentos de cada beneficiaerio
		-- 6 e el consecutivo del concepto de otros descuentos.

		Insert Into	#tmpBeneficiariosConceptos
		(
				nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				Valor,
				cnsctvo_cdgo_cncpto_lqdcn,	
				cnsctvo_cnta_mnls_cntrto
		)
		Select	nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				vlr_otros_dcts,
				6,				
				0
		From	#tmpBeneficiarios


		-- Cuarto se inserta el valor de l iva de cada beneficiario
		-- 7 e el consecutivo del valor del iva

		Insert Into	#tmpBeneficiariosConceptos
		(
				nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				Valor,
				cnsctvo_cdgo_cncpto_lqdcn,	
				cnsctvo_cnta_mnls_cntrto
		)
		Select	nmro_unco_idntfccn_aprtnte,	
				cnsctvo_scrsl_ctznte,
				nmro_unco_idntfccn_afldo,	
				cnsctvo_cdgo_tpo_cntrto,
				nmro_cntrto,			
				cnsctvo_bnfcro,
				nmro_unco_idntfccn_bnfcro,	
				inco_vgnca_bnfcro,
				fn_vgnca_bnfcro,		
				vlr_iva,
				3,				
				0
		From	#tmpBeneficiarios
end