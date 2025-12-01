# Korporacyjny proces akceptacji faktur (Camunda + SQL Server + Power BI)

Repozytorium zawiera **przykładowy proces typu enterprise** dla działu Accounts Payable (AP), czyli obsługi faktur kosztowych od dostawców w dużej korporacji.

Rozwiązanie podzielone jest na trzy główne warstwy:

- **Camunda BPMN** – model procesu obsługi faktur: rejestracja, rozdzielenie na faktury z zamówieniem (PO) i bez, wielopoziomowe akceptacje, księgowanie do ERP.
- **Microsoft SQL Server** – model danych dla dostawców, faktur, akceptacji i historii statusów.
- **Power BI** – warstwa raportowa z KPI i dashboardami dla działu AP.

> Celem projektu jest pokazanie end-to-end myślenia: od zaprojektowania procesu biznesowego, przez model danych, aż po raportowanie i KPI – w kontekście finansowym / korporacyjnym.

---

## Kontekst biznesowy

Duża korporacja otrzymuje co miesiąc tysiące faktur od dostawców, dla wielu jednostek prawnych (**Company Codes**). Faktury mogą:

- odnosić się do **zamówienia (Purchase Order, PO)** → wymagany jest tzw. 3-way match (zamówienie, przyjęcie towaru/usługi, faktura),
- być **bez zamówienia (non-PO)** → wymagają przypisania do centrum kosztów i wielopoziomowej akceptacji w zależności od kwoty i struktury organizacyjnej.

Zespół AP (Accounts Payable) musi:

- zapewnić, że faktury są przetwarzane na czas (przed **terminem płatności – Due Date**),
- minimalizować duplikaty i niezgodności,
- zapewnić przejrzyste KPI i raporty dla menedżerów.

To repozytorium pokazuje, jak taki proces można zamodelować i udokumentować.

---

## Stos technologiczny

- **Silnik procesowy**: Camunda (BPMN 2.0, w repo znajduje się model procesu)
- **Baza danych**: Microsoft SQL Server (schemat + dane przykładowe)
- **Raportowanie**: Power BI (plik PBIX + zrzuty ekranu)
- **Dokumentacja**: Markdown (to repo)

---

## Struktura repozytorium

- `bpmn/` – model procesu BPMN 2.0 wyeksportowany z Camunda Modeler (`invoice-approval.bpmn`)
- `sql/01_schema.sql` – schemat bazy danych dla domeny AP
- `sql/02_sample_data.sql` – przykładowe dane: spółki, dostawcy, faktury, akceptacje
- `powerbi/` – raport Power BI (`ap-dashboard.pbix`) oraz zrzuty ekranu
- `docs/` – dodatkowa dokumentacja:
  - `business-context.md` – opis kontekstu biznesowego i założeń
  - `process-description.md` – opis przebiegu procesu krok po kroku
  - `data-model.md` – opis modelu danych / ERD i tabel
  - `reporting-powerbi.md` – opis KPI i stron raportu

---

## Przegląd procesu (high-level)

Główny proces to **„Akceptacja i księgowanie faktury”**:

1. **Otrzymanie faktury** (e-mail na skrzynkę AP, EDI, upload w portalu)
2. **Rejestracja / OCR** – odczyt danych nagłówka i pozycji faktury
3. **Decyzja: faktura z PO czy bez PO**
4. **Faktury z PO (PO-based)**
   - 3-way match (PO vs przyjęcie towaru/usługi vs faktura)
   - obsługa niezgodności (różnice kwot, brak przyjęcia, brak PO)
5. **Faktury bez PO (non-PO)**
   - przypisanie do centrum kosztów i konta księgowego (GL)
   - wielopoziomowa akceptacja zgodnie z progami kwotowymi i strukturą organizacyjną
6. **Księgowanie do systemu ERP** (w tym projekcie zasymulowane)
7. **Stany końcowe**:
   - Zakksięgowana (`Posted`)
   - Odrzucona (`Rejected`)
   - Wygasła (brak decyzji w zadanym czasie / przekroczone SLA)

Szczegółowy opis przebiegu znajduje się w `docs/process-description.md`.

---

## Przegląd modelu danych

Schemat SQL Server zawiera m.in. następujące tabele:

- `Vendor` – dane podstawowe dostawców
- `CompanyCode` – jednostki prawne / spółki
- `InvoiceHeader`, `InvoiceLine` – nagłówek i pozycje faktury
- `PurchaseOrder`, `PurchaseOrderItem` – uproszczona struktura zamówień dla potrzeb 3-way match
- `InvoiceApproval` – rejestr decyzji akceptacyjnych (kto, kiedy, na jakim poziomie)
- `InvoiceStatusHistory` – historia zmian statusów faktury (audyt)

Szczegóły znajdują się w `docs/data-model.md` oraz w skrypcie `sql/01_schema.sql`.

---

## Raportowanie w Power BI

Raport Power BI skupia się na trzech głównych obszarach:

1. **Przegląd AP (Overview)**
   - liczba i wartość faktur wg okresu, spółki, dostawcy
   - udział faktur z PO vs bez PO
2. **SLA i wąskie gardła**
   - całkowity czas przetwarzania faktury
   - czas na poszczególnych etapach procesu i u konkretnych approverów
   - faktury przeterminowane względem terminu płatności
3. **Koszty wg organizacji**
   - koszty wg spółek, działów, centrów kosztów
   - top dostawcy pod względem wydatków
   - faktury odrzucone i wymagające wyjątkowej obsługi

Zrzuty ekranu znajdują się w `powerbi/screenshots/`, pełny raport – jako `ap-dashboard.pbix`.

---

## Jak korzystać z repozytorium

Projekt ma charakter **portfolio / case study**:

- Model procesu BPMN można otworzyć w **Camunda Modeler**, przeanalizować i rozbudować.
- Skrypty SQL można uruchomić na instancji **Microsoft SQL Server**, aby utworzyć schemat i wczytać dane przykładowe.
- Plik **Power BI** (`.pbix`) można otworzyć w **Power BI Desktop** i modyfikować istniejące dashboardy.

Repozytorium nie zawiera kompletnej aplikacji backendowej – fokus jest na **projektowaniu procesu, modelu danych oraz warstwy raportowej**.

