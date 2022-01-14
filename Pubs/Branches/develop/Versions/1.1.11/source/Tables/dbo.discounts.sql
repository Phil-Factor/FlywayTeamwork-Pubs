CREATE TABLE [dbo].[discounts]
(
[discounttype] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[lowqty] [smallint] NULL,
[highqty] [smallint] NULL,
[discount] [decimal] (4, 2) NOT NULL,
[Discount_id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [PK_Discounts] PRIMARY KEY CLUSTERED  ([Discount_id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Storid_index] ON [dbo].[discounts] ([stor_id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [FK__discounts__store] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
