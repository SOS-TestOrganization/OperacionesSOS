CREATE TABLE [dbo].[tbModeloExtraccionCondiciones_proceso] (
    [cnsctvo_prcso]     [dbo].[udtConsecutivo] NOT NULL,
    [cdgo_mdlo_extrccn] DECIMAL (18)           NOT NULL,
    [instrccn_slct]     VARCHAR (4000)         NOT NULL,
    [instrccn_whre]     VARCHAR (5000)         NULL,
    [cdgo_cnvno]        NUMERIC (18)           NULL,
    [nmbre_archvo]      CHAR (20)              NOT NULL,
    [adcnl]             DECIMAL (18)           NULL,
    [tpo_archvo]        CHAR (3)               NOT NULL,
    [fcha_crte]         DATETIME               NOT NULL,
    [dscrpcn]           [dbo].[udtDescripcion] NOT NULL,
    [fcha_fd]           DATETIME               NOT NULL,
    [prdcdd]            CHAR (1)               NOT NULL,
    CONSTRAINT [PK_tbModeloExtraccionCondiciones_proceso] PRIMARY KEY CLUSTERED ([cnsctvo_prcso] ASC, [cdgo_mdlo_extrccn] ASC)
);

