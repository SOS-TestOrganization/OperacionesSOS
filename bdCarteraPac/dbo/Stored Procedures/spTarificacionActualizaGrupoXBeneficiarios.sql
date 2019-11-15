






/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTarificacionActualizaGrupoXBeneficiarios
* Desarrollado por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Este procedimiento Actualiza el grupos de tarifas para cada beneficiario			 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/02 											FC\>
* Modificado  por		: <\A Ing. ROLANDO SIMBAQUEVA LASSO								A\>
* Descripcion			: <\D Aplicacion de tecnicas de optimizacion	 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P 													P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2005/09/28 											FC\>
**/
CREATE   PROCEDURE [dbo].[spTarificacionActualizaGrupoXBeneficiarios]
		@lnConsecutivoGrupo		udtConsecutivo,
		@cnsctvo_cdgo_lqdcn		udtConsecutivo,
		@ldFechaReferencia		Datetime
	

As
declare @grupo int

set nocount on				


Update	#RegistrosClasificar
Set	Ps_ss		=	'S'
Where	Atrzdo_sn_Ps	=	'S'
And	Ps_ss		=	'N'


--exec bdafiliacion..spCalcularGrupos @lnConsecutivoGrupo,	@ldFechaReferencia,	@grupo	output



--> Crear tabla temporal #Variables 

Create Table	 #Variables (	cnsctvo_cdgo_vrble  udtConsecutivo	,										
			dscrpcn_vrble  udtDescripcion ,			tpo_rngo	char,							
			tpo_dto	char	)							

CREATE TABLE  #DefinicionesTemporales (								
		cnsctvo_cdgo_rngo_vrble 	udtConsecutivo ,	cnsctvo_cdgo_dfncn_grpo	udtConsecutivo ,			
		cnsctvo_cdgo_dtlle_grpo 	udtConsecutivo ,	exste 				udtLogico	)


Create Table #RangosVariables (
	cnsctvo_cdgo_rngo_vrble 	udtConsecutivo,		inco_vgnca 		datetime,	
	fn_vgnca			datetime,		cnsctvo_cdgo_vrble	udtConsecutivo ,
	Vlr_1	varchar(50),			Vlr_2	varchar(50)	)

Create Table  #RegistrosVariables (	
	nmro_unco_idntfccn	 int,		dscrpcn_vrble	udtDescripcion ,		tpo_rngo	char,
	tpo_dto			char ,		valor		varchar(100), 		prueba 		varchar(100) ,
	cnsctvo_cdgo_vrble  	udtconsecutivo )

CREATE TABLE #RangoTemporal   (				
	nmro_unco_idntfccn	udtConsecutivo  ,	dscrpcn_vrble  		udtDescripcion ,
	tpo_rngo		char,			tpo_dto			char ,
	valor			varchar(100)  ,		cnsctvo_cdgo_vrble	 udtConsecutivo ,
	rngo_vrble		udtConsecutivo 	 )

CREATE TABLE #RangoTemporal1   (				
	nmro_unco_idntfccn	udtConsecutivo  ,	dscrpcn_vrble  		udtDescripcion ,
	tpo_rngo		char,			tpo_dto			char ,
	valor			varchar(100)  ,		cnsctvo_cdgo_vrble	 udtConsecutivo ,
	rngo_vrble		udtConsecutivo 	 )

CREATE TABLE #RangoTemporal2   (				
	nmro_unco_idntfccn	udtConsecutivo  ,	dscrpcn_vrble  		udtDescripcion ,
	tpo_rngo		char,			tpo_dto			char ,
	valor			varchar(100)  ,		cnsctvo_cdgo_vrble	 udtConsecutivo ,
	rngo_vrble		udtConsecutivo 	 )


Create Table 	#MaxGruposDefinitivos  (					
	nmro_unco_idntfccn	   udtConsecutivo ,	cnsctvo_cdgo_dfncn_grpo udtConsecutivo ,				
	cnsctvo_cdgo_dtlle_grpo   udtConsecutivo				)

Create Table	#Definiciones  (													
	nmro_unco_idntfccn		udtConsecutivo  , cnsctvo_cdgo_rngo_vrble udtConsecutivo ,
	cnsctvo_cdgo_dfncn_grpo udtConsecutivo ,			
	cnsctvo_cdgo_dtlle_grpo udtConsecutivo , Exste 	int)

Create table #tmp2
(ID_Num  int  IDENTITY(1,1),
 nmro_unco_idntfccn int)

create table 	#GruposDefinitivos  (				
		nmro_unco_idntfccn	 udtConsecutivo ,	cnsctvo_cdgo_dfncn_grpo udtConsecutivo ,				
		cnsctvo_cdgo_dtlle_grpo udtConsecutivo		, existe int		)

--> Recuperar la Variables Correspondientes al Grupo


/*If  @lnConsecutivoGrupo  = 214
begin
Insert into 	#Variables
Select	a.cnsctvo_cdgo_vrble  , 			a.Dscrpcn_Vrble, 
	max(a.Tpo_Rngo) as Tpo_Rngo, 		max(a.Tpo_Dto) as Tpo_Dto 
From	bdafiliacion.dbo.tbVariables a inner join bdafiliacion.dbo.tbRangosVariables b
	on (b.cnsctvo_cdgo_vrble	=	a.cnsctvo_cdgo_vrble ) inner join
	bdafiliacion.dbo.tbDetDefinicionGrupos c 
	on (b.cnsctvo_cdgo_rngo_vrble	=	c.cnsctvo_cdgo_rngo_vrble) inner join
	bdafiliacion.dbo.tbDefinicionGrupos d
	on (d.Cnsctvo_Cdgo_Dfncn_Grpo	=	c.Cnsctvo_Cdgo_Dfncn_Grpo) inner join
	bdafiliacion.dbo.tbDetGrupos e
	on (e.Cnsctvo_cdgo_dtlle_grpo	=	d.Cnsctvo_cdgo_dtlle_grpo ) inner join
	bdafiliacion.dbo.tbGrupos f
	on (f.Cnsctvo_Cdgo_Grpo		=	e.Cnsctvo_Cdgo_Grpo	)					
Where	f.Cnsctvo_Cdgo_Grpo		 in (2, 14)
AND	A.vsble_usro	=	'S'	
And	b.brrdo		=	'N'		
And	 CONVERT(VARCHAR(10),getdate(),111) BETWEEN CONVERT(VARCHAR(10),e.inco_vgnca,111) and  CONVERT(VARCHAR(10),e.fn_vgnca,111)
And	 CONVERT(VARCHAR(10),getdate(),111) BETWEEN CONVERT(VARCHAR(10),d.inco_vgnca,111) and  CONVERT(VARCHAR(10),d.fn_vgnca,111)
Group by a.Dscrpcn_Vrble	,a.cnsctvo_cdgo_vrble	


--> Recuperar las definiciones Correspondientes al Grupo
INSERT INTO 	#DefinicionesTemporales					
SELECT  c.cnsctvo_cdgo_rngo_vrble, 	 d.Cnsctvo_cdgo_dfncn_grpo, 
	e.cnsctvo_cdgo_dtlle_grpo,	 'N' 			
FROM	bdafiliacion.dbo.tbDetDefinicionGrupos c inner join	bdafiliacion.dbo.tbDefinicionGrupos d
	on (d.Cnsctvo_Cdgo_Dfncn_Grpo   = c.Cnsctvo_Cdgo_Dfncn_Grpo ) inner join
	bdafiliacion.dbo.tbDetGrupos e
	on (e.cnsctvo_cdgo_dtlle_grpo   =	d.cnsctvo_cdgo_dtlle_grpo ) inner join
	bdafiliacion.dbo.tbGrupos f  				
	on (f.Cnsctvo_Cdgo_Grpo		=	e.Cnsctvo_Cdgo_Grpo)	
WHERE   f.Cnsctvo_Cdgo_Grpo		= 14
And 	CONVERT(VARCHAR(10),getdate(),111)  BETWEEN CONVERT(VARCHAR(10),e.inco_vgnca,111) and  CONVERT(VARCHAR(10),e.fn_vgnca,111)
And	CONVERT(VARCHAR(10),getdate(),111)  BETWEEN CONVERT(VARCHAR(10),d.inco_vgnca,111) and  CONVERT(VARCHAR(10),d.fn_vgnca,111)					

end
else
begin*/
Insert into 	#Variables
Select	a.cnsctvo_cdgo_vrble  , 			a.Dscrpcn_Vrble, 
	max(a.Tpo_Rngo) as Tpo_Rngo, 		max(a.Tpo_Dto) as Tpo_Dto 
From	bdafiliacion.dbo.tbVariables a inner join bdafiliacion.dbo.tbRangosVariables b
	on (b.cnsctvo_cdgo_vrble	=	a.cnsctvo_cdgo_vrble ) inner join
	bdafiliacion.dbo.tbDetDefinicionGrupos c 
	on (b.cnsctvo_cdgo_rngo_vrble	=	c.cnsctvo_cdgo_rngo_vrble) inner join
	bdafiliacion.dbo.tbDefinicionGrupos d
	on (d.Cnsctvo_Cdgo_Dfncn_Grpo	=	c.Cnsctvo_Cdgo_Dfncn_Grpo) inner join
	bdafiliacion.dbo.tbDetGrupos e
	on (e.Cnsctvo_cdgo_dtlle_grpo	=	d.Cnsctvo_cdgo_dtlle_grpo ) inner join
	bdafiliacion.dbo.tbGrupos f
	on (f.Cnsctvo_Cdgo_Grpo		=	e.Cnsctvo_Cdgo_Grpo	)					
Where	f.Cnsctvo_Cdgo_Grpo		= @lnConsecutivoGrupo
AND	A.vsble_usro	=	'S'	
And	b.brrdo		=	'N'		
And	 CONVERT(VARCHAR(10),getdate(),111) BETWEEN CONVERT(VARCHAR(10),e.inco_vgnca,111) and  CONVERT(VARCHAR(10),e.fn_vgnca,111)
And	 CONVERT(VARCHAR(10),getdate(),111) BETWEEN CONVERT(VARCHAR(10),d.inco_vgnca,111) and  CONVERT(VARCHAR(10),d.fn_vgnca,111)
Group by a.Dscrpcn_Vrble	,a.cnsctvo_cdgo_vrble	


--> Recuperar las definiciones Correspondientes al Grupo
INSERT INTO 	#DefinicionesTemporales					
SELECT  c.cnsctvo_cdgo_rngo_vrble, 	 d.Cnsctvo_cdgo_dfncn_grpo, 
	e.cnsctvo_cdgo_dtlle_grpo,	 'N' 			
FROM	bdafiliacion.dbo.tbDetDefinicionGrupos c inner join	bdafiliacion.dbo.tbDefinicionGrupos d
	on (d.Cnsctvo_Cdgo_Dfncn_Grpo   = c.Cnsctvo_Cdgo_Dfncn_Grpo ) inner join
	bdafiliacion.dbo.tbDetGrupos e
	on (e.cnsctvo_cdgo_dtlle_grpo   =	d.cnsctvo_cdgo_dtlle_grpo ) inner join
	bdafiliacion.dbo.tbGrupos f  				
	on (f.Cnsctvo_Cdgo_Grpo		=	e.Cnsctvo_Cdgo_Grpo)	
WHERE   f.Cnsctvo_Cdgo_Grpo		=	@lnConsecutivoGrupo
And 	CONVERT(VARCHAR(10),getdate(),111)  BETWEEN CONVERT(VARCHAR(10),e.inco_vgnca,111) and  CONVERT(VARCHAR(10),e.fn_vgnca,111)
And	CONVERT(VARCHAR(10),getdate(),111)  BETWEEN CONVERT(VARCHAR(10),d.inco_vgnca,111) and  CONVERT(VARCHAR(10),d.fn_vgnca,111)					
 	
--end


--> Recuperar los Rangos Variables
insert into #RangosVariables				
Select 	cnsctvo_cdgo_rngo_vrble, 	inco_vgnca, 	fn_vgnca,
	cnsctvo_cdgo_vrble, 		Vlr_1, 		Vlr_2 				
From 	bdafiliacion.dbo.tbRangosVariables				



declare @lnCnsctvo_cdgo_grpo		udtConsecutivo,	
	@ldFechaVigencia		DateTime,
	@lnResultado			Int,	
	@lcInsertString 		nVarChar(2000),
	@dscrpcn_vrble varchar(20),
	@lcdscrpcn_vrble varchar(100)



--> Inicializar Variables

Set @lnResultado 		=	0
declare crCamposVariable CURSOR FOR
select  dscrpcn_vrble
from #Variables
order by dscrpcn_vrble
OPEN  crCamposVariable
	FETCH NEXT FROM crCamposVariable
	Into @lcdscrpcn_vrble
	WHILE @@FETCH_STATUS = 0
	 Begin

		select @lcInsertString 	=	'insert into #RegistrosVariables (nmro_unco_idntfccn,	  dscrpcn_vrble  , tpo_rngo, tpo_dto,valor,cnsctvo_cdgo_vrble,prueba  )
						select    nmro_unco_idntfccn,	  dscrpcn_vrble  , tpo_rngo, tpo_dto, '+@lcdscrpcn_vrble+' , cnsctvo_cdgo_vrble ,0'+
						 ' from	#Variables , #RegistrosClasificar'+	
						' where dscrpcn_vrble = ' +char(39)+@lcdscrpcn_vrble+char(39)
												
													
		Exec sp_ExecuteSql   @lcInsertString			

	FETCH NEXT FROM crCamposVariable
	into @lcdscrpcn_vrble
	End  
close crCamposVariable
deallocate crCamposVariable
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
--select * from #RegistrosClasificar

--> Crear Tabla temporal #RangoTemporal  para guardar los rangos

--> Actualizar los Rangos en la tabla temporal #RangoTemporal


Insert INTO	#RangoTemporal		
SELECT v.nmro_unco_idntfccn ,	v.dscrpcn_vrble , 
	v.tpo_rngo , 		 v.tpo_dto,  
	v.valor, 			v.cnsctvo_cdgo_vrble	, 
	r.cnsctvo_cdgo_rngo_vrble 
FROM 	bdafiliacion.dbo.tbRangosVariables r  inner join #RegistrosVariables v					
	on (r.cnsctvo_cdgo_vrble 	=	v.cnsctvo_cdgo_vrble)
WHERE 	v.tpo_rngo 		= 	'V'				
AND	v.tpo_dto	 	= 	 'N' 
AND	convert(int,vlr_1 )	=	convert(int, Valor)	
AND	VLR_1			!=	CHAR(39)+'S'+CHAR(39)
AND	VLR_1			!=	CHAR(39)+'N'+CHAR(39)
	
--> Ingresa los rangos que son  tipo rango != V y tipo Dato =N

INSERT INTO #RangoTemporal								
SELECT v.nmro_unco_idntfccn ,		v.dscrpcn_vrble , 
	v.tpo_rngo ,  			v.tpo_dto,  
	v.valor,  			v.cnsctvo_cdgo_vrble,
	r.cnsctvo_cdgo_rngo_vrble						
FROM	bdafiliacion.dbo.tbRangosVariables r inner join #RegistrosVariables v								
	on (r.cnsctvo_cdgo_vrble 	=	v.cnsctvo_cdgo_vrble)
WHERE 	v.tpo_rngo 	 	!=	 'V'							
AND	v.tpo_dto		= 	 'N'  			
AND	convert(int, Valor)  BETWEEN convert(int,vlr_1)  AND convert(int,vlr_2)				
AND	vlr_1			!=	CHAR(39)+'S'+CHAR(39)				
AND	vlr_1 			!=	CHAR(39)+'N'+CHAR(39)	

--> Ingresa los rangos que son  tipo rango = V y tipo Dato = F
--select  * from bdafiliacion..tbRangosVariables

INSERT INTO #RangoTemporal		
SELECT v.nmro_unco_idntfccn ,		v.dscrpcn_vrble , 
	v.tpo_rngo ,  			v.tpo_dto,  
	v.valor,  			v.cnsctvo_cdgo_vrble,
	r.cnsctvo_cdgo_rngo_vrble
FROM 	bdafiliacion.dbo.tbRangosVariables r inner join #RegistrosVariables v		
	on (r.cnsctvo_cdgo_vrble 	=	v.cnsctvo_cdgo_vrble)
WHERE 	v.tpo_rngo 	  		= 	'V'	
AND	v.tpo_dto	 		= 	 'F'  	
AND	convert(varchar(10),vlr_1,111)  =	convert(varchar(10), Valor,111)	
AND 	vlr_1 	 			!=	CHAR(39)+'S'+CHAR(39)		
AND	vlr_1  				!=	CHAR(39)+'N'+CHAR(39)		
	
-->  Ingresa los rangos que son  tipo rango != V y tipo Dato =F

INSERT INTO #RangoTemporal		
SELECT v.nmro_unco_idntfccn ,		v.dscrpcn_vrble , 
	v.tpo_rngo ,  			v.tpo_dto,  
	v.valor,  			v.cnsctvo_cdgo_vrble,
	r.cnsctvo_cdgo_rngo_vrble 
FROM 	(Select	*
	From	bdafiliacion..tbRangosVariables 
	Where	(vlr_1 Is Not Null And Ltrim(Rtrim(vlr_1)) != '')
	And	(vlr_2 Is Not Null And Ltrim(Rtrim(vlr_2)) != '')
	AND 	 vlr_1	!=	CHAR(39)+'S'+CHAR(39)		
	AND	 vlr_1	!=	CHAR(39)+'N'+CHAR(39)
	AND	 Len(Rtrim(Ltrim(vlr_1))) = 8
	AND	 Len(Rtrim(Ltrim(vlr_2))) = 8)  r inner join 
	#RegistrosVariables v	
	on (r.cnsctvo_cdgo_vrble  =	v.cnsctvo_cdgo_vrble)	
WHERE  	v.tpo_rngo 	  	  != 	'V'	
AND	v.tpo_dto	 	   = 	 'F'  	
AND	Valor  BETWEEN convert(datetime,vlr_1)  AND convert(datetime,vlr_2)	

--> Ingresa los rangos que son  tipo rango = V y cnsctvo_cdgo_vrble = 3 Estudiante
							
Insert Into	#RangoTemporal								
select 	v.nmro_unco_idntfccn ,		v.dscrpcn_vrble , 
	v.tpo_rngo ,  v.tpo_dto, 		v.valor,  
	v.cnsctvo_cdgo_vrble,		r.cnsctvo_cdgo_rngo_vrble						
from 	bdafiliacion.dbo.tbRangosVariables r inner join #RegistrosVariables v								
	on (r.cnsctvo_cdgo_vrble 	=	v.cnsctvo_cdgo_vrble)
where 	v.tpo_rngo 	 	= 	'V'	
And	v.tpo_dto		=  	'C'  	
And	vlr_1			=	char(39)+Valor+char(39)


--> Crear Tabla Temporal #MaxGruposDefinitivos						



Insert into	#RangoTemporal1
Select  nmro_unco_idntfccn,
	dscrpcn_vrble,
	tpo_rngo,
	tpo_dto,
	valor,
	cnsctvo_cdgo_vrble,
	rngo_vrble
From	#RangoTemporal
/*where nmro_unco_idntfccn not in (select nmro_unco_idntfccn 
								 from #RegistrosClasificarFinal where nmro_unco_idntfccn_aprtnte = 30043100 
								 and cnsctvo_scrsl_ctznte  = 3
								 group by nmro_unco_idntfccn  )*/

Insert into #RangoTemporal2
Select  nmro_unco_idntfccn,
	dscrpcn_vrble,
	tpo_rngo,
	tpo_dto,
	valor,
	cnsctvo_cdgo_vrble,
	rngo_vrble
From	#RangoTemporal1

Delete from #RangoTemporal2

Insert Into 	#tmp2
Select  nmro_unco_idntfccn
From	(select 	 nmro_unco_idntfccn
	 From	#RangoTemporal1
	 Group by nmro_unco_idntfccn ) tmpnuiApro

declare @contadorIni	int
declare @contadorFin	int,
	@lnValorTotal	int

Select  @lnValorTotal	=	isnull(max(ID_Num),0)  from #tmp2
Set	@contadorIni	=	1
SEt	@contadorFin	=	500


insert	into  tbPasosLiquidacion  values(@cnsctvo_cdgo_lqdcn,'Iinicia proceso encontrar grupo a los beneficiarios',Getdate())


while @contadorIni<=@lnValorTotal
	begin
		
		
		Delete from #RangoTemporal2

		insert into #RangoTemporal2
		Select	a.nmro_unco_idntfccn,dscrpcn_vrble,
			tpo_rngo,	tpo_dto,	
			valor,		cnsctvo_cdgo_vrble,
			rngo_vrble
		FRom	#RangoTemporal1	a inner join #tmp2 b
			on (a.nmro_unco_idntfccn =	b.nmro_unco_idntfccn)
		Where	b.ID_Num		>=	 @contadorIni-- @contador
		and 	b.ID_Num		<=@contadorFin


		
		Delete From	#Definiciones
	
		Insert into #Definiciones													
		Select 	distinct nmro_unco_idntfccn ,	t.cnsctvo_cdgo_rngo_vrble ,
			cnsctvo_cdgo_dfncn_grpo ,	cnsctvo_cdgo_dtlle_grpo ,	'1' 		
		from	#DefinicionesTemporales t , #RangoTemporal2	r





		update #Definiciones  set  exste=0
		from #Definiciones d,  #RangoTemporal2 t
		where d.nmro_unco_idntfccn= t.nmro_unco_idntfccn
		and d.cnsctvo_cdgo_rngo_vrble=rngo_vrble


		Delete From #GruposDefinitivos



		insert into #GruposDefinitivos
		select 	nmro_unco_idntfccn,		cnsctvo_cdgo_dfncn_grpo ,	
		cnsctvo_cdgo_dtlle_grpo , 	sum(exste) as ex
		FROM #Definiciones 
		group by nmro_unco_idntfccn, cnsctvo_cdgo_dfncn_grpo , cnsctvo_cdgo_dtlle_grpo 
		having sum(exste)=0

		--> Insertar los registros por beneficiario el maximo de las Definiciones por  Grupo

		Delete From	#MaxGruposDefinitivos

		insert into #MaxGruposDefinitivos
		select nmro_unco_idntfccn,	max(cnsctvo_cdgo_dfncn_grpo) ,		max(cnsctvo_cdgo_dtlle_grpo) 
		from #GruposDefinitivos
		group by nmro_unco_idntfccn

		update  #RegistrosClasificar 
		set 	grupo	=    m.cnsctvo_cdgo_dtlle_grpo			
		from	#RegistrosClasificar r inner join #MaxGruposDefinitivos m					
			on (r.nmro_unco_idntfccn	=   m.nmro_unco_idntfccn)

		Delete From	#RangoTemporal1
		From	#RangoTemporal1	a inner join	#tmp2 b
		on (a.nmro_unco_idntfccn = b.nmro_unco_idntfccn)
		Where	b.ID_Num		>=	 @contadorIni-- @contador
		and 	b.ID_Num		<=	@contadorFin


		Delete From	#tmp2
		where   ID_Num		>= @contadorIni -- @contador
		and 	ID_Num		<=@contadorFin

		set	@contadorIni	=	@contadorIni	+500
		set	@contadorFin	=	@contadorFin	+500
	end
  

------------------------SEGUNDO CICLO SOLO PARA CIAT SUCURSAL 3-----------------------------------------------------------
/*delete from #RangoTemporal1

Insert into	#RangoTemporal1
Select  nmro_unco_idntfccn,
	dscrpcn_vrble,
	tpo_rngo,
	tpo_dto,
	valor,
	cnsctvo_cdgo_vrble,
	rngo_vrble
From	#RangoTemporal
where nmro_unco_idntfccn  in (select nmro_unco_idntfccn 
								 from #RegistrosClasificarFinal where nmro_unco_idntfccn_aprtnte = 30043100 
								 and cnsctvo_scrsl_ctznte  = 3
								 group by nmro_unco_idntfccn   )

delete from #RangoTemporal2
Insert into #RangoTemporal2
Select  nmro_unco_idntfccn,
	dscrpcn_vrble,
	tpo_rngo,
	tpo_dto,
	valor,
	cnsctvo_cdgo_vrble,
	rngo_vrble
From	#RangoTemporal1

Delete from #RangoTemporal2

Insert Into 	#tmp2
Select  nmro_unco_idntfccn
From	(select 	 nmro_unco_idntfccn
	 From	#RangoTemporal1
	 Group by nmro_unco_idntfccn ) tmpnuiApro

Select  @lnValorTotal	=	isnull(max(ID_Num),0)  from #tmp2
Set	@contadorIni	=	1
SEt	@contadorFin	=	500



while @contadorIni<=@lnValorTotal
	begin
		
		
		Delete from #RangoTemporal2

		insert into #RangoTemporal2
		Select	a.nmro_unco_idntfccn,dscrpcn_vrble,
			tpo_rngo,	tpo_dto,	
			valor,		cnsctvo_cdgo_vrble,
			rngo_vrble
		FRom	#RangoTemporal1	a inner join #tmp2 b
			on (a.nmro_unco_idntfccn =	b.nmro_unco_idntfccn)
		Where	b.ID_Num		>=	 @contadorIni-- @contador
		and 	b.ID_Num		<=@contadorFin



		Delete From	#Definiciones
	
		Insert into #Definiciones													
		Select 	distinct nmro_unco_idntfccn ,	t.cnsctvo_cdgo_rngo_vrble ,
			cnsctvo_cdgo_dfncn_grpo ,	cnsctvo_cdgo_dtlle_grpo ,	'1' 		
		from	#DefinicionesTemporales t , #RangoTemporal2	r
        where cnsctvo_cdgo_dtlle_grpo between 359  and 368

		update #Definiciones  set  exste=0
		from #Definiciones d,  #RangoTemporal2 t
		where d.nmro_unco_idntfccn= t.nmro_unco_idntfccn
		and d.cnsctvo_cdgo_rngo_vrble=rngo_vrble


		Delete From #GruposDefinitivos



		insert into #GruposDefinitivos
		select 	nmro_unco_idntfccn,		cnsctvo_cdgo_dfncn_grpo ,	
		cnsctvo_cdgo_dtlle_grpo , 	sum(exste) as ex
		FROM #Definiciones 
		group by nmro_unco_idntfccn, cnsctvo_cdgo_dfncn_grpo , cnsctvo_cdgo_dtlle_grpo 
		having sum(exste)=0

		--> Insertar los registros por beneficiario el maximo de las Definiciones por  Grupo

		Delete From	#MaxGruposDefinitivos

		insert into #MaxGruposDefinitivos
		select nmro_unco_idntfccn,	max(cnsctvo_cdgo_dfncn_grpo) ,		max(cnsctvo_cdgo_dtlle_grpo) 
		from #GruposDefinitivos
		group by nmro_unco_idntfccn

		update  #RegistrosClasificar 
		set 	grupo	=    m.cnsctvo_cdgo_dtlle_grpo			
		from	#RegistrosClasificar r inner join #MaxGruposDefinitivos m					
			on (r.nmro_unco_idntfccn	=   m.nmro_unco_idntfccn)

		Delete From	#RangoTemporal1
		From	#RangoTemporal1	a inner join	#tmp2 b
		on (a.nmro_unco_idntfccn = b.nmro_unco_idntfccn)
		Where	b.ID_Num		>=	 @contadorIni-- @contador
		and 	b.ID_Num		<=	@contadorFin


		Delete From	#tmp2
		where   ID_Num		>= @contadorIni -- @contador
		and 	ID_Num		<=@contadorFin

		set	@contadorIni	=	@contadorIni	+500
		set	@contadorFin	=	@contadorFin	+500
	end
  */

------------------------------------------------------------------------------------

drop Table #Definiciones
drop Table #GruposDefinitivos
drop Table  #Variables
drop Table  #DefinicionesTemporales
drop Table  #RangosVariables
drop Table #RangoTemporal
drop table #MaxGruposDefinitivos
drop table #RegistrosVariables


--------------------------------------------------------------------------------------------






