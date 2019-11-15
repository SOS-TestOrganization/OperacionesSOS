/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerEstadosCuentaManual
* Desarrollado por		: <\A Ing. Maria Liliana Prieto  										A\>
* Descripcion			: <\D Este procedimiento realiza una busqueda de los estados de cuenta manuales			  	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P  Numero del estado de cuenta									P\>
				  <\P estado del estado cuenta	 									P\>
				  <\P Fecha Creacion											P\>
				  <\P Descripcion											P\>
				  <\P Digito Verficacion			 								P\>
				  <\P Numero Unico de Identificacion 	 								P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  Rolando Simbaqueva LassoAM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  2002/09/10	 FM\>
*---------------------------------------------------------------------------------*/

CREATE PROCEDURE spTraerEstadosCuentaManual

	@lcNumeroEstadoCuenta		Varchar(15)			= NULL,
	@lnEstadoEstadoCuenta			udtConsecutivo			= NULL,
	@ldFechaReferencia			Datetime			= NULL,
	@lcUsuario				udtusuario			= NULL

As	Declare

@Instruccion			Nvarchar(4000),
@Parametros			Nvarchar(1000),
@lcJoin				NVarchar(1000),
@lcCadena1			NVarchar(1000)

Set Nocount On
Select @Instruccion	=  	'Select   a.nmro_estdo_cnta,
					b.cdgo_tpo_idntfccn,
					a.nmro_idntfccn_rspnsble_pgo ,
					c.dscrpcn_clse_aprtnte,
					a.nmbre_scrsl,
					a.nmbre_empldr,
					a.ttl_pgr,
					g.dscrpcn_estdo_estdo_cnta,
					a.fcha_incl_fctrcn,
					a.fcha_fnl_fctrcn,
					convert(char(20),replace(convert(char(20),a.fcha_crcn,120), ' +   Char(39) + '-' + char(39) + ','   + Char(39) + '/' + Char(39) + ' )) fcha_crcn_hra,  
					a.usro_crcn,
					 '   +   Char(39) + ' NO SELECCIONADO' +  Char(39) + ' accn ,  ' + char(13)  + '
					a.fcha_lmte_pgo,
					a.nmro_unco_idntfccn_empldr,
					a.cnsctvo_scrsl,
					a.cnsctvo_cdgo_clse_aprtnte,
					a.cnsctvo_cdgo_tpo_idntfccn,
					a.dgto_vrfccn,
					a.cts_cnclr,
					a.drccn,
					a.cnsctvo_cdgo_cdd,
					a.tlfno,
					a.vlr_iva,
					a.sldo_fvr,
					a.ttl_fctrdo,
					a.fcha_crcn,
					a.cnsctvo_cdgo_prdo,
					a.cnsctvo_cdgo_autrzdr_espcl,
					prcntje_incrmnto,
					a.cnsctvo_cdgo_prdo_lqdcn,
					a.cnsctvo_cdgo_estdo_estdo_cnta,
					b.dscrpcn_tpo_idntfccn,
					c.cdgo_clse_aprtnte,
					d.cdgo_prdo,
					d.dscrpcn_prdo,
					e.cdgo_prdo_lqdcn,
					e.dscrpcn_prdo_lqdcn,
					g.cdgo_estdo_estdo_cnta,
					convert(varchar(200) , (ltrim(rtrim(isnull(f.prmr_nmbre_usro,' +  Char(39) + ' ' + char(39) + '  ))) + '  +  Char(39)  +  ' '  + Char(39)   +  '  + ltrim(rtrim(isnull(f.sgndo_nmbre_usro,' +  Char(39) + ' ' + char(39) + ' ))) + '  +  Char(39)  +  ' '  + Char(39)   + ' +  ltrim(rtrim(isnull(f.prmr_aplldo_usro,' +  Char(39) + ' ' + char(39) + '))) + '  +  Char(39)  +  ' '  + Char(39)   +   ' +  ltrim(rtrim(isnull(f.sgndo_aplldo_usro,' +  Char(39) + ' ' + char(39) + ')))))   Usro_atrzdr ,
					f.cdgo_autrzdr_espcl, a.exste_cntrto '  
					+   'From    bdafiliacion..tbtiposidentificacion b, 
						bdafiliacion..tbclasesaportantes    c, 
						bdafiliacion..tbperiodos	    d, 
						tbPeriodosLiquidacion		    e, 	
						tbautorizadoresEspeciales_vigencias	    f,
						tbestadosestadoscuenta		g,	
						TbCuentasManuales a
					Where    ' 

  


Select @lcJoin	 =	'      b.cnsctvo_cdgo_tpo_idntfccn 	= a.cnsctvo_cdgo_tpo_idntfccn
			And	c.cnsctvo_cdgo_clse_aprtnte	 = a.cnsctvo_cdgo_clse_aprtnte
			And	d.cnsctvo_cdgo_prdo		    = a.cnsctvo_cdgo_prdo
			And	e.cnsctvo_cdgo_prdo_lqdcn 	  = a.cnsctvo_cdgo_prdo_lqdcn
			And	f.cnsctvo_cdgo_autrzdr_espcl   = a.cnsctvo_cdgo_autrzdr_espcl
			And	g.cnsctvo_cdgo_estdo_estdo_cnta   = a.cnsctvo_cdgo_estdo_estdo_cnta '


Select @lcCadena1	= ''

If @ldFechaReferencia Is Not Null
Begin
	Select @lcCadena1	= Char(39) + Convert(Varchar(10),@ldFechaReferencia,111) + Char(39) + Space(1) + '=' + Space(1) + 'Convert(Varchar(10),a.fcha_crcn,111)'  + Space(1) +  'And'
End

If @lcNumeroEstadoCuenta Is Not Null
Begin
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.nmro_estdo_cnta = ' + char(39)  +  ltrim(rtrim(@lcNumeroEstadoCuenta))  + char(39) +  Space(1) +  'And'
End


If @lnEstadoEstadoCuenta Is Not Null 
Begin  
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.cnsctvo_cdgo_estdo_estdo_cnta = '+ Convert(Varchar(10),@lnEstadoEstadoCuenta)	+ Space(1) +  'And'
End

If @lcUsuario Is Not Null 
Begin  
	Select @lcCadena1	= @lcCadena1 + Space(1)+ ' a.usro_crcn = ' + char(39)  +  ltrim(rtrim(@lcUsuario))  + char(39) +  Space(1) +  'And'
End

--select substring(@Instruccion,1,250)
--select substring(@Instruccion,251,500)
--select @lcCadena1
--select @lcjoin

Select @Instruccion = @Instruccion + @lcCadena1 +  @lcJoin

Exec  Sp_executesql     @Instruccion