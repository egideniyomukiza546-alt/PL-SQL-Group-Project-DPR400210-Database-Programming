


 CREATE TABLES


-- Students table
CREATE TABLE students (
    student_id    NUMBER          PRIMARY KEY,
    first_name    VARCHAR2(50)    NOT NULL,
    last_name     VARCHAR2(50)    NOT NULL,
    email         VARCHAR2(100)   NOT NULL UNIQUE,
    enrolled_date DATE            DEFAULT SYSDATE
);

-- Courses table
CREATE TABLE courses (
    course_id       NUMBER        PRIMARY KEY,
    course_name     VARCHAR2(100) NOT NULL,
    credits         NUMBER(2)     NOT NULL CHECK (credits > 0),
    max_seats       NUMBER(3)     NOT NULL CHECK (max_seats > 0),
    available_seats NUMBER(3)     NOT NULL CHECK (available_seats >= 0)
);

-- Registrations table (junction between students and courses)CREATE TABLE registrations (
    registration_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    course_id NUMBER NOT NULL,
    registration_date DATE DEFAULT SYSDATE,
    grade NUMBER(5,2) CHECK (grade BETWEEN 0 AND 100),
    CONSTRAINT fk_reg_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),
    CONSTRAINT fk_reg_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id),
    CONSTRAINT uk_reg_student_course
        UNIQUE (student_id, course_id)
);


COMMIT;

-- ------------------------------------------------------------
-- 6. VERIFY TABLE STRUCTURE
-- ------------------------------------------------------------
SELECT table_name, status 
FROM user_tables 
WHERE table_name IN ('STUDENTS', 'COURSES', 'REGISTRATIONS')
ORDER BY table_name;

PROMPT ===============================================
PROMPT Schema created successfully!
PROMPT Tables: STUDENTS, COURSES, REGISTRATIONS
PROMPT ===============================================
