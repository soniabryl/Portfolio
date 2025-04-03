USE CompanyProjectsDB;
GO

--1. Retrieve a list of all roles in the company, which should include the number of employees for each of role assigned
SELECT r.RoleName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Role r
LEFT JOIN Employee e ON r.RoleID = e.RoleID
GROUP BY r.RoleName;
GO
--2. Get roles which has no employees assigned
SELECT r.RoleName
FROM Role r
LEFT JOIN Employee e ON r.RoleID = e.RoleID
WHERE e.EmployeeID IS NULL;
GO

--3. Get projects list where every project has list of roles supplied with number of employees
SELECT p.ProjectName, r.RoleName, COUNT(pe.EmployeeID) AS EmployeeCount
FROM Project p
JOIN ProjectEmployee pe ON p.ProjectID = pe.ProjectID
JOIN Role r ON pe.RoleID = r.RoleID
GROUP BY p.ProjectName, r.RoleName;
GO

--4. For every project count how many tasks there are assigned for every employee in average
SELECT p.ProjectName, AVG(TaskCount) AS AvgTasksPerEmployee
FROM (
    SELECT t.ProjectID, t.AssignedEmployeeID, COUNT(t.TaskID) AS TaskCount
    FROM Task t
    GROUP BY t.ProjectID, t.AssignedEmployeeID
) AS TaskSummary
JOIN Project p ON TaskSummary.ProjectID = p.ProjectID
GROUP BY p.ProjectName;
GO

--5. Determine duration for each project
SELECT ProjectName, DATEDIFF(DAY, CreationDate, CloseDate) AS DurationDays
FROM Project
WHERE Status = 'Closed';
GO

--6. Identify which employees has the lowest number tasks with non-closed statuses.
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, COUNT(t.TaskID) AS NonClosedTasks
FROM Employee e
JOIN Task t ON e.EmployeeID = t.AssignedEmployeeID
WHERE t.Status IN ('Open', 'Need Work')
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY NonClosedTasks ASC;
GO

--7. Identify which employees has the most tasks with non-closed statuses with failed deadlines.
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, COUNT(t.TaskID) AS OverdueTasks
FROM Employee e
JOIN Task t ON e.EmployeeID = t.AssignedEmployeeID
WHERE t.Status IN ('Open', 'Need Work') AND t.Deadline < GETDATE()
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY OverdueTasks DESC;
GO

--8. Move forward deadline for non-closed tasks in 5 days.
UPDATE Task
SET Deadline = DATEADD(DAY, 5, Deadline)
WHERE Status IN ('Open', 'Need Work');
GO

--9. For each project count how many there are tasks which were not started yet.
SELECT p.ProjectName, COUNT(t.TaskID) AS NotStartedTasks
FROM Project p
JOIN Task t ON p.ProjectID = t.ProjectID
WHERE t.Status = 'Open'
GROUP BY p.ProjectName;
GO

--10. For each project which has all tasks marked as closed move status to closed. Close date for such project should match close date for the last accepted task.
UPDATE Project 
SET Status = 'Closed', CloseDate = (
    SELECT MAX(ChangeDate) FROM TaskStatusHistory 
    WHERE Status = 'Accepted' AND TaskID IN (
        SELECT TaskID FROM Task WHERE ProjectID = Project.ProjectID
))
WHERE ProjectID IN (
    SELECT ProjectID FROM Task GROUP BY ProjectID HAVING MIN(Status) = 'Accepted'
);
GO

--11. Determine employees across all projects which has not non-closed tasks assigned.
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employee e
LEFT JOIN Task t ON e.EmployeeID = t.AssignedEmployeeID
WHERE e.EmployeeID NOT IN (
    SELECT DISTINCT AssignedEmployeeID 
    FROM Task 
    WHERE Status IN ('Open', 'Need Work')
);
GO

--12. Assign given project task (using task name as identifier) to an employee which has minimum tasks with open status.
DECLARE @TaskName NVARCHAR(255) = 'Develop Feature X'; -- Change task name as needed
UPDATE Task
SET AssignedEmployeeID = (
    SELECT TOP 1 e.EmployeeID
    FROM Employee e
    LEFT JOIN Task t ON e.EmployeeID = t.AssignedEmployeeID AND t.Status = 'Open'
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
    ORDER BY COUNT(t.TaskID) ASC
)
WHERE TaskName = @TaskName;
GO



