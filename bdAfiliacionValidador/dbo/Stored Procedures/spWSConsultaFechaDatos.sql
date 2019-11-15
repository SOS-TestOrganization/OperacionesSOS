


CREATE procedure  [dbo].[spWSConsultaFechaDatos]
@lfFechaReferencia		varchar(10) output

as

exec spPmFechaActualizacionDatos @lfFechaReferencia output



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSConsultaFechaDatos] TO PUBLIC
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spWSConsultaFechaDatos] TO [Consultor Servicio al Cliente]
    AS [dbo];

