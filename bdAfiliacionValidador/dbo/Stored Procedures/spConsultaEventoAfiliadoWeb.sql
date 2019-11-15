CREATE PROCEDURE [dbo].[spConsultaEventoAfiliadoWeb]
@lnTipoIdAfiliado	udtConsecutivo,
@lnNmroIdAfiliado	udtNumeroIdentificacionLargo,
@fcha_dsde			datetime = Null,
@fcha_hsta			datetime = Null
    
AS
set nocount on
    
declare @tutela int,
		@atep	int
    
select		@tutela = count(*)  
from		bdIpsTransaccional.dbo.tbtutela1			a	With(NoLock)
inner join	bdIpsTransaccional.dbo.tbactuanotificacion	b	With(NoLock)	On	a.cnsctvo_ntfccn			=	b.cnsctvo_ntfccn
																			and a.cnsctvo_cdgo_ofcna		=	b.cnsctvo_cdgo_ofcna              
inner join	bdIpsTransaccional.dbo.tbafiliadosmarcados	d	With(NoLock)	On  a.cnsctvo_ntfccn			=	d.cnsctvo_ntfccn
																			and a.cnsctvo_cdgo_ofcna		=	d.cnsctvo_cdgo_ofcna              
INNER JOIN	tbtiposidentificacion						e	With(NoLock)	on	b.cnsctvo_cdgo_tpo_idntfccn	=	e.cnsctvo_cdgo_tpo_idntfccn
inner join	bdIpsTransaccional.dbo.tbtutela				f	With(NoLock)	on	a.cnsctvo_ntfccn			=	f.cnsctvo_ntfccn
																			and a.cnsctvo_cdgo_ofcna		=	f.cnsctvo_cdgo_ofcna        
where		d.cnsctvo_cdgo_estdo_ntfccn!=55 and d.cnsctvo_cdgo_estdo_ntfccn!=21 -- excluyen los anulados y cerrados               
and			(nmro_idntfccn= @lnNmroIdAfiliado and b.cnsctvo_cdgo_tpo_idntfccn=@lnTipoIdAfiliado)              
and			(getdate() between fcha_fllo and fcha_vncmnto or     
			fcha_vncmnto is null or fcha_vncmnto='19000101')         
and exists	(	Select	1
				from	bdIpsTransaccional.dbo.tbDetalleDiagnosticoNotificacion	c	With(NoLock)
				where   a.cnsctvo_ntfccn		=  c.cnsctvo_ntfccn
				and		a.cnsctvo_cdgo_ofcna	=  c.cnsctvo_cdgo_ofcna
			)
  
select		@atep = count(*)  
from		bdIpsTransaccional.dbo.tbafiliadosmarcados	a	With(NoLock)
inner join  bdIpsTransaccional.dbo.tbactuanotificacion	b	With(NoLock)	On	a.cnsctvo_ntfccn		=  b.cnsctvo_ntfccn
																			and a.cnsctvo_cdgo_ofcna	=  b.cnsctvo_cdgo_ofcna
inner join	bdIpsTransaccional.dbo.tbatep				e   With(NoLock)	on	a.cnsctvo_ntfccn		=  e.cnsctvo_ntfccn
																			and a.cnsctvo_cdgo_ofcna	=  e.cnsctvo_cdgo_ofcna
where		b.cnsctvo_cdgo_tpo_idntfccn = @lnTipoIdAfiliado  
and			b.nmro_idntfccn     = @lnNmroIdAfiliado           
and			a.cnsctvo_cdgo_estdo_ntfccn in (7,11,130,131)  -- confirmado, cerrado, aceptado  
and			e.cnsctvo_cdgo_estdo_dgnstco in (3,10,9)  --  TRAMITE ARP, ACEPTADO ATEP, ACEPTADO EG  
and			a.cnsctvo_cdgo_clsfccn_evnto in (4,5)  --4 accidente de trabajo, 5 enfermedad profesional  
and			(a.fcha_ntfccn between @fcha_dsde and @fcha_hsta or @fcha_dsde is null or @fcha_hsta is null)  
and exists	(	Select	1
				from	bdIpsTransaccional.dbo.tbDetalleDiagnosticoNotificacion	c	With(NoLock)
				where   a.cnsctvo_ntfccn    =  c.cnsctvo_ntfccn
				and		a.cnsctvo_cdgo_ofcna =  c.cnsctvo_cdgo_ofcna
			)
    
select isnull(@tutela,0) as tne_ttla, isnull(@atep,0) as tne_atp



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaEventoAfiliadoWeb] TO [Analistas]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaEventoAfiliadoWeb] TO [webusr]
    AS [dbo];

