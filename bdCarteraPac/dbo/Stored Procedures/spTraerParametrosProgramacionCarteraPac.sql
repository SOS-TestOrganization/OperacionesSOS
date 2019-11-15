
/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerParametrosProgramacionCarteraPac
* Desarrollado por		: <\A Ing. rolando simbaqueva lasso									A\
* Descripcion			: <\D Este procedimiento permite recuperar la lista de los parametros  de programacion de un grupo especifico.	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P Consecutivo del grupo de parametros programacion que se desea recuperar 				P\>
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/07/04 											FC\>
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
CREATE  PROCEDURE spTraerParametrosProgramacionCarteraPac

@lnGrupoParametroProgramacion	UdtConsecutivo	= Null

As

Set Nocount On

-- Selecciona el codigo y la descripcion del(os) parametro(s) de programacion que hace(n) parte del grupo
Select	b.cdgo_prmtro_prgrmcn,		Ltrim(Rtrim(b.dscrpcn_prmtro_prgrmcn)) dscrpcn_prmtro_prgrmcn,		b.cnsctvo_cdgo_prmtro_prgrmcn
From	tbRelAgrupacionxParametrosProgramacion a,	tbParametrosProgramacionCarterapac b,	tbAgrupadoresparametrosProgramacion c
Where	a.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn	= @lnGrupoParametroProgramacion
And     a.brrdo = 'N'
And	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),a.inco_vgnca,111) And Convert(Varchar(10),a.fn_vgnca,111)
And	a.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn	= c.cnsctvo_cdgo_agrpdr_prmtro_prgrmcn
And 	c.brrdo = 'N'
And	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),c.inco_vgnca,111) And Convert(Varchar(10),c.fn_vgnca,111)
And	a.cnsctvo_cdgo_prmtro_prgrmcn		= b.cnsctvo_cdgo_prmtro_prgrmcn
And 	b.brrdo = 'N'
And	Convert(Varchar(10),Getdate(),111) Between Convert(Varchar(10),b.inco_vgnca,111) And Convert(Varchar(10),b.fn_vgnca,111)