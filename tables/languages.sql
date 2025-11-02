create table languages
(
    id   int          not null,
    name nvarchar(32) not null,
    constraint languages_pk
        primary key (id)
)
go

grant select on languages to Lecturer
go

