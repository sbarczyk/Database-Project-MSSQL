create table internship
(
    internshipID int identity,
    studiesID    int  not null,
    startDate    date not null,
    endDate      date not null,
    constraint internship_pk
        primary key (internshipID),
    constraint internship_studies
        foreign key (studiesID) references studies,
    constraint internshipDateCheck
        check ([endDate] > [startDate])
)
go

grant select on internship to Lecturer
go

grant select on internship to Participant
go

