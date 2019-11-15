
/*---------------------------------------------------------------------------------------------------------------------------------------
* Procedimiento			: spPmValidaServiciosCapitadosCaja
* Desarrollado por		:  <\A    Ing. Yasmin Ramirez						A\>
* Descripcion		 	:  <\D    Busca los items de capitacion de cada convenio 			D\>
* Observaciones		        :  <\O	Se eval£an las condiciones con los datos del afiliado en una fecha	O\>
* Parametros			:  <\P 	Convenio de capitacion del afiliado 				P\>
* 				:  <\P 	Ciudad de la ips de capitacion del convenio			P\>
* 				:  <\P 	Numero Unico de Identificacion del afiliado 			P\>
* 				:  <\P 	Tipo de Contrato del afiliado 					P\>
* 				:  <\P 	Fecha de la consulta del afiliado					P\>
* Fecha Creacion		:  <\FC  2003/09/01							FC\>
*
*---------------------------------------------------------------------------------------------------------------------------------------
* DATOS DE MODIFICACION 
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Ing. Carlos Andr‚s L¢pez Ram¡rez AM\>
* Descripci¢n			    : <\DM  DM\>
* Nuevos Parmetros	: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificaci¢n	: <\FM 2003/10/12 FM\>
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por			: <\AM Alexander Lopez Arboleda AM\>
* Descripci¢n			    : <\DM  Se inlcuye El servidor que hace el llamado, teniendo en cuenta que este mismo Sp se llama desde Temis y desde quiron,
* Cuando se llama desde Temis consulta tbs parametros de las aplicaciones de Salud en BdIpsParametros de Temis y cuando se llama desde quiron
* consulta tbs parametros de salud en bdSisalud que es la fuente de la Informacion de parametros de los sistemas de Salud. (Existe proceso backuo de bdsisalud quiron 
* que pasa las tablas a bdIPSParametros de temis // En temis consulta validacion las Aplicacion de Validadores Cajas )DM\>
* Fecha Modificaci¢n	: <\FM 2017/03/02 FM\>
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\AM  AM\>
* Descripci¢n			: <\DM Migracion a bogota DM\>
* Nuevos Parmetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificaci¢n	: <\FM 2017/11/04 FM\>
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\AM  ing Darling Liliana Dorado sisddm01 AM\>
* Descripcion			: <\DM  al final en el resultado se cambio dscrpcn_itm_cptcn por dscrpcn_itm_cptcn por 	ltrim(rtrim(dscrpcn_itm_cptcn))
								debido a que en fox salia en el campo memo. Y dscrpcn_itm_cptcn	Varchar(500) se cambio a 200 DM\>
* Nuevos Parmetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2017/11/ FM\>
*---------------------------------------------------------------------------------------------------------------------------------------
* Modificado Por		: <\AM  Ing Darling Liliana Dorado sisddm01 AM\>
* Descripcion			: <\DM   Si se tiene mas de un convenio se debe dejar el que no tiene condicion , ya que estos ocurre
								para los casos de plan familiar que alguno items no los capitan ya otros si. Si  no podemos esto el item 
								nos queda como actividad si no como capita generando confusionen el proceso (muestra los 2).
								Adicionalmente donde esta el tipo de modelo 4 (capita) se adiciona 10 (pgp) 
								Ticket 100 - 12225 de Alfonso Gironza DM\>
* Nuevos Parmetros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion	: <\FM 2018/10/17 / FM\>
*-------------------------------------------------------------------------------------------------------------------------------------*/
CREATE    procedure  [dbo].[spPmValidaServiciosCapitadosCaja]
--Declare 
@cdgo_cnvno				decimal,
@cnsctvo_cdgo_cdd			UdtConsecutivo,
@nui					UdtConsecutivo,
@cnsctvo_cdgo_tpo_cntrto		UdtConsecutivo, 
@fcha_vldccn				datetime

AS

--------------- Caso pruebas afiliado tipo Conv capita -- 
--set @cdgo_cnvno				        =  93--187--93 --187 --93 -- 187 
--set @cnsctvo_cdgo_cdd	            = 0
--set @nui					                = 34088351
--set @cnsctvo_cdgo_tpo_cntrto	    = 1
--set @fcha_vldccn				        = '20170210'
--------------------------------------------------------------
--------------- Caso pruebas afiliado tipo Conv pgp -- 
--set @cdgo_cnvno				        = 60

--set @cnsctvo_cdgo_cdd	            = 0
--set @nui					                = 31663497
--set @cnsctvo_cdgo_tpo_cntrto	    = 1
--set @fcha_vldccn				        = '20181012'
--------------------------------------------------------------

--select * from bdafiliacionValidador..TbBeneficiariosValidador where nmro_idntfccn = '14994552'

-- Declaraci¢n de variables
Declare
@cdgo_escnro 		UdtCodigo, 
@cnsctvo_cndcn  	int,
@abrr 			char(10),
@nmbre_cmpo		char(30),
@tpo_oprdr		char(2),
@vlrs_cndcn		varchar(100),
@crr			char(10),
@cnctndr		char(3),
@cdgo_itm_cptcn	char(3),
@Condiciones		varchar(1000),
@Query  		nvarchar(1000),
@Parametros  		nvarchar(1000),
@cdgo_escnro_cptcn	UdtCodigo,
@contador		int,
@fcha_fd		datetime,
@cdgo_ips		char(8),
@nmbre_srvdr	VarChar(50),
@hst_nme		VarChar(50)


Set NoCount On

--(sisatv01) Ajuste el cual los item deben ser igual al convenio del pos (2010/04/21)
if @cnsctvo_cdgo_tpo_cntrto=2
begin
	set @cnsctvo_cdgo_tpo_cntrto=1
end

-- Tabla donde se muestra los items de capitacion del convenio
Declare	@tmpCondicion table
(	cdgo_tpo_escnro 	Char(3), 
	cdgo_itm_cptcn		char(3),
	cndcn				varchar(3000), 
	dscrpcn_itm_cptcn	Varchar(200),
	accion 				varchar(50))


---- TEMIS
--Select	@nmbre_srvdr = Ltrim(Rtrim(vlr_prmtro))  
--From		bdAfiliacionValidador..tbtablaParametros  With(NoLock)
--Where	cnsctvo_prmtro = 5

Select		@hst_nme = Ltrim(Rtrim(Convert(Varchar(30), SERVERPROPERTY('machinename'))))

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Flujo Cuando la validacion se realiza en un servidor DIFERENTE a Temmis (Cso de las Aplicaciones SOS cuyas bases de dts de parametros entan en BdSisalud)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--print @hst_nme 
--print @nmbre_srvdr   
--If @hst_nme <> 'TEMIS'--@nmbre_srvdr   -- (ENTRA A CONSULTAR EN BASES DE DTS DE SERVIDOR QUIRON (BDSISALUD))
--If @hst_nme = @nmbre_srvdr   

If Exists	(	Select	1
				From	BDAfiliacionValidador.dbo.tbTablaParametros
				where	vlr_prmtro	=	@hst_nme
			)
	begin -- (ENTRA A CONSULTAR EN BASES DE DTS DE SERVIDOR TEMIS (BDIPSPARAMETROS)
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- Flujo Cuando la validacion se realiza en temmis, la base de datos fuente de parametros es BdIpsParametros
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

        set	@fcha_fd = (select max(b.fcha_fd)
        from 	BdAfiliacionValidador..tbMatrizCapitacionValidador a  with(nolock)
        Inner Join BdAfiliacionValidador..tbEscenarios_procesovalidador b  with(nolock)    On 	a.cdgo_cnvno 		= b.cdgo_cnvno
        Inner Join bdIPSParametros..tbModeloConveniosCapitacion c      on a.cdgo_cnvno = c.cdgo_mdlo_cnvno_cptcn
        where 	nmro_unco_idntfccn 	= @nui
        and cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
        and @fcha_vldccn between 	b.fcha_dsde 	and 	b.fcha_hsta
        and @fcha_vldccn between 	a.fcha_dsde 	and 	a.fcha_hsta
        and c.cnsctvo_cdgo_tpo_mdlo in ( 4, 10 ) ) -- Capitacion y PGP sisddm01 20181017


        --print 'b'
        --print @fcha_fd


        --calculo el codigo ips para calcular el consecutivo de la ciudad
        select 	@cdgo_ips			= a.cdgo_ips
        from 	BdAfiliacionValidador..tbActuarioCapitacionValidador a
        Where	@fcha_fd between a.fcha_dsde and a.fcha_hsta
        And	a.nmro_unco_idntfccn 		= @nui
        and	a.cnsctvo_cdgo_tpo_cntrto 	= @cnsctvo_cdgo_tpo_cntrto

        --calculo el consecutivo de ciudad de acuerdo al código ips
        Select	@cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd
        FROM 	tbIPSPrimarias_vigencias a Inner Join tbCiudades b On
        a.cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd 
        Where	a.cdgo_intrno			= @cdgo_ips

        insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,	dscrpcn_itm_cptcn)
        select 	cdgo_tpo_escnro, cdgo_itm_cptcn, instrccn_whre,	dscrpcn_itm_cptcn
        from	BdAfiliacionValidador..tbEscenarios_procesoValidador
        where 	cdgo_cnvno 		= @cdgo_cnvno
        and 	@fcha_vldccn 		between fcha_dsde and fcha_hsta
        and 	cnsctvo_cdgo_cdd 	= @cnsctvo_cdgo_cdd

        select 	* 
        into 	#tmpMatriz1 
        from 	BdAfiliacionValidador..tbActuarioCapitacionValidador
        where 	nmro_unco_idntfccn = @nui
        and 	cnsctvo_cdgo_tpo_cntrto  = @cnsctvo_cdgo_tpo_cntrto
        and 	convert(char(10) , @fcha_fd, 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)


        DECLARE crCapitados CURSOR FOR
        SELECT    cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn
        FROM        @tmpCondicion 

        OPEN crCapitados

        FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones

        WHILE @@FETCH_STATUS = 0
        begin
	        if ltrim(rtrim(@condiciones)) != ''
	        Begin 

            --print 'b1'

                set @query	= 'Select @contador_in = count(*) from #tmpMatriz1 where ' + ltrim(rtrim(@condiciones)) 
                Set @Parametros	= '@contador_in int output'
                exec sp_executesql @query,@Parametros,@contador_in = @contador output

		            if @contador > 0 
			            update @tmpCondicion  set accion = 'Capitacion'
			            where cdgo_itm_cptcn = @cdgo_itm_cptcn
		            else
			            update @tmpCondicion  set accion = 'Actividad'
			            where cdgo_itm_cptcn = @cdgo_itm_cptcn	
	        End
	        Else
			            update @tmpCondicion  set accion = 'Capitacion'
			            where cdgo_itm_cptcn = @cdgo_itm_cptcn	

                FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones
            end

            deallocate crCapitados

            drop table #tmpMatriz1

        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- sisala01 08.02.2017 vlda conv capita PGP - Si la consulta anterior de los detalles de Items de convenios tipo capita, no retorna información, busca los items en los convenios tipo Pgp
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        If @@rowcount = 0
        begin 

            --print 'b2'

            insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,	dscrpcn_itm_cptcn, accion)
            select b.cdgo_mdlo_cptn_escnro, cdgo_itm_cptcn,'' as cndcn, dscrpcn_itm_cptcn, 'Capitacion' as accion 
            from bdIPSParametros..tbDetModeloConveniosCapitacion a
            inner join bdIPSParametros..tbModeloCapitacionEscenarios b on b.cnsctvo_cdgo_mdlo_cptcn_escnro = a.cnsctvo_cdgo_mdlo_cptcn_escnro
            inner join bdIPSParametros..tbRelacionModeloCapitacionEscenariosServicios c on b.cnsctvo_cdgo_mdlo_cptcn_escnro = c.cnsctvo_cdgo_mdlo_cptcn_escnro
            inner join bdIPSParametros..tbModeloCapitacionServicios d on d.cnsctvo_cdgo_mdlo_cptcn_srvco = c.cnsctvo_cdgo_mdlo_cptcn_srvco
            inner join bdIPSParametros..tbDetModeloCapitacionServicios f on f.cnsctvo_cdgo_mdlo_cptcn_srvco = d.cnsctvo_cdgo_mdlo_cptcn_srvco
            inner join bdIPSParametros..tbItemCapitacion_vigencias g on g.cnsctvo_cdgo_itm_cptcn = f.cnsctvo_cdgo_itm_cptcn
            inner join bdIPSParametros..tbModeloConveniosCapitacion h on h.cnsctvo_cdgo_mdlo_cnvno_cptcn = a.cnsctvo_cdgo_mdlo_cnvno_cptcn
            where h.cdgo_mdlo_cnvno_cptcn =  @cdgo_cnvno
            and @fcha_vldccn  between a.inco_vgnca and a.fn_vgnca
            and  @fcha_vldccn between c.inco_vgnca and c.fn_vgnca
            and  @fcha_vldccn between b.inco_vgnca and b.fn_vgnca
            and  @fcha_vldccn between d.inco_vgnca and d.fn_vgnca
            and  @fcha_vldccn between f.inco_vgnca and f.fn_vgnca
            and  @fcha_vldccn between g.inco_vgnca and g.fn_vgnca
            and  @fcha_vldccn between h.inco_vgnca and h.fn_vgnca
            and h.cnsctvo_cdgo_tpo_mdlo in (10) -- Capitacion Pgp

        end
	end
Else
	begin	-- (ENTRA A CONSULTAR EN BASES DE DTS DE SERVIDOR QUIRON (BDSISALUD))
		--print 'a'
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- Valido el tipo de convenio para direccionar la consulta de los servicios capitados, Si el convenio es de tipo Capita se consulta la fecha 
        -- de generacion del proceso en tbEscenarios_procesovalidador de lo contario si la capita es de pago fijo Pgp, se debe consultar 
        -- de la fecha de vigencia registrada en el actuario de capitacion, con la cual se cargo manualmente el registro del afialido
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- Calculo la fecha fuente de datos para luego calcular el cdgo ips para los tipo modelo de covenios 4
        set	@fcha_fd = (select max(b.fcha_fd)
        from 	BdAfiliacionValidador..tbMatrizCapitacionValidador a  with(nolock)
        Inner Join BdAfiliacionValidador..tbEscenarios_procesovalidador b  with(nolock)    On 	a.cdgo_cnvno 		= b.cdgo_cnvno
        Inner Join bdsisalud..tbModeloConveniosCapitacion c      on a.cdgo_cnvno = c.cdgo_mdlo_cnvno_cptcn
        where 	nmro_unco_idntfccn 	= @nui
        and cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto
        and @fcha_vldccn between 	b.fcha_dsde 	and 	b.fcha_hsta
        and @fcha_vldccn between 	a.fcha_dsde 	and 	a.fcha_hsta
        and c.cnsctvo_cdgo_tpo_mdlo in ( 4, 10 ) ) -- Capitacion y PGP sisddm01 20181017

        --PRINT @fcha_fd

        --calculo el codigo ips para calcular el consecutivo de la ciudad
        select 	@cdgo_ips			= a.cdgo_ips
        from 	BdAfiliacionValidador..tbActuarioCapitacionValidador a
        Where	@fcha_fd between a.fcha_dsde and a.fcha_hsta
        And	a.nmro_unco_idntfccn 		= @nui
        and	a.cnsctvo_cdgo_tpo_cntrto 	= @cnsctvo_cdgo_tpo_cntrto

        --print @cdgo_ips

        --calculo el consecutivo de ciudad de acuerdo al código ips
        Select	@cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd
        FROM 	tbIPSPrimarias_vigencias a Inner Join tbCiudades b On
        a.cnsctvo_cdgo_cdd 		= b.cnsctvo_cdgo_cdd 
        Where	a.cdgo_intrno			= @cdgo_ips

        insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,	dscrpcn_itm_cptcn)
        select 	cdgo_tpo_escnro, cdgo_itm_cptcn, instrccn_whre,	dscrpcn_itm_cptcn
        from	BdAfiliacionValidador..tbEscenarios_procesoValidador
        where 	cdgo_cnvno 		= @cdgo_cnvno
        and 	@fcha_vldccn 		between fcha_dsde and fcha_hsta
        and 	cnsctvo_cdgo_cdd 	= @cnsctvo_cdgo_cdd

        select 	* 
        into 	#tmpMatriz 
        from 	BdAfiliacionValidador..tbActuarioCapitacionValidador
        where 	nmro_unco_idntfccn = @nui
        and 	cnsctvo_cdgo_tpo_cntrto  = @cnsctvo_cdgo_tpo_cntrto
        and 	convert(char(10) , @fcha_fd, 111) between convert(char(10), fcha_dsde, 111)  and convert(char(10), fcha_hsta, 111)


        DECLARE crCapitados CURSOR FOR
        SELECT    cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn
        FROM        @tmpCondicion 

        OPEN crCapitados

        FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones

        WHILE @@FETCH_STATUS = 0
        begin
	            if ltrim(rtrim(@condiciones)) != ''
	            Begin 

                --print 'a1'

                    set @query	= 'Select @contador_in = count(*) from #tmpMatriz where ' + ltrim(rtrim(@condiciones)) 
                    Set @Parametros	= '@contador_in int output'
                    exec sp_executesql @query,@Parametros,@contador_in = @contador output

		                if @contador > 0 
			                update @tmpCondicion  set accion = 'Capitacion'
			                where cdgo_itm_cptcn = @cdgo_itm_cptcn
		                else
			                update @tmpCondicion  set accion = 'Actividad'
			                where cdgo_itm_cptcn = @cdgo_itm_cptcn	
	            End
	            Else
			                update @tmpCondicion  set accion = 'Capitacion'
			                where cdgo_itm_cptcn = @cdgo_itm_cptcn	

                 FETCH NEXT FROM crCapitados into @cdgo_escnro, @cdgo_itm_cptcn, @Condiciones
        end

        deallocate crCapitados
        drop table #tmpMatriz
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- sisala01 08.02.2017 vlda conv capita PGP - Si la consulta anterior de los detalles de Items de convenios tipo capita, no retorna información, busca los items en los convenios tipo Pgp
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        If @@rowcount = 0
        begin 

            --print 'a2'

            insert 	into @tmpCondicion (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,	dscrpcn_itm_cptcn, accion)
            select b.cdgo_mdlo_cptn_escnro, cdgo_itm_cptcn,'' as cndcn, dscrpcn_itm_cptcn, 'Capitacion' as accion 
            from bdsisalud..tbDetModeloConveniosCapitacion a
            inner join bdsisalud..tbModeloCapitacionEscenarios b on b.cnsctvo_cdgo_mdlo_cptcn_escnro = a.cnsctvo_cdgo_mdlo_cptcn_escnro
            inner join bdsisalud..tbRelacionModeloCapitacionEscenariosServicios c on b.cnsctvo_cdgo_mdlo_cptcn_escnro = c.cnsctvo_cdgo_mdlo_cptcn_escnro
            inner join bdsisalud..tbModeloCapitacionServicios d on d.cnsctvo_cdgo_mdlo_cptcn_srvco = c.cnsctvo_cdgo_mdlo_cptcn_srvco
            inner join bdsisalud..tbDetModeloCapitacionServicios f on f.cnsctvo_cdgo_mdlo_cptcn_srvco = d.cnsctvo_cdgo_mdlo_cptcn_srvco
            inner join bdsisalud..tbItemCapitacion_vigencias g on g.cnsctvo_cdgo_itm_cptcn = f.cnsctvo_cdgo_itm_cptcn
            inner join bdSisalud.dbo.tbModeloConveniosCapitacion h on h.cnsctvo_cdgo_mdlo_cnvno_cptcn = a.cnsctvo_cdgo_mdlo_cnvno_cptcn
            where h.cdgo_mdlo_cnvno_cptcn =  @cdgo_cnvno
            and @fcha_vldccn  between a.inco_vgnca and a.fn_vgnca
            and  @fcha_vldccn between c.inco_vgnca and c.fn_vgnca
            and  @fcha_vldccn between b.inco_vgnca and b.fn_vgnca
            and  @fcha_vldccn between d.inco_vgnca and d.fn_vgnca
            and  @fcha_vldccn between f.inco_vgnca and f.fn_vgnca
            and  @fcha_vldccn between g.inco_vgnca and g.fn_vgnca
            and  @fcha_vldccn between h.inco_vgnca and h.fn_vgnca
            and h.cnsctvo_cdgo_tpo_mdlo in (10) -- Capitacion Pgp

        end
    end

/*==================================================================================================
	INICIO sisddm01 20181017
	Si se tiene mas de un convenio se debe dejar el que no tiene condicion , ya que estos ocurre
	para los casos de plan familiar que alguno items no los capitas ya otros si.
	Si  no podemos esto el item no queda como actividad si no como capita generando confusion
	en el proceso
====================================================================================================*/
	Declare	@tmpCondicionUnicos table
	(	cdgo_tpo_escnro 	Char(3),		cdgo_itm_cptcn		char(3),
		cndcn				varchar(3000), 	dscrpcn_itm_cptcn	Varchar(200))

	insert into @tmpCondicionUnicos (cdgo_tpo_escnro, cdgo_itm_cptcn, cndcn,  dscrpcn_itm_cptcn)
	select distinct cdgo_tpo_escnro,  cdgo_itm_cptcn,	cndcn,	ltrim(rtrim(dscrpcn_itm_cptcn)) as dscrpcn_itm_cptcn
	from	@tmpCondicion 


	Delete 
	from	@tmpCondicion 
	Where	cdgo_itm_cptcn in (select cdgo_itm_cptcn
									From @tmpCondicionUnicos
									group by cdgo_tpo_escnro,  cdgo_itm_cptcn, dscrpcn_itm_cptcn
									having COUNT(1)>1
							   )
	And		cndcn = ''
/*=======================================================================================
	FIN sisddm01 20181017
=======================================================================================*/

select distinct cdgo_tpo_escnro,  cdgo_itm_cptcn,	cndcn,	ltrim(rtrim(dscrpcn_itm_cptcn)) as dscrpcn_itm_cptcn,
				accion
from			@tmpCondicion  



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [vafss_role]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [310018 Auditor Salud Central]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Administrador Notificaciones Atep SOA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [outbts01]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [aut_webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [autsalud_rol]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auditor Autorizador CNA]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Coordinador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Validador de Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar Tesoreria Prestaciones Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Consultor de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Radicador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Analista Seguros Asistenciales]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Radicador de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auditor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Consultor Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Administrador de Prestaciones Economicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Coordinador Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Liquidador Facturas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Consultor de Cuentas Medicas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Autorizadora Notificacion]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar Sipres Analista Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auditoria Interna Salud]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Coordinador Juridico Notificaciones]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Consultor Servicio al Cliente]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Analista Red Servicios]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar Prestaciones Medicas y Validacion de Derechos]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spPmValidaServiciosCapitadosCaja] TO [Auxiliar de Prestaciones Centelsa]
    AS [dbo];

