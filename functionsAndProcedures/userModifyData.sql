create procedure userModifyData(@userID int, @firstName nvarchar(64), @lastName nvarchar(64), @email nvarchar(64),
                                @password nvarchar(64)) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy użytkownik o danym userID istnieje
    IF EXISTS (SELECT 1 FROM users WHERE userID = @userID)
    BEGIN
        -- Aktualizacja danych użytkownika
        UPDATE users
        SET
            firstName = @firstName,
            lastName = @lastName,
            email = @email,
            password = @password
        WHERE userID = @userID;

        PRINT 'Dane użytkownika zostały zaktualizowane.';
    END
    ELSE
    BEGIN
        -- Użytkownik o podanym userID nie istnieje
        RAISERROR ('Użytkownik o podanym ID nie istnieje.', 16, 1);
    END
END
go

