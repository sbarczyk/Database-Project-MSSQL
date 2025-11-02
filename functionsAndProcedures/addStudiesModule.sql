create procedure addStudiesModule(@studiesID int, @moduleTitle nvarchar(255), @coordinatorID int,
                                  @description nvarchar(max), @moduleID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM studies WHERE studiesID = @studiesID)
    BEGIN
        RAISERROR ('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM coordinators WHERE coordinatorID = @coordinatorID)
    BEGIN
        RAISERROR ('Koordynator o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    INSERT INTO studyModules (studiesID, description, moduleTitle, coordinatorID)
    VALUES (@studiesID, @description, @moduleTitle, @coordinatorID);

    SET @moduleID = SCOPE_IDENTITY();

    PRINT 'Nowy moduł został dodany.';
END
go

