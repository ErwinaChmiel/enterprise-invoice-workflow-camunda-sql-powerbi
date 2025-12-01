11. **Zakończenie ścieżki PO-based**
    - Proces kończy się zdarzeniem „Faktura zaksięgowana”.

---

## 6. Ścieżka dla faktur bez PO (non-PO)

### 6.1. Przypisanie kosztów

5. **Przypisanie do centrum kosztów i konta (kontowanie)**
   - Tworzone jest zadanie użytkownika dla AP Clerk lub właściciela kosztu.
   - Użytkownik uzupełnia:
     - centrum kosztów (Cost Center),
     - konto księgowe (GL Account),
     - ewentualny kod projektu / zlecenia wewnętrznego,
     - opis merytoryczny (np. „Usługi konsultingowe – projekt X”).

6. **Walidacja kontowania**
   - System weryfikuje, czy:
     - centrum kosztów jest aktywne,
     - konto księgowe jest poprawne dla danego typu kosztu,
     - waluta i kwoty są spójne.

### 6.2. Wyznaczenie ścieżki akceptacji

7. **Automatyczne wyznaczenie approverów**
   - Na podstawie:
     - kwoty faktury,
     - centrum kosztów,
     - spółki / kraju,
   - system wyznacza jeden lub kilka poziomów akceptacji, np.:
     - poziom 1 – kierownik działu,
     - poziom 2 – dyrektor/ CFO (dla kwot powyżej określonego progu).

### 6.3. Wielopoziomowa akceptacja

8. **Akceptacja 1. poziomu (Line Manager)**
   - Do kierownika działu trafia zadanie:
     - „Sprawdź i zatwierdź fakturę non-PO”.
   - Kierownik może:
     - zaakceptować fakturę,
     - odrzucić fakturę,
     - odesłać do korekty (np. zmiana centrum kosztów).

9. **Decyzja: czy potrzebny jest 2. poziom akceptacji?**
   - Jeśli kwota przekracza próg określony w polityce finansowej:
     - faktura kierowana jest do approvera 2. poziomu.
   - Jeśli nie – przechodzi od razu do księgowania.

10. **Akceptacja 2. poziomu (wyższy poziom)**
    - Approver 2. poziomu (np. dyrektor finansowy) otrzymuje zadanie:
      - „Zatwierdź fakturę o podwyższonej wartości”.
    - Może:
      - zaakceptować fakturę,
      - odrzucić fakturę,
      - poprosić o dodatkowe wyjaśnienia.

11. **Decyzja końcowa w ścieżce non-PO**
    - W przypadku akceptacji na wszystkich wymaganych poziomach faktura przechodzi do księgowania.
    - W przypadku odrzucenia – faktura otrzymuje status „Rejected”, a proces kończy się zdarzeniem „Faktura odrzucona”.

### 6.4. Księgowanie faktury non-PO

12. **Przygotowanie danych księgowych**
    - Wykorzystywane są informacje o centrum kosztów, kontach GL i opisach.
    - Weryfikowana jest zgodność sum pozycji z wartością nagłówka faktury.

13. **Księgowanie w ERP (symulacja)**
    - Podobnie jak w ścieżce PO-based faktura otrzymuje status „Posted” wraz z numerem dokumentu księgowego.

14. **Zakończenie ścieżki non-PO**
    - Proces kończy się zdarzeniem „Faktura zaksięgowana”.

---

## 7. Eskalacje i kontrola SLA

W procesie zdefiniowane są mechanizmy czasowe (SLA):

- Jeśli zadanie akceptacji nie zostanie wykonane w określonym czasie (np. 3 dni robocze):
  - system wysyła przypomnienie do approvera,
  - może również wysłać powiadomienie do jego przełożonego (eskalacja).

- W przypadku długotrwałego braku decyzji:
  - faktura może otrzymać status „Expired” lub
  - zostać ponownie skierowana do AP Clerk w celu interwencji.

Dane o przekroczeniach SLA są później analizowane w raportach Power BI.

---

## 8. Przykładowe warianty procesu

Poniższe warianty nie są modelowane w pełnych szczegółach, ale proces został zaprojektowany tak, aby można je było łatwo uwzględnić:

- **Faktury korygujące (nota kredytowa / debit note):**
  - powiązanie z fakturą pierwotną,
  - podobna ścieżka akceptacji, lecz z dodatkową walidacją różnicy.

- **Faktury w walutach obcych:**
  - dodatkowy krok ustalenia kursu wymiany,
  - raportowanie zarówno w walucie transakcji, jak i w walucie lokalnej.

- **Faktury podlegające szczególnym zasadom podatkowym:**
  - np. odwrotne obciążenie, mechanizm podzielonej płatności (split payment),
  - konieczność wyboru odpowiedniego schematu podatkowego.

- **Faktury oznaczone jako pilne:**
  - możliwość oznaczenia faktury flagą „priority”,
  - krótsze SLA i szybsze przypomnienia.

---

## 9. Stany końcowe procesu

Proces może zakończyć się w jednym z następujących stanów:

- **Faktura zaksięgowana (Posted)**  
  Dokument został poprawnie zaksięgowany w systemie ERP.

- **Faktura odrzucona (Rejected)**  
  W toku weryfikacji ustalono, że faktura nie powinna zostać zaksięgowana (np. błędny dostawca, brak usługi, duplikat).

- **Faktura wygasła / nieobsłużona (Expired)**  
  Proces przekroczył zdefiniowane limity czasowe bez podjęcia decyzji – wymaga interwencji manualnej i dodatkowej analizy.

Każda zmiana statusu jest zapisywana w historii, co umożliwia pełne śledzenie ścieżki życia faktury oraz późniejszą analizę w systemie raportowym.
