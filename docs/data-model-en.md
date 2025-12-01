# Data Model – AP Invoice Processing

## 1. Purpose

The data model supports the **Accounts Payable (AP)** invoice process in a large corporation. It:

- stores information about vendors, entities and invoices,
- represents the approval flow (who approved what and when),
- maintains invoice status history,
- feeds analytical reports in Power BI.

It is designed for **Microsoft SQL Server** and split into:

- master data,
- transactional data,
- process data.

---

## 2. Entity overview

### 2.1. Master data

- **CompanyCode** – legal entities,
- **Vendor** – vendors,
- **CostCenter** – cost centers,
- **GlAccount** – general ledger accounts,
- **UserAccount** – system users (AP, approvers).

### 2.2. Transactional data

- **InvoiceHeader** – invoice headers,
- **InvoiceLine** – invoice lines,
- **PurchaseOrder** – simplified purchase orders,
- **PurchaseOrderItem** – purchase order items.

### 2.3. Process data

- **InvoiceApproval** – approval decisions,
- **InvoiceStatusHistory** – invoice status history.

---

## 3. Table descriptions

### 3.1. CompanyCode

Represents legal entities for which invoices are posted.

- `CompanyCodeId` – primary key,
- `Code` – short code (e.g. “PL01”),
- `Name` – company name,
- `CurrencyCode` – default currency (e.g. “PLN”).

**Usage:**  
Each invoice (`InvoiceHeader`) is linked to one company code.

---

### 3.2. Vendor

Vendor master data.

- `VendorId` – primary key,
- `VendorNumber` – vendor ID in ERP,
- `Name` – vendor name,
- `TaxId` – tax identifier,
- `CountryCode` – vendor country (ISO 2),
- `PaymentTerms` – payment terms (e.g. 14D, 30D).

---

### 3.3. CostCenter

Cost centers (departments, organizational units).

- `CostCenterId` – primary key,
- `Code` – cost center code,
- `Name` – description,
- `CompanyCodeId` – related company (FK).

**Usage:**  
Cost allocation for non-PO invoices (`InvoiceLine.CostCenterId`).

---

### 3.4. GlAccount

General ledger accounts.

- `GlAccountId` – primary key,
- `AccountNumber` – e.g. “402-01”,
- `Name` – account name.

**Usage:**  
Cost type assignment on invoice lines (`InvoiceLine.GlAccountId`).

---

### 3.5. UserAccount

Users participating in the process.

- `UserId` – primary key,
- `Login` – system login,
- `DisplayName` – display name,
- `Email` – email address,
- `Role` – default role (`AP_CLERK`, `APPROVER_L1`, `APPROVER_L2`, etc.).

**Usage:**  
Referenced by `InvoiceApproval.ApproverUserId` and optionally `InvoiceStatusHistory.ChangedBy`.

---

### 3.6. InvoiceHeader

Invoice header.

- `InvoiceId` – primary key,
- `ExternalInvoiceNumber` – vendor invoice number,
- `VendorId` – FK to `Vendor`,
- `CompanyCodeId` – FK to `CompanyCode`,
- `InvoiceDate` – invoice date,
- `PostingDate` – posting date (if posted),
- `DueDate` – due date,
- `CurrencyCode` – invoice currency,
- `TotalNetAmount` – total net amount,
- `TotalTaxAmount` – total tax amount,
- `TotalGrossAmount` – total gross amount,
- `PoNumber` – purchase order number (optional, PO-based invoices),
- `Status` – process status (`NEW`, `IN_REVIEW`, `APPROVED`, `REJECTED`, `POSTED`, `EXPIRED`),
- `CamundaProcessInstanceId` – Camunda process instance ID,
- `CreatedAt`, `CreatedBy`, `ModifiedAt`, `ModifiedBy` – audit fields.

**Usage:**  
Central transactional table and main anchor for reporting and process tracking.

---

### 3.7. InvoiceLine

Invoice line items.

- `InvoiceLineId` – primary key,
- `InvoiceId` – FK to `InvoiceHeader`,
- `LineNumber` – line number,
- `Description` – description,
- `Quantity` – quantity,
- `UnitPrice` – unit price,
- `NetAmount` – net amount,
- `TaxAmount` – tax amount,
- `GrossAmount` – gross amount,
- `GlAccountId` – FK to `GlAccount` (non-PO),
- `CostCenterId` – FK to `CostCenter` (non-PO),
- `PoItemId` – FK to `PurchaseOrderItem` (PO-based).

---

### 3.8. PurchaseOrder

Simplified purchase order.

- `PurchaseOrderId` – primary key,
- `PoNumber` – PO number,
- `VendorId` – FK to `Vendor`,
- `CompanyCodeId` – FK to `CompanyCode`,
- `OrderDate` – order date,
- `TotalAmount` – total PO value,
- `CurrencyCode` – currency,
- `Status` – `OPEN`, `PARTIALLY_RECEIVED`, `CLOSED`.

---

### 3.9. PurchaseOrderItem

Purchase order line items.

- `PoItemId` – primary key,
- `PurchaseOrderId` – FK to `PurchaseOrder`,
- `LineNumber` – line number,
- `Description` – description,
- `Quantity` – ordered quantity,
- `UnitPrice` – unit price,
- `NetAmount` – line amount,
- `CostCenterId` – FK to `CostCenter`.

---

### 3.10. InvoiceApproval

Approval decisions.

- `ApprovalId` – primary key,
- `InvoiceId` – FK to `InvoiceHeader`,
- `ApproverUserId` – FK to `UserAccount`,
- `ApprovalLevel` – level (1, 2, 3…),
- `Decision` – `APPROVED` / `REJECTED`,
- `DecisionDate` – decision timestamp,
- `Comment` – approver comment.

---

### 3.11. InvoiceStatusHistory

Invoice status history.

- `Id` – primary key,
- `InvoiceId` – FK to `InvoiceHeader`,
- `OldStatus` – previous status,
- `NewStatus` – new status,
- `ChangedAt` – change timestamp,
- `ChangedBy` – user or system identifier.

---

## 4. Relationships

Key relationships:

- `CompanyCode` (1) – (N) `InvoiceHeader`
- `Vendor` (1) – (N) `InvoiceHeader`
- `InvoiceHeader` (1) – (N) `InvoiceLine`
- `PurchaseOrder` (1) – (N) `PurchaseOrderItem`
- `InvoiceHeader` (1) – (N) `InvoiceApproval`
- `InvoiceHeader` (1) – (N) `InvoiceStatusHistory`
- `UserAccount` (1) – (N) `InvoiceApproval`
- `CostCenter` / `GlAccount` (1) – (N) `InvoiceLine`

