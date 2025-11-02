create procedure removeWebinar(@webinarID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Webinars WHERE webinarID = @webinarID)
    BEGIN
        RAISERROR ('Webinar o podanym webinarID nie istnieje.', 16, 1);
        RETURN;
    END;

    DELETE FROM Webinars
    WHERE webinarID = @webinarID;

    PRINT 'Webinar został usunięty.';
END
go

