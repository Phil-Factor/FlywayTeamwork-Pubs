CREATE TABLE [dbo].[sales]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_num] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_date] [datetime] NOT NULL,
[qty] [smallint] NOT NULL,
[payterms] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[title_id] [dbo].[tid] NOT NULL
)
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED  ([stor_id], [ord_num], [title_id])
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales] ([title_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Stores] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
