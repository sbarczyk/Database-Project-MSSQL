create procedure updateInternshipDate(@InternshipID int, @StartDate date, @EndDate date) as
BEGIN
    SET NOCOUNT ON;

    IF @EndDate <= @StartDate
    BEGIN
        RAISERROR ('Data zakończenia musi być późniejsza niż data rozpoczęcia.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM internship WHERE internshipID = @InternshipID)
    BEGIN
        RAISERROR ('Praktyka o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    UPDATE internship
    SET startDate = @StartDate,
        endDate = @EndDate
    WHERE internshipID = @InternshipID;

    PRINT 'Daty praktyk zostały zaktualizowane.';
END
go

