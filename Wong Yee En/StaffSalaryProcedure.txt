SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE Update_Staff_Salary (
    v_StaffID IN CHAR,
    v_IncrementPercentage IN NUMBER
) IS
    v_CurrentSalary NUMBER(12,2);
    v_NewSalary NUMBER(12,2);
    v_row_count NUMBER := 0;
    EMPTY_DATA EXCEPTION;
    INVALID_INCREMENT EXCEPTION;
    INVALID_STAFFID EXCEPTION;
    PRAGMA EXCEPTION_INIT(EMPTY_DATA, -20000); -- REGISTER  
    PRAGMA EXCEPTION_INIT(INVALID_INCREMENT, -20001);
    PRAGMA EXCEPTION_INIT(INVALID_STAFFID, -20002);
BEGIN
    -- Check if staff ID is valid
    IF NOT REGEXP_LIKE(v_StaffID, '^E[0-9][0-9]$') THEN
        RAISE INVALID_STAFFID;
    END IF;

    -- Count the number of rows with the given staff ID
    SELECT COUNT(*) INTO v_row_count
    FROM Staff
    WHERE StaffID = v_StaffID;

    -- If no rows are found, raise EMPTY_DATA exception
    IF (v_row_count = 0) THEN
        RAISE EMPTY_DATA;
    END IF;

    -- Retrieve current salary of the staff
    SELECT Salary INTO v_CurrentSalary
    FROM Staff
    WHERE StaffID = v_StaffID;

    -- If staff is found, calculate new salary
    IF v_CurrentSalary > 0 THEN
        -- Check if increment percentage is within an acceptable range
        IF v_IncrementPercentage < 0 OR v_IncrementPercentage > 100 THEN
            RAISE INVALID_INCREMENT;
        ELSE
            v_NewSalary := v_CurrentSalary * (1 + (v_IncrementPercentage / 100));
            
            -- Update the staff salary
            UPDATE Staff
            SET Salary = v_NewSalary
            WHERE StaffID = v_StaffID;
            
            -- Output message
            DBMS_OUTPUT.PUT_LINE('Staff ' || v_StaffID || ' salary updated successfully.');
            DBMS_OUTPUT.PUT_LINE('New Salary RM: ' || v_NewSalary);
        END IF;
    ELSE
        RAISE EMPTY_DATA; -- or NOSALARY exception could be raised here
    END IF;

EXCEPTION
    WHEN EMPTY_DATA THEN
        DBMS_OUTPUT.PUT_LINE('Staff ' || v_StaffID || ' is not found or has no salary!');
    WHEN INVALID_INCREMENT THEN
        DBMS_OUTPUT.PUT_LINE('Invalid increment percentage. Please provide a percentage between 0 and 100.');
    WHEN INVALID_STAFFID THEN
        DBMS_OUTPUT.PUT_LINE('Invalid staff ID format. Staff ID should start with "E" followed by two digits.');
    WHEN OTHERS THEN
        -- Output error message for any other exceptions
        DBMS_OUTPUT.PUT_LINE('Error updating staff salary: ' || SQLERRM);
END;
/

EXEC Update_Staff_Salary('E19',100)
EXEC Update_Staff_Salary('E09',10)
EXEC Update_Staff_Salary('E02',-50)
