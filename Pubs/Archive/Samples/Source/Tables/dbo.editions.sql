CREATE TABLE [dbo].[editions]
(
[Edition_id] [int] NOT NULL IDENTITY(1, 1),
[publication_id] [dbo].[tid] NOT NULL,
[Publication_type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__editions__Public__1F398B65] DEFAULT ('book'),
[EditionDate] [datetime2] NOT NULL CONSTRAINT [DF__editions__Editio__202DAF9E] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED ([Edition_id])
GO
CREATE NONCLUSTERED INDEX [Publicationid_index] ON [dbo].[editions] ([publication_id])
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_edition] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_Publication_Type] FOREIGN KEY ([Publication_type]) REFERENCES [dbo].[Publication_Types] ([Publication_Type])
GO
EXEC sp_addextendedproperty N'MS_Description', N'A publication can come out in several different editions, of maybe a different type', 'SCHEMA', N'dbo', 'TABLE', N'editions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Editions Table', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'Edition_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date at which this edition was created', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'EditionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the foreign key to the publication', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'publication_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of publication', 'SCHEMA', N'dbo', 'TABLE', N'editions', 'COLUMN', N'Publication_type'
GO
