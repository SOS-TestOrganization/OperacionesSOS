CREATE TABLE [dbo].[tbProcesos] (
    [cnsctvo_prcso]    [dbo].[udtConsecutivo] NOT NULL,
    [fcha_inco_prcso]  DATETIME               NOT NULL,
    [fcha_fn_prcso]    DATETIME               NULL,
    [usro]             [dbo].[udtUsuario]     NOT NULL,
    [cnsctvo_prcso_fd] [dbo].[udtConsecutivo] NULL,
    [tpo_prcso]        CHAR (1)               NULL,
    CONSTRAINT [PK_tbProcesos] PRIMARY KEY CLUSTERED ([cnsctvo_prcso] ASC)
);

