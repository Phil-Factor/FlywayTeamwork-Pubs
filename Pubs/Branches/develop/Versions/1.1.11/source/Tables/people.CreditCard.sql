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
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardPK] PRIMARY KEY CLUSTERED  ([CreditCardID])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCardWasntUnique] UNIQUE NONCLUSTERED  ([CardNumber])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [DuplicateCreditCardUK] UNIQUE NONCLUSTERED  ([Person_id], [CardNumber])
GO
ALTER TABLE [people].[CreditCard] ADD CONSTRAINT [CreditCard_PersonFK] FOREIGN KEY ([Person_id]) REFERENCES [people].[Person] ([person_ID])
GO
