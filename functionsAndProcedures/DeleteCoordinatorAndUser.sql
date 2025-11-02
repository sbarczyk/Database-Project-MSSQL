create procedure DeleteCoordinatorAndUser(@CoordinatorID int) as
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM coordinators WHERE coordinatorID = @CoordinatorID)
        BEGIN
            THROW 50003, 'Invalid CoordinatorID. The specified CoordinatorID does not exist in the coordinators table.', 1;
        END;

        DELETE FROM coordinators
        WHERE coordinatorID = @CoordinatorID;

        DELETE FROM users
        WHERE userID = @CoordinatorID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
go

