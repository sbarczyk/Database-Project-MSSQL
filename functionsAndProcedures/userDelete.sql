create procedure userDelete(@userID int) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy użytkownik istnieje
    IF EXISTS (SELECT 1 FROM users WHERE userID = @userID)
    BEGIN
        -- Usunięcie użytkownika z tabeli 'users'
        DELETE FROM users
        WHERE userID = @userID;

        PRINT 'Użytkownik został usunięty.';
    END
    ELSE
    BEGIN
        -- Jeśli użytkownik nie istnieje, wyświetl komunikat
        RAISERROR ('Użytkownik o podanym ID nie istnieje.', 16, 1);
    END
END
go

