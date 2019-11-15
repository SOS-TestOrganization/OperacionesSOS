CREATE TABLE [dbo].[tbEmpresas] (
    [nmro_unco_idntfccn] INT           NOT NULL,
    [rzn_scl]            VARCHAR (200) NOT NULL,
    [estdo_emprsa]       CHAR (2)      NOT NULL,
    [fcha_ultma_mdfccn]  DATETIME      NOT NULL,
    [usro_ultma_mdfccn]  CHAR (30)     NOT NULL,
    [tme_stmp]           ROWVERSION    NOT NULL
);

