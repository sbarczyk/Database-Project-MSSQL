create view CourseDiplomasView as
WITH Completion AS (
    SELECT
        ca.courseID,
        ca.studentID,
        COUNT(*) AS totalModules,
        SUM(CASE WHEN cmp.moduleID IS NOT NULL THEN 1 ELSE 0 END) AS passedModules
    FROM CourseAccess ca
    JOIN CourseModules cm ON cm.courseID = ca.courseID
    LEFT JOIN courseModulesPassed cmp 
        ON cmp.moduleID = cm.moduleID
        AND cmp.studentID = ca.studentID
    GROUP BY
        ca.courseID,
        ca.studentID
)
SELECT
    co.courseID,
    co.title AS CourseTitle,
    comp.studentID,
    u.firstName,
    u.lastName,
    a.country,
    a.city,
    a.street,
    a.zipCode,

    CASE WHEN comp.totalModules = 0 THEN 0 
         ELSE 100.0 * comp.passedModules / comp.totalModules 
    END AS CompletionPercent
FROM Completion comp
JOIN Courses co 
    ON co.courseID = comp.courseID
JOIN users u
    ON u.userID = comp.studentID
JOIN address a
    ON a.userID = comp.studentID
WHERE 
    co.startDate < GETDATE()
    AND (CASE WHEN comp.totalModules = 0 THEN 0 
              ELSE 100.0 * comp.passedModules / comp.totalModules 
         END) >= 80.0
go

