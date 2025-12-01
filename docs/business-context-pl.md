# Kontekst biznesowy – obsługa faktur kosztowych w dużej korporacji

## 1. Wprowadzenie

Projekt przedstawia przykładowy, ustandaryzowany proces obsługi faktur kosztowych (Accounts Payable, AP) w dużej organizacji wielospółkowej.  
Celem jest pokazanie, w jaki sposób można:

- zaprojektować proces biznesowy,
- odwzorować go w modelu danych,
- oraz zbudować na tej podstawie raportowanie menedżerskie.

Proces jest zaimplementowany w formie modelu BPMN (Camunda), schematu bazy danych (SQL Server) oraz przykładowych dashboardów (Power BI).

---

## 2. Środowisko korporacyjne

Przyjmujemy, że:

- Firma posiada wiele jednostek prawnych (**Company Codes**) działających w różnych krajach.
- Co miesiąc wpływa **kilka tysięcy faktur** od setek dostawców (media, usługi, licencje, konsulting, podwykonawcy).
- Organizacja korzysta z centralnego systemu ERP (np. SAP / Oracle), ale klasyczny workflow akceptacji faktur jest:
  - mało elastyczny,
  - trudny do raportowania,
  - i nie zapewnia wystarczającej przejrzystości.

Dział Accounts Payable odpowiada za poprawne i terminowe zaksięgowanie faktur przy zachowaniu zgodności z:

- wewnętrznymi zasadami kontroli (kontrola kosztów, autoryzacje),
- oraz wymaganiami audytu (pełna ścieżka akceptacji i historia decyzji).

---

## 3. Problem biznesowy

W dotychczasowym procesie pojawiają się typowe problemy:

- Brak spójnego przepływu pracy – różne spółki pracują w różny sposób, na mailach i arkuszach.
- Ograniczona widoczność statusu faktury – trudno stwierdzić, gdzie obecnie „leży” faktura i dlaczego nie jest zaksięgowana.
- Długi czas od otrzymania faktury do księgowania:
  - faktury zalegają w skrzynkach mailowych approverów,
  - brakuje przypomnień i eskalacji.
- Trudności z raportowaniem:
  - brak centralnej bazy informacji o fakturach i przebiegu akceptacji,
  - raporty są przygotowywane ręcznie w Excelu.

Dodatkowo:

- Część faktur powinna być powiązana z istniejącymi zamówieniami (PO), ale w praktyce faktury są często wprowadzane jako non-PO.
- Brakuje kontroli duplikatów (te same faktury księgowane więcej niż raz).

---

## 4. Cele projektu

Projekt ma na celu:

1. **Ustandaryzowanie procesu AP** w skali całej organizacji:
   - wspólny model procesu,
   - jasne role, zadania i punkty decyzyjne.

2. **Zapewnienie przejrzystości i śledzenia statusów faktur:**
   - możliwość odpowiedzi na pytanie: „Na jakim etapie jest dana faktura i kto jest za nią odpowiedzialny?”.

3. **Skrócenie czasu obsługi faktur:**
   - automatyczny przepływ zadań,
   - przypomnienia i eskalacje po przekroczeniu SLA,
   - jasne ścieżki akceptacji (poziomy, progi kwotowe).

4. **Wsparcie kontroli kosztów i audytu:**
   - pełna historia statusów i decyzji akceptacyjnych,
   - rejestrowanie kto, kiedy, na jakim poziomie zaakceptował lub odrzucił fakturę.

5. **Zbudowanie warstwy raportowej:**
   - KPI dla działu AP,
   - analiza opóźnień i wąskich gardeł,
   - przegląd kosztów wg spółek, działów i centrów kosztów.

---

## 5. Interesariusze

Główne grupy interesariuszy procesu:

- **Dział AP (Accounts Payable):**
  - rejestracja faktur,
  - wstępna weryfikacja,
  - koordynacja akceptacji i kontakt z dostawcami.

- **Właściciele kosztów / menedżerowie działów:**
  - potwierdzanie zasadności kosztu,
  - akceptacja faktur non-PO,
  - wyjaśnianie niezgodności w fakturach PO.

- **Dyrektorzy finansowi / CFO / Controlling:**
  - zatwierdzanie faktur o wysokich kwotach,
  - nadzór nad budżetem i strukturą kosztów,
  - wymagania raportowe.

- **Dział IT / właściciele systemów:**
  - utrzymanie integracji z ERP,
  - konfiguracja procesów w silniku workflow.

- **Audyt wewnętrzny i zewnętrzny:**
  - weryfikacja zgodności z procedurami,
  - kontrola kompletności historii akceptacji.

---

## 6. Zakres projektu

W ramach tego projektu zakresem objęte są:

- **Proces biznesowy** obsługi faktur kosztowych:
  - od momentu otrzymania faktury,
  - przez rejestrację, weryfikację i akceptację,
  - aż do zaksięgowania w ERP.

- **Obsługa dwóch typów faktur:**
  - faktury powiązane z zamówieniem (PO-based),
  - faktury bez zamówienia (non-PO).

- **Model danych w Microsoft SQL Server:**
  - dostawcy, spółki,
  - nagłówki i pozycje faktur,
  - uproszczone zamówienia,
  - decyzje akceptacyjne i historia statusów.

- **Raportowanie w Power BI:**
  - KPI wydajności działu AP,
  - analiza SLA i opóźnień,
  - struktura kosztów wg organizacji,
  - wyjątki: faktury odrzucone, z dużymi odchyleniami, wymagające ręcznej interwencji.

---

## 7. Poza zakresem

Poza zakresem projektu znajdują się:

- Pełna integracja z realnym systemem ERP (SAP / Oracle) – w projekcie zakładamy symulowane księgowanie.
- Rzeczywisty OCR dokumentów i integracja z pocztą e-mail – zakładamy, że dane faktury są już dostępne w ustrukturyzowanej formie.
- Szczegółowe odwzorowanie wszystkich wariantów podatkowych i prawnych w różnych krajach.

---

## 8. Główne założenia

- Każda faktura posiada jednoznacznego dostawcę i spółkę (Company Code).
- Każda faktura może posiadać numer PO (dla faktur PO-based) lub nie (dla non-PO).
- Dla faktur non-PO wymagane jest przypisanie:
  - centrum kosztów,
  - oraz konta księgowego (GL Account).
- Ścieżka akceptacji zależy od:
  - kwoty faktury,
  - struktury organizacyjnej,
  - oraz ewentualnie typu kosztu.

---

## 9. Przykładowe KPI

Przykładowe miary (KPI), które można wyliczać na podstawie zaprojektowanego modelu danych:

- Średni czas od **otrzymania faktury** do **zaksięgowania**.
- % faktur zaksięgowanych przed terminem płatności (Due Date).
- Udział faktur z PO vs faktur non-PO.
- Liczba faktur przypadająca na danego approvera / dział.
- Liczba i odsetek faktur odrzuconych.
- Liczba faktur z wyjątkiem (niezgodność z PO, brak przyjęcia, inne odchylenia).
- Koszty wg spółek, działów, centrów kosztów i dostawców.

Te KPI są wykorzystywane w raportach przygotowanych w Power BI.
