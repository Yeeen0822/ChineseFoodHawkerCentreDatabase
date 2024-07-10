SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE Insert_Delivery_Company (
    p_CompanyName IN DeliveryCompany.CompanyName%TYPE,
    p_CompanyContact IN DeliveryCompany.CompanyContact%TYPE,
    p_CompanyAddress IN DeliveryCompany.CompanyAddress%TYPE,
    p_CompanyEmail IN DeliveryCompany.CompanyEmail%TYPE
)
IS
    -- Declare variables
    v_CompanyID DeliveryCompany.CompanyID%TYPE;
    v_CompanyExists NUMBER;
    -- Declare custom exceptions
    Missing_Field EXCEPTION;
    Duplicate_Name EXCEPTION;
    PRAGMA EXCEPTION_INIT(Missing_Field, -20001);
    PRAGMA EXCEPTION_INIT(Duplicate_Name, -20003);
BEGIN
    -- Check if any required field is missing
    IF p_CompanyName IS NULL OR p_CompanyAddress IS NULL OR p_CompanyEmail IS NULL THEN
        -- Raise an exception if any required field is missing
        RAISE Missing_Field;
    ELSE
        -- Check if the company name already exists
        SELECT COUNT(*)
        INTO v_CompanyExists
        FROM DeliveryCompany
        WHERE UPPER(CompanyName) = UPPER(p_CompanyName);

        IF v_CompanyExists > 0 THEN
            -- Raise an exception if the company name already exists
            RAISE Duplicate_Name;
        ELSE
            -- Get the maximum CompanyID and increment it
            SELECT 'DC' || LPAD(SUBSTR(MAX(CompanyID), 3) + 1, 2, '0')
            INTO v_CompanyID
            FROM DeliveryCompany;

            -- Insert the new delivery company
            INSERT INTO DeliveryCompany (CompanyID, CompanyName, CompanyContact, CompanyAddress, CompanyEmail)
            VALUES (v_CompanyID, p_CompanyName, p_CompanyContact, p_CompanyAddress, p_CompanyEmail);

            -- Commit the transaction
            COMMIT;

            -- Display success message
            DBMS_OUTPUT.PUT_LINE('New delivery company is inserted successfully with information as shown below.');
            DBMS_OUTPUT.PUT_LINE('Company ID     : ' || v_CompanyID);
 	    DBMS_OUTPUT.PUT_LINE('Company Name   : '|| p_CompanyName);
 	    DBMS_OUTPUT.PUT_LINE('Company Contact: ' || p_CompanyContact);
 	    DBMS_OUTPUT.PUT_LINE('Company Address: ' || p_CompanyAddress);
 	    DBMS_OUTPUT.PUT_LINE('Company Email  : ' || p_CompanyEmail);
        END IF;
    END IF;
EXCEPTION
    -- Handle missing field exception
    WHEN Missing_Field THEN
        -- Display error message
        DBMS_OUTPUT.PUT_LINE('Error: All fields are required.');
    
    -- Handle duplicate name exception
    WHEN Duplicate_Name THEN
        -- Display error message for duplicate company name
        DBMS_OUTPUT.PUT_LINE('Error: Company name ' || p_CompanyName || ' already exists.');

    -- Handle other exceptions
    WHEN OTHERS THEN
        -- Rollback the transaction
        ROLLBACK;
        -- Display generic error message
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END Insert_Delivery_Company;
/


EXEC Insert_Delivery_Company('LaiTapau','03-2117 2732','53,Lrg CP2/12','ye@gmail.com')
EXEC Insert_Delivery_Company('','03-2117 2732','53,Lrg CP/12','ye@gmail.com')
EXEC Insert_Delivery_Company('Grab Food','03-2447 2112','52, Jalan Loke Yew 2','ge@gmail.com')
