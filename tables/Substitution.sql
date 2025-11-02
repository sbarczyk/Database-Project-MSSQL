create table Substitution
(
    substitutionID    int identity,
    meetingID         int          not null,
    substituteTutorID int          not null,
    reason            nvarchar(64) not null,
    constraint Substitution_pk
        primary key (substitutionID),
    constraint Substitution_meeting
        foreign key (meetingID) references meeting,
    constraint Substitution_tutors
        foreign key (substituteTutorID) references tutors
)
go

grant select on Substitution to Lecturer
go

grant select on Substitution to Participant
go

