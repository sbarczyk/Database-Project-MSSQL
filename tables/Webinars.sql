create table Webinars
(
    webinarID    int identity,
    productID    int           not null,
    tutorID      int           not null,
    translatorID int,
    Title        nvarchar(64)  not null,
    StartDate    datetime      not null,
    Description  nvarchar(max) not null,
    recordingURL nvarchar(128) not null,
    languageID   int           not null,
    endDate      datetime      not null,
    constraint Webinars_pk
        primary key (webinarID),
    constraint Webinars_languages
        foreign key (languageID) references languages,
    constraint Webinars_translators
        foreign key (translatorID) references translators,
    constraint products_Webinars
        foreign key (productID) references products,
    constraint tutors_Webinars
        foreign key (tutorID) references tutors
)
go

grant select on Webinars to Lecturer
go

grant select on Webinars to Participant
go

