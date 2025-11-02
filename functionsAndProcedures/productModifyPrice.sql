create procedure productModifyPrice(@productID int, @price money) as
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie, czy produkt istnieje
    IF NOT EXISTS (SELECT 1 FROM products WHERE productID = @productID)
    BEGIN
        RAISERROR ('Produkt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    -- Sprawdzenie, czy cena jest prawidłowa
    IF @price < 0
    BEGIN
        RAISERROR ('Cena produktu nie może być mniejsza niż 0.', 16, 1);
        RETURN;
    END;

    -- Aktualizacja ceny produktu
    UPDATE products
    SET price = @price,
        priceUpdateDate = GETDATE() -- Aktualizacja daty zmiany ceny
    WHERE productID = @productID;

    PRINT 'Cena produktu została zaktualizowana.';
END
go

