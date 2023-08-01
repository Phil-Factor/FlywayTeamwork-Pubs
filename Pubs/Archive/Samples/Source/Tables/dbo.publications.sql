CREATE TABLE [dbo].[publications]
(
[Publication_id] [dbo].[tid] NOT NULL,
[title] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NULL,
[notes] [nvarchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [pub_NowDefault] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED ([Publication_id])
GO
CREATE NONCLUSTERED INDEX [pubid_index] ON [dbo].[publications] ([pub_id])
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [fkPublishers] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This lists every publication marketed by the distributor', 'SCHEMA', N'dbo', 'TABLE', N'publications', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'any notes about this publication', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'notes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the legacy publication key', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'pub_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date that it was published', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'pubdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Publications Table', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'Publication_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the title of the publicxation', 'SCHEMA', N'dbo', 'TABLE', N'publications', 'COLUMN', N'title'
GO
