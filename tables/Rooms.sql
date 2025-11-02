create table Rooms
(
    id         int identity,
    name       nvarchar(32) not null,
    placeLimit int          not null,
    constraint Rooms_pk
        primary key (id),
    check ([placeLimit] > 0)
)
go

grant select on Rooms to Lecturer
go

grant select on Rooms to Participant
go

