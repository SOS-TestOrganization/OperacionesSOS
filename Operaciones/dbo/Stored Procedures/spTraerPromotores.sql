/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerPromotores
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Retorna los datos correspondientes a los promotores, validando su vigencia o no, segun la descripcion o 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Fecha a la cual se valida la vigencia									P\>
				  <\P consecutivo del promotor que se desea localizar							P\>				 
				  <\P cadena de busqueda por descripcion								P\>				 
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/10/01											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\> 
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE	spTraerPromotores

@CodigoPromotor		UdtCodigo		= Null,
@ldFechaReferencia		Datetime		= Null,
@lcCadenaSeleccion		UdtDescripcion		= Null,
@lnConsecutivoPromotor	UdtConsecutivo		= Null,
@lcEstado			UdtConsecutivo		= Null



As	Declare
@Instruccion			Nvarchar(2000),
@Parametros			Nvarchar(1000),
@lcJoin				NVarchar(1000),
@lcCadena1			NVarchar(1000)

Set Nocount On
Select @Instruccion	=  	'Select     c.cdgo_prmtr,
					d.cdgo_tpo_idntfccn,
				c.nmro_idntfccn_prmtr,
				convert(varchar(200) , (ltrim(rtrim(isnull(c.prmr_aplldo,' +  Char(39) + ' ' + char(39) + '  ))) + '  +  Char(39)  +  ' '  + Char(39)   +  '  + ltrim(rtrim(isnull(c.sgndo_aplldo,' +  Char(39) + ' ' + char(39) + ' ))) + '  +  Char(39)  +  ' '  + Char(39)   + ' +  ltrim(rtrim(isnull(c.prmr_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '  +  Char(39)  +  ' '  + Char(39)   +   ' +  ltrim(rtrim(isnull(c.sgndo_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '   +    Char(39)  +  '  '  + Char(39)   +   ' +   ltrim(rtrim(isnull(c.rzn_scl,' +  Char(39) + ' ' + char(39) + ')))) ) nombre ,
				c.inco_vgnca,
				c.fn_vgnca,
				convert(char(20),replace(convert(char(20),c.fcha_crcn,120), ' +   Char(39) + '-' + char(39) + ','   + Char(39) + '/' + Char(39) + ' )) fcha_crcn_hra,
				c.usro_crcn,
				c.cnsctvo_cdgo_tpo_idntfccn,
				c.cnsctvo_cdgo_cdd,
				c.tlfno,
				c.drccn,
				c.eml,
				c.cnsctvo_cdgo_estdo_prmtr,
				c.cnsctvo_cdgo_tpo_prmtr,
				c.dgto_vrfccn,
				b.dscrpcn_tpo_prmtr,
				a.dscrpcn_estdo_prmtr ,c.cnsctvo_cdgo_prmtr ,  '   +   Char(39) + 'NO SELECCIONADO' +  Char(39) + ' accn ' + char(13)
			            +	'From tbestadospromotor a, tbtipospromotor b, tbpromotores_vigencias  c , bdafiliacion..tbtiposidentificacion_vigencias  d 
				Where '


Select @lcJoin =	' a.cnsctvo_cdgo_estdo_prmtr 	=	 c.cnsctvo_cdgo_estdo_prmtr
		and   b.cnsctvo_cdgo_tpo_prmtr 		=	 c.cnsctvo_cdgo_tpo_prmtr
		and   c.cnsctvo_cdgo_tpo_idntfccn 	=	 d.cnsctvo_cdgo_tpo_idntfccn  '
--		and   c.brrdo 	= ' + Char(39) + 	  'N' + Char(39) 

Select @lcCadena1	= ''

If @ldFechaReferencia Is Not Null
Begin
	Select @lcCadena1	= Char(39) + Convert(Varchar(10),@ldFechaReferencia,111) + Char(39) + Space(1) + 'Between' + Space(1) + 'Convert(Varchar(10),d.inco_vgnca,111)' + Space(1) +  'And' + Space(1) + 'Convert(Varchar(10),d.fn_vgnca,111)' + Space(1) +  'And'
End

If @lnConsecutivoPromotor Is Not Null
Begin
	Select @lcCadena1	= @lcCadena1 + Space(1)+ 'c.cnsctvo_cdgo_prmtr = ' + convert(varchar(10),@lnConsecutivoPromotor) + Space(1) +  'And'
End
Else
Begin
	If @lcCadenaSeleccion Is Not Null   And @lcCadenaSeleccion != '+'
	Begin
       		Select @lcCadena1	= @lcCadena1 + Space(1) + '  (ltrim(rtrim(isnull(c.prmr_aplldo,' +  Char(39) + ' ' + char(39) + '  ))) + '  +  Char(39)  +  ' '  + Char(39)   +  '  + ltrim(rtrim(isnull(c.sgndo_aplldo,' +  Char(39) + ' ' + char(39) + ' ))) + '  +  Char(39)  +  ' '  + Char(39)   + ' +  ltrim(rtrim(isnull(c.prmr_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '  +  Char(39)  +  ' '  + Char(39)   +   ' +  ltrim(rtrim(isnull(c.sgndo_nmbre,' +  Char(39) + ' ' + char(39) + '))) + '   +    Char(39)  +  '  '  + Char(39)   +   ' +   ltrim(rtrim(isnull(c.rzn_scl,' +  Char(39) + ' ' + char(39)  +  '))))  '   +   '   Like ' + Char(39) +  '%' + Ltrim(Rtrim(@lcCadenaSeleccion)) + '%' + Char(39)+ Space(1) +  '  And'
	End
End

If @lcEstado Is Not Null 
Begin 
	Select @lcCadena1	= @lcCadena1 + Space(1)+ 'c.cnsctvo_cdgo_estdo_prmtr = '+ Convert(Varchar(10),@lcEstado)	+ Space(1) +  'And'
End


If    @CodigoPromotor Is Not Null
Begin
	Select @lcCadena1	= @lcCadena1 + Space(1)+ 'c.cdgo_prmtr = ' + convert(varchar(10),@CodigoPromotor) + Space(1) +  'And'
End


--select substring(@Instruccion,1,250)
--select substring(@Instruccion,251,500)
--select @lcCadena1
--select @lcjoin
Select @Instruccion = @Instruccion + @lcCadena1 +  @lcJoin

Exec  Sp_executesql     @Instruccion