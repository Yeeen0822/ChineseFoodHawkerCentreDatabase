SET SERVEROUTPUT ON
SET LINESIZE 120
SET PAGESIZE 100
ALTER SESSION SET NLS_DATE_FORMAT ='DD/MM/YYYY';

cl screen
-- IDEA
-- DOB getAge()
-- Outer Cursor(CustID, CustName, Cust Address LIKE %Ampang%'...,CustContact,CustAge)
-- Inner Cursor(OrderID,OrderDate,OrderTime,TotalSpent,
-- Variable, grand_total_amount(sum of all cust total spent),total_customer (sum of a cust's total spent))



CREATE OR REPLACE FUNCTION fun_getAge(v_dob IN DATE) RETURN NUMBER IS
 BEGIN
  RETURN EXTRACT (YEAR FROM (SYSDATE - v_dob) YEAR TO MONTH);
 END;
/


--fun_getAge(v_dob)

CREATE OR REPLACE PROCEDURE prc_cust_orders_on_duration(v_startDate IN DATE,v_endDate IN DATE) IS

    v_custID Orders.CustID%TYPE;
    v_custName Customer.CustName%TYPE;
    v_custAddress Customer.CustAddress%TYPE;
    v_custContact Customer.CustContact%TYPE;
    v_dob Customer.CustDOB%TYPE;
    v_orderID Orders.OrderID%TYPE;
    v_orderDate Orders.OrderDate%TYPE;
    v_orderTime Orders.OrderTime%TYPE;
    v_total Orders.FINALIZEDTOTAL%TYPE;

--create extra variable
    v_grandtotal NUMBER(11,2); 
    v_totalValue NUMBER(11,2);
     

-- create cursor   
CURSOR custCursor IS
SELECT DISTINCT C.CustID, C.CustName, CustAddress, CustContact, CustDOB
FROM Customer C
JOIN Orders O ON C.CustID = O.CustID
WHERE O.OrderDate BETWEEN v_startDate AND v_endDate
ORDER BY C.CUSTID;



-- create cursor
CURSOR orderCursor IS 
SELECT OrderID,OrderDate,OrderTime,FinalizedTotal
FROM Orders O
WHERE O.OrderDate BETWEEN v_startDate AND v_endDate
AND O.CustID = v_custID
ORDER BY OrderDate;



BEGIN
DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'=')); 
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE(RPAD('-', 35, '-') || 'Customer Orders Report' || RPAD('-', 43, '-'));
DBMS_OUTPUT.PUT_LINE(CHR(10));

OPEN custCursor; 
--initialize after open cursor
v_totalValue := 0;
LOOP
FETCH custCursor INTO v_custID, v_custName, v_custAddress, v_custContact, v_dob;
EXIT WHEN custCursor%NOTFOUND;



--Title
-- 10 space, 4 for 'Code', 6 for space
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Customer ID    : ' || v_custID);
  DBMS_OUTPUT.PUT_LINE('Customer Name  : ' || v_custName);
  DBMS_OUTPUT.PUT_LINE('Address        : ' || v_custAddress);
  DBMS_OUTPUT.PUT_LINE('Contact        : ' || v_custContact);
  DBMS_OUTPUT.PUT_LINE('Age            : ' || fun_getAge(v_dob));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


--Heading
  DBMS_OUTPUT.PUT_LINE(RPAD('Order ID',10,' ') ||
                       RPAD('Order Date',15,' ') ||
                       RPAD('Order Time',19,' ') ||
                       RPAD('Total',15,' ')); 
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


  
--Body
OPEN orderCursor;
v_grandTotal :=0; --initialization after open cursor
LOOP
FETCH orderCursor INTO v_orderID,v_orderDate,v_orderTime,v_total;
EXIT WHEN orderCursor%NOTFOUND;

v_grandTotal:= v_grandTotal + v_total;



  DBMS_OUTPUT.PUT_LINE(RPAD(v_orderID,10,' ') ||
                       RPAD(v_orderDate,15,' ') ||
                       RPAD(v_orderTime,15,' ') ||
                       RPAD(TO_CHAR(v_total,'$99,999.99'),12,' ')); 
END LOOP;
v_totalValue:= v_grandTotal + v_totalValue;

  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


--Footer

  DBMS_OUTPUT.PUT_LINE('Grand Total: ' || TO_CHAR(v_grandTotal, '$99,999.99'));
  DBMS_OUTPUT.PUT_LINE('Total number of orders: ' || orderCursor%ROWCOUNT);

CLOSE orderCursor;
END LOOP;
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('<', 44, '<') || 'SUMMARY' || RPAD('>', 49, '>'));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Total Value:' || TO_CHAR(v_totalValue, '$99,999.99')); --totalvalue is add up all the grand total
  DBMS_OUTPUT.PUT_LINE('Total number of customers: ' || custCursor%ROWCOUNT);
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End Of Report',56,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));

CLOSE custCursor;
END;
/ 

EXEC prc_cust_orders_on_duration('01/01/2020','19/08/2022')
-- to check total value using query

--select DISTINCT C.CUSTID,sum(o.finalizedtotal) from orders o join customer c on o.custid = c.custid where o.orderdate between '01/01/2020' and '19/08/2022' GROUP BY C.CUSTID ORDER BY C.CUSTID ;


