CREATE TABLE [dbo].[tbTablasRelacionGeneral] (
    [tbla_rlcn]   CHAR (100) NOT NULL,
    [tbla_prmtro] CHAR (100) NOT NULL,
    [cmpo_rlcn]   CHAR (100) NOT NULL,
    [bse_dts]     CHAR (100) NULL,
    CONSTRAINT [Pk_tbTablasRelacionGeneral] PRIMARY KEY CLUSTERED ([tbla_prmtro] ASC, [tbla_rlcn] ASC, [cmpo_rlcn] ASC)
);


GO
CREATE STATISTICS [tbla_rlcn]
    ON [dbo].[tbTablasRelacionGeneral]([tbla_rlcn]);


GO
CREATE STATISTICS [cmpo_rlcn]
    ON [dbo].[tbTablasRelacionGeneral]([cmpo_rlcn]);


GO
CREATE STATISTICS [bse_dts]
    ON [dbo].[tbTablasRelacionGeneral]([bse_dts]);

