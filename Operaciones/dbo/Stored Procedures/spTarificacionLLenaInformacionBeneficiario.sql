
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTarificacionLLenaInformacionBeneficiario
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento Actualiza la informacion basica de los beneficiarios para poder calcular el grupo  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM   Ing. Sandra Milena Ruiz Reyes 				AM\>
* Descripcion			 : <\DM   Aplicacion de tecnicas de optimizacion		DM\>
* Nuevos Parametros	 	 : <\PM													PM\>
* Nuevas Variables		 : <\VM													VM\>
* Fecha Modificacion	 : <\FM   05/09/2005									FM\>
* Modificado Por		 : <\AM   Ing. Francisco Javier Gonzalez Ruano 			AM\>
* Descripcion			 : <\DM   Se ajusta el proceso de tarificación PAC, para que a los beneficiarios entre 18 y 25 años, no les verifique su condicion		DM\>
*						 :		  de documento (certificado de estudio y/ó declaración suscrita de padres sobre dependencia economica), de acuerdo Ley 1753		DM\>
*						 :		  del 2015   del plan Nacional de desarrollo Art 218 Literal C.																	DM\>
* Nuevos Parametros	 	 : <\PM													PM\>
* Nuevas Variables		 : <\VM													VM\>
* Fecha Modificacion	 : <\FM   31/07/2015									FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spTarificacionLLenaInformacionBeneficiario](
	@cnsctvo_cdgo_lqdcn udtconsecutivo
)
As
Begin
	set nocount on;

	Declare	@cnsctvo_cdgo_prdo_lqdcn	int,
			@ldFecha_Corte_Prdo			Datetime,
			@ldFecha_Fin_Prdo			Datetime,
			@lcfecha_actual				Datetime = getDate();

	Create table #tmpCantidadContratosPos
	(
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,
		nmro_cntrto					udtNumeroFormulario,
		cnsctvo_bnfcro				udtConsecutivo,
		nmro_unco_idntfccn			udtConsecutivo
	)

	Create table #tmpCantidadContratosPosContratantes
	(
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,
		nmro_cntrto					udtNumeroFormulario,
		cnsctvo_bnfcro				udtConsecutivo,
		nmro_unco_idntfccn			udtConsecutivo
	)

	Create table #tmpBenePosC
	(
		nmro_cntrto					char(15),
		cnsctvo_cdgo_tpo_cntrto		int,
		cnsctvo_cbrnza				int,
		con_bene					int
	)

	Create table #tmpBeneficiarioPacByE
	(
		cnsctvo_cdgo_tpo_cntrto		int,
		nmro_cntrto					char(15),
		nmro_unco_idntfccn			int,
		fcha_aflcn_pc				datetime
	)

	Create table #tmpTablaFechas
	(
		item					int IDENTITY(1, 1),
		nui						int,
		nmro_dias				int,	
		cnsctvo_aux				int,
		fecha_ini				datetime,
		fecha_fin				datetime,
		fecha_aux				datetime,
		fecha_ini_real			datetime
	)

	Create table #tmpHijosConPos 
	(
		nmro_unco_idntfccn			udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,
		nmro_cntrto					udtNumeroFormulario,			
		cnsctvo_bnfcro				udtConsecutivo,
		estdnte						Varchar(1)
	)
	
	Create table #tmpHijosConPosDiscapacidad
	(
		nmro_unco_idntfccn			udtConsecutivo,
		cnsctvo_cdgo_tpo_cntrto		udtConsecutivo,
		nmro_cntrto					udtNumeroFormulario,
		cnsctvo_bnfcro				udtConsecutivo,
		Dscpctdo					Varchar(1),
	)
	
	Create table #tmpcontratosFamiliarQuimbaya
	(
		cnsctvo_cdgo_tpo_cntrto			udtConsecutivo,
		nmro_cntrto						udtNumeroFormulario,
		nmro_unco_idntfccn				udtConsecutivo,
		cnsctvo_cdgo_pln				udtConsecutivo,
		cantidad_beneficiarios			int,
	    cantidad_beneficiariosCeH		int
	)
	
	Create table #tmpCantidadBeneficiarios
	(
		cnsctvo_cdgo_tpo_cntrto			udtConsecutivo,
		nmro_cntrto						udtNumeroFormulario,
		cantidad_beneficiarios			int
	)
	
	Create table #tmpCantidadBeneficiariosCeH
	(
		cnsctvo_cdgo_tpo_cntrto			udtConsecutivo,
		nmro_cntrto						udtNumeroFormulario,
		cantidad_beneficiariosCeH		int
	)

	-- se trae el periodo de liquidacion
	Select	@cnsctvo_cdgo_prdo_lqdcn	=	cnsctvo_cdgo_prdo_lqdcn
	From	bdcarteraPac.dbo.tbliquidaciones with(nolock)
	Where	cnsctvo_cdgo_lqdcn		=	@cnsctvo_cdgo_lqdcn
	
	Select 	@ldFecha_Corte_Prdo		=	fcha_incl_prdo_lqdcn,
			@ldFecha_Fin_Prdo		=	fcha_fnl_prdo_lqdcn
	From	bdcarteraPac.dbo.tbperiodosliquidacion_vigencias with(nolock)
	Where	cnsctvo_cdgo_prdo_lqdcn	=	@cnsctvo_cdgo_prdo_lqdcn


	-- Se actualiza el parentesco y el tipo de afiliado del contrato pac
	Update		#RegistrosClasificarFinal
	Set			cnsctvo_cdgo_tpo_afldo	=	b.cnsctvo_cdgo_tpo_afldo,
				cnsctvo_cdgo_prntsco	=	b.cnsctvo_cdgo_prntsco
	From		#RegistrosClasificarFinal			a 
	Inner join	bdafiliacion.dbo.tbbeneficiarios	b with(nolock)
		On		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto				=	b.nmro_cntrto
		And		a.cnsctvo_bnfcro			=	b.cnsctvo_bnfcro

	If  @@error <> 0
	Begin 
		Return -1
	end


	Update		#RegistrosClasificarFinal 
	Set			fcha_aflcn_pc		= det.inco_vgnca_tmpo,
				inco_vgnca_cntrto	= det.inco_vgnca_tmpo
	From		#RegistrosClasificarFinal a 
	Inner join	(Select		a.nmro_unco_idntfccn_afldo, max(a.inco_vgnca_tmpo) as inco_vgnca_tmpo
				 From		bdafiliacion.dbo.tbtiemposafiliacion a WITH(NOLOCK)
				 Inner Join #RegistrosClasificarFinal b
					On		a.nmro_unco_idntfccn_afldo = b.nmro_unco_idntfccn
				 Where		a.cnsctvo_cdgo_pln	= 2
				 And		a.ttl_ds_rngo		= 0
	             group by  a.nmro_unco_idntfccn_afldo ) det
		On		a.nmro_unco_idntfccn	= det.nmro_unco_idntfccn_afldo 

	If  @@error <> 0
	Begin 
		Return -1
	end

	--Se crea una tabla temporal
	Insert into #tmpCantidadContratosPos
	Select		a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_bnfcro,
				b.nmro_unco_idntfccn
	FROM		bdafiliacion.dbo.tbBeneficiarios a 
	INNER JOIN	#RegistrosClasificarFinal b 
		ON		a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
	WHERE		(DATEDIFF(dd, a.inco_vgnca_bnfcro, @ldFecha_Corte_Prdo) >= 0) 
	AND			(DATEDIFF(dd, @ldFecha_Corte_Prdo, a.fn_vgnca_bnfcro) >= 0) 
	AND 		(a.estdo					= 'A') 
	AND			(a.cnsctvo_cdgo_tpo_cntrto	= 1)
	GROUP BY a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, a.cnsctvo_bnfcro, b.nmro_unco_idntfccn
	--aqui estdo

	Insert into #tmpCantidadContratosPosContratantes
	Select		a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_bnfcro,
				b.nmro_unco_idntfccn
	FROM		bdafiliacion.dbo.tbBeneficiarios a 
	INNER JOIN	#RegistrosClasificarFinal b 
		ON		a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
	WHERE		(DATEDIFF(dd, a.inco_vgnca_bnfcro, @ldFecha_Corte_Prdo) >= 0) 
	AND			(DATEDIFF(dd, @ldFecha_Corte_Prdo, a.fn_vgnca_bnfcro) >= 0) 
	AND 		(a.estdo = 'A') 
	AND			(a.cnsctvo_cdgo_tpo_cntrto = 1)
	AND			(a.cnsctvo_cdgo_prntsco = 0)
	GROUP BY a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, a.cnsctvo_bnfcro, b.nmro_unco_idntfccn

	If  @@error <> 0
	Begin 
		Return -1
	end

	--Se actualiza el campo si tiene pos con sos
	update 		#RegistrosClasificarFinal
	Set			ps_ss	=	'S'
	From		#RegistrosClasificarFinal a 
	Inner join 	(Select  nmro_unco_idntfccn,
				count(*) cantidad_contratos_POs
				From 	#tmpCantidadContratosPos
				group by nmro_unco_idntfccn) b
		On		a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
	Where		b.cantidad_contratos_POs	>	0


	--Se actualiza el campo si tiene pos con sos para el contratante
	update 	#RegistrosClasificarFinal
	Set		cntrtnte_ps_ss	=	'S'
	From	#RegistrosClasificarFinal a 
	Inner join 	(Select  cnsctvo_cdgo_tpo_cntrto, 	 nmro_cntrto, 
				count(*) cantidad_contratos_POs
				From 	#tmpCantidadContratosPosContratantes
				group by cnsctvo_cdgo_tpo_cntrto, 	 nmro_cntrto ) b
		On 	a.cnsctvo_cdgo_tpo_cntrto		=	b.cnsctvo_cdgo_tpo_cntrto
	and		a.nmro_cntrto		=	b.nmro_cntrto
	Where	b.cantidad_contratos_POs	>	0
	and		a.cnsctvo_cdgo_prntsco != 0


	select	nmro_cntrto,  nmro_unco_idntfccn, ps_ss, Atrzdo_sn_Ps 
	into	#GrupoBasicoConPos1
	from	#RegistrosClasificarFinal 
	where	cnsctvo_cdgo_tpo_afldo != 1
	group by nmro_cntrto , nmro_unco_idntfccn,  ps_ss, Atrzdo_sn_Ps
	
	update	#GrupoBasicoConPos1
	set		ps_ss = 'S'
	where	ps_ss = 'N' 
	and		Atrzdo_sn_Ps = 'S'
	
	select	nmro_cntrto, count(nmro_unco_idntfccn) can_bene, 0 con_pos, 0 sin_pos 
	into	#agrupacionConPos
	from	#GrupoBasicoConPos1
	group by nmro_cntrto

	update	#agrupacionConPos
	set		con_pos = b.canti
	from	#agrupacionConPos a 
	inner join (select  nmro_cntrto, count(*) canti from #GrupoBasicoConPos1 where ps_ss = 'S' group by nmro_cntrto ) b
		on a.nmro_cntrto = b.nmro_cntrto
	
	update	#agrupacionConPos
	set		sin_pos = b.canti
	from	#agrupacionConPos a 
	inner join (select  nmro_cntrto, count(*) canti from #GrupoBasicoConPos1 where ps_ss = 'N' group by nmro_cntrto ) b
		on	a.nmro_cntrto = b.nmro_cntrto
	
	update	a
	set		a.grpo_bsco_cn_ps = 'S'
	from	#RegistrosClasificarFinal a
	inner join (select nmro_cntrto from #agrupacionConPos where can_bene = con_pos group by nmro_cntrto  )b
		on	a.nmro_cntrto = b.nmro_cntrto
	where	cnsctvo_cdgo_tpo_afldo = 1

	If  @@error <> 0
	Begin 
		Return -1
	end

	--Se actualiza el tipo de afiliado a pos c aquellos que tiene un contrato pos y son cotizantes
	--SE crea un tabla temporal  con todos los beneficiarios con parentescos conyuge o compañera y que tengan un pos vigente y sean cotizantes en el pos..
	
	-- se  adiciona modificacion 23 de junio 
	-- no solamente que diga cotizante en pos sino que tambien conyuge cotizante , ya  que hay contratos que guardan con un solo bene y ese es conyuge cotizante
	
	
	--Se actualiza el tipos de afiliado a cotizante pos c a esos contratos pac
	Update	#RegistrosClasificarFinal
	Set		cnsctvo_cdgo_tpo_afldo	=	2
	From	#RegistrosClasificarFinal a
	inner join	(SELECT		nmro_unco_idntfccn
				FROM		bdafiliacion.dbo.tbBeneficiarios a with(nolock)
				INNER JOIN	#RegistrosClasificarFinal b 
				ON 		a.nmro_unco_idntfccn_bnfcro = b.nmro_unco_idntfccn
				WHERE   (DATEDIFF(dd, a.inco_vgnca_bnfcro, @ldFecha_Corte_Prdo) >= 0) 
				AND 	(DATEDIFF(dd, @ldFecha_Corte_Prdo, a.fn_vgnca_bnfcro) >= 0) 
				AND 	(a.estdo = 'A') 
				AND		(a.cnsctvo_cdgo_tpo_cntrto = 1) 
				AND		(a.cnsctvo_cdgo_tpo_afldo IN (1, 2)) 
				AND		(b.ps_ss = 'S') 
				AND		(b.cnsctvo_cdgo_prntsco = 2 OR b.cnsctvo_cdgo_prntsco = 3) 
				AND		(b.cnsctvo_cdgo_tpo_afldo <> 2)
				GROUP BY b.nmro_unco_idntfccn) b
		On		a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
	Where		a.ps_ss				= 	'S'	       -- que tengan pos	
	And			(a.cnsctvo_cdgo_prntsco		=	2 or 	a.cnsctvo_cdgo_prntsco	=3)       --parentesco Conyuge o Compañero
	And			a.cnsctvo_cdgo_tpo_afldo	!=	2	       --sean diferentes del POSC
	--aqui estdo
	
	--Se verifica si en realidad se le debe de cobrar como pos c porque si el cotizante no tiene grupo basico o adicionales entonces el pos c queda como grupo basico
	
	--Se crea una tabla temporal con la informacion de los beneficiarios Pos c
	--Parentesco conyuge o compañera para tipo de afiliado  pos c
	
	Insert into #tmpBenePosC
	Select	nmro_cntrto , cnsctvo_cdgo_tpo_cntrto,cnsctvo_cbrnza,0 con_bene
	From	#RegistrosClasificarFinal
	Where	cnsctvo_cdgo_tpo_afldo 	= 2
	And		(cnsctvo_cdgo_prntsco 	= 2 or cnsctvo_cdgo_prntsco = 3)
		
	--Se verifica si para ese numero de contrato , tipo de contrato y consecutivo de la cobranzas tiene algun beneficiario que tenga otro parentesco diferente 
	--a  cotizante, conyuge o compañera
	Update		#tmpBenePosC 
	Set			con_bene = 1
	FROM		#tmpBenePosC a 
	INNER JOIN	#RegistrosClasificarFinal b 
		ON		a.nmro_cntrto 			= b.nmro_cntrto 
	AND			a.cnsctvo_cdgo_tpo_cntrto	= b.cnsctvo_cdgo_tpo_cntrto 
	AND			a.cnsctvo_cbrnza = b.cnsctvo_cbrnza
	WHERE		(b.cnsctvo_cdgo_prntsco <> 1) 
	AND			(b.cnsctvo_cdgo_prntsco <> 2) 
	AND			(b.cnsctvo_cdgo_prntsco <> 3)
			
	--Se actualizan esos beneficiarios que eran cotizantes pos c a tipo de afiliado beneficiario
	Update		#RegistrosClasificarFinal
	Set 		cnsctvo_cdgo_tpo_afldo = 3
	FROM		#RegistrosClasificarFinal a 
	INNER JOIN  #tmpBenePosC b 
		ON		a.nmro_cntrto = b.nmro_cntrto 
	AND 		a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto 
	AND			a.cnsctvo_cbrnza 		= b.cnsctvo_cbrnza
	WHERE		(a.cnsctvo_cdgo_prntsco = 2 OR  a.cnsctvo_cdgo_prntsco = 3) 
	AND 		(a.cnsctvo_cdgo_tpo_afldo = 2) 
	AND 		(b.con_bene = 0)
	                      
	--Se calcula la edad del beneficiario
	Update		#RegistrosClasificarFinal
	Set			edd_bnfcro	=	BDAFILIACION.DBO.fnCalcularTiempo (a.fcha_ncmnto,@ldFecha_Fin_Prdo,1,2)
	From		bdafiliacion.dbo.tbpersonas a 
	Inner Join  #RegistrosClasificarFinal b
		On 		a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
	
	
	If  @@error <> 0
	Begin 
		Return -1
	end
		
	--Se CALCULA LA EDAD EN AÑOS Y LA EDAD REAL
	Update		#RegistrosClasificarFinal
	Set			bnfcdo_pc		=	case when (BDAFILIACION.DBO.fnCalcularTiempo (a.fcha_ncmnto,@ldFecha_Fin_Prdo,1,2) != BDAFILIACION.DBO.fnCalcularTiempo (a.fcha_ncmnto,@ldFecha_Fin_Prdo,1,1)) then 'N' else 'S' END
	From		bdafiliacion.dbo.tbpersonas a 
	Inner Join  #RegistrosClasificarFinal b
	On 			a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
	
	If  @@error <> 0
	Begin 
		Return -1
	End
	
	---Actualiza  si tiene antiguedad en los planes para bienestar y execlencia para para las personas mayores de 60 y menores de 70
	--Se crea una tabla temporal  con todos los beneficiarios que hay tenido plan complementario
	
	-- antiguedad en sos para pac
	
	--Se crea una tabla temporal con los benefiarios entre  60 y 70 años de planes bienestar  o excelencia
	
	Insert into #tmpBeneficiarioPacByE
	Select  cnsctvo_cdgo_tpo_cntrto,
			nmro_cntrto, 
			nmro_unco_idntfccn,
			fcha_aflcn_pc	
	From 	#RegistrosClasificarFinal

	Insert into #tmpTablaFechas
	select	nmro_unco_idntfccn_afldo nui,  
			0 nmro_dias,		0 cnsctvo_aux,
			inco_vgnca_tmpo		fecha_ini,
			fn_vgnca_tmpo		fecha_fin,
			convert(datetime,NULL)	fecha_aux,
			convert(datetime,NULL)	fecha_ini_real 	
	From	(Select nmro_unco_idntfccn_afldo,
			inco_vgnca_tmpo,
			fn_vgnca_tmpo
			From   	bdafiliacion.dbo.tbtiemposafiliacion    		
			Where	cnsctvo_cdgo_pln		=	2
			And    	estdo_rgstro			=	'S'
			And	cnsctvo_cdgo_clsfccn_tmpo 	= 	50 
			And	cnsctvo_cdgo_orgn_tmpo 		= 	51 ) tmpAntiguedadByE
	order by nmro_unco_idntfccn_afldo,inco_vgnca_tmpo,  fn_vgnca_tmpo --- Modificacion (fn_vgnca_tmpo) para caso de antiguedad que no estaba tomando
	
	Update  #tmpTablaFechas
	Set		cnsctvo_aux	=	item - 1
	
	update  #tmpTablaFechas
	Set		fecha_aux = tmpFechaIni.fecha_fin
	From	#tmpTablaFechas a 
	Inner Join (Select nui,item,fecha_fin From #tmpTablaFechas) tmpFechaIni
	On	a.cnsctvo_aux   = tmpFechaIni.item 
	And	a.nui		= tmpFechaIni.nui
		
	Update  #tmpTablaFechas
	Set		nmro_dias	=	isnull(DATEDIFF(day, fecha_aux,fecha_ini) ,0)
		
	update	#tmpTablaFechas
	Set		fecha_ini_real	=	tmpFechainif.fecha_ini
	From	#tmpTablaFechas a 
	Inner Join (Select nui, max(fecha_ini)  fecha_ini
				    From   #tmpTablaFechas	 
				    Where nmro_dias >=	30
				    group by nui ) tmpFechainif
	On	a.nui = tmpFechainif.nui
	
	
	Update	#tmpTablaFechas
	Set		fecha_ini_real	=	tmpFechainif.fecha_ini
	From	#tmpTablaFechas a 
	Inner Join (Select nui, min(fecha_ini)  fecha_ini
				From  #tmpTablaFechas	 
			   	where nmro_dias <	30
				and	 fecha_ini_real is null	
				group by nui ) tmpFechainif
	On	a.nui = tmpFechainif.nui
		
	Update  #tmpBeneficiarioPacByE
	Set		fcha_aflcn_pc 	=	b.inco_vgnca_tmpo
	From	#tmpBeneficiarioPacByE a 
	Inner Join (Select  fecha_ini_real  inco_vgnca_tmpo,  nui	nmro_unco_idntfccn_afldo
				from	#tmpTablaFechas
				group by nui, fecha_ini_real) b
	On	a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn_afldo
	
	-- Le  actualiza  la fecha inicio  de vigencia del contrato para poder hacer la evaluacion y contenga la antiguedad
	Update		#RegistrosClasificarFinal
	Set			fcha_aflcn_pc	=	b.fcha_aflcn_pc
	From		#RegistrosClasificarFinal a 
	Inner Join	#tmpBeneficiarioPacByE b
		On   	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
	And			a.nmro_cntrto			=	b.nmro_cntrto
	And			a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	 
	
	Update		#RegistrosClasificarFinal
	Set			inco_vgnca_cntrto =	b.fcha_aflcn_pc
	From		#RegistrosClasificarFinal a 
	Inner Join	#tmpBeneficiarioPacByE b
		On   	a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn
	And			a.nmro_cntrto			=	b.nmro_cntrto
	And			a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	where		a.cnsctvo_cdgo_pln		=	8
	and			a.fcha_aflcn_pc			>=	'20040201'
	and			a.ps_ss					=	'N'
	
	
	--como Hay Registros en tiempos de afiliacion menor o igual ala parametrizacion de inicio de la empresa como fecha inicial
	--19950101 entonces la actualizamos a la fecha inicial de la eps
	
	Update	#RegistrosClasificarFinal
	Set		fcha_aflcn_pc	=	'19950101'
	From	#RegistrosClasificarFinal 
	Where	fcha_aflcn_pc	<=	'19900101'

	--Se calcula si es discapacitado o no 
	update 	#RegistrosClasificarFinal
	Set		Dscpctdo	=	case when (cnsctvo_cdgo_tpo_dscpcdd	=	4	 or cnsctvo_cdgo_tpo_dscpcdd =0) then  'N'	else 'S'	end
	From	#RegistrosClasificarFinal a Inner Join bdafiliacion.dbo.tbafiliados  b
	On 	a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn_afldo
	
	If  @@error <> 0
	Begin 
		
		Return -1
	end
	
	-- se verifica todos los afiliados que tienen antiguedad hcu
	--poliza cajas de compensacion
	update 		#RegistrosClasificarFinal
	Set			Antgdd_hcu	=	'S'
	FROM		bdAfiliacion.dbo.tbAfiliados a 
	INNER JOIN	bdAfiliacion.dbo.tbEntidades_Vigencias b with(nolock)
		ON		a.cnsctvo_cdgo_plza_antrr = b.cnsctvo_cdgo_entdd 
	INNER JOIN  #RegistrosClasificarFinal c 
		ON		a.nmro_unco_idntfccn_afldo = c.nmro_unco_idntfccn
	WHERE		(b.cnsctvo_cdgo_tpo_entdd = 6) 
	AND			(a.cnsctvo_cdgo_plza_antrr = 119) 
	AND			datediff(dd,b.inco_vgnca,@lcfecha_actual)>=0  
	And			datediff(dd,@lcfecha_actual,b.fn_vgnca)>=0
		
	update 		#RegistrosClasificarFinal
	Set			Antgdd_clptra	=	'S' 
	FROM		bdAfiliacion.dbo.tbAfiliados a 
	INNER JOIN  bdAfiliacion.dbo.tbEntidades_Vigencias b with(nolock)
		ON		a.cnsctvo_cdgo_plza_antrr = b.cnsctvo_cdgo_entdd 
	INNER JOIN  #RegistrosClasificarFinal c 
		ON		a.nmro_unco_idntfccn_afldo = c.nmro_unco_idntfccn
	WHERE		(b.cnsctvo_cdgo_tpo_entdd = 6) 
	AND			(a.cnsctvo_cdgo_plza_antrr = 89)  --- EMP 019 - SALUD COLPATRIA S.A. MEDICINA PREPAGADA                                                                                                               
	AND			datediff(dd,b.inco_vgnca,@lcfecha_actual)>=0  
	And			datediff(dd,@lcfecha_actual,b.fn_vgnca)>=0
		
	If  @@error <> 0
	Begin 		
		Return -1
	end
	
	Insert into #tmpHijosConPos
	Select 		b.nmro_unco_idntfccn,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_bnfcro,
				'N' estdnte
	From 		#tmpCantidadContratosPos a 
	Inner Join  #RegistrosClasificarFinal b 
		on 		a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
	Where		b.cnsctvo_cdgo_prntsco	=	4
	And			b.ps_ss			=	'S'
	
	
	Insert into #tmpHijosConPosDiscapacidad
	Select 		b.nmro_unco_idntfccn,
				a.cnsctvo_cdgo_tpo_cntrto,
				a.nmro_cntrto,
				a.cnsctvo_bnfcro,
				'N'	Dscpctdo
	From 		#tmpCantidadContratosPos a 
	Inner Join  #RegistrosClasificarFinal b 
		On 		a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
	Where		b.cnsctvo_cdgo_prntsco	=	4
	And			b.ps_ss			=	'S'
	
	
	---tipo de documento estudiante
	Update		#tmpHijosConPos
	Set			estdnte		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a
	Inner Join	#tmpHijosConPos b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	=	13 
	And			a.estdo_rgstro			=	'S'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  
	And			datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0
	
	---- sisdgb01 24/07/2014 Solicitud :  Tarificación PAC - incluir novedad Decreto 1164  
	Update		#tmpHijosConPos
	Set			estdnte		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a 
	Inner Join	#tmpHijosConPos b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	=	88 --- DECLARACION SUSCRITA DE PADRES-ACREDITACION CONDICION BENF ESTUDIANTE Y DEP ECONOMICA-
	And			a.estdo_rgstro				=	'S'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  
	And			datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0
	
	
	/*
	Quick:			2015-00001-000022182 
	Fecha:			2015-07-31
	Por:			Francisco Javier Gonzalez Ruano
	Descripcion:	Se ajusta el proceso de tarificación PAC, para que a los beneficiarios entre 18 y 25 años, no les verifique su condicion
					de documento (certificado de estudio y/ó declaración suscrita de padres sobre dependencia economica), de acuerdo Ley 1753
					del 2015   del plan Nacional de desarrollo Art 218 Literal C.															
	*/
	 
	 -- Segun decreto, ahora si tiene entre 18 y 25 años hace parte del grupo basico, no importando si esta estudiando o no estudia.
	
	Update		a
	Set			estdnte		=	'S'
	from 		#tmpHijosConPos a
	Inner Join	#RegistrosClasificarFinal b		
		On		b.nmro_unco_idntfccn = a.nmro_unco_idntfccn
	Where		b.edd_bnfcro	BetWeen 18 And 25
		
	-- Fin Quick 2015-00001-000022182
		
	Update		#RegistrosClasificarFinal
	Set			estdnte			=	b.estdnte
	From		#RegistrosClasificarFinal a 
	Inner Join  #tmpHijosConPos b
		On 		a.nmro_unco_idntfccn	= b.nmro_unco_idntfccn
	Where		b.estdnte		=	'S'
	
	--Si tiene documento de discapacida en pos
	Update		#tmpHijosConPosDiscapacidad
	Set			Dscpctdo		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a 
	Inner Join	#tmpHijosConPosDiscapacidad b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	in (15,29) 
	And			a.estdo_rgstro			=	'S'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  And datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0 -- que sea el siguiente del periodo a evaluar
	
	Update		#RegistrosClasificarFinal
	Set			Dscpctdo		=	b.Dscpctdo
	From		#RegistrosClasificarFinal a 
	Inner Join  #tmpHijosConPosDiscapacidad b
		On 		a.nmro_unco_idntfccn	=	b.nmro_unco_idntfccn
	Where		b.Dscpctdo		=	'S'
	
	
	--Actualiza si tiene certificado de discapacidad en pac
	Update		#RegistrosClasificarFinal
	Set			Dscpctdo		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a 
	Inner Join	#RegistrosClasificarFinal b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	in	(15,29)
	And			a.estdo_rgstro			=	'S'
	And			b.Dscpctdo			=	'N'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  And datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0 -- que sea el siguiente del periodo a evaluar
	
	--Actualiza si tiene certificado de estudios
	---tipo de documento estudiante
	Update		#RegistrosClasificarFinal
	Set			Estdnte		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a 
	Inner Join	#RegistrosClasificarFinal b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	=	13 
	And			a.estdo_rgstro			=	'S'
	And			b.estdnte				=	'N'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  And datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0 -- que sea el siguiente del periodo a evaluar
	
	If  @@error <> 0
	Begin 
		
		Return -1
	end
		
	---- sisdgb01 24/07/2014 Solicitud :  Tarificación PAC - incluir novedad Decreto 1164  
	Update		#RegistrosClasificarFinal
	Set			Estdnte		=	'S'
	from 		bdafiliacion.dbo.tbDocumentossoportesxafiliado a 
	Inner Join	#RegistrosClasificarFinal b
		On 		a.nmro_unco_idntfccn_bnfcro	=	b.nmro_unco_idntfccn
	Where		a.cnsctvo_cdgo_tpo_dcmnto	=	88  --- DECLARACION SUSCRITA DE PADRES-ACREDITACION CONDICION BENF ESTUDIANTE Y DEP ECONOMICA-
	And			a.estdo_rgstro			=	'S'
	And			b.estdnte				=	'N'
	And			datediff(dd,a.inco_vgnca_dcmnto,@lcfecha_actual)>=0  And datediff(dd,@lcfecha_actual,a.fn_vgnca_dcmnto)>=0 -- que sea el siguiente del periodo a evaluar
		
	If  @@error <> 0
	Begin 
		
		Return -1
	end
		
	--para poder  actualizar si pertenece al grupos basico
	--se debe traer  los contratos familiar o quimbaya
	Insert into	#tmpcontratosFamiliarQuimbaya
	select		a.cnsctvo_cdgo_tpo_cntrto,a.nmro_cntrto,d.nmro_unco_idntfccn,a.cnsctvo_cdgo_pln, 0 cantidad_beneficiarios, 0 cantidad_beneficiariosCeH
	FROM		bdAfiliacion.dbo.tbContratos a with(nolock)
	INNER JOIN	bdAfiliacion.dbo.tbCobranzas b with(nolock)
		ON 		a.cnsctvo_cdgo_tpo_cntrto 	= b.cnsctvo_cdgo_tpo_cntrto 
		AND 	a.nmro_cntrto 			= b.nmro_cntrto 
	INNER JOIN	bdAfiliacion.dbo.tbVigenciasCobranzas c with(nolock)
		ON 		b.cnsctvo_cdgo_tpo_cntrto 	= c.cnsctvo_cdgo_tpo_cntrto 
		AND 	b.nmro_cntrto 			= c.nmro_cntrto 
		AND 	b.cnsctvo_cbrnza 		= c.cnsctvo_cbrnza 
	INNER JOIN 	#RegistrosClasificarFinal d 
		ON 		a.nmro_unco_idntfccn_afldo 	= d.nmro_unco_idntfccn
	WHERE		(d.cnsctvo_cdgo_prntsco 	= 1) 
	AND     	datediff(dd,a.inco_vgnca_cntrto,@ldFecha_Corte_Prdo)>=0  And datediff(dd,@ldFecha_Corte_Prdo,a.fn_vgnca_cntrto)>=0 -- que sea el siguiente del periodo a evaluar
	AND 		(a.estdo_cntrto 		= 'A') 
	AND     	datediff(dd,c.inco_vgnca_cbrnza,@ldFecha_Corte_Prdo)>=0  And datediff(dd,@ldFecha_Corte_Prdo,c.fn_vgnca_cbrnza)>=0 
	AND 		(a.cnsctvo_cdgo_tpo_cntrto 	= 2) 
	AND 		(a.cnsctvo_cdgo_pln = 2 OR a.cnsctvo_cdgo_pln = 6)
	GROUP BY a.cnsctvo_cdgo_tpo_cntrto, a.nmro_cntrto, d.nmro_unco_idntfccn, a.cnsctvo_cdgo_pln
	--aqui estdo
	
	If  @@error <> 0
	Begin 
		
		Return -1
	end
		
	--se trae la cantidad de beneficiarios que hay para esos contratos quimbaya o familiar
	Insert into #tmpCantidadBeneficiarios
	Select		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto, count (cnsctvo_bnfcro) cantidad_beneficiarios
	From 		bdafiliacion.dbo.tbBeneficiarios a 
	Inner Join  #tmpcontratosFamiliarQuimbaya b
		On		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And	a.nmro_cntrto			=	b.nmro_cntrto
	Where 	a.estdo				=	'A'
	And    	datediff(dd,a.inco_vgnca_bnfcro,@ldFecha_Corte_Prdo)>=0  And datediff(dd,@ldFecha_Corte_Prdo,a.fn_vgnca_bnfcro)>=0  -- que sea el siguiente del periodo a evaluar
	And		a.cnsctvo_cdgo_prntsco	 in (1,2,3,4,5)
	group by a.cnsctvo_cdgo_tpo_cntrto,a.nmro_cntrto 
		
	--- Solo conyugue e hijos
	
	Insert into #tmpCantidadBeneficiariosCeH
	Select		a.cnsctvo_cdgo_tpo_cntrto,	a.nmro_cntrto, count (cnsctvo_bnfcro) cantidad_beneficiarios
	From 		bdafiliacion.dbo.tbBeneficiarios a with(nolock)
	Inner Join  #tmpcontratosFamiliarQuimbaya b
		On		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
	Where 		a.estdo				=	'A'
	And    		datediff(dd,a.inco_vgnca_bnfcro,@ldFecha_Corte_Prdo)>=0  And datediff(dd,@ldFecha_Corte_Prdo,a.fn_vgnca_bnfcro)>=0  -- que sea el siguiente del periodo a evaluar
	And			a.cnsctvo_cdgo_prntsco	 in (1,2,3,4)
	group by a.cnsctvo_cdgo_tpo_cntrto,a.nmro_cntrto 
	
	--aqui estdo
	
	If  @@error <> 0
	Begin 
		Return -1
	end
		
	--Se actualiza la cantidad de beneficiarios que hay para esos contratos
	
	update		#tmpcontratosFamiliarQuimbaya
	Set			cantidad_beneficiarios		=	b.cantidad_beneficiarios
	From		#tmpcontratosFamiliarQuimbaya a 
	Inner Join	#tmpCantidadBeneficiarios b
		On		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And			a.nmro_cntrto			=	b.nmro_cntrto
	
	update		#tmpcontratosFamiliarQuimbaya
	Set			cantidad_beneficiariosCeH		=	b.cantidad_beneficiariosCeH
	From		#tmpcontratosFamiliarQuimbaya a 
	Inner Join	#tmpCantidadBeneficiariosCeH b
		On		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
	And			a.nmro_cntrto			=	b.nmro_cntrto
	
	If  @@error <> 0
	Begin 
		Return -1
	end
		
	--Se actualiza si pertenece al grupos basico
	update  #RegistrosClasificarFinal
	Set		grpo_bsco			=	'S'
	From	#RegistrosClasificarFinal a 
	Inner Join 	(select cnsctvo_cdgo_pln ,nmro_unco_idntfccn, sum(cantidad_beneficiarios) cantidad_por_plan
				From	#tmpcontratosFamiliarQuimbaya 
				group by cnsctvo_cdgo_pln ,nmro_unco_idntfccn )	TmpCantidadXPlan -- se calcula la cantidad de beneficarios por plan para cada contrato
		On 	a.nmro_unco_idntfccn			=	TmpCantidadXPlan.nmro_unco_idntfccn
	And		a.cnsctvo_cdgo_pln			=	TmpCantidadXPlan.cnsctvo_cdgo_pln
	Where	TmpCantidadXPlan.cantidad_por_plan	>  1 
	
	--- Si tiene conyugue e hijos
	update  #RegistrosClasificarFinal
	Set		Tne_hjos_cnyge_cmpnra			=	'S'
	From	#RegistrosClasificarFinal a 
	Inner Join 	(select cnsctvo_cdgo_pln ,nmro_unco_idntfccn, sum(cantidad_beneficiariosCeH) cantidad_por_plan
				From	#tmpcontratosFamiliarQuimbaya 
				group by cnsctvo_cdgo_pln ,nmro_unco_idntfccn ) 	TmpCantidadXPlan -- se calcula la cantidad de beneficarios por plan para cada contrato
		On 	a.nmro_unco_idntfccn			=	TmpCantidadXPlan.nmro_unco_idntfccn
	And		a.cnsctvo_cdgo_pln			=	TmpCantidadXPlan.cnsctvo_cdgo_pln
	Where	TmpCantidadXPlan.cantidad_por_plan	> =1 
	
	If  @@error <> 0
	Begin 
		Return -1
	end
	
	---Actualiza el campo autotizado sin pos
	
	update		#RegistrosClasificarFinal
	Set			atrzdo_sn_Ps			=	'S'
	From		#RegistrosClasificarFinal a 
	Inner Join	bdafiliacion.dbo.tbConceptosPendientesxBeneficiario b with(nolock)
		On 		a.nmro_unco_idntfccn		=	b.nmro_unco_idntfccn_bnfcro
		And		a.cnsctvo_bnfcro		=	b.cnsctvo_bnfcro
		And		a.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
		And		a.nmro_cntrto			=	b.nmro_cntrto
	Where		b.cnsctvo_cdgo_cncpto_espra	=	3	-- BENEFICIARIOS PAC SIN POS 
	And    		datediff(dd,b.inco_vgnca_espra,@ldFecha_Corte_Prdo)>=0  And datediff(dd,@ldFecha_Corte_Prdo,b.fn_vgnca_espra)>=0
	
	
	If  @@error <> 0
	Begin 		
		Return -1
	end

end

