# Reporting – Power BI for AP Process

## 1. Report purpose

The Power BI report provides:

- real-time view of invoice status in the AP process,
- SLA and processing time monitoring,
- bottleneck identification,
- cost overview by organisation,
- exception and risk analysis.

---

## 2. Report structure

Pages:

1. **AP Overview**
2. **SLA & Bottlenecks**
3. **Costs by Organisation**
4. **Exceptions & Risks**

---

## 3. Page 1 – AP Overview

**Goal:** high-level view of invoice volume and value.

**KPIs:**

- number of invoices in the selected period,
- total gross invoice value,
- share of PO vs non-PO invoices,
- number of posted vs in-process vs rejected invoices.

**Visuals:**

- line chart – invoice count over time (by status),
- column chart – invoice value by company,
- stacked columns – PO vs non-PO by period,
- table – top vendors by value.

**Filters:**

- date range,
- company,
- vendor,
- invoice status.

---

## 4. Page 2 – SLA & Bottlenecks

**Goal:** processing time analysis.

**KPIs:**

- average time from InvoiceDate to PostingDate,
- average approval time,
- % of invoices within SLA,
- % of overdue invoices (past Due Date).

**Example DAX logic (conceptual):**

- processing days = date difference between InvoiceDate and PostingDate,
- on-time flag = PostingDate ≤ DueDate.

**Visuals:**

- histogram – distribution of processing time (day buckets),
- column chart – average processing time by company / invoice type / vendor,
- table – approvers with number of decisions, avg time, SLA breaches,
- KPI card – % of invoices past Due Date.

**Filters:**

- period,
- company,
- invoice type (PO / non-PO),
- approval level.

---

## 5. Page 3 – Costs by Organisation

**Goal:** show where costs are concentrated.

**KPIs:**

- total cost (NetAmount / GrossAmount) by:
  - company,
  - cost center,
  - vendor,
  - GL account.

**Visuals:**

- drill-down: Company → Department (if available) → CostCenter,
- column chart – top cost centers by value,
- column chart – costs by GL account,
- table – top vendors by spend.

**Filters:**

- period,
- company,
- cost center,
- GL account,
- vendor.

---

## 6. Page 4 – Exceptions & Risks

**Goal:** highlight unusual or risky cases.

**KPIs:**

- count and % of rejected invoices,
- count of invoices with exceptions (e.g. mismatches, duplicates),
- top vendors by number of exceptions.

**Visuals:**

- KPI cards – rejected invoice count and percentage,
- column chart – number of exceptions by type (e.g. no PO, no GR, amount mismatch),
- map / column chart – exceptions by vendor country,
- detail table – problematic invoices (number, vendor, amount, exception type, time in process).

**Filters:**

- period,
- company,
- vendor,
- exception type.

---

## 7. Example DAX measures (conceptual)

Example logic:

- **Invoice Count** – count of rows in `InvoiceHeader`,
- **Total Gross Amount** – sum of `TotalGrossAmount`,
- **Average Processing Time (Days)** – average of date difference between InvoiceDate and PostingDate,
- **On Time Flag** – 1 if PostingDate ≤ DueDate,
- **On Time %** – share of invoices with On Time Flag = 1,
- **PO Share** – share of invoices with non-empty `PoNumber`.

---

## 8. Report consumers

The report can be used by:

- AP team – monitoring workload and delays,
- line managers – cost visibility for their areas,
- controlling / CFO – cost and risk trends,
- audit – overview of exceptions and process behaviour.

