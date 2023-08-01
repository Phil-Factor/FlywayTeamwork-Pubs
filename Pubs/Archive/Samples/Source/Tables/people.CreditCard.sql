CREATE TABLE [people].[CreditCard]
(
[CreditCardID] [int] NOT NULL IDENTITY(1, 1),
[Person_id] [int] NOT NULL,
[CardNumber] [people].[PersonalPaymentCardNumber] NOT NULL,
[ValidFrom] [date] NOT NULL,
[ValidTo] [date] NOT NULL,
[CVC] [people].[PersonalCVC] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [CreditCardModifiedDateD] DEFAULT (getdate())
)
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED ([CreditCardID])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED ([CardNumber])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED ([Person_id], [CardNumber])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCard_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N' the customer''s credit card details. This is here just because this database is used as a nursery slope to check for personal information ', 'SCHEMA', N'people', 'TABLE', N'CreditCard', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual card-number', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CardNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surrogate primary key for the Credit card', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CreditCardID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the CVC', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'CVC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'when was this last modified', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'foreign key to the person who has the addess', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'Person_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'from when the credit card was valid', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ValidFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'to when the credit card was valid', 'SCHEMA', N'people', 'TABLE', N'CreditCard', 'COLUMN', N'ValidTo'
GO
