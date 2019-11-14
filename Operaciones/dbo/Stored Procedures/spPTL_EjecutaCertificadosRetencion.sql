
/*--------------------------------------------------------------------------------- 
* Metodo o PRG 		: [spPTL_EjecutaCertificadosRetencion] 
* Desarrollado por		: <\A Ing. Diana Lorena Gomez									A\> 
* Descripcion			: <\D Este procedimiento se desarrolló para generar el certificado de retención desde el portal transaccional de SOS				 	D\> 
* Observaciones			: <\O  													O\> 
* Parametros			: <\P													P\> 
* Variables			: <\V  													V\> 
* Fecha Creacion		: <\FC 2015/05/26											FC\> 
* 
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		 : <\AM Ing. Warner Fernando Valencia -SEIT Consultores AM\>
* Descripcion			 : <\DM Modificación para incluir en el resultado los usuarios que solo son contratantes de un 
								plan PAC los cuales no son beneficiarios del mismo DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2015/07/30	FM\>
*---------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------- 
* Modificado Por		 : <\AM Ing. Diana Lorena Gomez AM\>
* Descripcion			 : <\DM Se corrige caso reportado en producción para la consulta de certificado de rte fuente para un 
	 trabajador que es responsable de pago del plan , no es beneficiario dentro del plan y es trabajador dependiente 
	 se evidencia que se debe generar el certificado. Se agrega dentro de la consulta de empleadores DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2016/09/13	FM\>
*---------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------- 
* Modificado Por		 : <\AM Ing. Diana Lorena Gomez AM\>
* Descripcion			 : <\DM Se ajusta para que el filtro por nui del cotizante solo aplique para los independientes o los dependientes que consultan a traves de la opcion de afiliados fase I DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2017/01/03	FM\>
* --------------------------------------------------------------------------------- 
* --------------------------------------------------------------------------------- 
* Modificado Por		 : <\AM Ing. Warner Fernando Valencia -SEIT Consultores AM\>
* Descripcion			 : <\DM Se ajusta para que cuando el afiliado en un mismo periodo es independiente 
								y dependiente salgan los registros de estos  
						    DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2018/04/26	FM\>
* --------------------------------------------------------------------------------- 
* --------------------------------------------------------------------------------- 
* Modificado Por		 : <\AM Ing. Warner Fernando Valencia -SEIT Consultores AM\>
* Descripcion			 : <\DM Se ajusta el SP alterando la tabla temporal (#tmpbeneficiariosXabonosFinal) adicionando dos nuevos campos
								nmro_unco_idntfccn_afldo, cnsctvo_cdgo_tpo_idntfccn, ya que estos fueron adicionados al SP spEjecutaConsCertificadosRetencion
						    DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2018/08/26	FM\>
* --------------------------------------------------------------------------------- 
* --------------------------------------------------------------------------------- 
* Modificado Por		 : <\AM Ing. Warner Fernando Valencia -SEIT Consultores AM\>
* Descripcion			 : <\DM Se reemplaza la forma como se crea la tabla temporal #tmpLiquidacionesFinalizadas cambiando el SELECT INTO por
								CREATE TABLE 
								Se reorganiza el procedimiento subiendo el CREATE TABLE de (#tmpbeneficiariosXabonosFinal,#tmpLiquidacionesFinalizadas
								,#tbCriteriosTmp,#tbCriteriosTmpPTL y #tbEmpleadoresCriterios) se coloca despues del DECLARE

						    DM\>
* Nuevos Parametros	 	 : <\PM   PM\>
* Nuevas Variables		 : <\VM   VM\>
* Fecha Modificacion	 : <\FM	2019/03/23	FM\>
*---------------------------------------------------------------------------------*/
/*
exec spPTL_EjecutaCertificadosRetencion 32718730 ,'2015' --contratante/beneficiario
exec spPTL_EjecutaCertificadosRetencion 31856133 ,'2015' --contratante
*/

CREATE PROCEDURE [dbo].[spPTL_EjecutaCertificadosRetencion]  
	 @nmro_unco_idntfccn_ctznte int , --- Nui enviado desde el portal
	@fcha_cnslta varchar(4), --- Año gravable para consultar el certificado de retención
	@nmro_unco_idntfccn_empldr	Int	=	NULL


AS
	SET XACT_ABORT ON

	SET NOCOUNT ON

BEGIN
		declare
		@Fcha_incl	Datetime, 
		@Fcha_fnl		Datetime,
		@cdgo_tpo_idntfccn_ctznte varchar(3),
		@nmro_idntfccn_ctznte varchar(23),
		@cdgo_tpo_idntfccn_empldr varchar(3),
		@nmro_idntfccn_empldr varchar(23),
		@nuiResponsablePago int,
		@MarcaClaseAportante int,
		@ejcta_crtfcdo			Int,
		@cont int,
		@max int,
		@responsablePagoPlan varchar(20)

		
		CREATE TABLE #tmpbeneficiariosXabonosFinal(
			[nmro_rdcn] [int]  NULL,
			[TI_coti] [varchar](3) NULL,
			[NI_coti] [varchar](15) NULL,
			[nombre_Coti] [varchar](100) NULL,
			[Fecha_ini] datetime NULL,
			[Fecha_fin] datetime NULL,
			[Valor_total_plan] [int] NULL,
			[TI_bene] [varchar](3) NULL,
			[NI_bene] [varchar](15) NULL,
			[nombre_bene] [varchar](100) NULL,
			[dscrpcn_prntsco] [varchar](30) NULL,
			[dscrpcn_pln] [varchar](30) NULL,
			[cnsctvo_cdgo_pln] [int]  NULL,
			[AfiliadoPlan] [varchar](22) NULL,
			responsablePagoPlan varchar(20) null,
			nmro_unco_idntfccn_afldo udtConsecutivo null,
			cnsctvo_cdgo_tpo_idntfccn udtConsecutivo)

		CREATE TABLE #tmpLiquidacionesFinalizadas  (
			cnsctvo_cdgo_lqdcn udtConsecutivo,
			cnsctvo_cdgo_prdo_lqdcn  udtConsecutivo,
			fcha_crcn datetime NULL,
			fcha_fnl_prdo_lqdcn datetime NULL,
		)
		 --- Se crea la tabla de criterios que requiere el procedimiento que genera el certificado
		CREATE TABLE #tbCriteriosTmp
				(cdgo_cmpo Char(128),
				 oprdr Char(2),
				 vlr Char(250),
				 cmpo_rlcn Char(128),
				 cmpo_rlcn_prmtro Char(128),
				 tbla Char(128) )

		 --- Se crea la tabla de criterios que requiere el procedimiento que genera el certificado
		CREATE TABLE #tbCriteriosTmpPTL
				(cdgo_cmpo Char(128),
				 oprdr Char(2),
				 vlr Char(250),
				 cmpo_rlcn Char(128),
				 cmpo_rlcn_prmtro Char(128),
				 tbla Char(128) )

			Create table #tbEmpleadoresCriterios(
				nmro_unco_idntfccn_empldr int,
				cdgo_tpo_idntfccn_empldr varchar(3),
				nmro_idntfccn_empldr	 varchar(23) ,
				cnsctvo_cdgo_clse_aprtnte	int
			)



		Set	@ejcta_crtfcdo	=	0
																																																					If	@nmro_unco_idntfccn_empldr Is Not Null
		Begin
			If	(	Select Top 1 1
					From		BDAfiliacion.dbo.tbBeneficiarios	b	With(NoLock)
					Inner Join	BDAfiliacion.dbo.tbContratos		c	With(NoLock)	On	c.cnsctvo_cdgo_tpo_cntrto	=	b.cnsctvo_cdgo_tpo_cntrto
																						And	c.nmro_cntrto				=	b.nmro_cntrto
					Inner Join	BDAfiliacion.dbo.tbCobranzas		co	With(NoLock)	On	co.cnsctvo_cdgo_tpo_cntrto	=	c.cnsctvo_cdgo_tpo_cntrto
																						And	co.nmro_cntrto				=	c.nmro_cntrto
					Where		b.nmro_unco_idntfccn_bnfcro		=	@nmro_unco_idntfccn_ctznte
					And			co.nmro_unco_idntfccn_aprtnte	=	@nmro_unco_idntfccn_empldr
					And			GETDATE() Between c.inco_vgnca_cntrto and c.fn_vgnca_cntrto
					And			c.estdo_cntrto	= 'A'
					And			co.estdo		= 'A'
						)	> 0
						Begin
							Set	@ejcta_crtfcdo	=	1
						End
					Else
						Begin
							Set	@ejcta_crtfcdo	=	0
						End
		End
	Else
		Begin
			Set	@ejcta_crtfcdo	=	1
		End

		---- Se consulta Tipo y Numero de identificacion del afiliado
		Select	@cdgo_tpo_idntfccn_ctznte = ti.cdgo_tpo_idntfccn , @nmro_idntfccn_ctznte = v.nmro_idntfccn
		from	bdafiliacion.dbo.tbVinculados v With(NoLock) Inner Join bdafiliacion.dbo.tbTiposIdentificacion ti With(NoLock)
		On v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
		Where	v.nmro_unco_idntfccn = @nmro_unco_idntfccn_ctznte 	
		And		v.vldo							= 'S'


		If	@ejcta_crtfcdo	=	1
			Begin

		--- Se inserta la fecha inicial del año gravable agregando el primer dia del primer mes del año 
		Insert into #tbCriteriosTmp
		(cdgo_cmpo ,
		 cmpo_rlcn,
		 oprdr,
		 vlr)
		Values
		('fcha_crcn',
		'fcha_crcn',
		  '>=' ,
		ltrim(Rtrim(@fcha_cnslta)) + '0101' 
		)

		--- Se inserta la fecha final del año gravable agregando el ultimo dia del ultimo mes del año 
		Insert into #tbCriteriosTmp
		(cdgo_cmpo,
		 cmpo_rlcn,
		 oprdr,
		 vlr)
		Values
		('fcha_crcn',
		 'fcha_crcn',
		 '<='  ,
		ltrim(Rtrim(@fcha_cnslta)) + '1231' 
		)

		--- Se inserta  el nui del cotizante
		Insert into #tbCriteriosTmp
		(cdgo_cmpo,
		 cmpo_rlcn,
		 oprdr,
		 vlr)
		Values
		('nmro_unco_idntfccn_ctznte',
		'nmro_unco_idntfccn_ctznte',
		  '=' ,
		@nmro_unco_idntfccn_ctznte
		)


		--- Se requiere calcular cual fue el último responsable de pago para el afiliado por este motivo se consulta en la base de facturacion para el año gravable consultado
		Select  @Fcha_incl  	=	vlr+' 00:00:00'  
		From 	 #tbCriteriosTmp 
		Where 	 cmpo_rlcn 		= 	'fcha_crcn'  
		And	     oprdr	           	= 	'>=' 
 
 
		Select  @Fcha_fnl 	=	vlr+' 23:59:59'  
		From 	#tbCriteriosTmp 
		Where 	cmpo_rlcn 		= 	'fcha_crcn'  
		And	oprdr	    		= 	'<=' 

		---- Se consultan todas las liquidaciones en estado finalizado para el año gravable
		INSERT INTO #tmpLiquidacionesFinalizadas  (
			 fcha_crcn				,cnsctvo_cdgo_prdo_lqdcn
			 ,cnsctvo_cdgo_lqdcn	,fcha_fnl_prdo_lqdcn 
		)
		select  a.fcha_incl_prdo_lqdcn 	fcha_crcn,	b.cnsctvo_cdgo_prdo_lqdcn, 
				cnsctvo_cdgo_lqdcn,					a.fcha_fnl_prdo_lqdcn 
		from 	tbperiodosliquidacion_vigencias a With(NoLock), tbliquidaciones b  With(NoLock)
		Where	a.cnsctvo_cdgo_prdo_lqdcn	=	b.cnsctvo_cdgo_prdo_lqdcn 
		And		b.cnsctvo_cdgo_estdo_lqdcn	=	3 
		And		a.fcha_incl_prdo_lqdcn between @Fcha_incl and @Fcha_fnl		 
      
 		 

		--Consultar el último responsable de pago para el afiliado a la fecha de consulta

		 /*20150609 consultar los empeladores asociadoa al afiliado*/
		 Insert #tbEmpleadoresCriterios(nmro_unco_idntfccn_empldr,cnsctvo_cdgo_clse_aprtnte)
		SELECT   distinct c.nmro_unco_idntfccn_empldr, c.cnsctvo_cdgo_clse_aprtnte
		FROM	#tmpLiquidacionesFinalizadas b Inner Join dbo.tbEstadosCuenta c
					On 	  b.cnsctvo_cdgo_lqdcn	  	= 	c.cnsctvo_cdgo_lqdcn		
				Inner Join      	  Tbestadoscuentacontratos   		d With(NoLock)
					On 	 c.cnsctvo_estdo_cnta		=	d.cnsctvo_estdo_cnta 
				Inner Join  	  tbCuentasContratosBeneficiarios	f With(NoLock)
					On d.cnsctvo_estdo_cnta_cntrto	=	f.cnsctvo_estdo_cnta_cntrto
				left outer join      	  Tbabonoscontrato  			e With(NoLock)
					On d.cnsctvo_estdo_cnta_cntrto	=	e.cnsctvo_estdo_cnta_cntrto 
		Where	f.nmro_unco_idntfccn_bnfcro			=  @nmro_unco_idntfccn_ctznte
		and		c.cnsctvo_cdgo_estdo_estdo_cnta		!= 4

		/*20150609 Obtener los datos del empleador*/


			/*Para este caso si la persona no es beneficiaro del plan complementario se consulta si la persona es la contratante y 
			paga como independiente, lo que se me ocurrió fue algo de esta manera 2015-07-30 */

			declare @CantidadEmpleadores int
			select @CantidadEmpleadores = count(*) from #tbEmpleadoresCriterios

 
			If @CantidadEmpleadores = 0 --2121210
			begin
	 
					 Insert #tbEmpleadoresCriterios(nmro_unco_idntfccn_empldr,cnsctvo_cdgo_clse_aprtnte)
					SELECT   distinct c.nmro_unco_idntfccn_empldr, c.cnsctvo_cdgo_clse_aprtnte
					FROM       #tmpLiquidacionesFinalizadas b With(NoLock) Inner Join dbo.tbEstadosCuenta c With(NoLock)
							   On  b.cnsctvo_cdgo_lqdcn = c.cnsctvo_cdgo_lqdcn
							   Inner Join Tbestadoscuentacontratos d With(NoLock)
							   On c.cnsctvo_estdo_cnta =d.cnsctvo_estdo_cnta
							   Inner Join tbCuentasContratosBeneficiarios f With(NoLock)
							   On d.cnsctvo_estdo_cnta_cntrto = f.cnsctvo_estdo_cnta_cntrto
							   left outer join  Tbabonoscontrato e With(NoLock)
							   On d.cnsctvo_estdo_cnta_cntrto = e.cnsctvo_estdo_cnta_cntrto
					Where        c.nmro_unco_idntfccn_empldr =@nmro_unco_idntfccn_ctznte
								and c.cnsctvo_cdgo_estdo_estdo_cnta != 4
								and     c.cnsctvo_cdgo_clse_aprtnte in (1,4) --Empleador, Independiente
			end
			/* 2015-07-30 usuarios que solo son contratantes*/
	
			/* 	13/09/2016 sisdgb01 Se corrige caso reportado en producción para la consulta de certificado de rte fuente para un 
			 trabajador que es responsable de pago del plan , no es beneficiario dentro del plan y es trabajador dependiente 
			 se evidencia que se debe generar el certificado.
			*/

		  select @CantidadEmpleadores = count(*) from #tbEmpleadoresCriterios
  
		 -- select * from  #tbEmpleadoresCriterios
			If @CantidadEmpleadores = 0
			 begin 
					   --Insert #tbEmpleadoresCriterios(nmro_unco_idntfccn_empldr, cnsctvo_cdgo_clse_aprtnte)
					   SELECT   distinct c.nmro_unco_idntfccn_empldr , c.cnsctvo_cdgo_clse_aprtnte
					   FROM       #tmpLiquidacionesFinalizadas b With(NoLock) Inner Join dbo.tbEstadosCuenta c With(NoLock) 
					   On  b.cnsctvo_cdgo_lqdcn = c.cnsctvo_cdgo_lqdcn
					   Inner Join Tbestadoscuentacontratos d With(NoLock) 
					   On c.cnsctvo_estdo_cnta =d.cnsctvo_estdo_cnta
					   Inner join bdafiliacion.dbo.tbContratos ct With(NoLock) 
					   on d.nmro_cntrto = ct.nmro_cntrto
					   and d.cnsctvo_cdgo_tpo_cntrto = ct.cnsctvo_cdgo_tpo_cntrto
					   Inner Join tbCuentasContratosBeneficiarios f With(NoLock) 
					   On d.cnsctvo_estdo_cnta_cntrto = f.cnsctvo_estdo_cnta_cntrto
					   left outer join  Tbabonoscontrato e With(NoLock) 
					   On d.cnsctvo_estdo_cnta_cntrto = e.cnsctvo_estdo_cnta_cntrto
					   Where        ct.nmro_unco_idntfccn_afldo =@nmro_unco_idntfccn_ctznte --- Nui Contratante
						and c.cnsctvo_cdgo_estdo_estdo_cnta != 4
						and     c.cnsctvo_cdgo_clse_aprtnte = 1 -- Dependiente
			   end

		 --select * from  #tbEmpleadoresCriterios

		select @MarcaClaseAportante = max(cnsctvo_cdgo_clse_aprtnte) from #tbEmpleadoresCriterios
		select @nuiResponsablePago = max(nmro_unco_idntfccn_empldr) from #tbEmpleadoresCriterios


		if @MarcaClaseAportante = 4 
		begin

		--- Dentro del procedimiento que genera el certificado se esta leyendo el tipo y numero de identificacion del cotizante de acuerdo al parametro cmpo_rlcn_prmtro = 'nmro_unco_idntfccn_ctznte'

		Insert into #tbCriteriosTmp
		(cdgo_cmpo,
		 cmpo_rlcn,
		 cmpo_rlcn_prmtro,
		 oprdr,
		 vlr)
		Values
		('nmro_unco_idntfccn_ctznte',
		 'nmro_unco_idntfccn_ctznte',
		 'nmro_unco_idntfccn_ctznte',
		 '='  ,
		ltrim(Rtrim(@cdgo_tpo_idntfccn_ctznte))  
		)

		--- Dentro del procedimiento que genera el certificado se esta leyendo el tipo y numero de identificacion del cotizante de acuerdo al parametro cmpo_rlcn_prmtro = 'nmro_unco_idntfccn_ctznte'

		Insert into #tbCriteriosTmp
		(cdgo_cmpo,
		 cmpo_rlcn,
		 cmpo_rlcn_prmtro,
		 oprdr,
		 vlr)
		Values
		('nmro_unco_idntfccn_ctznte',
		 'nmro_unco_idntfccn_ctznte',
		 'nmro_unco_idntfccn_ctznte',
		 '='  ,
		ltrim(Rtrim(@nmro_idntfccn_ctznte))  
		)
		end

		IF @MarcaClaseAportante = 1 AND @nuiResponsablePago != @nmro_unco_idntfccn_ctznte
		BEGIN
				--- Dentro del procedimiento que genera el certificado se esta leyendo el tipo y numero de identificacion del cotizante de acuerdo al parametro cmpo_rlcn_prmtro = 'nmro_unco_idntfccn_ctznte'

				Insert into #tbCriteriosTmp
				(cdgo_cmpo,
				 cmpo_rlcn,
				 cmpo_rlcn_prmtro,
				 oprdr,
				 vlr)
				Values
				('nmro_unco_idntfccn_ctznte',
				 'nmro_unco_idntfccn_ctznte',
				 'nmro_unco_idntfccn_ctznte',
				 '='  ,
				ltrim(Rtrim(@cdgo_tpo_idntfccn_ctznte))  
				)

				--- Dentro del procedimiento que genera el certificado se esta leyendo el tipo y numero de identificacion del cotizante de acuerdo al parametro cmpo_rlcn_prmtro = 'nmro_unco_idntfccn_ctznte'

				Insert into #tbCriteriosTmp
				(cdgo_cmpo,
				 cmpo_rlcn,
				 cmpo_rlcn_prmtro,
				 oprdr,
				 vlr)
				Values
				('nmro_unco_idntfccn_ctznte',
				 'nmro_unco_idntfccn_ctznte',
				 'nmro_unco_idntfccn_ctznte',
				 '='  ,
				ltrim(Rtrim(@nmro_idntfccn_ctznte))  
				)
		END


		update #tbEmpleadoresCriterios
		Set		cdgo_tpo_idntfccn_empldr = ti.cdgo_tpo_idntfccn, 
				nmro_idntfccn_empldr	 =v.nmro_idntfccn
		from #tbEmpleadoresCriterios c With(NoLock)  inner join bdafiliacion.dbo.tbVinculados v With(NoLock) 
		on v.nmro_unco_idntfccn= c.nmro_unco_idntfccn_empldr
		inner join bdafiliacion.dbo.tbTiposIdentificacion ti With(NoLock) 
		On v.cnsctvo_cdgo_tpo_idntfccn = ti.cnsctvo_cdgo_tpo_idntfccn
		where		v.vldo= 'S'

		-- tabla temporal para el manejo de los crierios 
 		Insert Into #tbCriteriosTmpPTL 
		select * from #tbCriteriosTmp                                                                                                                                                                                                                                         
 
		 Alter table  #tbEmpleadoresCriterios add id int identity(1,1)
 		 set  @cont =1
		 select @max = max(id) from #tbEmpleadoresCriterios
 		 while @cont<=@max
		 Begin
	  			
				Select @responsablePagoPlan=  ltrim(rtrim(nmro_idntfccn_empldr))
				from #tbEmpleadoresCriterios
				where id = @cont

				Insert into #tbCriteriosTmpPTL (cdgo_cmpo	,cmpo_rlcn	,oprdr	,vlr)
				Select 'cdgo_tpo_idntfccn'	,'cdgo_tpo_idntfccn'	,'='	,ltrim(rtrim(cdgo_tpo_idntfccn_empldr))
				from #tbEmpleadoresCriterios
				where id = @cont

				Insert into #tbCriteriosTmpPTL (cdgo_cmpo	,cmpo_rlcn	,oprdr	,vlr)
				Select 'nmro_idntfccn'	,'nmro_idntfccn'	,'='	,ltrim(rtrim(nmro_idntfccn_empldr))
				from #tbEmpleadoresCriterios
				where id = @cont
	   
				Delete  from #tbCriteriosTmp 
				Insert Into #tbCriteriosTmp 
				select * from #tbCriteriosTmpPTL
	  
			  -- Inserta en la tabla el resultado del SP 
			  Insert into #tmpbeneficiariosXabonosFinal
			  (	nmro_rdcn			,TI_coti		,NI_coti				,nombre_Coti
				,Fecha_ini			,Fecha_fin		,Valor_total_plan		,TI_bene
				,NI_bene			,nombre_bene	,dscrpcn_prntsco		,dscrpcn_pln
				,cnsctvo_cdgo_pln	,AfiliadoPlan	,nmro_unco_idntfccn_afldo,	cnsctvo_cdgo_tpo_idntfccn 
			  )
			 exec bdcarterapac.dbo.[spEjecutaConsCertificadosRetencion]
			 -- Se actualiza el responsable de pago de ese periodo
			update #tmpbeneficiariosXabonosFinal
					set responsablePagoPlan=@responsablePagoPlan
			Where responsablePagoPlan is null
			set @cont =@cont +1
		 End
  
 
			Select		 *
			From		#tmpbeneficiariosXabonosFinal	With(NoLock)

			Drop Table	#tbCriteriosTmp
			Drop Table	#tbEmpleadoresCriterios
		End
			Else
				Begin
					Select		  *
					From		#tmpbeneficiariosXabonosFinal	With(NoLock)
				End

			Drop Table	#tmpbeneficiariosXabonosFinal
			Drop Table #tmpLiquidacionesFinalizadas
			Drop Table  #tbCriteriosTmpPTL
End
