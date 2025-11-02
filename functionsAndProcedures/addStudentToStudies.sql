create procedure addStudentToStudies(@studentID int, @studiesID int) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy student już jest zapisany na te studia
    IF EXISTS (
        SELECT 1
        FROM studiesParticipants
        WHERE studentID = @studentID AND studiesID = @studiesID
    )
    BEGIN
        PRINT 'Student już jest zapisany na te studia.';
        RETURN;
    END

    -- Sprawdzenie, czy są wolne miejsca na studiach
    IF dbo.availableSeatsForStudies(@studiesID) <= 0
    BEGIN
        PRINT 'Brak dostępnych miejsc na studiach.';
        RETURN;
    END

    -- Dodanie studenta do studiów
    INSERT INTO studiesParticipants (studiesID, studentID)
    VALUES (@studiesID, @studentID);

    PRINT 'Student został zapisany na studia.';
END
go

