
CREATE  PROCEDURE [dbo].[spSCTraerParametroGeneral] 

@lcConsecutivoParametro		udtConsecutivo,
@ldFechaReferencia		Datetime	=	Null,
@lcTipoParametro		Char(1)		=	Null		Output,
@LnValorParametroNumerico	int		=	Null		Output,
@lcValorParametroCaracter	Varchar(100)	=	Null		Output,
@ldValorParametroFecha	Datetime	=	Null		Output,
@vsble_usro			udtLogico	=	Null

AS

Set Nocount On

If @vsble_usro is null
	set @vsble_usro='S'

--2 líneas nuevas de código.
If @ldFechaReferencia is Null
	Set @ldFechaReferencia = GetDate()

--Selecciona el tipo de parametro que se encuentra en la tabla  tbparametrosgenerales y que cumpla
--con las Condiciones de Validacion
Select	@lcTipoParametro	 =	 tpo_dto_prmtro
--Línea antigua de código. Las fechas de vigencia se encuentran en la tabla de vigencias.
/*from	tbparametrosgenerales*/
--Nueva línea de código
From	tbparametrosgenerales_Vigencias
Where	(@ldFechaReferencia    Between   Inco_Vgnca    And    Fn_Vgnca )   			
And	(vsble_usro		= 	@vsble_usro or @vsble_usro='T')
And	@lcConsecutivoParametro	=  	cnsctvo_cdgo_prmtro_gnrl

--Select @lcTipoParametro

--Se valida si es diferente de Null , se verifica si el tipo de parametro es caracter , numerico, o de tipo fecha
--If  @lcTipoParametro != Null   
If  @lcTipoParametro Is Not Null
Begin
		
		If	@lcTipoParametro = 'N'
			--Se asigna a la variable el valor del parametro cuando es numerico
			Select     @lnValorParametroNumerico =  vlr_prmtro_nmrco
			--Línea antigua de código. Las fechas de vigencia se encuentran en la tabla de vigencias.
			/*from	tbparametrosgenerales*/
			--Nueva línea de código
			From 	 tbParametrosGenerales_Vigencias                      
			Where	  (@ldFechaReferencia    Between   Inco_Vgnca    And    Fn_Vgnca )   			
			And	  (vsble_usro		= 	@vsble_usro or @vsble_usro='T')
			And	  @lcConsecutivoParametro	 =	cnsctvo_cdgo_prmtro_gnrl
		Else
			Begin
			--Se asigna a la variable el valor del parametro cuando es caracter
				If	@lcTipoParametro = 'C'
					 Begin
						Select     @lcValorParametroCaracter  =  vlr_prmtro_crctr
						--Línea antigua de código. Las fechas de vigencia se encuentran en la tabla de vigencias.
						/*from	tbparametrosgenerales*/
						--Nueva línea de código
						From	  tbParametrosGenerales_Vigencias                      
						Where	 (@ldFechaReferencia    Between   Inco_Vgnca    And    Fn_Vgnca )   			
						And	  (vsble_usro		= 	@vsble_usro or @vsble_usro='T')
						And	  @lcConsecutivoParametro	=	cnsctvo_cdgo_prmtro_gnrl
						--Select  'parametro caracter', @lcValorParametroCaracter
					End

				Else
						--Se asigna a la variable el valor del parametro cuando es fecha
						Select     @ldValorParametroFecha  =  vlr_prmtro_fcha
						--Línea antigua de código. Las fechas de vigencia se encuentran en la tabla de vigencias.
						/*from	tbparametrosgenerales*/
						--Nueva línea de código
						From	  tbParametrosGenerales_Vigencias
						Where	  (@ldFechaReferencia    Between   Inco_Vgnca    And    Fn_Vgnca )   			
						And	  (vsble_usro		= 	@vsble_usro or @vsble_usro='T')
						And	  @lcConsecutivoParametro	=	cnsctvo_cdgo_prmtro_gnrl
			End
End

Else
	Return (-1)



--


