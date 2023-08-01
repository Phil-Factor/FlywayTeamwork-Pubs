CREATE TABLE [dbo].[prices]
(
[Price_id] [int] NOT NULL IDENTITY(1, 1),
[Edition_id] [int] NULL,
[price] [dbo].[Dollars] NULL,
[advance] [dbo].[Dollars] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[PriceStartDate] [datetime2] NOT NULL CONSTRAINT [DF__prices__PriceSta__230A1C49] DEFAULT (getdate()),
[PriceEndDate] [datetime2] NULL
)
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED ([Price_id])
GO
CREATE NONCLUSTERED INDEX [editionid_index] ON [dbo].[prices] ([Edition_id])
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [fk_prices] FOREIGN KEY ([Edition_id]) REFERENCES [dbo].[editions] ([Edition_id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'these are the current prices of every edition of every publication', 'SCHEMA', N'dbo', 'TABLE', N'prices', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'the advance to the authors', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'advance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The edition that this price applies to', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'Edition_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the price in dollars', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'price'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The surrogate key to the Prices Table', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'Price_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'null if the price is current, otherwise the date at which it was supoerceded', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'PriceEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the start date for which this price applies', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'PriceStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the royalty', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'royalty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the current sales this year', 'SCHEMA', N'dbo', 'TABLE', N'prices', 'COLUMN', N'ytd_sales'
GO
