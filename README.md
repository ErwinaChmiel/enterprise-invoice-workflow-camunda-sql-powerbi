# Enterprise Invoice Approval Workflow (Camunda + SQL Server + Power BI)

This repository contains a **sample enterprise-grade Accounts Payable (AP) process** for handling vendor invoices in a large corporation.

The solution is split into three main layers:

- **Camunda BPMN** – workflow for invoice registration, PO / non-PO split, multi-level approvals and posting to ERP.
- **Microsoft SQL Server** – data model for vendors, invoices, approvals and status history.
- **Power BI** – reporting layer with KPIs and analytical dashboards for AP performance.

> The goal of this project is to demonstrate end-to-end thinking: from business process design, through data modeling, to reporting & KPIs – in a financial / corporate context.

---

## Business Scenario

A large corporation receives thousands of vendor invoices every month across multiple legal entities (**Company Codes**). Invoices can:

- reference a **Purchase Order (PO)** → 3-way match is required (PO, Goods Receipt, Invoice),
- or be **non-PO** → they require cost center assignment and multi-level approval based on amount and organisation structure.

The AP (Accounts Payable) team must:

- ensure invoices are processed on time (before **Due Date**),
- minimise duplicates and mismatches,
- provide transparency to management via KPIs and dashboards.

This repository shows how such a process can be modelled and documented.

---

## Tech Stack

- **Process Engine**: Camunda (BPMN 2.0, process model only in this repo)
- **Database**: Microsoft SQL Server (schema + sample data)
- **Reporting**: Power BI (PBIX + screenshots)
- **Documentation**: Markdown (this repo)

---

## Repository Structure

- `bpmn/` – BPMN 2.0 model exported from Camunda Modeler (`invoice-approval.bpmn`)
- `sql/01_schema.sql` – database schema for the AP domain
- `sql/02_sample_data.sql` – sample vendors, invoices and approvals
- `powerbi/` – Power BI report (`ap-dashboard.pbix`) and screenshots
- `docs/` – additional documentation:
  - `business-context.md` – business description and assumptions
  - `process-description.md` – step-by-step process flow
  - `data-model.md` – ERD description and table details
  - `reporting-powerbi.md` – KPIs and report pages

---

## Process Overview (high-level)

The main process is **Invoice Approval & Posting**:

1. **Invoice Received** (email, EDI, portal upload)
2. **Registration / OCR** – header & line items are captured
3. **PO vs non-PO decision**
4. **PO invoices**
   - 3-way match (PO vs Goods Receipt vs Invoice)
   - mismatch handling and exception workflow
5. **Non-PO invoices**
   - cost center & GL account assignment
   - multi-level approval based on amount / organisation
6. **Posting to ERP** (simulated in this project)
7. **End states**:
   - Posted
   - Rejected
   - Expired (no action within SLA)

See `docs/process-description.md` for a detailed flow.

---

## Data Model Overview

The SQL Server schema contains, among others, the following tables:

- `Vendor` – suppliers’ master data
- `CompanyCode` – legal entities
- `InvoiceHeader`, `InvoiceLine` – invoice data
- `PurchaseOrder`, `PurchaseOrderItem` – simplified PO structure for 3-way match
- `InvoiceApproval` – approval decisions (who, when, which level)
- `InvoiceStatusHistory` – status audit trail over time

See `docs/data-model.md` and `sql/01_schema.sql` for details.

---

## Power BI Reporting

The Power BI report focuses on three main areas:

1. **AP Overview**
   - number and value of invoices by period, company, vendor
   - share of PO vs non-PO invoices
2. **SLA & Bottlenecks**
   - end-to-end processing time
   - processing time per workflow step and approver
   - overdue invoices
3. **Costs by Organisation**
   - costs by company, department and cost center
   - top vendors by spend
   - exceptions and rejected invoices

Screenshots are available under `powerbi/screenshots/`, full report as `ap-dashboard.pbix`.

---

## How to Use This Repository

This project is primarily intended as a **portfolio / case study**:

- You can open the BPMN file in **Camunda Modeler** to review or extend the process.
- You can run the SQL scripts against a **SQL Server** instance to explore the data model and sample data.
- You can open the **Power BI** file to inspect and modify the dashboards.

No runnable backend application is provided – the focus is on process, data and reporting design.
