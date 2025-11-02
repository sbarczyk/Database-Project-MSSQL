create view vCourseCompletitionProgress as
SELECT 
    ca.courseID,
    co.title AS CourseTitle,
    ca.studentID,
    u.firstName,
    u.lastName,
    COUNT(*) AS TotalModules,
    COUNT(mp.moduleID) AS PassedModules,
    CASE 
       WHEN COUNT(*)=0 THEN 0 
       ELSE 100.0 * COUNT(mp.moduleID) / COUNT(*)
    END AS CompletionPercent
FROM CourseModules cm
JOIN Courses co ON co.courseID = cm.courseID
JOIN CourseAccess ca ON ca.courseID = cm.courseID
JOIN users u ON u.userID = ca.studentID
LEFT JOIN courseModulesPassed mp 
       ON mp.moduleID = cm.moduleID 
       AND mp.studentID = ca.studentID
GROUP BY 
    ca.courseID,
    co.title,
    ca.studentID,
    u.firstName,
    u.lastName
go

