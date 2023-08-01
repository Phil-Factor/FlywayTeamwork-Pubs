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
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED ([stor_id], [ord_num], [title_id])
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales] ([title_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Stores] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[publications] ([Publication_id]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are the sales of every edition of every publication', 'SCHEMA', N'dbo', 'TABLE', N'sales', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the date of the order', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'ord_date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the reference to the order', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'ord_num'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the pay terms', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'payterms'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the quantity ordered', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'qty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The store for which the sales apply', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'stor_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the title', 'SCHEMA', N'dbo', 'TABLE', N'sales', 'COLUMN', N'title_id'
GO
