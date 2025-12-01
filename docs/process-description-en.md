# Business Context – Invoice Processing in a Large Corporation (EN)

## 1. Introduction

This project presents a standardized **Accounts Payable (AP)** process for handling cost invoices in a large multi-entity organization.  
The goal is to demonstrate how to:

- design a business process,
- map it to a data model,
- and build management reporting on top of it.

The process is implemented as a BPMN model (Camunda), a database schema (SQL Server) and sample dashboards (Power BI).

---

## 2. Corporate environment

Assumptions:

- The company operates multiple legal entities (**Company Codes**) in different countries.
- Every month it receives **thousands of invoices** from hundreds of vendors (utilities, services, licenses, consulting, subcontractors).
- The organization uses a central ERP system (e.g. SAP / Oracle), but the standard invoice approval workflow is:
  - not flexible enough,
  - hard to report on,
  - and does not provide sufficient transparency.

The Accounts Payable department is responsible for accurate and timely posting of invoices while ensuring compliance with:

- internal control rules (cost control, authorizations),
- and audit requirements (full approval trail and decision history).

---

## 3. Business problem

Typical issues in the existing process:

- Lack of a unified workflow – each entity handles invoices differently, often via emails and spreadsheets.
- Limited visibility of invoice status – it is hard to see where a specific invoice is stuck and why it has not been posted.
- Long lead time from invoice receipt to posting:
  - invoices sit in approvers’ mailboxes,
  - there are no systematic reminders and escalations.
- Reporting challenges:
  - no central repository containing invoices and approval steps,
  - reports are prepared manually in Excel.

Additionally:

- Some invoices should be linked to existing Purchase Orders (PO), but in practice many are entered as non-PO.
- There is no robust duplicate control (same invoice posted more than once).

---

## 4. Project goals

The project aims to:

1. **Standardize the AP process** across the entire organization:
   - a common process model,
   - clear roles, tasks and decision points.

2. **Provide transparency and status tracking:**
   - ability to answer: “At which stage is this invoice and who is responsible now?”.

3. **Reduce invoice processing time:**
   - automated task routing,
   - reminders and escalations after SLA breaches,
   - clear approval paths (levels, amount thresholds).

4. **Support cost control and audit:**
   - full status and approval history,
   - logging who approved or rejected the invoice, and when.

5. **Enable management reporting:**
   - KPIs for the AP department,
   - analysis of delays and bottlenecks,
   - cost overview by company, department and cost center.

---

## 5. Stakeholders

Main stakeholder groups:

- **AP Department (Accounts Payable):**
  - invoice registration,
  - initial validation,
  - coordination of approvals and vendor communication.

- **Cost owners / Line managers:**
  - confirming the validity of costs,
  - approving non-PO invoices,
  - resolving discrepancies for PO invoices.

- **Finance Directors / CFO / Controlling:**
  - approving high-value invoices,
  - monitoring budgets and cost structure,
  - defining reporting requirements.

- **IT / System owners:**
  - maintaining ERP integration,
  - configuring workflows in the process engine.

- **Internal and external audit:**
  - checking compliance with procedures,
  - reviewing completeness of approval history.

---

## 6. Project scope

In scope:

- **Business process** for cost invoice handling:
  - from invoice receipt,
  - through registration, validation and approval,
  - up to posting to ERP.

- **Support for two invoice types:**
  - invoices with Purchase Order (PO-based),
  - invoices without PO (non-PO).

- **Data model in Microsoft SQL Server:**
  - vendors, company codes,
  - invoice headers and lines,
  - simplified purchase orders,
  - approval decisions and status history.

- **Reporting in Power BI:**
  - AP performance KPIs,
  - SLA and delay analysis,
  - cost structure by organization,
  - exceptions: rejected invoices, large deviations, invoices requiring manual intervention.

---

## 7. Out of scope

Out of scope:

- Full integration with a real ERP system (SAP / Oracle) – posting is simulated.
- Actual OCR and email ingestion – the project assumes invoice data is already structured.
- Detailed modelling of tax and legal specifics for each country.

---

## 8. Key assumptions

- Each invoice has exactly one vendor and company code.
- Each invoice may or may not have a PO number (PO-based vs non-PO).
- For non-PO invoices, at least:
  - one cost center,
  - and one GL account must be assigned.
- The approval path depends on:
  - invoice amount,
  - organizational structure,
  - and optionally cost type.

---

## 9. Example KPIs

Example measures that can be derived from the data model:

- Average time from **invoice receipt** to **posting**.
- % of invoices posted **before Due Date**.
- Share of PO vs non-PO invoices.
- Number of invoices per approver / department.
- Count and share of rejected invoices.
- Number of invoices with exceptions (PO mismatch, missing goods receipt, other deviations).
- Costs by company, department, cost center and vendor.

These KPIs are used in Power BI reports.

