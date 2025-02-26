SET PAGESIZE 120
SET LINESIZE 90
SET VERIFY OFF


CLEAR SCREEN

PROMPT 'Stalls that have sales above 5K in a specific year'
PROMPT

-- COLUMN Settings
COLUMN "STALL ID" FORMAT A8 
COLUMN "STALL NAME" FORMAT A25 
COLUMN "TOTAL SALES" FORMAT $999,999.99 HEADING "TOTAL SALES"


--Get input from the user
ACCEPT v_year DATE FORMAT 'yyyy' PROMPT 'Enter Year (2020/2021/2022):'

-- settings
TTITLE ON
TTITLE CENTER '+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+' SKIP 1 -
       CENTER '|       Stalls that have sales above 5K in 'v_year'      | ' SKIP 1 -
       CENTER '+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+' SKIP 1 - 
       LEFT   'DATE: ' _DATE - 
       RIGHT  'PAGE: ' FORMAT 999 SQL.PNO SKIP 2

CREATE OR REPLACE VIEW view_Sales_Comparison AS 
SELECT 
    S.StallID AS "STALL ID",
    S.StallName AS "STALL NAME",
    SUM(O.FINALIZEDTOTAL) AS "TOTAL SALES"
FROM 
    Stall S
JOIN 
    Menu M ON S.StallID = M.StallID
JOIN 
    OrderMenu OM ON M.MenuID = OM.MenuID
JOIN 
    Orders O ON OM.OrderID = O.OrderID
WHERE TO_CHAR(O.orderdate, 'YYYY') = '&v_year'
GROUP BY 
    S.StallID, S.StallName
HAVING 
    SUM(O.FINALIZEDTOTAL) >= 5000 
ORDER BY 
    "TOTAL SALES" DESC;
BREAK ON REPORT
COMPUTE SUM LABEL "Total:" OF "TOTAL SALES" ON REPORT

SELECT * 
FROM view_Sales_Comparison;

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF
