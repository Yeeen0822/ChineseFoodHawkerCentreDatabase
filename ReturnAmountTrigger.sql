CREATE OR REPLACE TRIGGER trg_calculate_return_amount
BEFORE INSERT ON OrderMenu
FOR EACH ROW
FOLLOWS trg_calTotal
DECLARE
    v_finalized_total Orders.FinalizedTotal%TYPE;
    v_payment_amount Payment.PaymentAmount%TYPE;
    v_return_amount Payment.ReturnAmount%TYPE;
    v_payment_id Orders.PaymentID%TYPE;
BEGIN
    -- Retrieve the PaymentID associated with the OrderID from the Orders table
    SELECT PaymentID INTO v_payment_id
    FROM Orders
    WHERE OrderID = :NEW.OrderID;

    -- Retrieve the finalized total for the corresponding order using the fetched PaymentID
    SELECT FinalizedTotal INTO v_finalized_total
    FROM Orders
    WHERE PaymentID = v_payment_id;

    -- Retrieve payment amount from the Payment table
    SELECT PaymentAmount INTO v_payment_amount
    FROM Payment
    WHERE PaymentID = v_payment_id;

    IF v_payment_amount != 0 AND v_finalized_total != 0 AND v_payment_amount >= v_finalized_total THEN
        -- Calculate the return amount only for cash payments
        v_return_amount := v_payment_amount - v_finalized_total;

        -- Update the return amount in the Payment table
        UPDATE Payment
        SET ReturnAmount = v_return_amount
        WHERE PaymentID = v_payment_id;
    ELSE
        RAISE_APPLICATION_ERROR(-20009, 'Payment Amount or Finalized Total cannot be zero.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order or payment record found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred in the trigger: ' || SQLERRM);
END;
/
