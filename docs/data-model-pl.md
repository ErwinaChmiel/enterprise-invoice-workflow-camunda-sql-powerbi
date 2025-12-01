# Model danych – obsługa faktur kosztowych

## 1. Cel modelu danych

Model danych wspiera proces obsługi faktur kosztowych (Accounts Payable, AP) w dużej korporacji.  
Jego zadania:

- przechowywanie informacji o dostawcach, spółkach i fakturach,
- odwzorowanie przebiegu akceptacji (kto, kiedy, na jakim poziomie),
- zapewnienie historii zmian statusów faktury,
- dostarczenie danych do raportowania w Power BI.

Model jest zaprojektowany pod **Microsoft SQL Server** i podzielony na:

- dane podstawowe (master data),
- dane transakcyjne,
- dane procesowe.

---

## 2. Przegląd encji

### 2.1. Dane podstawowe (master data)

- **CompanyCode** – jednostki prawne (spółki),
- **Vendor** – dostawcy,
- **CostCenter** – centra kosztów,
- **GlAccount** – konta księgowe (GL),
- **UserAccount** – użytkownicy systemu (AP, approverzy).

### 2.2. Dane transakcyjne

- **InvoiceHeader** – nagłówki faktur,
- **InvoiceLine** – pozycje faktur,
- **PurchaseOrder** – uproszczone zamówienia zakupu,
- **PurchaseOrderItem** – pozycje zamówień.

### 2.3. Dane procesowe

- **InvoiceApproval** – decyzje akceptacyjne,
- **InvoiceStatusHistory** – historia zmian statusów faktur.

---

## 3. Opis tabel

### 3.1. CompanyCode

Reprezentuje jednostki prawne, dla których księgowane są faktury.

- `CompanyCodeId` – klucz główny (INT),
- `Code` – krótki kod spółki (np. „PL01”),
- `Name` – nazwa spółki,
- `CurrencyCode` – waluta domyślna (np. „PLN”).

**Zastosowanie:**  
Każda faktura (`InvoiceHeader`) jest przypisana do jednego `CompanyCode`.

---

### 3.2. Vendor

Dane podstawowe dostawców.

- `VendorId` – klucz główny,
- `VendorNumber` – numer dostawcy w ERP,
- `Name` – nazwa dostawcy,
- `TaxId` – NIP / identyfikator podatkowy,
- `CountryCode` – kraj dostawcy (ISO 2),
- `PaymentTerms` – warunki płatności (np. 14D, 30D).

**Zastosowanie:**  
Powiązanie z fakturami (`InvoiceHeader.VendorId`), raporty wg dostawców.

---

### 3.3. CostCenter

Centra kosztów (np. działy, jednostki organizacyjne).

- `CostCenterId` – klucz główny,
- `Code` – kod centrum kosztów,
- `Name` – opis,
- `CompanyCodeId` – powiązana spółka (FK do `CompanyCode`).

**Zastosowanie:**  
Przypisanie kosztów na fakturach non-PO (`InvoiceLine.CostCenterId`), analiza kosztów wg centrów.

---

### 3.4. GlAccount

Konta księgowe (General Ledger).

- `GlAccountId` – klucz główny,
- `AccountNumber` – numer konta (np. „402-01”),
- `Name` – opis konta.

**Zastosowanie:**  
Przypisanie typu kosztu na poziomie pozycji faktury (`InvoiceLine.GlAccountId`).

---

### 3.5. UserAccount

Użytkownicy biorący udział w procesie.

- `UserId` – klucz główny,
- `Login` – login systemowy,
- `DisplayName` – nazwa wyświetlana (np. „Jan Kowalski”),
- `Email` – adres e-mail (np. do powiadomień),
- `Role` – rola domyślna (`AP_CLERK`, `APPROVER_L1`, `APPROVER_L2`, itp.).

**Zastosowanie:**  
Referencja w `InvoiceApproval.ApproverUserId` oraz potencjalnie w `InvoiceStatusHistory.ChangedBy`.

---

### 3.6. InvoiceHeader

Nagłówek faktury kosztowej.

- `InvoiceId` – klucz główny,
- `ExternalInvoiceNumber` – numer faktury od dostawcy,
- `VendorId` – FK do `Vendor`,
- `CompanyCodeId` – FK do `CompanyCode`,
- `InvoiceDate` – data wystawienia faktury,
- `PostingDate` – data księgowania (jeśli zaksięgowana),
- `DueDate` – termin płatności,
- `CurrencyCode` – waluta faktury,
- `TotalNetAmount` – suma netto,
- `TotalTaxAmount` – suma VAT,
- `TotalGrossAmount` – suma brutto,
- `PoNumber` – numer zamówienia (dla faktur PO-based, opcjonalny),
- `Status` – status procesu (`NEW`, `IN_REVIEW`, `APPROVED`, `REJECTED`, `POSTED`, `EXPIRED`),
- `CamundaProcessInstanceId` – identyfikator instancji procesu w Camunda,
- `CreatedAt`, `CreatedBy`, `ModifiedAt`, `ModifiedBy` – pola audytowe.

**Zastosowanie:**  
Główna tabela transakcyjna, punkt referencyjny dla całego procesu i raportowania.

---

### 3.7. InvoiceLine

Szczegóły pozycji faktury.

- `InvoiceLineId` – klucz główny,
- `InvoiceId` – FK do `InvoiceHeader`,
- `LineNumber` – numer pozycji,
- `Description` – opis pozycji,
- `Quantity` – ilość,
- `UnitPrice` – cena jednostkowa,
- `NetAmount` – kwota netto,
- `TaxAmount` – kwota VAT,
- `GrossAmount` – kwota brutto,
- `GlAccountId` – FK do `GlAccount` (dla non-PO),
- `CostCenterId` – FK do `CostCenter` (dla non-PO),
- `PoItemId` – FK do `PurchaseOrderItem` (dla PO-based).

**Zastosowanie:**  
Analiza kosztów na poziomie szczegółowym (konto, centrum kosztów, typ usługi).

---

### 3.8. PurchaseOrder

Uproszczone zamówienie zakupu (PO).

- `PurchaseOrderId` – klucz główny,
- `PoNumber` – numer zamówienia,
- `VendorId` – FK do `Vendor`,
- `CompanyCodeId` – FK do `CompanyCode`,
- `OrderDate` – data zamówienia,
- `TotalAmount` – wartość zamówienia,
- `CurrencyCode` – waluta,
- `Status` – `OPEN`, `PARTIALLY_RECEIVED`, `CLOSED`.

**Zastosowanie:**  
Źródło danych do 3-way match (PO vs GR vs Invoice).

---

### 3.9. PurchaseOrderItem

Pozycje zamówienia.

- `PoItemId` – klucz główny,
- `PurchaseOrderId` – FK do `PurchaseOrder`,
- `LineNumber` – numer pozycji,
- `Description` – opis,
- `Quantity` – ilość zamówiona,
- `UnitPrice` – cena jednostkowa,
- `NetAmount` – wartość pozycji,
- `CostCenterId` – FK do `CostCenter` (jeśli znane z góry).

**Zastosowanie:**  
Powiązanie z pozycjami faktury, kontrola ilości i kwot przy dopasowaniu 3-way.

---

### 3.10. InvoiceApproval

Rejestr decyzji akceptacyjnych.

- `ApprovalId` – klucz główny,
- `InvoiceId` – FK do `InvoiceHeader`,
- `ApproverUserId` – FK do `UserAccount`,
- `ApprovalLevel` – poziom akceptacji (1, 2, 3…),
- `Decision` – `APPROVED` / `REJECTED`,
- `DecisionDate` – data i czas decyzji,
- `Comment` – komentarz approvera.

**Zastosowanie:**  
Ścieżka audytowa procesu akceptacji, baza do raportów o pracy approverów.

---

### 3.11. InvoiceStatusHistory

Historia zmian statusów faktury.

- `Id` – klucz główny,
- `InvoiceId` – FK do `InvoiceHeader`,
- `OldStatus` – poprzedni status (opcjonalny dla pierwszego wpisu),
- `NewStatus` – nowy status,
- `ChangedAt` – data i czas zmiany,
- `ChangedBy` – użytkownik lub system (np. „SYSTEM” dla timeoutu).

**Zastosowanie:**  

- odtworzenie pełnego „życia” faktury,
- liczenie czasu w poszczególnych statusach (SLA),
- analiza wąskich gardeł.

---

## 4. Relacje między tabelami

Najważniejsze relacje:

- `CompanyCode` (1) – (N) `InvoiceHeader`
- `Vendor` (1) – (N) `InvoiceHeader`
- `InvoiceHeader` (1) – (N) `InvoiceLine`
- `PurchaseOrder` (1) – (N) `PurchaseOrderItem`
- `InvoiceHeader` (1) – (N) `InvoiceApproval`
- `InvoiceHeader` (1) – (N) `InvoiceStatusHistory`
- `UserAccount` (1) – (N) `InvoiceApproval`
- `CostCenter` / `GlAccount` – (1) – (N) `InvoiceLine`

---

## 5. Uproszczenia i możliwe rozszerzenia

**Uproszczenia:**

- Model PO jest uproszczony – celem jest wsparcie 3-way match i raportowania, nie pełna funkcjonalność ERP.
- Dane o przyjęciach (Goods Receipt) mogą być odwzorowane np. dodatkowymi kolumnami w `PurchaseOrderItem`.

**Możliwe rozszerzenia:**

- tabela `Payment` – informacje o płatnościach za faktury,
- tabela `CurrencyRate` – kursy walut i przeliczenia na walutę raportową,
- model projektów (`Project`, `ProjectTask`) – analizy kosztów projektowych,
- osobne tabele dla podatków (np. `TaxCode`, `InvoiceTaxLine`).
