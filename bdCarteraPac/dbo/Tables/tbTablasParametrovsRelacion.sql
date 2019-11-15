CREATE TABLE [dbo].[tbTablasParametrovsRelacion] (
    [tbla_prmtro]    VARCHAR (100) NOT NULL,
    [tbla_rlcn]      VARCHAR (100) NOT NULL,
    [cmpo_rlcn]      VARCHAR (100) NOT NULL,
    [bse_dts]        VARCHAR (100) NOT NULL,
    [opcn_mnu]       VARCHAR (100) NOT NULL,
    [cmpo_llve_rlcn] VARCHAR (100) NOT NULL,
    CONSTRAINT [Pk_tbTablasParametrovsRelacion] PRIMARY KEY CLUSTERED ([tbla_prmtro] ASC, [tbla_rlcn] ASC, [cmpo_rlcn] ASC)
);


GO
CREATE STATISTICS [tbla_prmtro]
    ON [dbo].[tbTablasParametrovsRelacion]([tbla_prmtro]);


GO
CREATE STATISTICS [tbla_rlcn]
    ON [dbo].[tbTablasParametrovsRelacion]([tbla_rlcn]);


GO
CREATE STATISTICS [cmpo_rlcn]
    ON [dbo].[tbTablasParametrovsRelacion]([cmpo_rlcn]);


GO
CREATE STATISTICS [bse_dts]
    ON [dbo].[tbTablasParametrovsRelacion]([bse_dts]);


GO
CREATE STATISTICS [opcn_mnu]
    ON [dbo].[tbTablasParametrovsRelacion]([opcn_mnu]);


GO
CREATE STATISTICS [cmpo_llve_rlcn]
    ON [dbo].[tbTablasParametrovsRelacion]([cmpo_llve_rlcn]);

