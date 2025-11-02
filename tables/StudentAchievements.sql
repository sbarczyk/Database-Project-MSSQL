create table StudentAchievements
(
    achievementID      int identity,
    studentID          int          not null,
    achievementType    nvarchar(16) not null,
    achievementIDValue int          not null,
    certificateSent    bit          not null,
    constraint StudentAchievements_pk
        primary key (achievementID),
    constraint StudentAchievements_students
        foreign key (studentID) references students
)
go

