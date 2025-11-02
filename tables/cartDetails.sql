create table cartDetails
(
    cartID    int not null,
    productID int not null,
    constraint cartDetails_pk
        primary key (cartID, productID),
    constraint cartDetails_cart
        foreign key (cartID) references cart,
    constraint cartDetails_products
        foreign key (productID) references products
)
go

grant select on cartDetails to Participant
go

