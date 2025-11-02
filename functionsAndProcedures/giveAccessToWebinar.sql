create procedure giveAccessToWebinar(@studentID int, @webinarID int, @accessStartDate datetime, @accessEndDate datetime,
                                     @accessID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Students WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym studentID nie istnieje.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Webinars WHERE webinarID = @webinarID)
    BEGIN
        RAISERROR ('Webinar o podanym webinarID nie istnieje.', 16, 1);
        RETURN;
    END;

    INSERT INTO WebinarAccess (studentID, webinarID, accessStartDate, accessEndDate)
    VALUES (@studentID, @webinarID, @accessStartDate, @accessEndDate);

    SET @accessID = SCOPE_IDENTITY();

    PRINT 'Dostęp do webinaru został przyznany.';
END
go

