CREATE   procedure spValidaPosVigente  
@tpo_idntfccn_bnfcro		int,
@nmro_idntfccn_bnfcro 		char(15)
as

declare @exste				int
--0 No existe 1 Existe
-- Cuando se encontraton mas de un registro con el mismo numero  de afiliacion (spConsultaPacVigentes2 retorna mas de un registro)
-- el audio solicita el numero de identificación del 
-- beneficiario y a partir de el se recupera el tipo de identificacion
-- del mismo, en este caso el tipo de identificacion debe ser enviado
-- en nul
-- Cuando solo se encuentra un registro para el numero de afiliacion el tipo y numero de identificacion
-- del beneficiario se recupera del cursor
set nocount on

if @tpo_idntfccn_bnfcro is null or @tpo_idntfccn_bnfcro=''
-- Recupero el tipo de identificación del beneficiario del contrato pac (tipo formulario = 3) y vigente a la fecha del sistema
	
	select @tpo_idntfccn_bnfcro = cnsctvo_cdgo_tpo_idntfccn
	from bdAfiliacionValidador..tbBeneficiariosValidador a
	where a.nmro_idntfccn 	= convert(char(15), @nmro_idntfccn_bnfcro) 	and
              	             a.cnsctvo_cdgo_tpo_cntrto =1	and
	      getdate() between a.inco_vgnca_bnfcro and a.fn_vgnca_bnfcro 

	
	-- Verifico que exista un contrato pos (tipo formulario = 1) vigente a la fecha del sistema
	if exists(select 1  from  bdAfiliacionValidador..tbBeneficiariosValidador b
	  		where	b.nmro_idntfccn 		 = @nmro_idntfccn_bnfcro  	and
        		b.cnsctvo_cdgo_tpo_idntfccn	 = @tpo_idntfccn_bnfcro		and
			b.cnsctvo_cdgo_tpo_cntrto 		 = 1 			and
			getdate() between inco_vgnca_bnfcro and fn_vgnca_bnfcro )
			set @exste = 1
			--set @exste = 0
	else
		set @exste = 0
		--set @exste = 1
select @exste as exste

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spValidaPosVigente] TO [Consultor Servicio al Cliente]
    AS [dbo];

