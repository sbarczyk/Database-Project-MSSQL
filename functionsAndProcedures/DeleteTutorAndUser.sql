create procedure DeleteTutorAndUser(@TutorID int) as
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM tutors WHERE tutorID = @TutorID)
        BEGIN
            THROW 50002, 'Invalid TutorID. The specified TutorID does not exist in the tutors table.', 1;
        END;

        DELETE FROM tutors
        WHERE tutorID = @TutorID;

        DELETE FROM users
        WHERE userID = @TutorID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
go

