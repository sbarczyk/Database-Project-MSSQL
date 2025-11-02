create procedure AddUserWithCoordinator(@FirstName nvarchar(64), @LastName nvarchar(64), @Email nvarchar(64),
                                        @Password nvarchar(64)) as
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO users (firstName, lastName, email, password)
        VALUES (@FirstName, @LastName, @Email, @Password);

        DECLARE @NewUserID INT;
        SET @NewUserID = SCOPE_IDENTITY();

        INSERT INTO coordinators (coordinatorID)
        VALUES (@NewUserID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
go

