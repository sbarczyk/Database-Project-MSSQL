create function totalRevenueForProduct(@productID float) returns money as
BEGIN
    DECLARE @totalRevenue MONEY = 0;

    -- Oblicz całkowity przychód dla danego produktu
    SELECT @totalRevenue = COUNT(od.productID) * MAX(p.price)
    FROM orderDetails od
    JOIN products p ON od.productID = p.productID
    WHERE od.productID = @productID;

    RETURN @totalRevenue;
END
go

