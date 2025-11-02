create procedure addProduct(@productName nvarchar(64), @price money, @priceUpdateDate datetime) as
BEGIN
    SET NOCOUNT ON;

    -- Walidacja ceny (czy cena jest większa lub równa 0)
    IF @price < 0
    BEGIN
        RAISERROR ('Cena produktu nie może być mniejsza niż 0.', 16, 1);
        RETURN;
    END;

    -- Dodanie nowego produktu do tabeli products
    INSERT INTO products (productName, price, priceUpdateDate)
    VALUES (@productName, @price, GETDATE());

    PRINT 'Produkt został dodany do bazy.';
END
go

