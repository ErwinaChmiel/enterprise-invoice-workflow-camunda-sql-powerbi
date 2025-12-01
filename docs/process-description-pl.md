# Opis procesu – obsługa faktur kosztowych

## 1. Cel procesu

Proces „Obsługa faktur kosztowych” (Accounts Payable) ma zapewnić:

- poprawne merytorycznie i formalnie zaksięgowanie faktur kosztowych,
- zgodność z wewnętrznymi zasadami akceptacji kosztów,
- terminowe regulowanie zobowiązań wobec dostawców,
- pełną ścieżkę audytową dla decyzji akceptacyjnych.

Proces rozpoczyna się w momencie otrzymania faktury od dostawcy, a kończy zaksięgowaniem dokumentu lub jego odrzuceniem.

---

## 2. Role w procesie

W procesie biorą udział następujące role:

- **AP Clerk (Specjalista ds. zobowiązań):**
  - rejestruje faktury w systemie,
  - weryfikuje kompletność danych,
  - kieruje faktury na odpowiednie ścieżki.

- **Cost Owner / Line Manager (Właściciel kosztu / Kierownik działu):**
  - potwierdza zasadność kosztu,
  - akceptuje faktury non-PO.

- **Approver 2nd Level (Dyrektor / CFO / wyższy poziom akceptacji):**
  - akceptuje faktury o wyższych kwotach,
  - zatwierdza wyjątki (np. różnice względem PO).

- **AP Manager / Supervisor:**
  - monitoruje SLA,
  - przyjmuje eskalacje,
  - rozwiązuje spory i konflikty.

- **System ERP (np. SAP / Oracle):**
  - system finansowo-księgowy, w którym finalnie księgowane są faktury (w projekcie zakładamy symulację tego etapu).

---

## 3. Wyzwalacz procesu i źródła faktur

Proces rozpoczyna się, gdy do organizacji wpływa faktura od dostawcy. Źródła faktur mogą być różne:

- faktura papierowa zeskanowana do PDF (czytana przez OCR),
- faktura elektroniczna w formacie PDF lub EDI przesłana na dedykowaną skrzynkę e-mail,
- faktura wgrana przez dostawcę w dedykowanym portalu.

W projekcie zakładamy, że dane faktury są dostępne w postaci ustrukturyzowanej (nagłówek + pozycje).

---

## 4. Główne kroki procesu

### 4.1. Rejestracja faktury

1. **Otrzymanie faktury – Start procesu**  
   Proces rozpoczyna się od zdarzenia „Invoice Received”.  
   Dane faktury (nagłówek, pozycje) są przekazywane do systemu workflow.

2. **Rejestracja / OCR**  
   AP Clerk lub zautomatyzowany komponent (OCR) uzupełnia:
   - numer faktury,
   - numer dostawcy,
   - spółkę (Company Code),
   - datę faktury,
   - kwoty (netto, VAT, brutto),
   - walutę,
   - termin płatności (Due Date),
   - ewentualny numer zamówienia (PO Number).  
   Faktura otrzymuje status „NEW”.

3. **Walidacja podstawowa**  
   System weryfikuje:
   - unikalność kombinacji dostawca + numer faktury (kontrola duplikatów),
   - kompletność wymaganych pól (np. brak daty, brak kwoty).  
   W przypadku błędu faktura może zostać:
   - zwrócona do AP Clerk do poprawy,
   - lub odrzucona (np. duplikat).

---

### 4.2. Rozdzielenie na faktury z PO i bez PO

4. **Decyzja: faktura z PO czy bez PO**  
   System sprawdza, czy w nagłówku faktury został podany numer zamówienia (PO Number).

   - Jeśli tak – faktura kierowana jest do ścieżki **PO-based**.
   - Jeśli nie – faktura trafia do ścieżki **non-PO**.

---

## 5. Ścieżka dla faktur z PO (PO-based)

### 5.1. 3-way match

5. **Automatyczne dopasowanie (3-way match)**  
   System porównuje:
   - dane z faktury (pozycje, ilości, kwoty),
   - dane z zamówienia (Purchase Order),
   - informacje o przyjęciu towaru/usługi (Goods Receipt).

   Sprawdzane są m.in.:

   - zgodność dostawcy i spółki,
   - zgodność wartości,
   - przekroczenia ilości (np. faktura na większą ilość niż w zamówieniu).

6. **Decyzja: wynik dopasowania**  
   - Jeśli różnice mieszczą się w dopuszczalnych tolerancjach – faktura może przejść bez dodatkowej akceptacji.
   - Jeśli występują niezgodności – faktura trafia na ścieżkę **obsługi wyjątków**.

### 5.2. Obsługa wyjątków dla faktur z PO

7. **Wyjątek – zadanie dla właściciela zamówienia**  
   System tworzy zadanie użytkownika dla właściciela PO (Cost Owner / Line Manager).  
   Właściciel może:

   - zaktualizować zamówienie,
   - potwierdzić dopuszczalne odchylenie,
   - odrzucić fakturę (np. usługa nie została zrealizowana).

8. **Decyzja właściciela zamówienia**  
   - W przypadku akceptacji – faktura wraca do ścieżki standardowej i może zostać zaksięgowana.
   - W przypadku odrzucenia – faktura otrzymuje status „Rejected”, a proces kończy się.

### 5.3. Księgowanie faktury z PO

9. **Przygotowanie danych księgowych**  
   System przygotowuje dane do księgowania w ERP (kontowanie z PO).  
   Przypisywane są odpowiednie konta księgowe oraz informacje o podatku.

10. **Księgowanie w ERP (symulacja)**  
    Faktura otrzymuje status „Posted”, zapisywany jest numer dokumentu księgowego oraz data księgowania.

11. **Zakończenie ścieżki PO-based**  
    Proces kończy się zdarzeniem „Faktura zaksięgowana”.

---

## 6. Ścieżka dla faktur bez PO (non-PO)

### 6.1. Przypisanie kosztów

5. **Przypisanie do centrum kosztów i konta (kontowanie)**  
   Tworzone jest zadanie dla AP Clerk lub właściciela kosztu.  
   Użytkownik uzupełnia:

   - centrum kosztów (Cost Center),
   - konto księgowe (GL Account),
   - ewentualny kod projektu / zlecenia,
   - opis merytoryczny (np. „Usługi konsultingowe – projekt X”).

6. **Walidacja kontowania**  
   System weryfikuje, czy:

   - centrum kosztów jest aktywne,
   - konto księgowe jest poprawne dla danego typu kosztu,
   - waluta i kwoty są spójne.

### 6.2. Wyznaczenie ścieżki akceptacji

7. **Automatyczne wyznaczenie approverów**  
   Na podstawie:

   - kwoty faktury,
   - centrum kosztów,
   - spółki / kraju,

   system wyznacza jeden lub kilka poziomów akceptacji, np.:

   - poziom 1 – kierownik działu,
   - poziom 2 – dyrektor/CFO (dla wyższych kwot).

### 6.3. Wielopoziomowa akceptacja

8. **Akceptacja 1. poziomu (Line Manager)**  
   Kierownik działu otrzymuje zadanie „Sprawdź i zatwierdź fakturę non-PO”.  
   Może:

   - zaakceptować fakturę,
   - odrzucić fakturę,
   - odesłać do korekty (np. zmiana centrum kosztów).

9. **Decyzja: czy potrzebny jest 2. poziom akceptacji?**  
   - Jeśli kwota przekracza próg – faktura kierowana jest do approvera 2. poziomu.
   - Jeśli nie – przechodzi do księgowania.

10. **Akceptacja 2. poziomu (wyższy poziom)**  
    Approver 2. poziomu (np. dyrektor finansowy) otrzymuje zadanie „Zatwierdź fakturę o podwyższonej wartości”.  
    Może:

    - zaakceptować fakturę,
    - odrzucić fakturę,
    - poprosić o dodatkowe wyjaśnienia.

11. **Decyzja końcowa w ścieżce non-PO**  
    - W przypadku akceptacji na wszystkich poziomach faktura przechodzi do księgowania.
    - W przypadku odrzucenia – faktura otrzymuje status „Rejected”, a proces kończy się.

### 6.4. Księgowanie faktury non-PO

12. **Przygotowanie danych księgowych**  
    Wykorzystywane są informacje o centrum kosztów, kontach GL i opisach.  
    Spójność kwot na pozycjach z kwotą nagłówka jest ponownie weryfikowana.

13. **Księgowanie w ERP (symulacja)**  
    Faktura otrzymuje status „Posted” wraz z numerem dokumentu księgowego.

14. **Zakończenie ścieżki non-PO**  
    Proces kończy się zdarzeniem „Faktura zaksięgowana”.

---

## 7. Eskalacje i kontrola SLA

W procesie zdefiniowane są mechanizmy czasowe (SLA):

- jeśli zadanie akceptacji nie zostanie wykonane w określonym czasie (np. 3 dni robocze):
  - system wysyła przypomnienie do approvera,
  - może wysłać powiadomienie do przełożonego (eskalacja).

- w przypadku długotrwałego braku decyzji:
  - faktura może otrzymać status „Expired”,
  - lub zostać ponownie skierowana do AP Clerk.

Dane o przekroczeniach SLA są analizowane w raportach Power BI.

---

## 8. Przykładowe warianty procesu

Przykładowe rozszerzenia:

- **Faktury korygujące (nota kredytowa / debit note):**
  - powiązanie z fakturą pierwotną,
  - podobna ścieżka akceptacji z dodatkowymi kontrolami różnicy.

- **Faktury w walutach obcych:**
  - dodatkowy krok ustalenia kursu wymiany,
  - raportowanie w walucie lokalnej i transakcji.

- **Faktury ze szczególnymi zasadami podatkowymi:**
  - np. odwrotne obciążenie, split payment,
  - konieczność wyboru właściwego schematu podatkowego.

- **Faktury pilne:**
  - flaga „priority”,
  - krótsze SLA i szybsze przypomnienia.

---

## 9. Stany końcowe procesu

Proces może zakończyć się w jednym z trzech stanów:

- **Faktura zaksięgowana (Posted)** – dokument zaksięgowany w ERP.
- **Faktura odrzucona (Rejected)** – ustalono, że faktura nie powinna być zaksięgowana.
- **Faktura wygasła (Expired)** – przekroczone limity czasowe bez podjęcia decyzji, wymaga interwencji manualnej.

Każda zmiana statusu jest zapisywana w `InvoiceStatusHistory`, co umożliwia odtworzenie pełnej ścieżki życia faktury.
