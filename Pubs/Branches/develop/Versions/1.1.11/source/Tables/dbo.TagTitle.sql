CREATE TABLE [dbo].[TagTitle]
(
[TagTitle_ID] [int] NOT NULL IDENTITY(1, 1),
[title_id] [dbo].[tid] NOT NULL,
[Is_Primary] [bit] NOT NULL CONSTRAINT [NotPrimary] DEFAULT ((0)),
[TagName_ID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [PK_TagNameTitle] PRIMARY KEY CLUSTERED  ([title_id], [TagName_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TagName_index] ON [dbo].[TagTitle] ([TagName_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Titleid_index] ON [dbo].[TagTitle] ([title_id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [fkTagname] FOREIGN KEY ([TagName_ID]) REFERENCES [dbo].[TagName] ([TagName_ID])
GO
ALTER TABLE [dbo].[TagTitle] ADD CONSTRAINT [FKTitle_id] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
