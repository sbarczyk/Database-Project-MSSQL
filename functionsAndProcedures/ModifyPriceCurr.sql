create procedure ModifyPriceCurr(@currencyID int, @currencyRate real) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy waluta istnieje
    IF NOT EXISTS (SELECT 1 FROM currencies WHERE currencyID = @currencyID)
    BEGIN
        RAISERROR ('Waluta o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie, czy kurs waluty jest prawidłowy
    IF @currencyRate <= 0
    BEGIN
        RAISERROR ('Kurs waluty musi być większy niż 0.', 16, 1);
        RETURN;
    END;

    -- Aktualizacja kursu waluty
    UPDATE currencies
    SET currencyRate = @currencyRate
    WHERE currencyID = @currencyID;

    PRINT 'Kurs waluty został zaktualizowany.';
END
go

