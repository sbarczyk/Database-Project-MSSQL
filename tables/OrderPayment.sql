create table OrderPayment
(
    paymentID     int identity,
    exception     bit           not null,
    PaymentStatus bit           not null,
    orderID       int           not null,
    advance       bit default 0 not null,
    paymentDate   datetime,
    link          nvarchar(128),
    constraint OrderPayment_pk
        primary key (paymentID),
    constraint coursePayment_orders
        foreign key (orderID) references orders,
)
go

