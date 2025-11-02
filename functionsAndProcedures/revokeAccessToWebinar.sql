create procedure revokeAccessToWebinar(@accessID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM WebinarAccess WHERE accessID = @accessID)
    BEGIN
        RAISERROR ('Dostęp o podanym accessID nie istnieje.', 16, 1);
        RETURN;
    END;

    DELETE FROM WebinarAccess
    WHERE accessID = @accessID;

    PRINT 'Dostęp do webinaru został odebrany.';
END
go

