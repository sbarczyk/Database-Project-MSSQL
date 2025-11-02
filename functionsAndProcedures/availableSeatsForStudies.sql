create function availableSeatsForStudies(@studiesID int) returns int as
BEGIN
    DECLARE @placeLimit INT;
    DECLARE @studentCount INT;
    DECLARE @availableSeats INT;

    -- Pobierz limit miejsc dla danych studiów
    SELECT @placeLimit = placeLimit
    FROM studies
    WHERE studiesID = @studiesID;

    -- Policz liczbę zapisanych studentów
    SELECT @studentCount = COUNT(*)
    FROM studiesParticipants
    WHERE studiesID = @studiesID;

    -- Oblicz liczbę dostępnych miejsc
    SET @availableSeats = @placeLimit - @studentCount;

    RETURN @availableSeats;
END
go

grant execute on availableSeatsForStudies to Participant
go

