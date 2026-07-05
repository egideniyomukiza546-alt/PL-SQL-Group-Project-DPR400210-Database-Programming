
-- STORED PROCEDURE: enrol_student



-- 2. CREATE PROCEDURE

CREATE OR REPLACE PROCEDURE enrol_student (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER
)
AS
    v_available       NUMBER;
    v_max_seats       NUMBER;
    v_registration_id NUMBER;
    v_exists          NUMBER;

    e_course_full     EXCEPTION;
    e_duplicate       EXCEPTION;
    e_invalid_student EXCEPTION;

BEGIN
    -- Check student exists
    SELECT COUNT(*)
    INTO v_exists
    FROM students
    WHERE student_id = p_student_id;

    IF v_exists = 0 THEN
        RAISE e_invalid_student;
    END IF;

    -- Check course exists and lock row
    SELECT available_seats, max_seats
    INTO v_available, v_max_seats
    FROM courses
    WHERE course_id = p_course_id
    FOR UPDATE;

    -- Check seats
    IF v_available <= 0 THEN
        RAISE e_course_full;
    END IF;

    -- Check duplicate registration
    SELECT COUNT(*)
    INTO v_exists
    FROM registrations
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF v_exists > 0 THEN
        RAISE e_duplicate;
    END IF;

    -- Generate new registration id
    SELECT NVL(MAX(registration_id),300) + 1
    INTO v_registration_id
    FROM registrations;

    -- Insert registration
    INSERT INTO registrations
    (
        registration_id,
        student_id,
        course_id,
        registration_date
    )
    VALUES
    (
        v_registration_id,
        p_student_id,
        p_course_id,
        SYSDATE
    );

    -- Update seats
    UPDATE courses
    SET available_seats = available_seats - 1
    WHERE course_id = p_course_id;

    DBMS_OUTPUT.PUT_LINE('Student enrolled successfully.');
    DBMS_OUTPUT.PUT_LINE('Registration ID: ' || v_registration_id);
    DBMS_OUTPUT.PUT_LINE('Remaining seats: ' || (v_available - 1));

EXCEPTION
    WHEN e_invalid_student THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Student ID ' || p_student_id || ' does not exist.');

    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Course ID ' || p_course_id || ' does not exist.');

    WHEN e_course_full THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Course ' || p_course_id || ' is full.');

    WHEN e_duplicate THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Student is already registered for this course.');

    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Duplicate registration.');

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999,
            'Unexpected error: ' || SQLERRM);
END enrol_student;
/

-- 4. Verify procedure compilation

SHOW ERRORS PROCEDURE enrol_student;

-- 5. TEST EXECUTION (optional – run this to test the procedure)
--    Uncomment the block below to run tests after creation.

/*
SET SERVEROUTPUT ON;

BEGIN
    -- Test 1: Enrol student 110 into course 203 (has 2 available seats)
    enrol_student(110, 203);
END;
/

BEGIN
    -- Test 2: Try to enrol student 110 into course 201 (full)
    enrol_student(110, 201);
END;
/

BEGIN
    -- Test 3: Try to enrol student 110 into course 203 again (duplicate)
    enrol_student(110, 203);
END;
/

BEGIN
    -- Test 4: Try with invalid student ID (999)
    enrol_student(999, 203);
END;
/

BEGIN
    -- Test 5: Try with invalid course ID (999)
    enrol_student(110, 999);
END;
/
*/


-- 6. Display current state for verification


PROMPT Procedure created successfully!
PROMPT Use: EXEC enrol_student(student_id, course_id);


-- Check current available seats for testing reference
SELECT course_id, course_name, available_seats, max_seats
FROM courses
ORDER BY course_id;
