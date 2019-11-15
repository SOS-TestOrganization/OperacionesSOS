CREATE TABLE [dbo].[tbTiposServicio] (
    [cnsctvo_cdgo_tpo_srvco] INT           NOT NULL,
    [cdgo_tpo_srvco]         CHAR (3)      NOT NULL,
    [dscrpcn_tpo_srvco]      VARCHAR (150) NOT NULL,
    [fcha_crcn]              DATETIME      NOT NULL,
    [usro_crcn]              CHAR (30)     NOT NULL,
    [vsble_usro]             CHAR (1)      NOT NULL,
    CONSTRAINT [PK_tbTiposServicio] PRIMARY KEY CLUSTERED ([cnsctvo_cdgo_tpo_srvco] ASC)
);

