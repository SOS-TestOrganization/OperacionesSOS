
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Metodo o PRG 	              	 :  fnCalcularCamposNombres 
* Desarrollado por		 :  <\A    Ing. Andres Taborda										A\>
* Descripcion			 :  <\D  Devuelve los campos de los nombres	D\>
* Observaciones		         :  <\O													O\>
* Parametros			 :  <\P @ldInicioPeriodo, @ldFinPeriodo, Archivo a Generar  								P\>
*				    <\P													P\>
* Fecha Creacion		 :  <\FC  2007/04/17								FC\>
*  
*---------------------------------------------------------------------------------*/
CREATE	Function fnCalcularCamposNombres  (@nombre char(120),@parametro int)

Returns	char(30)

As  
Begin

--Partir Nombres de Afiliados Inexistenes

Declare --@nombre char(100), 
	@i int, 
	@letra char(1),
	@espacios  int,
	@prmr_nmbre char(30) ,
	@sgndo_nmbre char(30),
	@prmr_aplldo char(30),
	@sgndo_aplldo char(30),
	@calculochar char(30)


--Verificar cantidad de Espacios
set @i=1
set @espacios =0
while (@i<len(@nombre) )
begin
  set @letra = substring(@nombre,@i,1) 
  if (@letra = '' )
  begin
	set @espacios = @espacios +1
  end	
  set @i = @i + 1	
end 
-- calculos para partir la cadena
select @prmr_aplldo = SubString(@nombre,1,CharIndex(' ',@nombre))
select @nombre=Ltrim(Rtrim(SubString(@nombre,CharIndex(' ',@nombre),250)))

IF (SUBSTRING(@nombre,1,3) = 'de ' OR  SUBSTRING(@nombre,1,3) = 'DE ' )
begin	
	set @sgndo_aplldo = substring(@nombre,1,charindex(' ',substring(@nombre,4,len(@nombre)))+3)
	select @nombre=   ltrim(rtrim(substring(@nombre,charindex(' ',substring(@nombre,4,len(@nombre)))+3,len(@nombre))))	
	set  @prmr_nmbre =  @nombre	
	select @nombre=Ltrim(Rtrim(SubString(@nombre,CharIndex(' ',@nombre),250)))

END
ELSE
BEGIN
	select @sgndo_aplldo = SubString(@nombre,1,CharIndex(' ',@nombre))
	select @nombre=Ltrim(Rtrim(SubString(@nombre,CharIndex(' ',@nombre),250)))
	IF (SUBSTRING(@nombre,1,3) = 'de ' OR  SUBSTRING(@nombre,1,3) = 'DE ' )
	begin	
		set @prmr_nmbre = @sgndo_aplldo
		set @sgndo_aplldo = null
		set  @sgndo_nmbre = @nombre

	END
	ELSE
	BEGIN
		--nombres raros
		if @espacios >= 4
		begin
			select @prmr_nmbre = SubString(@nombre,1,CharIndex(' ',@nombre))
			select @nombre=Ltrim(Rtrim(SubString(@nombre,CharIndex(' ',@nombre),250)))
			select @sgndo_nmbre = ltrim(rtrim(SubString(@nombre,1,CharIndex(' ',@nombre))))
			set @prmr_aplldo = ltrim(rtrim(@prmr_aplldo)) + ' '+ ltrim(rtrim(@sgndo_aplldo)) + ' '+ ltrim(rtrim(@prmr_nmbre))
			set @prmr_nmbre = @sgndo_nmbre 
			set @sgndo_aplldo = null 
			set @sgndo_nmbre = null
			set @sgndo_nmbre = substring(@nombre,charindex(' ',@nombre),len(@nombre))

			if @espacios >=6
			begin
				set @sgndo_aplldo = @prmr_nmbre
				set @prmr_nmbre = @sgndo_nmbre 	
				set @sgndo_nmbre = substring(@sgndo_nmbre,  charindex(' ',ltrim(rtrim(@sgndo_nmbre)))+1,len(@sgndo_nmbre))
				set @prmr_nmbre = substring(@prmr_nmbre,  1, charindex(' ',ltrim(rtrim(@prmr_nmbre))))
				--set @prmr_nmbre = substring(@prmr_nmbre,  1, charindex(' ',@prmr_nmbre))	
			end

		end
		else
		begin
			select @prmr_nmbre = SubString(@nombre,1,CharIndex(' ',@nombre))
			select @nombre=Ltrim(Rtrim(SubString(@nombre,CharIndex(' ',@nombre),250)))
			select @sgndo_nmbre = ltrim(rtrim(SubString(@nombre,1,CharIndex(' ',@nombre))))
		end
			

	
		
	END

	--chequeo nombre y apellido
	if @espacios = 1
	begin
		
		set @prmr_nmbre = @sgndo_aplldo
	 	set @sgndo_aplldo = null
		set @sgndo_nmbre = null

	end
	
	

END
--datos calculados nombres
/*
Insert into 	@tbCamposNombres (
	prmr_nmbre ,
	sgndo_nmbre,
	prmr_aplldo,
	sgndo_aplldo )
select	ltrim(rtrim(@prmr_nmbre)),
	ltrim(rtrim(@sgndo_nmbre)),
	ltrim(rtrim(@prmr_aplldo)) ,
	ltrim(rtrim(@sgndo_aplldo))
*/	
if @parametro =1 
begin
set @calculochar  = ltrim(rtrim(@prmr_nmbre))
end
if @parametro = 2
begin
set @calculochar  = ltrim(rtrim(@sgndo_nmbre))
end
if @parametro = 3 
begin
set @calculochar  = ltrim(rtrim(@prmr_aplldo))
end
if @parametro = 4
begin
set @calculochar = ltrim(rtrim(@sgndo_aplldo))
end
Return(@calculochar)

End






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCamposNombres] TO [AdminScripts_Cambios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCamposNombres] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCamposNombres] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalcularCamposNombres] TO [Liquidador Facturas]
    AS [dbo];

