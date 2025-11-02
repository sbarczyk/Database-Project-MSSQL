create procedure orderCreate(@orderID int, @studentID int, @orderDate datetime) as
BEGIN
    SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM students WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END;


    IF NOT EXISTS (SELECT 1 FROM cart WHERE studentID = @studentID)
    BEGIN
        RAISERROR ('Student nie ma przypisanego koszyka.', 16, 1);
        RETURN;
    END;


    IF NOT EXISTS (SELECT 1 FROM cartDetails c
                   INNER JOIN cart ct ON c.cartID = ct.cartID
                   WHERE ct.studentID = @studentID)
    BEGIN
        RAISERROR ('Koszyk studenta jest pusty.', 16, 1);
        RETURN;
    END;


    INSERT INTO orders (studentID, orderDate)
    VALUES (@studentID, GETDATE());


    SET @orderID = SCOPE_IDENTITY();


    INSERT INTO orderDetails (orderID, productID)
    SELECT @orderID, c.productID
    FROM cartDetails c
    INNER JOIN cart ct ON c.cartID = ct.cartID
    WHERE ct.studentID = @studentID;


    DELETE FROM cartDetails
    WHERE cartID IN (SELECT cartID FROM cart WHERE studentID = @studentID);

    PRINT 'Zamówienie zostało utworzone.';
END
go

grant execute on orderCreate to Participant
go

