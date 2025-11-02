create function singleProductPriceHistory(@productID int) returns table as
SELECT
        pph.startDate,
        pph.endDate,
        pph.price
    FROM ProductPriceHistory pph
    WHERE pph.productID = @productID
go

