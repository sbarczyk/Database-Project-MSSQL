create table coordinators
(
    coordinatorID int not null,
    constraint coordinators_pk
        primary key (coordinatorID),
    constraint coordinators_users
        foreign key (coordinatorID) references users
)
go

grant select on coordinators to Lecturer
go

