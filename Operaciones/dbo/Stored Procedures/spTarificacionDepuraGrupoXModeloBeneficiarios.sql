

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	    :   spTarificacionDepuraGrupoXModeloBeneficiarios
* Desarrollado por	:	<\A Ing. Francisco Javier Gonzalez Ruano																		A\>
* Descripcion		:	<\D Este procedimiento elimina las definiciones de grupos que no corresponden al modelo del producto			D\>
* Observaciones		:	<\O	O\>
* Parametros		:	<\P #DefinicionesTemporales tabla que tiene los grupos a eliminar	P\>
*					:	<\P	@lnConsecutivoGrupo	Contiene el grupo generico de tarifas P\>
*					:	<\P	P\>
* Variables			:	<\V	V\>
				    :	<\V	V\>	
* Fecha Creacion	:  <\FC  20123/03/13																								FC\>*  
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION   
*---------------------------------------------------------------------------------  
* Modificado Por		 : <\AM   AM\>  
* Descripcion			 : <\DM   DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM   FM\>
*---------------------------------------------------------------------------------*/


CREATE   PROCEDURE [dbo].[spTarificacionDepuraGrupoXModeloBeneficiarios]
		@lnConsecutivoGrupo		udtConsecutivo--,
--		@cnsctvo_cdgo_lqdcn		udtConsecutivo,
--		@ldFechaReferencia		Datetime
	

As

set nocount on				


Declare		@ldFechaEvaluacion			Datetime,
			@cnsctvo_cdgo_prdo_lqdcn	int,
			@grupo int


-- Se recupera el consecutivo del periodo de liquidacion

Select 	@cnsctvo_cdgo_prdo_lqdcn			=	cnsctvo_cdgo_prdo_lqdcn
From	bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo			=	2	


--  Se recupera la fecha inical del perido de liquidacion con estado de periodo abierto

Select 	@ldFechaEvaluacion		=	fcha_incl_prdo_lqdcn
From	bdcarteraPac.dbo.tbPeriodosliquidacion_Vigencias
Where	cnsctvo_cdgo_estdo_prdo	=	2	
And		cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn	


--------------------------------------------------------------------------------------------------------------------------------------
--													Creacion de tablas temporales													--
--------------------------------------------------------------------------------------------------------------------------------------

Create table	#tmpProductosCobranza_Depurar
(cnsctvo_prdcto_cbrnza int,
 cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto varchar(20),
 cnsctvo_cbrnza int,
 cnsctvo_prdcto_scrsl int,
 cnsctvo_prdcto int,
 inco_vgnca datetime,
 fn_vgnca datetime,
 estdo_rgstro char(1))


-----------------------------------------

Create table  	#tmpModelosAsociadosxProducto_Depurar	
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto varchar(20),
 cnsctvo_bnfcro int,
 cnsctvo_cbrnza int,
 cnsctvo_prdcto int,
 cnsctvo_mdlo int,
 cnsctvo_cdgo_clse_mdlo int,
 inco_vgnca_asccn datetime,
 fn_vgnca_asccn datetime,
 fcha_uso_mdlo datetime,    
 fcha_aflcn_pc datetime,
 Estado  int)                                     

------------------------------------------------------

Create table #tmpModelosMayorUno_Depurar
(cnsctvo_cdgo_tpo_cntrto int,
 nmro_cntrto varchar(20),
 cnsctvo_bnfcro int,
 cnsctvo_cbrnza int,
 cnsctvo_prdcto int,
 cnsctvo_mdlo int,
 cnsctvo_cdgo_clse_mdlo int,
 inco_vgnca_asccn datetime,
 fn_vgnca_asccn datetime,
 fcha_uso_mdlo datetime,     
 fcha_aflcn_pc datetime,
 Estado1 int,
 Estado2 int,
 brrdo char(1))

------------------------------------------------------

Create table 	#RegistrosClasificar_Depurar
(nmro_unco_idntfccn int,
 edd_bnfcro int,
 cnsctvo_cdgo_pln int,
 ps_ss char(1),
 fcha_aflcn_pc	datetime,
 cnsctvo_cdgo_prntsco int,
 cnsctvo_cdgo_tpo_afldo int,
 Dscpctdo char(1),
 Estdnte char(1),
 Antgdd_hcu char(1),
 Atrzdo_sn_Ps char(1),
 grpo_bsco char(1),
 cnsctvo_cdgo_tpo_cntrto int,	
 nmro_cntrto varchar(20),
 cnsctvo_bnfcro int,
 cnsctvo_cbrnza int,
 grupo int,
 cnsctvo_prdcto int,
 cnsctvo_mdlo int,
 vlr_upc numeric(12,0),
 vlr_rl_pgo numeric(12,0),
 cnsctvo_cdgo_tps_cbro int,
 Cobranza_Con_producto int,
 Beneficiario_Con_producto int,
 Con_Modelo int,
 grupo_tarificacion int,
 igual_plan int,
 grupo_modelo int,
 nmro_unco_idntfccn_aprtnte int,
 cnsctvo_scrsl_ctznte int, 
 cnsctvo_cdgo_clse_aprtnte int,
 inco_vgnca_cntrto datetime,
 bnfcdo_pc char(1),
Tne_hjos_cnyge_cmpnra char(1),
cntrtnte_ps_ss char(1),
grpo_bsco_cn_ps char(1),
cntrtnte_tn_pc char(1)
)

------------------------------------------------------

Create table 	#tmpDetallesGrupoValidos	(
		cnsctvo_cdgo_dtlle_grpo	Int, cnsctvo_cdgo_dfncn_grpo Int,	cnsctvo_cdgo_rngo_vrble Int	)



------------------------------------------------------
------------------------------------------------------


-- Se carga la informacion en una tabla intermedia

Insert Into #RegistrosClasificar_Depurar
Select	*
From	#RegistrosClasificar

If  @@error <> 0
Begin 
	Return 10
end


-- se recupera la informacion de las cobranzas que tiene productos

Insert into	#tmpProductosCobranza_Depurar
Select	a.cnsctvo_prdcto_cbrnza,
		a.cnsctvo_cdgo_tpo_cntrto,
		a.nmro_cntrto,
		a.cnsctvo_cbrnza,
		a.cnsctvo_prdcto_scrsl,
		a.cnsctvo_prdcto,
		a.inco_vgnca,
		a.fn_vgnca,
		a.estdo_rgstro
From	bdafiliacion.dbo.tbProductosCobranza a inner join   #RegistrosClasificar b
		on	(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto				=	b.nmro_cntrto
		And	a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
Where	convert(varchar(10), @ldFechaEvaluacion,111) 	between convert(varchar(10),a.inco_vgnca,111)       and	convert(varchar(10),a.fn_vgnca,111) -- que sea el siguiente del periodo a evaluar
And		a.estdo_rgstro		=	'S'

If  @@error <> 0
Begin 
	Return 20
end



-- Se elimina las cobranzas sin producto o con producto 1

Delete from #tmpProductosCobranza_Depurar where cnsctvo_prdcto = 1 or cnsctvo_prdcto = 0

If  @@error <> 0
Begin 
	Return 30
end


/*
--Se actualiza los cobranzas que tiene  productos

Update	b
Set		Cobranza_Con_producto		=	1
From	#tmpProductosCobranza_Depurar		a inner join   #RegistrosClasificar_Depurar b
		on	(a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto				=	b.nmro_cntrto
		And	a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)

If  @@error <> 0
Begin 
	Return 30
end
*/


--Actualiza los beneficiarios que tiene productos

Update 	a
Set		cnsctvo_prdcto				=	c.cnsctvo_prdcto,
		Beneficiario_Con_producto	=	1
From	#RegistrosClasificar_Depurar a inner join  bdafiliacion.dbo.tbProductosxBeneficiario b 
			on     (a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
			And	a.nmro_cntrto			=	b.nmro_cntrto
			And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
			And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza) 
		inner join	#tmpProductosCobranza_Depurar c
			on (b.cnsctvo_prdcto_cbrnza		=	c.cnsctvo_prdcto_cbrnza	)
Where	convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),b.inco_vgnca,111)       and	convert(varchar(10),b.fn_vgnca,111) -- que sea el siguiente del periodo a evaluar
And		b.estdo_rgstro		=	'S'

If  @@error <> 0
Begin 
	Return 40
end


-- clase modelo de tarifas..

Insert into 	#tmpModelosAsociadosxProducto_Depurar	
select  b.cnsctvo_cdgo_tpo_cntrto,					b.nmro_cntrto,								b.cnsctvo_bnfcro,							
		b.cnsctvo_cbrnza,							a.cnsctvo_prdcto,							a.cnsctvo_mdlo,								
		a.cnsctvo_cdgo_clse_mdlo,					a.inco_vgnca_asccn,							a.fn_vgnca_asccn,							
		a.fcha_uso_mdlo,							b.fcha_aflcn_pc,							0	Estado                                       
from 	bdplanbeneficios.dbo.tbDetproductos a inner join #RegistrosClasificar_Depurar b
		on (a.cnsctvo_prdcto		=	b.cnsctvo_prdcto)
where 	a.cnsctvo_cdgo_clse_mdlo	=	6	
And	( 	 (Convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),a.inco_vgnca_asccn,111)       and	convert(varchar(10),a.fn_vgnca_asccn,111) )
	or 	 (Convert(varchar(10), @ldFechaEvaluacion	,111) 	between convert(varchar(10),a.fcha_uso_mdlo,111)       and	convert(varchar(10),a.inco_vgnca_asccn,111) )
	)

If  @@error <> 0
Begin 
	Return 50
end



--Se actualiza  para aquellos productos que solamente tienen un solo registro a evaluar

Update #tmpModelosAsociadosxProducto_Depurar
Set	Estado	=	1
From	#tmpModelosAsociadosxProducto_Depurar a , 
		(Select	cnsctvo_cdgo_tpo_cntrto,			    nmro_cntrto,
				cnsctvo_bnfcro,							cnsctvo_cbrnza,
				cnsctvo_prdcto ,						count(*)	Cantidad_Productos
		 From	#tmpModelosAsociadosxProducto_Depurar
		 group by	cnsctvo_cdgo_tpo_cntrto,				nmro_cntrto,
					cnsctvo_bnfcro,							cnsctvo_cbrnza,
					cnsctvo_prdcto
		Having	count(*)=1 ) tmpCantidadProductos1
Where	a.cnsctvo_prdcto			=	tmpCantidadProductos1.cnsctvo_prdcto
And		a.cnsctvo_cdgo_tpo_cntrto	=	tmpCantidadProductos1.cnsctvo_cdgo_tpo_cntrto
And		a.nmro_cntrto				=	tmpCantidadProductos1.nmro_cntrto
And		a.cnsctvo_bnfcro			=	tmpCantidadProductos1.cnsctvo_bnfcro
And		a.cnsctvo_cbrnza			=	tmpCantidadProductos1.cnsctvo_cbrnza						    
						  
If  @@error <> 0
Begin 
	Return 60
end



--Se crea una tabla temporal que contiene todos los productos que tiene mas de un modelo

Insert into	 #tmpModelosMayorUno_Depurar
select  cnsctvo_cdgo_tpo_cntrto,
		nmro_cntrto,
		cnsctvo_bnfcro,
		cnsctvo_cbrnza,
		cnsctvo_prdcto,
		cnsctvo_mdlo,
		cnsctvo_cdgo_clse_mdlo,
		inco_vgnca_asccn,
		fn_vgnca_asccn,
		fcha_uso_mdlo,    
		fcha_aflcn_pc,
		0	Estado1,
		0	Estado2,
		'N'	brrdo
From	#tmpModelosAsociadosxProducto_Depurar
where 	Estado	=	0

If  @@error <> 0
Begin 
	Return 70
end



--Se actualiza el modelo que que esta vigente al sistema
update #tmpModelosMayorUno_Depurar
Set	Estado1		=	1
Where	convert(varchar(10),@ldFechaEvaluacion ,111) 	between convert(varchar(10),inco_vgnca_asccn,111)       and	convert(varchar(10),fn_vgnca_asccn,111) 

If  @@error <> 0
Begin 
	Return 80
end




--Se actualiza  el registro si se requiere utilizar el modelo donde el incio del contrato sea mayor que
--la fecha de uso y no este vigente para el sistema
update #tmpModelosMayorUno_Depurar
Set	Estado2		=	1
Where	fcha_aflcn_pc >=  fcha_uso_mdlo
and	Estado1		=	0	

If  @@error <> 0
Begin 
	Return 90
end


--Se marcan los modelos que no se actualizaron con el fin de contemplarlos para el proceso

update #tmpModelosMayorUno_Depurar
Set	brrdo		=	'S'
Where	Estado1	=	0 and	Estado2 = 0

If  @@error <> 0
Begin 
	Return 100
end


--se actualiza  el registro para aquellos modelos que cumplen con las dos condiciones
--pero se requiere qel que el estado2 sea igual  a cero es decir que no es vigente para el sistema
--pwero si vigente para el uso

update #tmpModelosMayorUno_Depurar
Set	brrdo	=	'S'
From	#tmpModelosMayorUno_Depurar a, 
		(Select   cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,
					 cnsctvo_bnfcro,							cnsctvo_cbrnza,
					 cnsctvo_prdcto ,							count(*) Cantidad_Modelos
		 From	#tmpModelosMayorUno_Depurar
		 Where   brrdo	=	'N'
		 Group by	cnsctvo_cdgo_tpo_cntrto,						nmro_cntrto,
					cnsctvo_bnfcro,									cnsctvo_cbrnza,
					 cnsctvo_prdcto
		 Having	count(*)> 1 ) tmpBorrados
Where	a.cnsctvo_prdcto			=	tmpBorrados.cnsctvo_prdcto
And		a.cnsctvo_cdgo_tpo_cntrto	=	tmpBorrados.cnsctvo_cdgo_tpo_cntrto
And		a.nmro_cntrto				=	tmpBorrados.nmro_cntrto
And		a.cnsctvo_bnfcro			=	tmpBorrados.cnsctvo_bnfcro
And		a.cnsctvo_cbrnza			=	tmpBorrados.cnsctvo_cbrnza
And		a.Estado2					=	0

If  @@error <> 0
Begin 
	Return 100
end


--Se actualiza el modelo que re requiere para que aquellos que tenia mas de 1 modelo
--para su evaluacion

Update #tmpModelosAsociadosxProducto_Depurar
Set		Estado	=	1
From	#tmpModelosAsociadosxProducto_Depurar a inner join #tmpModelosMayorUno_Depurar b
	on	(a.cnsctvo_prdcto			=	b.cnsctvo_prdcto
	And	a.cnsctvo_mdlo				=	b.cnsctvo_mdlo
	And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto				=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro
	And	a.cnsctvo_cbrnza			=	b.cnsctvo_cbrnza)
Where	a.Estado				=	0
And		b.brrdo					=	'N'


If  @@error <> 0
Begin 
	Return 110
end


--Se actualiza el modelo final del producto para cada beneficiario

/*
Update #RegistrosClasificar
Set	cnsctvo_mdlo	=	b.cnsctvo_mdlo,
	Con_Modelo	=	1
From	#RegistrosClasificar a inner join #tmpModelosAsociadosxProducto_Depurar b
	on     (a.cnsctvo_prdcto		=	b.cnsctvo_prdcto
	And	a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And	a.nmro_cntrto			=	b.nmro_cntrto
	And	a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
	And	a.cnsctvo_cbrnza		=	b.cnsctvo_cbrnza)
Where	b.Estado				=	1

*/

-- Se calculas los grupos validos

Insert Into	#tmpDetallesGrupoValidos	(
		cnsctvo_cdgo_dtlle_grpo,		cnsctvo_cdgo_dfncn_grpo,		cnsctvo_cdgo_rngo_vrble	)
Select	a.cnsctvo_cdgo_dtlle_grpo,		d.cnsctvo_cdgo_dfncn_grpo,		e.cnsctvo_cdgo_rngo_vrble 
From	bdafiliacion.dbo.tbdetgrupos a,
		bdAfiliacion.dbo.tbDefinicionGrupos d,
		bdAfiliacion.dbo.tbDetDefinicionGrupos e
Where	a.cnsctvo_cdgo_dtlle_grpo  in (	Select cnsctvo_cdgo_grpo_trfro 
										From	bdplanbeneficios.dbo.tbdetmodelotarifas b,
												#tmpModelosAsociadosxProducto_Depurar c	
										Where	b.cnsctvo_mdlo	= c.cnsctvo_mdlo
										And		c.Estado		=	1)
And		a.cnsctvo_cdgo_dtlle_grpo	= d.cnsctvo_cdgo_dtlle_grpo
And		d.cnsctvo_cdgo_dfncn_grpo	= e.cnsctvo_cdgo_dfncn_grpo


If  @@error <> 0
Begin 
	Return 120
end



-- Se eliminan los grupos que no pertenencen al modelo del producto del beneficiario

Delete	a
From	#DefinicionesTemporales a
Where	Not Exists (Select	1
					From	#tmpDetallesGrupoValidos b
					Where	a.cnsctvo_cdgo_dtlle_grpo	= b.cnsctvo_cdgo_dtlle_grpo
					And		a.cnsctvo_cdgo_dfncn_grpo	= b.cnsctvo_cdgo_dfncn_grpo
					And		a.cnsctvo_cdgo_rngo_vrble	= b.cnsctvo_cdgo_rngo_vrble)



-- Eliminacion de tablas temporales

Drop table #tmpProductosCobranza_Depurar
Drop table #tmpModelosAsociadosxProducto_Depurar	
Drop table #tmpModelosMayorUno_Depurar
Drop table #RegistrosClasificar_Depurar
Drop table #tmpDetallesGrupoValidos
	
