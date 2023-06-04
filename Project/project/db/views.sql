CREATE VIEW uni_tasks.TaskListView AS
SELECT
    t.id AS task_id,
    t.name AS task_name,
    c.name AS class_name,
    a.description,
    a.[group],
    a.[status],
    a.start_date,
    a.end_date,
    a.priority_lvl,
    a.is_public,
    assigned.usr_id
FROM
    uni_tasks.task t
    INNER JOIN uni_tasks.attributes a ON a.t_id = t.id
    INNER JOIN uni_tasks.class c ON t.cl_id = c.id
    INNER JOIN uni_tasks.assigned_to assigned ON t.id = assigned.t_id
WHERE
    t.is_deleted = 0;
