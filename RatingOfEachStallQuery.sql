SET PAGESIZE 120
SET LINESIZE 130
SET VERIFY OFF

cl scr
PROMPT 'Feedback Analysis of each stall of a specific year'
PROMPT

-- COLUMN Settings
COLUMN "STALL ID" FORMAT A8 
COLUMN "STALL NAME" FORMAT A25 
COLUMN "AverageRating" FORMAT 9.99 heading "AVERAGE|RATING"
COLUMN HighestRating FORMAT 9 heading "HIGHEST|RATING"
COLUMN LowestRating FORMAT 9 heading "LOWEST|RATING"
COLUMN GoodFeedbackPercentage FORMAT 999.99 heading "POSITIVE|FEEDBACK|PERCENTAGE|(%)"
COLUMN BadFeedbackPercentage FORMAT 999.99 heading "NEGATIVE|FEEDBACK|PERCENTAGE|(%)"
COLUMN OkFeedbackPercentage FORMAT 999.99 heading "NEUTRAL|FEEDBACK|PERCENTAGE|(%)"
COLUMN GoodFeedbackCount FORMAT 999 heading "POSITIVE|FEEDBACK|COUNT"
COLUMN BadFeedbackCount FORMAT 999 heading "NEGATIVE|FEEDBACK|COUNT"
COLUMN OkFeedbackCount FORMAT 999 heading "NEUTRAL|FEEDBACK|COUNT"
COLUMN "WORST RATING" FORMAT 9 heading "WORST|RATING"
COLUMN "TOP RATING" FORMAT 9 heading "TOP|RATING"


--Get input from the user
ACCEPT v_year DATE FORMAT 'yyyy' PROMPT 'Enter Year (2020/2021/2022):'

-- settings
TTITLE ON
TTITLE CENTER '+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+' SKIP 1 -
       CENTER ' |    Feedback Analysis for year '&v_year'    | ' SKIP 1 -
       CENTER '+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+' SKIP 1 - 
       LEFT   'DATE: ' _DATE - 
       RIGHT  'PAGE: ' FORMAT 999 SQL.PNO SKIP 2

CREATE OR REPLACE VIEW view_Feedback_Analysis
AS 
SELECT 
    S.StallID AS "STALL ID",
    S.StallName AS "STALL NAME",
    ROUND(AVG(O.OrderRating), 2) AS "AverageRating",
    MAX(O.OrderRating) AS HighestRating,
    MIN(O.OrderRating) AS LowestRating,
    ROUND((SUM(CASE WHEN O.OrderFeedback LIKE '%Good%' THEN 1 ELSE 0 END) / SUM(CASE WHEN O.DeliveryID IS NOT NULL THEN 1 ELSE 0 END)) * 100, 2) AS GoodFeedbackPercentage,
    ROUND((SUM(CASE WHEN O.OrderFeedback LIKE '%Bad%' THEN 1 ELSE 0 END) / SUM(CASE WHEN O.DeliveryID IS NOT NULL THEN 1 ELSE 0 END)) * 100, 2) AS BadFeedbackPercentage,
    ROUND((SUM(CASE WHEN O.OrderFeedback LIKE '%Ok%' THEN 1 ELSE 0 END) / SUM(CASE WHEN O.DeliveryID IS NOT NULL THEN 1 ELSE 0 END)) * 100, 2) AS OkFeedbackPercentage,
    SUM(CASE WHEN O.OrderFeedback LIKE '%Good%' THEN 1 ELSE 0 END) AS GoodFeedbackCount,
    SUM(CASE WHEN O.OrderFeedback LIKE '%Bad%' THEN 1 ELSE 0 END) AS BadFeedbackCount,
    SUM(CASE WHEN O.OrderFeedback LIKE '%Ok%' THEN 1 ELSE 0 END) AS OkFeedbackCount
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
    -- Make sure the output show only stalls that have delivery order in that specific year
    SUM(CASE WHEN O.DeliveryID IS NOT NULL THEN 1 ELSE 0 END)  != 0
ORDER BY
   "AverageRating" DESC;
BREAK ON REPORT
COMPUTE SUM LABEL "Total:" OF "GoodFeedbackCount" ON REPORT
COMPUTE SUM LABEL "Total:" OF "BadFeedbackCount" ON REPORT
COMPUTE SUM LABEL "Total:" OF "OkFeedbackCount" ON REPORT

SELECT * 
FROM view_Feedback_Analysis;


CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF

