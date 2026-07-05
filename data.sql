
-- SAMPLE DATA: Student Course Registration System




-- 2. INSERT STUDENTS (10 students)

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (101, 'Jean', 'Muhire', 'jean.muhire@unilak.ac.rw', DATE '2024-09-01');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (102, 'Marie', 'Uwimana', 'marie.uwimana@unilak.ac.rw', DATE '2024-09-01');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (103, 'David', 'Habimana', 'david.habimana@unilak.ac.rw', DATE '2024-09-02');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (104, 'Grace', 'Niyonzima', 'grace.niyonzima@unilak.ac.rw', DATE '2024-09-02');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (105, 'Olivier', 'Rukundo', 'olivier.rukundo@unilak.ac.rw', DATE '2024-09-03');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (106, 'Chantal', 'Mukamazimpaka', 'chantal.mukamazimpaka@unilak.ac.rw', DATE '2024-09-03');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (107, 'Eric', 'Nshimiyimana', 'eric.nshimiyimana@unilak.ac.rw', DATE '2024-09-04');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (108, 'Aline', 'Ishimwe', 'aline.ishimwe@unilak.ac.rw', DATE '2024-09-04');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (109, 'Patrick', 'Mugisha', 'patrick.mugisha@unilak.ac.rw', DATE '2024-09-05');

INSERT INTO students (student_id, first_name, last_name, email, enrolled_date)
VALUES (110, 'Sandra', 'Uwase', 'sandra.uwase@unilak.ac.rw', DATE '2024-09-05');


-- 3. INSERT COURSES (6 courses with different capacities)
--    Available seats: some full (0), some half-empty, some almost full.

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (201, 'Database Programming', 5, 30, 0);      -- FULL

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (202, 'Web Development', 4, 25, 10);

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (203, 'Data Structures & Algorithms', 6, 20, 2);

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (204, 'Operating Systems', 4, 20, 15);

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (205, 'Network Security', 3, 15, 1);          -- Almost full

INSERT INTO courses (course_id, course_name, credits, max_seats, available_seats)
VALUES (206, 'Software Engineering', 5, 25, 8);

-- ------------------------------------------------------------
-- 4. INSERT REGISTRATIONS (22 registrations)
--    Covers multiple students & courses, including duplicates avoided by UNIQUE.
--    Registration date defaults to SYSDATE if omitted.
-- ------------------------------------------------------------
INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (301, 101, 201, 88.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (302, 101, 202, 92.0);

INSERT INTO registrations (registration_id, student_id, course_id)
VALUES (303, 101, 205);   -- no grade yet

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (304, 102, 201, 75.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (305, 102, 203, 81.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (306, 103, 201, 95.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (307, 103, 202, 78.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (308, 103, 204, 85.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (309, 104, 201, 62.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (310, 104, 203, 90.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (311, 105, 201, 71.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (312, 105, 205, 68.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (313, 106, 202, 97.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (314, 106, 203, 88.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (315, 106, 206, 79.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (316, 107, 201, 93.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (317, 107, 204, 86.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (318, 108, 203, 70.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (319, 108, 205, 82.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (320, 109, 201, 89.0);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (321, 109, 206, 91.5);

INSERT INTO registrations (registration_id, student_id, course_id, grade)
VALUES (322, 110, 202, 76.0);


COMMIT;


-- 7. VERIFY DATA (display counts)

PROMPT Data inserted successfully!
PROMPT Students:   (SELECT COUNT(*) FROM students);
PROMPT Courses:    (SELECT COUNT(*) FROM courses);
PROMPT Registrations: (SELECT COUNT(*) FROM registrations);


-- Display sample data to confirm
SELECT 'Students' AS "Table", student_id, first_name, last_name 
FROM students 
WHERE ROWNUM <= 5;

SELECT 'Courses' AS "Table", course_id, course_name, credits, max_seats, available_seats 
FROM courses 
ORDER BY course_id;

SELECT 'Registrations' AS "Table", registration_id, student_id, course_id, grade 
FROM registrations 
WHERE ROWNUM <= 10;
