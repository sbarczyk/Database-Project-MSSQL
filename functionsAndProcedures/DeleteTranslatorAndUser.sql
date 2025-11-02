create procedure DeleteTranslatorAndUser(@TranslatorID int) as
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM translators WHERE translatorID = @TranslatorID)
        BEGIN
            THROW 50004, 'Invalid TranslatorID. The specified TranslatorID does not exist in the translators table.', 1;
        END;

        DELETE FROM translators
        WHERE translatorID = @TranslatorID;

        DELETE FROM users
        WHERE userID = @TranslatorID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
go

