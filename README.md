# System Zarządzania Kursami i Szkoleniami — Projekt Baz Danych (MS SQL)

Projekt akademicki realizowany w ramach przedmiotu **Systemy Baz Danych** na **Akademii Górniczo-Hutniczej w Krakowie (Wydział Informatyki)**.  
Celem projektu było zaprojektowanie oraz implementacja relacyjnego systemu bazodanowego dla firmy oferującej różne formy kursów i szkoleń — zarówno stacjonarnych, jak i online.

## Opis projektu

System obejmuje kompleksowy model obsługi kursów, webinarów oraz studiów podyplomowych, uwzględniający m.in.:
- różne formy zajęć (stacjonarne, online synchroniczne, online asynchroniczne, hybrydowe),
- zarządzanie uczestnikami, prowadzącymi i tłumaczami,
- obsługę płatności (z integracją z zewnętrznym systemem),
- generowanie raportów finansowych i organizacyjnych,
- kontrolę frekwencji oraz możliwość odrabiania nieobecności,
- mechanizmy ról i uprawnień użytkowników,
- zapewnienie integralności i spójności danych poprzez **triggery**, **procedury składowane** oraz **widoki**.

Projekt został w pełni zrealizowany przy użyciu **Microsoft SQL Server**.

## Kluczowe elementy

- **Schemat bazy danych**: pełny diagram encji z opisem tabel i kluczy obcych.  
- **Integralność danych**: zastosowanie ograniczeń, wartości domyślnych i unikalnych indeksów.  
- **Widoki i raporty**: raporty finansowe, listy obecności, analiza frekwencji, bilokacja uczestników.  
- **Procedury i triggery**: logika biznesowa zapewniająca spójność danych i automatyzację operacji.  
- **Uprawnienia**: system ról (administrator, wykładowca, uczestnik) z różnymi poziomami dostępu.  

## Technologie

- **Microsoft SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**

## Autorzy

- **Szymon Barczyk**  
- **Jan Dyląg**  
- **Maciej Trznadel**  

Akademia Górniczo-Hutnicza w Krakowie  
Wydział Informatyki

## Cel projektu

Projekt stanowił podsumowanie praktycznych umiejętności w zakresie projektowania i implementacji relacyjnych baz danych, w tym:
- analizy wymagań systemowych,  
- projektowania złożonych schematów danych,  
- optymalizacji zapytań i struktury indeksów,  
- implementacji zaawansowanej logiki biznesowej w SQL.  

Dzięki rozbudowanemu modelowi i realistycznym założeniom biznesowym projekt odzwierciedla rzeczywiste wyzwania inżynierii danych w środowisku komercyjnym.

