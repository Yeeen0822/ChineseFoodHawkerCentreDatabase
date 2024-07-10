SET SERVEROUTPUT ON
SET LINESIZE 120
SET PAGESIZE 100
ALTER SESSION SET NLS_DATE_FORMAT ='DD/MM/YYYY';
cl screen


CREATE OR REPLACE PROCEDURE prc_deliveryCom_orders(v_startDate IN DATE,v_endDate IN DATE) IS

 v_companyID DeliveryCompany.CompanyID%TYPE;
 v_companyName DeliveryCompany.CompanyName%TYPE;
 v_CompanyContact DeliveryCompany.CompanyContact%TYPE;
 v_CompanyAddress DeliveryCompany.CompanyAddress%TYPE;
 v_CompanyEmail DeliveryCompany.CompanyEmail%TYPE;
 v_DeliveryID Delivery.DeliveryID%TYPE;
 v_DeliveryAddress Delivery.DeliveryAddress%TYPE;
 v_orderID Orders.OrderID%TYPE;
 v_orderDate Orders.OrderDate%TYPE;
 v_orderTime Orders.OrderTime%TYPE;
 v_finalTotal Orders.FinalizedTotal%TYPE;

--create extra variable
    v_grandtotal NUMBER(11,2); 
    v_totalValue NUMBER(11,2);

-- create cursor   
CURSOR delCompanyCursor IS
SELECT DISTINCT DC.CompanyID, CompanyName, CompanyContact, CompanyAddress, CompanyEmail
FROM DeliveryCompany DC
JOIN Delivery D ON DC.CompanyID = D.CompanyID
JOIN Orders O ON O.DeliveryID = D.DeliveryID
WHERE O.OrderDate BETWEEN v_startDate AND v_endDate
ORDER BY DC.CompanyID;


-- create cursor
CURSOR orderCursor IS 
SELECT OrderID,OrderDate,OrderTime,FinalizedTotal
FROM Orders O 
JOIN Delivery D ON O.DeliveryID = D.DeliveryID
WHERE O.OrderDate BETWEEN v_startDate AND v_endDate
AND D.CompanyID = v_companyID
ORDER BY OrderDate;


BEGIN
DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'=')); 
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE(RPAD('-', 35, '-') || 'Delivery Company Orders Report' || RPAD('-', 35, '-'));
DBMS_OUTPUT.PUT_LINE(CHR(10));
OPEN delCompanyCursor; 
--initialize after open cursor
v_totalValue := 0;
LOOP
FETCH delCompanyCursor INTO v_companyID, v_companyName, v_CompanyContact, v_CompanyAddress, v_CompanyEmail;
EXIT WHEN delCompanyCursor%NOTFOUND;


--Title
-- 10 space, 4 for 'Code', 6 for space
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Company ID    : ' || v_companyID);
  DBMS_OUTPUT.PUT_LINE('Company Name  : ' || v_companyName);
  DBMS_OUTPUT.PUT_LINE('Contact       : ' || v_CompanyContact);
  DBMS_OUTPUT.PUT_LINE('Address       : ' || v_CompanyAddress);
  DBMS_OUTPUT.PUT_LINE('Email         : ' || v_CompanyEmail);
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


--Heading
  DBMS_OUTPUT.PUT_LINE(RPAD('Order ID',10,' ') ||
                       RPAD('Order Date',15,' ') ||
                       RPAD('Order Time',19,' ') ||
                       RPAD('  Total',15,' ')); 
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


--Body
OPEN orderCursor;
v_grandTotal :=0; --initialization after open cursor
LOOP
FETCH orderCursor INTO v_orderID,v_orderDate,v_orderTime,v_finalTotal;
EXIT WHEN orderCursor%NOTFOUND;

v_grandTotal:= v_grandTotal + v_finalTotal;



  DBMS_OUTPUT.PUT_LINE(RPAD(v_orderID,10,' ') ||
                       RPAD(v_orderDate,15,' ') ||
                       RPAD(v_orderTime,15,' ') ||
                       RPAD(TO_CHAR(v_finalTotal,'$99,999.99'),12,' ')); 
END LOOP;
v_totalValue:= v_grandTotal + v_totalValue;

  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));


--Footer

  DBMS_OUTPUT.PUT_LINE('Grand Total RM: ' || TO_CHAR(v_grandTotal, '$99,999.99'));
  DBMS_OUTPUT.PUT_LINE('Total number of orders: ' || orderCursor%ROWCOUNT);

CLOSE orderCursor;
END LOOP;
  DBMS_OUTPUT.PUT_LINE(RPAD('=',100,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('<', 44, '<') || 'SUMMARY' || RPAD('>', 49, '>'));
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE('Total Value: RM' || TO_CHAR(v_totalValue, '$99,999.99')); --totalvalue is add up all the grand total
  DBMS_OUTPUT.PUT_LINE('Total number of delivery companies: ' || delCompanyCursor%ROWCOUNT);
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  DBMS_OUTPUT.PUT_LINE(RPAD('=',44,'=') || RPAD('End Of Report',56,'='));
  DBMS_OUTPUT.PUT_LINE(CHR(10));

CLOSE delCompanyCursor;
END;
/ 

EXEC prc_deliveryCom_orders('01/01/2020','19/08/2020')

---- to check total value using query
--SELECT DISTINCT DC.CompanyID,SUM(O.FINALIZEDTOTAL)
--FROM DeliveryCompany DC
--JOIN Delivery D ON DC.CompanyID = D.CompanyID
--JOIN Orders O ON O.DeliveryID = D.DeliveryID
--WHERE O.OrderDate BETWEEN '01/01/2020' AND '19/08/2020'
--GROUP BY DC.COMPANYID
--ORDER BY DC.CompanyID;
