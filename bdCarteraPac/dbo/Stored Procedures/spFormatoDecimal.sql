



CREATE PROCEDURE [dbo].[spFormatoDecimal] 
                 @valor                 varchar(100),
                 @valorformato  	varchar(100) output ,
	    @tipo			int = NULL 
as

declare  
                  @i     	int,
                  @lnlen  	int,
                  @auxl   	int,
                  @sw    	int 


SET NOCOUNT ON


CREATE TABLE #tbvalornumerico
( 
	 valor numeric(12)
	)

set   @sw     =  0
set   @lnlen  =  len(@valor)

if    SUBSTRING(@valor,1, 1)='-'
     begin
         set @valor= SUBSTRING(@valor,2, @lnlen)
         set @sw=1

    end

set   @lnlen =  len(@valor)
set  @auxl =   @lnlen

set    @valorformato =''

WHILE @auxl>3
   begin
      set 	@auxl = @auxl - 3
      insert into #tbvalornumerico
      select @auxl+1
   
   end


set @i=1
while @i<=@lnlen
  begin
      if exists (select 1
                 from #tbvalornumerico
                 where valor = @i)            

         begin
                   set @valorformato = @valorformato + ',' +  SUBSTRING(@valor,@i, 1)
         end
      else
         begin
                 set @valorformato = @valorformato +           SUBSTRING(@valor,@i, 1)
         end
      set @i=@i +1
  end

if @tipo = 1
   begin
	if  @sw=1 
	     set @valorformato=  '-'+ @valorformato
	else
	      set @valorformato=  @valorformato
  end
else 
   begin
	if  @sw=1 
	     set @valorformato='$' + '-'+ @valorformato
	else
	      set @valorformato='$' +  @valorformato
  end


--select  @cadena
drop table  #tbvalornumerico

