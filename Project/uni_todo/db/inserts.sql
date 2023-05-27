USE project
-- Dummy data for uni_tasks.course
INSERT INTO uni_tasks.course (id, name, field) VALUES
  (1, 'Mathematics', 'Science'),
  (2, 'Computer Science', 'Technology'),
  (3, 'History', 'Humanities'),
  (4, 'Physics', 'Science'),
  (5, 'English', 'Humanities');

-- Dummy data for uni_tasks.country
INSERT INTO uni_tasks.country (code, name, flag) VALUES
  ('US', 'United States', 'us_flag.png'),
  ('UK', 'United Kingdom', 'uk_flag.png'),
  ('AU', 'Australia', 'au_flag.png'),
  ('CA', 'Canada', 'ca_flag.png'),
  ('DE', 'Germany', 'de_flag.png');

-- Dummy data for uni_tasks.university
INSERT INTO uni_tasks.university (id, name, logo_path, ctry_code) VALUES
  (1, 'Harvard University', 'harvard_logo.png', 'US'),
  (2, 'University of Oxford', 'oxford_logo.png', 'UK'),
  (3, 'University of Melbourne', 'melbourne_logo.png', 'AU'),
  (4, 'University of Toronto', 'toronto_logo.png', 'CA'),
  (5, 'Technical University of Munich', 'tum_logo.png', 'DE');

-- Dummy data for uni_tasks.offered_at
INSERT INTO uni_tasks.offered_at (uni_id, crs_id) VALUES
  (1, 1),
  (1, 3),
  (2, 2),
  (3, 1),
  (3, 5);

-- Dummy data for uni_tasks._user
INSERT INTO uni_tasks._user (id, name, password_hash, uni_id) VALUES
  (1, 'John Doe',  HASHBYTES('SHA2_256','password_1'), 1),
  (2, 'Jane Smith',  HASHBYTES('SHA2_256','password_2'), 2),
  (3, 'Michael Johnson',  HASHBYTES('SHA2_256','password_3'), 3),
  (4, 'Emily Wilson',  HASHBYTES('SHA2_256','password_4'), 4),
  (5, 'David Lee',  HASHBYTES('SHA2_256','password_5'), 5);

-- Dummy data for uni_tasks.class
INSERT INTO uni_tasks.class (id, name, crs_id, prof_id) VALUES
  (1, 'Algebra 101', 1, 1),
  (2, 'Introduction to Programming', 2, 2),
  (3, 'World History', 3, 3),
  (4, 'Quantum Mechanics', 4, 4),
  (5, 'Shakespearean Literature', 5, 5);

-- Dummy data for uni_tasks.follows
INSERT INTO uni_tasks.follows (usr_id_follower, usr_id_followee) VALUES
  (1, 2),
  (1, 3),
  (2, 3),
  (3, 1),
  (3, 4);

-- Dummy data for uni_tasks.assignment
INSERT INTO uni_tasks.assignment (id, grade, date, usr_id, cl_id) VALUES
  (1, 90, '2023-05-15', 1, 1),
  (2, 80, '2023-05-16', 2, 2),
  (3, 95, '2023-05-17', 3, 3),
  (4, 88, '2023-05-18', 4, 4),
  (5, 92, '2023-05-19', 5, 5);

-- Dummy data for uni_tasks.enrolled_in
INSERT INTO uni_tasks.enrolled_in (grade, usr_id, cl_id) VALUES
  (16, 1, 1),
  (12, 2, 2),
  (20, 3, 3),
  (9, 4, 4),
  (14, 5, 5);

-- Dummy data for uni_tasks.task
INSERT INTO uni_tasks.task (id, name, cl_id) VALUES
  (1, 'Homework 1', 1),
  (2, 'Lab Exercise 1', 2),
  (3, 'Research Paper', 3),
  (4, 'Problem Set 2', 4),
  (5, 'Essay Assignment', 5);

-- Dummy data for uni_tasks.attributes
INSERT INTO uni_tasks.attributes (t_id, description, [group], status, start_date, end_date, priority_lvl, is_public) VALUES
  (1, 'Complete the algebra problems', 'Homework', 'Pending', '2023-05-20', '2023-05-25', 3, 1),
  (2, 'Implement a sorting algorithm', 'Lab', 'Completed', '2023-05-21', '2023-05-26', 2, 1),
  (3, 'Write a research paper on World War II', 'Research', 'In Progress', '2023-05-22', '2023-05-27', 4, 0),
  (4, 'Solve quantum mechanics problems', 'Homework', 'Pending', '2023-05-23', '2023-05-28', 3, 1),
  (5, 'Analyzing Shakespearean sonnets', 'Essay', 'Completed', '2023-05-24', '2023-05-29', 1, 1);

-- Dummy data for uni_tasks._resource
INSERT INTO uni_tasks._resource (id, path, type, cl_id) VALUES
  (1, 'resource1.pdf', 'PDF', 1),
  (2, 'resource2.docx', 'Document', 2),
  (3, 'resource3.jpg', 'Image', 3),
  (4, 'resource4.pptx', 'Presentation', 4),
  (5, 'resource5.txt', 'Text', 5);

-- Dummy data for uni_tasks.assigned_to
INSERT INTO uni_tasks.assigned_to (usr_id, t_id) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
