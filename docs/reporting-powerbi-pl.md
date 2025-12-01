# Raportowanie – Power BI dla procesu AP (PL)

## 1. Cel raportu

Raport Power BI ma zapewnić:

- bieżący podgląd stanu faktur w procesie AP,
- monitorowanie czasu przetwarzania (SLA),
- identyfikację wąskich gardeł,
- przegląd kosztów według organizacji,
- analizę wyjątków i ryzyk.

---

## 2. Struktura raportu

Strony raportu:

1. **Przegląd AP (Overview)**
2. **SLA i wąskie gardła (SLA & Bottlenecks)**
3. **Koszty wg organizacji (Costs by Organisation)**
4. **Wyjątki i ryzyka (Exceptions & Risks)**

---

## 3. Strona 1 – „Przegląd AP”

**Cel:** ogólny obraz wolumenu i wartości faktur.

**KPI:**

- liczba faktur w okresie,
- łączna wartość brutto faktur,
- udział faktur z PO vs non-PO,
- liczba faktur zaksięgowanych, w procesie, odrzuconych.

**Wizualizacje:**

- wykres liniowy – liczba faktur w czasie (wg statusu),
- kolumny – wartość faktur wg spółki,
- kolumny skumulowane – PO vs non-PO wg okresu,
- tabela – top dostawcy wg wartości.

**Filtry:**

- zakres dat,
- spółka,
- dostawca,
- status faktury.

---

## 4. Strona 2 – „SLA i wąskie gardła”

**Cel:** analiza czasu przetwarzania.

**KPI:**

- średni czas od InvoiceDate do PostingDate,
- średni czas akceptacji,
- % faktur w SLA,
- % faktur po terminie płatności.

**Przykładowe miary (opis):**

- dni od otrzymania do księgowania = różnica dat,
- flaga „w terminie” = PostingDate ≤ DueDate.

**Wizualizacje:**

- histogram – rozkład czasu przetwarzania (przedziały dni),
- kolumny – średni czas wg spółki / typu faktury / dostawcy,
- tabela – approverzy: liczba decyzji, średni czas, decyzje po SLA,
- karta KPI – % faktur po Due Date.

**Filtry:**

- okres,
- spółka,
- typ faktury (PO / non-PO),
- poziom akceptacji.

---

## 5. Strona 3 – „Koszty wg organizacji”

**Cel:** pokazanie, gdzie koncentrują się koszty.

**KPI:**

- suma kosztów (NetAmount / GrossAmount) wg:
  - spółki,
  - centrum kosztów,
  - dostawcy,
  - kont GL.

**Wizualizacje:**

- drill-down: Company → Department (jeśli jest) → CostCenter,
- kolumny – top centra kosztów wg wartości,
- kolumny – koszty wg kont GL,
- tabela – top dostawcy wg wartości.

**Filtry:**

- okres,
- spółka,
- centrum kosztów,
- konto GL,
- dostawca.

---

## 6. Strona 4 – „Wyjątki i ryzyka”

**Cel:** identyfikacja sytuacji nietypowych.

**KPI:**

- liczba i % faktur odrzuconych,
- liczba faktur z wyjątkiem (np. mismatch, duplikat),
- top dostawcy generujący najwięcej wyjątków.

**Wizualizacje:**

- KPI – liczba / % odrzuconych faktur,
- kolumny – liczba wyjątków wg typu (np. brak PO, brak GR, różnica kwoty),
- mapa / kolumny – wyjątki wg kraju dostawcy,
- tabela – lista problematycznych faktur (numer, dostawca, kwota, typ wyjątku, czas w procesie).

**Filtry:**

- okres,
- spółka,
- dostawca,
- typ wyjątku.

---

## 7. Przykładowe miary DAX (opisowo)

Przykładowa logika DAX:

- **Invoice Count** – liczba faktur,
- **Total Gross Amount** – suma `TotalGrossAmount`,
- **Average Processing Time (Days)** – średnia różnica między InvoiceDate a PostingDate,
- **On Time Flag** – 1 jeśli Posted ≤ DueDate,
- **On Time %** – udział faktur z flagą 1,
- **PO Share** – udział faktur z niepustym `PoNumber`.

---

## 8. Użytkownicy raportu

Raport może być używany przez:

- dział AP – monitorowanie pracy i opóźnień,
- menedżerów działów – wgląd w koszty,
- controlling / CFO – analiza trendów kosztów i ryzyk,
- audyt – przegląd wyjątków i ścieżki procesu.

