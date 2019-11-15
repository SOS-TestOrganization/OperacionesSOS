/*---------------------------------------------------------------------------------
* Metodo o PRG 		: fnCalculaValorLetras
* Desarrollado por		: <\A Ing. Julian Fernando Bonilla  										A\>
* Descripcion			: <\D Esta función permite calcular el valor en letras						D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2011/12/27											FC\>
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por		: <\AM  Omar Antonio Granados AM\>
* Descripcion			: <\DM  Se cambia tipo de dato del parametro de float(8) a float par evitar datos errados por overflow DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM  2019/07/22 FM\>
*---------------------------------------------------------------------------------
*/

CREATE  FUNCTION [dbo].[fnCalculaValorLetras] (@vlr_lqdcn  float)  
RETURNS char(250)
AS  
BEGIN 

Declare @a		money,
        @c	  	varchar(250), 
        @modo		int

set @a = @vlr_lqdcn
set @modo = 0
 declare @b    int, 
           @i    int, 
           @g    int, 
           @e    int,
           @l    varchar(20), 
           @sw1  int, 
           @d    int, 
           @x    int, 
           @sw2  int, 
           @f    int, 
           @h    char(18), 
           @j    char(03)
	if @modo = 0
	   select @c = ''
	else
	   begin
	       select @c = @c + ' CON'
	   select @a = @a * 100
	   end
	select @h = convert ( char ( 18 ) , @a )
	select @f = 15
	select @i = 1
	while   @i < 16
	begin
   	   select @sw1 = 0
	   select @j = substring( @h , @i , 3 )
	   select @b = convert(int,@j)
   	   select @g = @b
   	   select @sw2 = 0
   	   if @b != 0		/* hay resultado de la division */
              select @sw2 = 1
   	   if exists ( 	select 	mnt_descr 
			from 	tbmontos 
			where 	mnt_valor = @b )
       	      begin
       	         select @sw1 = 1   /* resultado encontrado en la tabla */
       	         select @l = mnt_descr    
	         from   tbmontos 
	         where  mnt_valor = @b
       	         select @c = @c + @l  
	         if @b = 1 and @i = 13 and @modo = 0
	            select @c = @c + 'O'
	         end
	         select @a = @a - ( @b * @i )
	         if @sw1 = 0 and @b != 0	
	            begin		/* hay resultado pero no en la tabla */
	                  select @x = 100
	                  while 2 = 2
	                        begin
	   if @b < 16
	                              select @x = 1
	                              select @d = @b / @x
	                              select @e = @d * @x
	                           if @d = 0
	                              select @d= @b
   	                      if exists ( 	select 	mnt_descr 
				      from 	tbmontos 
				      where 	mnt_valor = @e )
       	      	                      begin
       	      	                         select  @l = mnt_descr 
		      			 from    tbmontos 
		                   where   mnt_valor = @e
	                                 select @c = @c + @l
	                                 if @e = 100 and @b != 0
		                             select @c = @c + 'TO'
	             		      end
		   if @b = 1 and @i = 13 and @modo = 0
		                       select @c = @c + 'O'
	                            select @b = @b - @e
    	                            if @x = 10 and @b  != 0
       	                               select @c = @c + ' Y '
	                           if @x = 1
	                               break
	                            else
	                               select @x = @x / 10
	                  end	/* end while 2 = 2 */
             end		/* end if @sw1 = 0 and @b != 0*/
           if @sw2 = 1
              begin
              if @f = 15
                 begin
                 select @c = @c + ' BILLON'
	         if @g != 1
	            select @c = @c + 'ES'
                 end
              if @f = 12 or @f = 6
             begin
	           select @c = @c + ' MIL'
                   if @f = 12 and (convert(int,substring(@h,7,3))=0)
                      select @c=@c+ ' MILLONES' 
                 end
              if @f = 9
                 begin
	         select @c = @c + ' MILLON'
	         if @g != 1
	            select @c = @c + 'ES'
                 end
       end
           if @f = 3
              break
           else
              begin
              select @i = @i + 3
              select @f = @f - 3
              end
	end				/* end while 1 = 1 */
	if @modo = 1			/* parte decimal */
	   begin
	   if @g = 1
	      select @c = @c + ' CENTAVO M/CTE'
	   else
	      begin
	      if @g = 0
	         select @c = @c + ' CERO CENTAVOS M/CTE'
	      else
	         select @c = @c + ' CENTAVOS M/CTE'
	      end
	   end


   select @c=@c+' '+'PESOS M/CTE'
	
	Return(@c)
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaValorLetras] TO [Consultor Asesor Cartera]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaValorLetras] TO [Consultor Administrativo Novedades]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaValorLetras] TO [portal_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaValorLetras] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnCalculaValorLetras] TO [Consultor Administrador]
    AS [dbo];

