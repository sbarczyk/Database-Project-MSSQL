create table cart
(
    cartID    int identity,
    studentID int not null,
    constraint cart_pk
        primary key (cartID),
    constraint cart_students
        foreign key (studentID) references students
)
go

grant select on cart to Participant
go

