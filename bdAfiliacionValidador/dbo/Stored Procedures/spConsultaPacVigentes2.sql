
CREATE   PROCEDURE spConsultaPacVigentes2
@nmro_idntfccn    numeric(12),
@cnsctvo_bnfcro   int
AS

set nocount on
declare @nmro_idntfccn_n varchar(23)

set @nmro_idntfccn_n  = convert(varchar(23), @nmro_idntfccn)

select  c.cnsctvo_cdgo_tpo_idntfccn as tpo_idntfccn, c.nmro_idntfccn as nmro_idntfccn, b.cnsctvo_bnfcro, 
	b.cnsctvo_cdgo_tpo_idntfccn as tpo_idntfccn_bnfcro, b.nmro_idntfccn as nmro_idntfccn_bnfcro
from bdAfiliacionValidador..tbContratosValidador c,bdAfiliacionValidador..tbBeneficiariosValidador b
where c.cnsctvo_cdgo_tpo_cntrto=b.cnsctvo_cdgo_tpo_cntrto
and   c.nmro_cntrto=b.nmro_cntrto
and   c.nmro_idntfccn=@nmro_idntfccn_n
and   b.cnsctvo_cdgo_tpo_cntrto = 2
and   b.cnsctvo_bnfcro=@cnsctvo_bnfcro
and   getdate() between b.inco_vgnca_bnfcro  and b.fn_vgnca_bnfcro 
and   getdate() between c.inco_vgnca_cntrto  and c.fn_vgnca_cntrto

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaPacVigentes2] TO [Consultor Servicio al Cliente]
    AS [dbo];

