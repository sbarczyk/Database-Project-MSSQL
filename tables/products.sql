create table products
(
    productID       int identity,
    price           money        not null,
    productName     nvarchar(64) not null,
    priceUpdateDate datetime     not null,
    constraint products_pk
        primary key (productID),
    check ([price] >= 0)
)
go

grant select on products to Participant
go

