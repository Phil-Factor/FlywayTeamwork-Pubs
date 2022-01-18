CREATE TABLE [dbo].[pub_info]
(
[pub_id] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL,
[logo] [varbinary] (max) NULL,
[pr_info] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED  ([pub_id])
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [FK__pub_info__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
