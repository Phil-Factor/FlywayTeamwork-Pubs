CREATE TABLE [dbo].[discounts]
(
[discounttype] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[lowqty] [smallint] NULL,
[highqty] [smallint] NULL,
[discount] [decimal] (4, 2) NOT NULL,
[Discount_id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED ([Discount_id])
GO
CREATE NONCLUSTERED INDEX [Storid_index] ON [dbo].[discounts] ([stor_id])
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [FK__discounts__store] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'These are the discounts offered by the sales people for bulk orders', 'SCHEMA', N'dbo', 'TABLE', N'discounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the percentage discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'discount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Discounts Table', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'Discount_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The type of discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'discounttype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The highest order quantity for which the discount applies', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'highqty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The lowest order quantity for which the discount applies', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'lowqty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The store that has the discount', 'SCHEMA', N'dbo', 'TABLE', N'discounts', 'COLUMN', N'stor_id'
GO
