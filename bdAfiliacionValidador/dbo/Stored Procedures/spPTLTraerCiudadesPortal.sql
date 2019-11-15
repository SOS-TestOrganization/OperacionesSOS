/*---------------------------------------------------------------------------------
* Metodo o PRG 	             	  :  [spPTLTraerCiudadesPortal]
* Desarrollado por		  : <\A Ing.  	Soluciones Informaticas				A\>
* Descripcion			  : <\D Trae la descripcion de las ciudades	para el portal				D\>
* Observaciones		          	  : <\O										O\>
* Parametros			  : <\P  										P\>
* Variables			  : <\V  										V\>
* Fecha Creacion	          	  : <\FC 2015/06/24								FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------
* Modificado Por		:<\AM  Ing. Warner Valencia -  gerniarwva AM\>
* Descripcion			: <\DM  Cambio temporal solicitado por el usuario para que 
								no permita hacer cambio de IPS en la ciudad de Cali DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2019-03-06 FM\>
*---------------------------------------------------------------------------------
 
* Modificado Por		:<\AM  Ing. Warner Valencia -  gerniarwva AM\>
* Descripcion			: <\DM  Se reversa el cambio anterior  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2019-03-07 FM\>
*---------------------------------------------------------------------------------
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
--exec [spPTLTraerCiudadesPortal] null,'',NULL,NULL,17 2 

CREATE PROCEDURE [dbo].[spPTLTraerCiudadesPortal]  
@lcCodigoCiudad		udtCiudad	= NULL,
@lcDescripcionCiudad		udtDescripcion	= NULL,
@ldFechaActual			datetime	= NULL,
@vsble_usro			udtLogico	= NULL,
@lnConsecDpto			udtConsecutivo  = NULL	
AS
BEGIN


Set Nocount On


	Declare @vsble char(1)


If  @ldFechaActual Is Null
    Set @ldFechaActual = GetDate()


	Set @vsble ='S'

CREATE TABLE #tmppciudadesportal(
	[cdgo_cdd] [char](8) ,
	[dscrpcn_cdd] [varchar](150) ,
	[dscrpcn_cdd_prtl] [varchar](303)  ,
	[cnsctvo_cdgo_dprtmnto] [int] ,
	[dscrpcn_dprtmnto] [varchar](150) ,
	[cnsctvo_cdgo_cdd] [int] ,
	[cnsctvo_cdgo_sde] [int] ,
	[cdgo_sde] [char](3) ,
	[dscrpcn_sde] [varchar](150) 
)  

CREATE TABLE #tmpciudadesportalFinal(
    [id]   int identity (1,1),
	[cdgo_cdd] [char](8) ,
	[dscrpcn_cdd] [varchar](150) ,
	[dscrpcn_cdd_prtl] [varchar](303)  ,
	[cnsctvo_cdgo_dprtmnto] [int] ,
	[dscrpcn_dprtmnto] [varchar](150) ,
	[cnsctvo_cdgo_cdd] [int] ,
	[cnsctvo_cdgo_sde] [int] ,
	[cdgo_sde] [char](3) ,
	[dscrpcn_sde] [varchar](150) 
	
)

If @lnConsecDpto is not null
    Begin 
        If @lcCodigoCiudad is null
	Begin
	      If  @lcDescripcionCiudad IS NULL or @lcDescripcionCiudad = '+'
		--Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente.
		Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde--, a.cnsctvo_cbcra_mncpl, d.dscrpcn_cdd as dscrpcn_cbcra_mncpl,a.cnsctvo_cdgo_clsfccn_ggrfca
		From	bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock) inner join 
                        bdAfiliacionValidador.dbo.tbDepartamentos b with (nolock) on
			a.cnsctvo_cdgo_dprtmnto		= b.cnsctvo_cdgo_dprtmnto
                        inner join bdAfiliacionValidador.dbo.tbsedes_vigencias  c with (nolock) on
		 	a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
		inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock)
		on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
		Where	(@ldFechaActual  between a.inco_vgnca   And   a. fn_vgnca)
		And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
		And	(a.Vsble_Usro  = @vsble 	or 	@vsble_usro = @vsble)
		And	a.cnsctvo_cdgo_dprtmnto 	= @lnConsecDpto
		order by 2
   	      Else
		--Selecciona todos los registros de la tabla  tbciudades dentro de un rango vigente y donde el campo descripcionciudad sea el parametro de consulta.

		Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde
		From	bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock) inner join 
                        bdAfiliacionValidador.dbo.tbDepartamentos b with (nolock) on
			a.cnsctvo_cdgo_dprtmnto		= b.cnsctvo_cdgo_dprtmnto
                        inner join bdAfiliacionValidador.dbo.tbsedes_vigencias c with (nolock) on
		 	a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
		inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock)
		on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
		Where	(@ldFechaActual  between a.inco_vgnca        And   a.fn_vgnca) 
		And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
		And	a.dscrpcn_cdd like  '%' + ltrim(rtrim(@lcDescripcionCiudad) + '%' ) 
		And	a.cnsctvo_cdgo_dprtmnto	 	= @lnConsecDpto
		And	(a.Vsble_Usro  = @vsble 	or 	@vsble_usro = @vsble)
		order by 2
            End
         Else 
             --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.
	  Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde
		From	bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock) inner join 
                        bdAfiliacionValidador.dbo.tbDepartamentos b  with (nolock) on
			a.cnsctvo_cdgo_dprtmnto		= b.cnsctvo_cdgo_dprtmnto
                        inner join bdAfiliacionValidador.dbo.tbsedes_vigencias c with (nolock)  on
		 	a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
		inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock) 
		on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
	    Where	(@ldFechaActual  between a.inco_vgnca    And    a. fn_vgnca)
		And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
	    And	a.cdgo_cdd  =  @lcCodigoCiudad
	   And	(a.Vsble_Usro  = @vsble or @vsble_usro = @vsble)
	   And	a.cnsctvo_cdgo_dprtmnto 	= @lnConsecDpto
	   order by 2
       End	
 Else
	Begin 
	If @lcCodigoCiudad is null
		Begin	
	  	If  @lcDescripcionCiudad IS NULL
		   --Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.
		   Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde
			From	bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock)  inner join 
                        bdAfiliacionValidador.dbo.tbDepartamentos b with (nolock)  on
			a.cnsctvo_cdgo_dprtmnto		= b.cnsctvo_cdgo_dprtmnto
                        inner join bdAfiliacionValidador.dbo.tbsedes_vigencias c with (nolock)  on
		 	a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
			inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock) 
		    on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
			Where	(@ldFechaActual  between a.inco_vgnca    And    a. fn_vgnca)
			And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
--				And	cdgo_cdd  =  @lcCodigoCiudad
				And	(a.Vsble_Usro  = @vsble or @vsble_usro = @vsble)
			order by 2
             		 Else 
     	             		--Selecciona todos los registros de la tabla  tbciudades dentro de un rango vigente y donde el campo descripcionciudad sea el parametro de consulta.
		Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde
		From	bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock)  inner join 
                        bdAfiliacionValidador.dbo.tbDepartamentos b with (nolock)  on
			a.cnsctvo_cdgo_dprtmnto		= b.cnsctvo_cdgo_dprtmnto
                        inner join bdAfiliacionValidador.dbo.tbsedes_vigencias c with (nolock)  on
		 	a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
			inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock) 
		    on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
			Where	(@ldFechaActual  between a.inco_vgnca    And    a. fn_vgnca)
			And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
				And	a.dscrpcn_cdd like  '%' + ltrim(rtrim(@lcDescripcionCiudad) + '%' ) 
				And	(a.Vsble_Usro  = @vsble 	or 	@vsble_usro = @vsble)
			order by 2

		End
   	Else
		--Selecciona todos los registros de  la tabla  tbciudades dentro de un rango vigente y donde el parametro de consulta [codigo] sea igual a @lcCodigoCiudad.
		Insert Into #tmppciudadesportal
		([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde] )
		Select	a.cdgo_cdd, 
		        a.dscrpcn_cdd, 
				case when a.cnsctvo_cdgo_clsfccn_ggrfca  = 1  then  ltrim(rtrim(a.dscrpcn_cdd)) 
	                 when a.cnsctvo_cdgo_clsfccn_ggrfca != 1 then ltrim(rtrim(a.dscrpcn_cdd)) + ' - ' + ltrim(rtrim(d.dscrpcn_cdd))  end dscrpcn_cdd_prtl,
			b.cnsctvo_cdgo_dprtmnto,
			(b.dscrpcn_dprtmnto) dscrpcn_dprtmnto,
			(a.cnsctvo_cdgo_cdd) cnsctvo_cdgo_cdd,
			c.cnsctvo_cdgo_sde,	
			c.cdgo_sde,	
			c.dscrpcn_sde
		FROM		bdAfiliacionValidador.dbo.tbCiudades_Vigencias a with (nolock) 
		INNER JOIN	bdAfiliacionValidador.dbo.tbDepartamentos b with (nolock) 
		ON		a.cnsctvo_cdgo_dprtmnto	= b.cnsctvo_cdgo_dprtmnto
		INNER JOIN	bdAfiliacionValidador.dbo.tbsedes_vigencias c with (nolock) 
		ON		a.cnsctvo_sde_inflnca 		= c.cnsctvo_cdgo_sde
		inner join bdAfiliacionValidador.dbo.tbCiudades_Vigencias d with (nolock) 
		    on a.cnsctvo_cbcra_mncpl = d.cnsctvo_cdgo_cdd
		WHERE	a.cdgo_cdd			= @lcCodigoCiudad
		AND		(@ldFechaActual  BETWEEN a.inco_vgnca    AND    a. fn_vgnca)
		And (@ldFechaActual  between d.inco_vgnca   And   d. fn_vgnca)
		AND		(a.Vsble_Usro  = @vsble 	OR 	@vsble_usro = @vsble)
		order by 2
	End

	--- De acuerdo a la solicitud de Sponsor del proyecto ya que la mayoría de la poblacion es de la ciudad de Cali debe filtrarse de primera para el combo de ciudades 
	Insert Into #tmpCiudadesPortalFinal  
	    ([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde])
	select 	[cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		'CALI' as [dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde]
	from #tmppciudadesportal
	where cnsctvo_cdgo_cdd = 8112
 

 	Insert Into #tmpCiudadesPortalFinal  
	    ([cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde])
	select 	[cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde]
	from #tmppciudadesportal
	where cnsctvo_cdgo_cdd != 8112
	order by [dscrpcn_cdd_prtl] asc

	select [cdgo_cdd]  ,
		[dscrpcn_cdd] , 
		[dscrpcn_cdd_prtl] ,  
		[cnsctvo_cdgo_dprtmnto],
		[dscrpcn_dprtmnto] ,
		[cnsctvo_cdgo_cdd] ,
		[cnsctvo_cdgo_sde] ,
		[cdgo_sde] ,
		[dscrpcn_sde]
	from #tmpCiudadesPortalFinal  
	order by id asc
	
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPTLTraerCiudadesPortal] TO [portal_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPTLTraerCiudadesPortal] TO [portal_rol]
    AS [dbo];

