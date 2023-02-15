PRINT 'Disable all constraints for database';
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";

PRINT 'Deleting all data from accounting.Bill_Lines';
DELETE FROM accounting.Bill_Lines;
PRINT 'Deleting all data from accounting.Bill_Payments';
DELETE FROM accounting.Bill_Payments;
PRINT 'Deleting all data from accounting.Bills';
DELETE FROM accounting.Bills;
PRINT 'Deleting all data from accounting.Chart_of_Accounts';
DELETE FROM accounting.Chart_of_Accounts;
PRINT 'Deleting all data from accounting.customer';
DELETE FROM accounting.customer;
PRINT 'Deleting all data from accounting.Invoice_Lines';
DELETE FROM accounting.Invoice_Lines;
PRINT 'Deleting all data from accounting.Invoice_Payments';
DELETE FROM accounting.Invoice_Payments;
PRINT 'Deleting all data from accounting.Invoices';
DELETE FROM accounting.Invoices;
PRINT 'Deleting all data from accounting.Received_Money_Lines';
DELETE FROM accounting.Received_Money_Lines;
PRINT 'Deleting all data from accounting.Received_Moneys';
DELETE FROM accounting.Received_Moneys;
PRINT 'Deleting all data from accounting.Spent_Money_Lines';
DELETE FROM accounting.Spent_Money_Lines;
PRINT 'Deleting all data from accounting.Spent_Moneys';
DELETE FROM accounting.Spent_Moneys;
PRINT 'Deleting all data from accounting.Suppliers';
DELETE FROM accounting.Suppliers;
Print 'Enable all constraints for database'
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"