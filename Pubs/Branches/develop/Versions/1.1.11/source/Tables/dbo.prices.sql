CREATE TABLE [dbo].[prices]
(
[Price_id] [int] NOT NULL IDENTITY(1, 1),
[Edition_id] [int] NULL,
[price] [dbo].[Dollars] NULL,
[advance] [dbo].[Dollars] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[PriceStartDate] [datetime2] NOT NULL CONSTRAINT [DF__prices__PriceSta__390E6C01] DEFAULT (getdate()),
[PriceEndDate] [datetime2] NULL
)
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED  ([Price_id])
GO
CREATE NONCLUSTERED INDEX [editionid_index] ON [dbo].[prices] ([Edition_id])
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [fk_prices] FOREIGN KEY ([Edition_id]) REFERENCES [dbo].[editions] ([Edition_id])
GO
