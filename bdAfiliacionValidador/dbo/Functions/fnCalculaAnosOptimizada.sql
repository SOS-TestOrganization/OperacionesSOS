/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* Metodo o PRG 	              : fnCalculaAnos 
* Desarrollado por		 : <\A    Ing. Alexander Yela Reyes					A\>
* Descripcion			 : <\D  									D\>
* Observaciones		              : <\O									O\>
* Parametros			   <\P 									P\>
* Fecha Creacion		 : <\FC  2004/08/18							FC\>
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
create Function [dbo].[fnCalculaAnosOptimizada]  (@dFechaNacimiento DateTime ,@dFechaCalculo DateTime, @nTipoOpcion int )
Returns Int
As  
Begin
	Declare @dFechaNacimientoTmp	DateTime,
		@nYears	 		Int,
		@nMeses			Int,
		@nEdad			Int 
	
	
	-- Inicializa las variables utilizadas en la funcion

	Set	@dFechaNacimientoTmp 	= @dFechaNacimiento
	Set	@nYears			= 0
	Set 	@nMeses			= 0
	Set	@nEdad			= 0

	If @dFechaNacimiento <= @dFechaCalculo And Convert(Char(10),@dFechaNacimiento,111) < '9999/12/31'
	Begin
		-- Valida el tipo de calculo que se esta pidiendo - Años

		If	@nTipoOpcion In (1,2)
		Begin
			-- Valida si hay mas de un año entre la Fecha de Nacimiento Temporal y la Fecha de Calculo

			If	DateDiff(Year, @dFechaNacimientoTmp, @dFechaCalculo) > 1
			Begin
				Set	@nYears = DateDiff(Year, @dFechaNacimientoTmp, @dFechaCalculo) - 1
				Set 	@dFechaNacimientoTmp = DateAdd(Year,@nYears,@dFechaNacimientoTmp) 	
			End
	
			-- Valida si hay mas de un año entre la Fecha de Nacimiento Temporal y la Fecha de Calculo

			If	DateAdd(Year,1,@dFechaNacimientoTmp) <= @dFechaCalculo
			Begin
				Set	@nYears = @nYears + 1
				Set 	@dFechaNacimientoTmp = DateAdd(Year,1,@dFechaNacimientoTmp) 					
			End
		End
	
	
		-- Valida el tipo de calculo que se esta pidiendo - Meses

		If	@nTipoOpcion In (2)
		Begin
			-- Valida si hay mas de un mes entre la Fecha de Nacimiento Temporal y la Fecha de Calculo

			If	DateDiff(Month, @dFechaNacimientoTmp, @dFechaCalculo) > 1
			Begin
				Set	@nMeses = DateDiff(Month, @dFechaNacimientoTmp, @dFechaCalculo) - 1
				Set 	@dFechaNacimientoTmp = DateAdd(Month,@nMeses,@dFechaNacimientoTmp) 	
			End
	
			-- Valida si hay mas de un mes entre la Fecha de Nacimiento Temporal y la Fecha de Calculo

			If	DateAdd(Month, 1,@dFechaNacimientoTmp) <= @dFechaCalculo
			Begin
				Set	@nMeses = @nMeses + 1
				Set 	@dFechaNacimientoTmp = DateAdd(Month,1,@dFechaNacimientoTmp) 	
			End
		End
	
	
		-- Valida si calcula la edad en años (1) , meses (2), dias (3)

		If 	@nTipoOpcion = 1
		Begin
			Set	@nEdad	= 	@nYears 
		End
		Else
		Begin  														
			If 	@nTipoOpcion = 2
			Begin
				Set 	@nEdad	=	(@nYears*12) + @nMeses
			End
			Else
			Begin
				If 	@nTipoOpcion = 3
				Begin
					Set 	@nEdad	=	DateDiff(Day, @dFechaNacimientoTmp, @dFechaCalculo)
				End
			End
		End
	End	
		
	-- Retorna la edad calculada

	Return @nEdad
	
End


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaAnosOptimizada] TO [cna_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaAnosOptimizada] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaAnosOptimizada] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaAnosOptimizada] TO [autsalud_rol]
    AS [dbo];

