create procedure userAdd(@firstName nvarchar(64), @lastName nvarchar(64), @email nvarchar(64), @password nvarchar(64),
                         @userID int) as
BEGIN
    SET NOCOUNT ON;

    -- Dodanie nowego użytkownika do tabeli 'users'
    INSERT INTO users (firstName, lastName, email, password)
    VALUES (@firstName, @lastName, @email, @password);

    -- Pobranie wygenerowanego userID
    SET @userID = SCOPE_IDENTITY();
END
go

