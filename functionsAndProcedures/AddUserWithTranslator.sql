create procedure AddUserWithTranslator(@FirstName nvarchar(64), @LastName nvarchar(64), @Email nvarchar(64),
                                       @Password nvarchar(64), @LanguageID int) as
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM languages WHERE id = @LanguageID)
        BEGIN
            THROW 50001, 'Invalid LanguageID. The specified LanguageID does not exist in the languages table.', 1;
        END;

        INSERT INTO users (firstName, lastName, email, password)
        VALUES (@FirstName, @LastName, @Email, @Password);

        DECLARE @NewUserID INT;
        SET @NewUserID = SCOPE_IDENTITY();

        INSERT INTO translators (translatorID, languageID)
        VALUES (@NewUserID, @LanguageID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
go

