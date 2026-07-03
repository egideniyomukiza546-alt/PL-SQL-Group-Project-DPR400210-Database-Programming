-- ============================================================
-- ANONYMOUS BLOCK: Enrol a student with validation
-- Course: DPR400210 – Database Programming
-- Author: Group Assignment III
-- Date: July 2026
-- ============================================================
-- Description:
--   This anonymous block performs a single enrolment transaction.
--   It checks available seats, ensures the student is not already
--   registered, and updates the course seat count.
--   It is written as a standalone script for a quick, one‑off action.
-- ============================================================

SET SERVEROUTPUT ON;

DECLARE
    -- Input parameters (modify these to test different scenarios)
    v_student_id    NUMBER := 110;   -- Change to any existing student
    v_course_id     NUMBER := 203;   -- Change to any existing course
    
    -- Local variables
    v_available     NUMBER;
    v_max_seats     NUMBER;
    v_reg_id        NUMBER;
    v_exists        NUMBER;
    
    -- Custom exceptions
    e_course_full   EXCEPTION;
    e_duplicate     EXCEPTION;
    e_student_not_found EXCEPTION;
    e_course_not_found EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(e_course_full, -20001);
    PRAGMA EXCEPTION_INIT(e_duplicate, -20002);
    PRAGMA EXCEPTION_INIT(e_student_not_found, -20003);
    PRAGMA EXCEPTION_INIT(e_course_not_found, -20004);

BEGIN
    -- --------------------------------------------------------
    -- Step 1: Validate student exists
    -- --------------------------------------------------------
    SELECT COUNT(*) INTO v_exists
    FROM students
    WHERE student_id = v_student_id;
    
    IF v_exists = 0 THEN
        RAISE e_student_not_found;
    END IF;

    -- --------------------------------------------------------
    -- Step 2: Get course details with row lock
    -- --------------------------------------------------------
    SELECT available_seats, max_seats 
    INTO v_available, v_max_seats
    FROM courses
    WHERE course_id = v_course_id
    FOR UPDATE;
    
    -- If no course found, NO_DATA_FOUND is raised.

    -- --------------------------------------------------------
    -- Step 3: Check course capacity
    -- --------------------------------------------------------
    IF v_available <= 0 THEN
        RAISE e_course_full;
    END IF;

    -- --------------------------------------------------------
    -- Step 4: Check duplicate registration
    -- --------------------------------------------------------
    SELECT COUNT(*) INTO v_exists
    FROM registrations
    WHERE student_id = v_student_id AND course_id = v_course_id;
    
    IF v_exists > 0 THEN
        RAISE e_duplicate;
    END IF;

    -- --------------------------------------------------------
    -- Step 5: Generate new registration ID
    -- --------------------------------------------------------
    SELECT NVL(MAX(registration_id), 0) + 1 
    INTO v_reg_id
    FROM registrations;

    -- --------------------------------------------------------
    -- Step 6: Insert registration and update seats
    -- --------------------------------------------------------
    INSERT INTO registrations (registration_id, student_id, course_id, registration_date)
    VALUES (v_reg_id, v_student_id, v_course_id, SYSDATE);
    
    UPDATE courses 
    SET available_seats = available_seats - 1
    WHERE course_id = v_course_id;

    -- --------------------------------------------------------
    -- Step 7: Commit and report
    -- --------------------------------------------------------
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('✅ SUCCESS: Student ' || v_student_id || 
                         ' enrolled in course ' || v_course_id || 
                         '. Seats left: ' || (v_available - 1));

EXCEPTION
    WHEN e_student_not_found THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: Student ID ' || v_student_id || ' does not exist.');
    
    WHEN e_course_not_found THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: Course ID ' || v_course_id || ' does not exist.');
    
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: Course ID ' || v_course_id || ' does not exist.');
    
    WHEN e_course_full THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: Course ' || v_course_id || 
                             ' is full (max: ' || v_max_seats || ').');
    
    WHEN e_duplicate THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ ERROR: Student ' || v_student_id || 
                             ' is already registered for course ' || v_course_id || '.');
    
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('❌ UNEXPECTED ERROR: ' || SQLERRM);
END;
/

-- ------------------------------------------------------------
-- After running, you can check the updated seat counts:
-- ------------------------------------------------------------
SELECT course_id, course_name, available_seats, max_seats
FROM courses
WHERE course_id IN (201, 203, 205);  -- Show our test courses

PROMPT ===============================================
PROMPT Anonymous block execution complete.
PROMPT Modify v_student_id and v_course_id to test different cases.
PROMPT ===============================================