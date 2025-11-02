create table RODO
(
    consent_id int  not null,
    userID     int  not null,
    status     bit  not null,
    timestamp  date not null,
    constraint RODO_pk
        primary key (consent_id),
    constraint Table_73_users
        foreign key (userID) references users
)
go

