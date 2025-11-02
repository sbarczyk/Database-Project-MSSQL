create table meeting
(
    meetingID         int identity,
    tutorID           int      not null,
    startDate         datetime not null,
    endDate           datetime not null,
    languageID        int      not null,
    meetingTranslator int,
    constraint meeting_pk
        primary key (meetingID),
    constraint meeting_languages
        foreign key (languageID) references languages,
    constraint meeting_translators
        foreign key (meetingTranslator) references translators,
    constraint meeting_tutors
        foreign key (tutorID) references tutors,
    constraint meetingDateCheck
        check ([endDate] > [startDate])
)
go

grant select on meeting to Lecturer
go

grant select on meeting to Participant
go

