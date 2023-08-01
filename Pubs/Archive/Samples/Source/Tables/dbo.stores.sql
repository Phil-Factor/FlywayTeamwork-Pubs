CREATE TABLE [dbo].[stores]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_name] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[stor_address] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (40) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[stores] ADD CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED ([stor_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are all the stores who are our customers', 'SCHEMA', N'dbo', 'TABLE', N'stores', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The city in which the store is based', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The state where the store is base', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first-line address of the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The primary key to the Store Table', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'stor_name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The zipt code for the store', 'SCHEMA', N'dbo', 'TABLE', N'stores', 'COLUMN', N'zip'
GO
