create procedure productCartAdd(@cartID int, @studentID int, @productID int) as
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM cart WHERE cartID = @cartID AND studentID = @studentID)
    BEGIN
        RAISERROR ('Koszyk o podanym ID nie istnieje dla tego studenta.', 16, 1);
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM students WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;
    IF NOT EXISTS (SELECT 1 FROM products WHERE productID = @productID)
    BEGIN
        RAISERROR ('Produkt o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;

    INSERT INTO cartDetails (cartID, productID)
    VALUES (@cartID, @productID);

    PRINT 'Produkt został dodany do koszyka.';
END
go

grant execute on productCartAdd to Participant
go

