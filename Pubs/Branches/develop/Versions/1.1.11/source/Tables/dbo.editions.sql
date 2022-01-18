CREATE TABLE [dbo].[editions]
(
[Edition_id] [int] NOT NULL IDENTITY(1, 1),
[publication_id] [dbo].[tid] NOT NULL,
[Publication_type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__editions__Public__353DDB1D] DEFAULT ('book'),
[EditionDate] [datetime2] NOT NULL CONSTRAINT [DF__editions__Editio__3631FF56] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED  ([Edition_id])
GO
CREATE NONCLUSTERED INDEX [Publicationid_index] ON [dbo].[editions] ([publication_id])
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_edition] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_Publication_Type] FOREIGN KEY ([Publication_type]) REFERENCES [dbo].[Publication_Types] ([Publication_Type])
GO
