create table address
(
    userID  int          not null,
    country nvarchar(64) not null,
    city    nvarchar(64) not null,
    street  nvarchar(64) not null,
    zipCode nvarchar(8)  not null,
    constraint address_pk
        primary key (userID),
    constraint address_users
        foreign key (userID) references users,
    check ([zipCode] like '[0-9][0-9]-[0-9][0-9][0-9]')
)
go

