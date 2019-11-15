


CREATE procedure [dbo].[spWSTraerPlan]

@dscrpcn_pln	udtDescripcion

as

set @dscrpcn_pln = case @dscrpcn_pln
	when '00' then 'POS'
	WHEN '01' THEN 'POS'
	WHEN '02' THEN 'FAMILIAR'
	WHEN '05' THEN 'QUIMBAYA'
	WHEN '04' THEN 'EXCELENCIA'
	WHEN '07' THEN 'BIENESTAR'
    WHEN '08' THEN 'POS SUBSIDIADO'
Else @dscrpcn_pln
end


select	cnsctvo_cdgo_pln
from	tbPlanes
where	dscrpcn_pln = @dscrpcn_pln







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerPlan] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerPlan] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerPlan] TO [Consultor Servicio al Cliente]
    AS [dbo];

