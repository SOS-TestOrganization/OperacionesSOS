CREATE TABLE [dbo].[tbRedEmpresarial] (
    [cnsctvo_rd_emprsrl]        INT        NOT NULL,
    [cnsctvo_scrsl]             INT        NOT NULL,
    [nmro_unco_idntfccn_empldr] INT        NOT NULL,
    [cnsctvo_cdgo_clse_aprtnte] INT        NOT NULL,
    [fcha_crcn]                 DATETIME   NOT NULL,
    [usro_crcn]                 CHAR (30)  NOT NULL,
    [tme_stmp]                  BINARY (8) NOT NULL,
    CONSTRAINT [PK_tbRedEmpresarial] PRIMARY KEY CLUSTERED ([cnsctvo_rd_emprsrl] ASC)
);


GO
CREATE STATISTICS [cnsctvo_scrsl]
    ON [dbo].[tbRedEmpresarial]([cnsctvo_scrsl]);


GO
CREATE STATISTICS [nmro_unco_idntfccn_empldr]
    ON [dbo].[tbRedEmpresarial]([nmro_unco_idntfccn_empldr]);


GO
CREATE STATISTICS [cnsctvo_cdgo_clse_aprtnte]
    ON [dbo].[tbRedEmpresarial]([cnsctvo_cdgo_clse_aprtnte]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbRedEmpresarial]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbRedEmpresarial]([usro_crcn]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbRedEmpresarial]([tme_stmp]);

