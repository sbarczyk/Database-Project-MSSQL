create procedure studentModifyAddress(@studentID int, @country nvarchar(64), @city nvarchar(64), @street nvarchar(64),
                                      @zipCode nvarchar(8)) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy adres dla podanego studentID istnieje
    IF EXISTS (SELECT 1 FROM address WHERE userID = @studentID)
    BEGIN
        -- Aktualizacja adresu studenta
        UPDATE address
        SET
            country = @country,
            city = @city,
            street = @street,
            zipCode = @zipCode
        WHERE userID = @studentID;

        PRINT 'Adres został zaktualizowany.';
    END
    ELSE
    BEGIN
        -- Jeśli adres nie istnieje
        RAISERROR ('Nie znaleziono adresu dla podanego studentID.', 16, 1);
    END
END
go

grant execute on studentModifyAddress to Participant
go

