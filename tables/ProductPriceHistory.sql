create table ProductPriceHistory
(
    productID int      not null,
    price     money    not null,
    startDate datetime not null,
    endDate   datetime not null,
    constraint PK_ProductPriceHistory
        primary key (productID, startDate),
    constraint ProductPriceHistory_products
        foreign key (productID) references products,
    check ([price] >= 0),
    constraint priceHistoryDateCheck
        check ([endDate] > [startDate])
)
go

