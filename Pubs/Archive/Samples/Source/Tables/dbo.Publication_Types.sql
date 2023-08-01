CREATE TABLE [dbo].[Publication_Types]
(
[Publication_Type] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[Publication_Types] ADD CONSTRAINT [PK__Publicat__66D9D2B3FB0C9D95] PRIMARY KEY CLUSTERED ([Publication_Type])
GO
EXEC sp_addextendedproperty N'MS_Description', N'An edition can be one of several types', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Publication_Types', 'COLUMN', N'Publication_Type'
GO
