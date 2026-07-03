-- ============================================================
-- FUNCTION: get_total_credits
-- Course: DPR400210 – Database Programming
-- Author: Group Assignment III
-- Date: July 2026
-- ============================================================
-- Description:
--   This function returns the total number of credits a student
--   has accumulated based on their completed registrations.
--   It handles the case where the student has no registrations.
-- ============================================================


CREATE OR REPLACE FUNCTION get_total_credits (
    p_student_id IN NUMBER
) RETURN NUMBER
IS
    v_total_credits NUMBER := 0;
    v_student_exists NUMBER;
    e_student_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_student_not_found, -20005);
BEGIN
    -- --------------------------------------------------------
    -- Validate that the student exists
    -- --------------------------------------------------------
    SELECT COUNT(*) INTO v_student_exists
    FROM students
    WHERE student_id = p_student_id;
    
    IF v_student_exists = 0 THEN
        RAISE e_student_not_found;
    END IF;

    -- --------------------------------------------------------
    -- Compute total credits from registrations
    -- --------------------------------------------------------
    SELECT NVL(SUM(c.credits), 0)
    INTO v_total_credits
    FROM registrations r
    JOIN courses c ON r.course_id = c.course_id
    WHERE r.student_id = p_student_id;
    
    -- If no registrations, the SUM returns NULL, NVL converts to 0.
    -- The function returns the total.
    RETURN v_total_credits;

EXCEPTION
    WHEN e_student_not_found THEN
        -- Raise a user-friendly error message
        RAISE_APPLICATION_ERROR(-20005, 'Student ID ' || p_student_id || ' does not exist.');
    WHEN OTHERS THEN
        -- Return NULL or re-raise; we'll re-raise to notify caller
        RAISE;
END get_total_credits;
/

-- ------------------------------------------------------------
-- 3. Verify function compilation
-- ------------------------------------------------------------
SHOW ERRORS FUNCTION get_total_credits;

-- ------------------------------------------------------------
-- 4. Test the function with sample students
-- ------------------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    v_credits NUMBER;
BEGIN
    -- Test 1: Student with registrations (101)
    v_credits := get_total_credits(101);
    DBMS_OUTPUT.PUT_LINE('Student 101 total credits: ' || v_credits);
    
    -- Test 2: Student with registrations (110 – has only 1 registration)
    v_credits := get_total_credits(110);
    DBMS_OUTPUT.PUT_LINE('Student 110 total credits: ' || v_credits);
    
    -- Test 3: Invalid student (should raise error)
    v_credits := get_total_credits(999);
    DBMS_OUTPUT.PUT_LINE('Student 999 total credits: ' || v_credits);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- ------------------------------------------------------------
-- 5. Use the function in a SQL query
--    Show all students with their total credits
-- ------------------------------------------------------------
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS full_name,
    get_total_credits(s.student_id) AS total_credits
FROM 
    students s
ORDER BY 
    s.student_id;

PROMPT ===============================================
PROMPT Function get_total_credits created successfully.
PROMPT Use: SELECT get_total_credits(student_id) FROM DUAL;
PROMPT ===============================================