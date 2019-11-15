CREATE TABLE [dbo].[tbDetRedEmpresarial] (
    [cnsctvo_dtlle_rd_emprsrl] INT           NOT NULL,
    [cnsctvo_rd_emprsrl]       INT           NOT NULL,
    [cnsctvo_cdgo_tpo_prstdr]  INT           NOT NULL,
    [cnsctvo_cdgo_frma_vnclcn] INT           NOT NULL,
    [inco_prstcn_srvco]        DATETIME      NOT NULL,
    [fn_prstcn_srvco]          DATETIME      NOT NULL,
    [obsrvcns]                 VARCHAR (250) NULL,
    [fcha_crcn]                DATETIME      NOT NULL,
    [usro_crcn]                CHAR (30)     NOT NULL,
    [Estdo_rgstro]             CHAR (1)      NULL,
    [tme_stmp]                 BINARY (8)    NOT NULL,
    CONSTRAINT [PK_tbDetRedEmpresarial] PRIMARY KEY CLUSTERED ([cnsctvo_dtlle_rd_emprsrl] ASC, [cnsctvo_rd_emprsrl] ASC)
);


GO
CREATE STATISTICS [cnsctvo_cdgo_tpo_prstdr]
    ON [dbo].[tbDetRedEmpresarial]([cnsctvo_cdgo_tpo_prstdr]);


GO
CREATE STATISTICS [cnsctvo_cdgo_frma_vnclcn]
    ON [dbo].[tbDetRedEmpresarial]([cnsctvo_cdgo_frma_vnclcn]);


GO
CREATE STATISTICS [inco_prstcn_srvco]
    ON [dbo].[tbDetRedEmpresarial]([inco_prstcn_srvco]);


GO
CREATE STATISTICS [fn_prstcn_srvco]
    ON [dbo].[tbDetRedEmpresarial]([fn_prstcn_srvco]);


GO
CREATE STATISTICS [obsrvcns]
    ON [dbo].[tbDetRedEmpresarial]([obsrvcns]);


GO
CREATE STATISTICS [fcha_crcn]
    ON [dbo].[tbDetRedEmpresarial]([fcha_crcn]);


GO
CREATE STATISTICS [usro_crcn]
    ON [dbo].[tbDetRedEmpresarial]([usro_crcn]);


GO
CREATE STATISTICS [Estdo_rgstro]
    ON [dbo].[tbDetRedEmpresarial]([Estdo_rgstro]);


GO
CREATE STATISTICS [tme_stmp]
    ON [dbo].[tbDetRedEmpresarial]([tme_stmp]);

