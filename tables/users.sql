create table users
(
    userID    int identity,
    firstName nvarchar(64) not null,
    lastName  nvarchar(64) not null,
    email     nvarchar(64) not null,
    password  nvarchar(64) not null,
    constraint users_pk
        primary key (userID),
    constraint email
        unique (email)
)
go

grant select on users to Lecturer
go

