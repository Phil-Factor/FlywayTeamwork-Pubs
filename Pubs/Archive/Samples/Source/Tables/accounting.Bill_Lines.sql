CREATE TABLE [accounting].[Bill_Lines]
(
[id] [int] NOT NULL,
[line_amount] [decimal] (20, 2) NOT NULL,
[bill_id] [int] NULL,
[line_Chart_of_Accounts_id] [int] NOT NULL
)
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [PK__Bill_Lin__3213E83FAE977E69] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [FK__Bill_Line__bill___2799C73C] FOREIGN KEY ([bill_id]) REFERENCES [accounting].[Bills] ([id])
GO
ALTER TABLE [accounting].[Bill_Lines] ADD CONSTRAINT [FK__Bill_Line__line___288DEB75] FOREIGN KEY ([line_Chart_of_Accounts_id]) REFERENCES [accounting].[Chart_of_Accounts] ([id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'this is the joining table between Bills and COA. An account may appear in multiple bills and a bill may have multiple accounts.', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'bill_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'line_amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'accounting', 'TABLE', N'Bill_Lines', 'COLUMN', N'line_Chart_of_Accounts_id'
GO
