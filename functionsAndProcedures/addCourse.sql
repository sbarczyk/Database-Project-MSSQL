create procedure addCourse(@coordinatorID int, @title nvarchar(100), @description nvarchar(max), @productID int,
                           @startDate date, @courseID int) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy istnieje podany koordynator
    IF NOT EXISTS (SELECT 1 FROM Coordinators WHERE coordinatorID = @coordinatorID)
    BEGIN
        RAISERROR ('Koordynator o podanym coordinatorID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie, czy istnieje podany produkt
    IF NOT EXISTS (SELECT 1 FROM Products WHERE productID = @productID)
    BEGIN
        RAISERROR ('Produkt o podanym productID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Dodanie kursu do tabeli Courses
    INSERT INTO Courses (coordinatorID, title, description, productID, startDate)
    VALUES (@coordinatorID, @title, @description, @productID, @startDate);

    -- Pobranie ID dodanego kursu
    SET @courseID = SCOPE_IDENTITY();

    PRINT 'Kurs został dodany do bazy.';
END
go

