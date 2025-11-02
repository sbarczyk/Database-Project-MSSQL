create table orders
(
    orderID   int identity,
    studentID int      not null,
    orderDate datetime not null,
    constraint orders_pk
        primary key (orderID),
    constraint orders_students
        foreign key (studentID) references students
)
go

grant select on orders to Participant
go

