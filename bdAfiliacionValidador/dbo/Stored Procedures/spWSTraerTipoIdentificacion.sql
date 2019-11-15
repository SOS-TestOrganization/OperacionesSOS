
CREATE procedure [dbo].[spWSTraerTipoIdentificacion]

@lcCodigoTipoIdentificacion	udtTipoIdentificacion

as

exec spPmTraerTiposIdentificacion null,null,@lcCodigoTipoIdentificacion,null,null


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerTipoIdentificacion] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerTipoIdentificacion] TO [webusr]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSTraerTipoIdentificacion] TO [Consultor Servicio al Cliente]
    AS [dbo];

