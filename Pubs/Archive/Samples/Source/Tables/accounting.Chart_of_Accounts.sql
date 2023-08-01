CREATE TABLE [accounting].[Chart_of_Accounts]
(
[id] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [accounting].[Chart_of_Accounts] ADD CONSTRAINT [PK__Chart_of__3213E83FE903E3B3] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Chart_of_Accounts] ADD CONSTRAINT [UQ__Chart_of__737584F6B2A5ADFA] UNIQUE NONCLUSTERED ([Name])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Chart_of_Accounts', 'COLUMN', N'Name'
GO
