
CREATE procedure spConsultaPacVigentes
@nmro_idntfccn 		varchar(25),
@cnsctvo_bnfcro		int
as


SELECT  c.cnsctvo_cdgo_tpo_idntfccn as tpo_idntfccn,c.nmro_idntfccn,b.cnsctvo_bnfcro,
	b.cnsctvo_cdgo_tpo_idntfccn as tpo_idntfccn_bnfcro,b.nmro_idntfccn as nmro_idntfccn_bnfcro, b.nmro_unco_idntfccn_afldo
from bdAfiliacionValidador..tbContratosValidador c, bdAfiliacionValidador..tbBeneficiariosValidador b
	where c.cnsctvo_cdgo_tpo_cntrto=b.cnsctvo_cdgo_tpo_cntrto
	and c.nmro_cntrto=b.nmro_cntrto
	and c.cnsctvo_cdgo_tpo_cntrto=2
	and c.nmro_idntfccn =@nmro_idntfccn
	and b.cnsctvo_bnfcro =@cnsctvo_bnfcro
	and getdate() between b.inco_vgnca_bnfcro  and b.fn_vgnca_bnfcro 
	and getdate() between c.inco_vgnca_cntrto   and c.fn_vgnca_cntrto



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaPacVigentes] TO [Consultor Servicio al Cliente]
    AS [dbo];

