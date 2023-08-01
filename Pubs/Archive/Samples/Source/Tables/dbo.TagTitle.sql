CREATE TABLE [dbo].[TagTitle]
(
[TagTitle_ID] [int] NOT NULL IDENTITY(1, 1),
[title_id] [dbo].[tid] NOT NULL,
[Is_Primary] [bit] NOT NULL CONSTRAINT [NotPrimary] DEFAULT ((0)),
[TagName_ID] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED ([title_id], [TagName_ID])
GO
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle] ([TagName_ID])
GO
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle] ([title_id])
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [fkTagname] FOREIGN KEY ([TagName_ID]) REFERENCES [dbo].[TagName] ([TagName_ID])
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [FKTitle_id] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This relates tags (e.g. crime) to publications so that publications can have more than one', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'is this the primary tag (e.g. ''Fiction'')', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'Is_Primary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the tagname', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagName_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the TagTitle Table', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'TagTitle_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The foreign key to the title', 'SCHEMA', N'dbo', 'TABLE', N'TagTitle', 'COLUMN', N'title_id'
GO
