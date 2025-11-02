create table translators
(
    translatorID int not null,
    languageID   int not null,
    constraint translators_pk
        primary key (translatorID),
    constraint translators_languages
        foreign key (languageID) references languages,
    constraint translators_users
        foreign key (translatorID) references users
)
go

grant select on translators to Lecturer
go

