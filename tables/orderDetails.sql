create table orderDetails
(
    orderID   int not null,
    productID int not null,
    constraint orderDetails_pk
        primary key (orderID, productID),
    constraint orderDetails_orders
        foreign key (orderID) references orders,
    constraint orderDetails_products
        foreign key (productID) references products
)
go

grant select on orderDetails to Participant
go

