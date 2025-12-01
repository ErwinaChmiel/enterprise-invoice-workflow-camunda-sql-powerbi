/* 
    02_sample_data.sql
    Przykładowe dane dla korporacyjnego procesu obsługi faktur (AP)
    Sample data for enterprise AP invoice process
*/

------------------------------------------------------------
-- (Opcjonalnie) Wyczyść dane – odkomentuj jeśli chcesz
------------------------------------------------------------
-- DELETE FROM InvoiceStatusHistory;
-- DELETE FROM InvoiceApproval;
-- DELETE FROM InvoiceLine;
-- DELETE FROM InvoiceHeader;
-- DELETE FROM PurchaseOrderItem;
-- DELETE FROM PurchaseOrder;
-- DELETE FROM CostCenter;
-- DELETE FROM GlAccount;
-- DELETE FROM UserAccount;
-- DELETE FROM Vendor;
-- DELETE FROM CompanyCode;


------------------------------------------------------------
-- Master data: CompanyCode
------------------------------------------------------------

INSERT INTO CompanyCode (Code, Name, CurrencyCode)
VALUES 
    ('PL01', 'Poland Services Sp. z o.o.', 'PLN'),
    ('DE01', 'Germany Services GmbH', 'EUR');


------------------------------------------------------------
-- Master data: Vendor
------------------------------------------------------------

INSERT INTO Vendor (VendorNumber, Name, TaxId, CountryCode, PaymentTerms)
VALUES
    ('VEND001', 'ABC Consulting Sp. z o.o.', 'PL1234567890', 'PL', '14D'),
    ('VEND002', 'XYZ Utilities S.A.', 'PL9876543210', 'PL', '14D'),
    ('VEND003', 'Global Software GmbH', 'DE1111111111', 'DE', '30D');


------------------------------------------------------------
-- Master data: CostCenter
------------------------------------------------------------

INSERT INTO CostCenter (Code, Name, CompanyCodeId)
VALUES
    (
        'IT001',
        'IT Infrastructure',
        (SELECT CompanyCodeId FROM CompanyCode WHERE Code = 'PL01')
    ),
    (
        'HR001',
        'HR & Payroll',
        (SELECT CompanyCodeId FROM CompanyCode WHERE Code = 'PL01')
    ),
    (
        'DE-OPS',
        'Operations Germany',
        (SELECT CompanyCodeId FROM CompanyCode WHERE Code = 'DE01')
    );


------------------------------------------------------------
-- Master data: GlAccount
------------------------------------------------------------

INSERT INTO GlAccount (AccountNumber, Name)
VALUES
    ('402-01', 'External consulting services'),
    ('403-10', 'Software subscriptions'),
    ('404-05', 'Utilities');


------------------------------------------------------------
-- Master data: UserAccount (AP & approvers)
------------------------------------------------------------

INSERT INTO UserAccount (Login, DisplayName, Email, Role)
VALUES
    ('ap.clerk', 'AP Clerk Poland', 'ap.clerk@corp.local', 'AP_CLERK'),
    ('mgr.it', 'IT Line Manager', 'mgr.it@corp.local', 'APPROVER_L1'),
    ('dir.finance', 'Finance Director', 'dir.finance@corp.local', 'APPROVER_L2'),
    ('mgr.de', 'DE Operations Mgr', 'mgr.de@corp.local', 'APPROVER_L1');


------------------------------------------------------------
-- Purchase Orders (PO-based scenario)
------------------------------------------------------------

-- PO for consulting services in PL (ABC Consulting)
INSERT INTO PurchaseOrder (PoNumber, VendorId, CompanyCodeId, OrderDate, TotalAmount, CurrencyCode, Status)
VALUES
(
    'PO2025-0001',
    (SELECT VendorId FROM Vendor WHERE VendorNumber = 'VEND001'),
    (SELECT CompanyCodeId FROM CompanyCode WHERE Code = 'PL01'),
    '2025-01-10',
    50000.00,
    'PLN',
    'OPEN'
);

-- PO for utilities in PL (XYZ Utilities)
INSERT INTO PurchaseOrder (PoNumber, VendorId, CompanyCodeId, OrderDate, TotalAmount, CurrencyCode, Status)
VALUES
(
    'PO2025-0002',
    (SELECT VendorId FROM Vendor WHERE VendorNumber = 'VEND002'),
    (SELECT CompanyCodeId FROM

