CREATE TABLE [dbo].[publications]
(
[Publication_id] [dbo].[tid] NOT NULL,
[title] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NULL,
[notes] [nvarchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [pub_NowDefault] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED  ([Publication_id])
GO
CREATE NONCLUSTERED INDEX [pubid_index] ON [dbo].[publications] ([pub_id])
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [fkPublishers] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
