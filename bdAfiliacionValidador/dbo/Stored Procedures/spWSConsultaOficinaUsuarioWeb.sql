CREATE PROCEDURE [dbo].[spWSConsultaOficinaUsuarioWeb] 
@lgn_usro	char(30)
AS

Select		a.cnsctvo_cdgo_ofcna,		b.cdgo_ofcna,		b.dscrpcn_ofcna
From		bdSeguridad.dbo.tbUsuariosWeb			a	With(NoLock)
Inner Join	bdAfiliacionValidador.dbo.tbOficinas	b	With(NoLock)	On	a.cnsctvo_cdgo_ofcna	=	b.cnsctvo_cdgo_ofcna
Where		lgn_usro 	=	@lgn_usro


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSConsultaOficinaUsuarioWeb] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSConsultaOficinaUsuarioWeb] TO [Consultor Servicio al Cliente]
    AS [dbo];

