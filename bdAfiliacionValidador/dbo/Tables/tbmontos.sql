CREATE TABLE [dbo].[tbmontos] (
    [mnt_valor] MONEY         NOT NULL,
    [mnt_descr] VARCHAR (250) NOT NULL,
    CONSTRAINT [PK_tbmontos] PRIMARY KEY NONCLUSTERED ([mnt_valor] ASC)
);

