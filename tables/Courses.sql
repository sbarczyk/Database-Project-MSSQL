create table Courses
(
    courseID      int identity,
    productID     int           not null,
    coordinatorID int           not null,
    title         nvarchar(128),
    description   nvarchar(max) not null,
    startDate     date          not null,
    constraint Courses_pk
        primary key (courseID),
    constraint Courses_coordinators
        foreign key (coordinatorID) references coordinators,
    constraint Courses_products
        foreign key (productID) references products
)
go

grant select on Courses to Lecturer
go

grant select on Courses to Participant
go

