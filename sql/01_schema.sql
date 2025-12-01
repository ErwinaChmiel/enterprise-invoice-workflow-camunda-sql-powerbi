CREATE TABLE CompanyCode (
    CompanyCodeId INT IDENTITY PRIMARY KEY,
    Code VARCHAR(4) NOT NULL,
    Name VARCHAR(200) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL
);

CREATE TABLE Vendor (
    VendorId INT IDENTITY PRIMARY KEY,
    VendorNumber VARCHAR(20) NOT NULL,
    Name VARCHAR(200) NOT NULL,
    TaxId VARCHAR(20) NULL,
    CountryCode CHAR(2) NOT NULL,
    PaymentTerms VARCHAR(50) NULL
);

CREATE TABLE InvoiceHeader (
    InvoiceId INT IDENTITY PRIMARY KEY,
    ExternalInvoiceNumber VARCHAR(50) NOT NULL,
    VendorId INT NOT NULL,
    CompanyCodeId INT NOT NULL,
    InvoiceDate DATE NOT NULL,
    PostingDate DATE NULL,
    DueDate DATE NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    TotalNetAmount DECIMAL(18,2) NOT NULL,
    TotalTaxAmount DECIMAL(18,2) NOT NULL,
    TotalGrossAmount DECIMAL(18,2) NOT NULL,
    PoNumber VARCHAR(20) NULL,
    Status VARCHAR(20) NOT NULL,
    CamundaProcessInstanceId VARCHAR(64) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CreatedBy VARCHAR(50) NULL,
    ModifiedAt DATETIME2 NULL,
    ModifiedBy VARCHAR(50) NULL,
    CONSTRAINT FK_InvoiceHeader_Vendor
        FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId),
    CONSTRAINT FK_InvoiceHeader_CompanyCode
        FOREIGN KEY (CompanyCodeId) REFERENCES CompanyCode(CompanyCodeId)
);

CREATE TABLE InvoiceLine (
    InvoiceLineId INT IDENTITY PRIMARY KEY,
    InvoiceId INT NOT NULL,
    LineNumber INT NOT NULL,
    Description VARCHAR(200) NULL,
    Quantity DECIMAL(18,2) NOT NULL,
    UnitPrice DECIMAL(18,4) NOT NULL,
    NetAmount DECIMAL(18,2) NOT NULL,
    TaxAmount DECIMAL(18,2) NOT NULL,
    GrossAmount DECIMAL(18,2) NOT NULL,
    GlAccountId INT NULL,
    CostCenterId INT NULL,
    PoItemId INT NULL,
    CONSTRAINT FK_InvoiceLine_Invoice
        FOREIGN KEY (InvoiceId) REFERENCES InvoiceHeader(InvoiceId)
);

CREATE TABLE InvoiceApproval (
    ApprovalId INT IDENTITY PRIMARY KEY,
    InvoiceId INT NOT NULL,
    ApproverUserId INT NOT NULL,
    ApprovalLevel TINYINT NOT NULL,
    Decision VARCHAR(20) NOT NULL,
    DecisionDate DATETIME2 NOT NULL,
    Comment VARCHAR(500) NULL,
    CONSTRAINT FK_InvoiceApproval_Invoice
        FOREIGN KEY (InvoiceId) REFERENCES InvoiceHeader(InvoiceId)
);

CREATE TABLE InvoiceStatusHistory (
    Id INT IDENTITY PRIMARY KEY,
    InvoiceId INT NOT NULL,
    OldStatus VARCHAR(20) NULL,
    NewStatus VARCHAR(20) NOT NULL,
    ChangedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ChangedBy VARCHAR(50) NULL,
    CONSTRAINT FK_InvoiceStatusHistory_Invoice
        FOREIGN KEY (InvoiceId) REFERENCES InvoiceHeader(InvoiceId)
);
