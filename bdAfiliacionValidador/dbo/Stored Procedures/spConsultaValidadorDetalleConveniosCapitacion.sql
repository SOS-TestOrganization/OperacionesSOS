CREATE PROCEDURE [dbo].[spConsultaValidadorDetalleConveniosCapitacion](
    @cnsctvo_cdgo_tpo_cntrto	UdtConsecutivo,
    @nmro_cntrto				UdtNumeroFormulario,
    @cnsctvo_bnfcro				UdtConsecutivo,
    @nui_afldo					UdtConsecutivo,
    @fcha_vldcn					DATETIME
)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @tmpCapitacionContrato TABLE (	
        dscrpcn_cnvno					varchar(150) null,
		cdgo_cnvno						numeric null,
		estado							varchar(20) not null,
		capitado						char not null,
		fcha_crte						datetime null,
       	cdgo_cdd						char(8) null,
       	cdgo_ips 						char(8) null,
       	dscrpcn_cdd						varchar(150) null, 
		dscrpcn_ips						varchar(150) null,
		cnsctvo_cdgo_cdd				int null,
		cnsctvo_cdgo_tpo_cntrto			int,
		nmro_cntrto						char(15),
		cnsctvo_bnfcro					int,
		nmro_idntfccn_ips				VarChar(30)
	);

    DECLARE	@tmpCondicion TABLE (
        cdgo_tpo_escnro 	CHAR(3), 
	    cdgo_itm_cptcn		CHAR(3),
	    cndcn			    VARCHAR(3000), 
	    dscrpcn_itm_cptcn	VARCHAR(500),
	    accion 			    VARCHAR(50)
    );

    INSERT INTO @tmpCapitacionContrato (
        dscrpcn_cnvno,				estado,				dscrpcn_ips,					cdgo_cnvno,					capitado,
        fcha_crte,					cdgo_cdd,			dscrpcn_cdd,					cdgo_ips,					cnsctvo_cdgo_cdd,
        cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,		cnsctvo_bnfcro,					nmro_idntfccn_ips
    )  
    EXEC [dbo].[spPmConsultaDetConveniosCapitacionAfiliado] @cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto,
                                                            @nmro_cntrto				= @nmro_cntrto,
                                                            @cnsctvo_bnfcro				= @cnsctvo_bnfcro,
                                                            @nui_afldo					= @nui_afldo,
                                                            @fcha_vldcn                 = @fcha_vldcn;

    SELECT	dscrpcn_cnvno,				estado,			dscrpcn_ips,		cdgo_cnvno,				capitado,
       		fcha_crte,					cdgo_cdd,		dscrpcn_cdd,		cdgo_ips,				cnsctvo_cdgo_cdd,
			cnsctvo_cdgo_tpo_cntrto,	nmro_cntrto,	cnsctvo_bnfcro,		nmro_idntfccn_ips
    FROM	@tmpCapitacionContrato;

    DECLARE @cdgo_cnvno	        NUMERIC,
			@cnsctvo_cdgo_cdd   INT,
            @fcha_actl          DATETIME = GETDATE();

    DECLARE curConvenios CURSOR LOCAL FAST_FORWARD FOR 
	SELECT	cdgo_cnvno, @cnsctvo_cdgo_cdd
	FROM	@tmpCapitacionContrato;
	
	OPEN curConvenios;
	
	FETCH NEXT FROM curConvenios INTO @cdgo_cnvno, @cnsctvo_cdgo_cdd;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
        INSERT INTO @tmpCondicion
        EXEC [dbo].[spPmValidaServiciosCapitadosCaja]  @cdgo_cnvno				= @cdgo_cnvno,
                                                       @cnsctvo_cdgo_cdd		= @cnsctvo_cdgo_cdd,
                                                       @nui					    = @nui_afldo,
                                                       @cnsctvo_cdgo_tpo_cntrto	= @cnsctvo_cdgo_tpo_cntrto, 
                                                       @fcha_vldccn				= @fcha_actl;
		
        SELECT  @cdgo_cnvno AS cdgo_cnvno,  
                @cnsctvo_cdgo_cdd AS cnsctvo_cdgo_cdd,
                cdgo_tpo_escnro,    cdgo_itm_cptcn,     cndcn,
	            dscrpcn_itm_cptcn,  accion
        FROM    @tmpCondicion;

		DELETE FROM @tmpCondicion;

		FETCH NEXT FROM curConvenios INTO @cdgo_cnvno, @cnsctvo_cdgo_cdd;
	END	
	
	CLOSE curConvenios;
	DEALLOCATE curConvenios;
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spConsultaValidadorDetalleConveniosCapitacion] TO [webusr]
    AS [dbo];

