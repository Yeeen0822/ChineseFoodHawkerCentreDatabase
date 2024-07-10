Chapter 1  Background of the System

In setting up a database for a Chinese Food Hawker Centre, we are creating a system to keep everything organised and running smoothly so that the hawker centre can operate smoothly. Think of it like a digital hub where each food stall, staff member, and customer detail is neatly stored and managed.
For starters, we will have all the stall information like names, sizes, and rental fees, making sure each stall is accounted for. Staff details are also included to ensure everyone's roles are clear and accounted for.
Contracts between the hawker centre and stall tenants are a big part of this system too. These contracts lay out all the terms and dates, making sure everyone knows what is expected. Furthermore, this system also helps to keep track of the start date and end date of each contract.
When it comes to orders, we are keeping track of every dish and drink customers order, whether they are dining in or ordering online. This way, we can manage resources and keep things running smoothly.
Financial matters are also covered. We are logging payments and keeping tabs on promotions to make sure everything adds up and customers get the best deals.
We are serious about security too. By using special rules and checks, we make sure all the data stays safe and accurate.
In a nutshell, our system is like the engine that keeps the Chinese Food Hawker Centre running smoothly, ensuring everyone gets their fill of delicious food while keeping everything organised behind the scenes.


 
Chapter 2  Entity-Relationship Modeling
2.1 Business Rules and Assumptions

Business Rules:
1.	Each order has an option for dine in or take away.
2.	Only third party companies are responsible for take away orders.
3.	Every stall has its menu. For example, a stall with stall ID ‘SA’ has menu items with menu ID starting with ‘SA’ like ‘SA01’.
4.	Every order must be delivered on the same day.
5.	The order cannot be cancelled once placed.
6.	Stall Size	Rental Fee (RM)
   Small (900 sq ft)	1500
   Medium (1600 sq ft)	2300
   Big (2500 sq ft)	3000
7.	Business hours are from 10 am to 8 pm.
8.	Each staff can collect zero or many rentals and each rental collection can only be collected by one and only one staff. (Zero to Many)
9.	Each tenant can pay one or many rentals and each rental can only be paid by one and only one tenant. (One to Many)
10.	Each tenant signs one or many contracts and each contract can only be signed by one and only one tenant. (One to Many)
11.	Each stall can have one or many contracts and each contract is for one and only one stall. (One to Many)
12.	Each stall has one or many menus while each menu belongs to one and only one stall. (One to Many)
13.	Each menu can have zero or many ordermenu(bridge) and each ordermenu belongs to one and only one menu. (Zero to Many)
14.	Each order can have one or many ordermenu(bridge) and each ordermenu belongs to one and only order. (One to Many)
15.	Each order can have zero or one delivery and each delivery belongs to one and only one order. (Zero to One)
16.	Each delivery company can have zero or many deliveries and each delivery belongs to one and only one delivery company. (Zero to Many)
17.	Each customer can place one or many orders and each order can be placed by one and only one customer.  (One to Many)
18.	Each promotion can be applied zero to many orders and each order can have zero or one promotion applied. (Zero to Many)
19.	Each order can have one and only one payment and each payment can only belong to one and only one order. (One to One)
20.	Promotion can only be applied to dine in orders.
21.	Promotion can only be applied while it is valid because each promotion has its start date and end date.
22.	Each order can only contain food from one stall.
23.	Customers can only pay via cash, Touch N Go (tng), QR, GrabPay and card.
24.	Each contract must be renewed every year.
25.	A menu item can only order a maximum of 7 in a single order. 
26.	The finalised total (amount to pay) cannot be less than or equal to zero.
27.	10% service charge is applied to dine in orders only.
28.	The selling price of each menu item is inclusive of 6% SST.
29.	Every tenant has to pay electricity and water bills every month.
30.	Customers can only rate from 1 to 5 stars for each order.
31.	The promotion can only be redeemed if it is not fully redeemed. 
32.	The PromoStartDate should be earlier than the PromoEndDate.  

 Assumptions:
1.	Assume RM 5000 rental is charged to Hawker Center owner and owner has sub rent to other tenants or stalls.
2.	All delivery orders require customer ID.
3.	The DineinCustNo will be refreshed every day. The first dine in customer of the day will have the DineinCustNo “Q01”. 
4.	If it is a dine in order, the deliveryID and customer ID for the order will be null.
5.	If it is a delivery order, the promotionID and DineInCustNo will be null.
6.	The customer will pay at the counter upon ordering via any available payment method.
7.	Take away orders such as Food Panda/ Grab Food/ Shopee food can be placed directly at each of their respective websites and will be punched into the system manually by staff.
8.	Assume that the details of customers that order via delivery companies’ websites will be updated into our system as well.
9.	 No cancellation or refund is allowed once the order has been placed at the counter.
10.	The staff are loyal to our company and will not resign for any reason.
 
2.2 ERD

![erd drawio](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/3ece7a15-e45e-447e-8c8e-73e02089f147)


4.3.1 Query 1: Feedback analysis of each stall of a specific year
Purpose: The purpose of this query is to help managers look at customer feedback for stalls in a specific year, showing key performance metrics like average rating and feedback counts. It helps managers see what customers like or dislike about each stall, which can guide improvements. It also helps with bigger decisions like where to invest resources and how to stay competitive in the market, all aimed at improving customer satisfaction and the business performance.
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/b5f0a344-e901-44b0-bc6c-2dd677771980)

Figure 4.3.1 
Figure 4.3.1 presents a feedback analysis of stalls for the year 2022, including average ratings, percentage breakdown of positive, negative, and neutral feedback. The average rating is sorted in descending order, facilitating easy viewing for stakeholders.

4.3.2 Query 2: Stalls that have sales above 5K in a specific year
Purpose: The purpose of this query is to provide actionable insights into the performance of individual stalls by calculating the total sales for each stall and filtering out those with sales above the threshold. This information can be valuable for operational managers in identifying high-performing stalls and potentially allocating resources or adjusting strategies to capitalise on their success. Additionally, it allows stakeholders to assess overall revenue distribution and make informed decisions to drive business growth and profitability.
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/ae969b12-f272-4c0a-af82-77b908424229)

Figure 4.3.2
Figure 4.3.2 presents stalls with sales exceeding $5,000 in the year 2022, showcasing top-performing stalls such as Ah Huat Bak Kut Teh with total sales of $13,364.92 and Teochew Porridge King with $8,665.16. The total sales for all qualifying stalls sum up to $63,268.60, highlighting significant revenue generated by these high-performing stalls.

4.3.3 Procedure 1:  Insert delivery company details
Purpose: This purpose of this procedure is to add a new delivery company to the database. It ensures all required fields are provided and avoids duplicate company names. If successful, it generates a unique company ID, inserts the company details, and displays a success message. If errors occur, it handles them and provides appropriate feedback. Overall, it simplifies the process of adding new delivery companies with validation and error handling.
 ![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/eb99e88b-8da8-47ce-aedc-6bcced461988)

Figure 4.3.3
Figure 4.3.3 shows output which indicates successful insertion of a new delivery company named "LaiTapau" with company ID "DC11", alongside error messages for missing fields and an existing company name ("Grab Food").

4.3.4 Procedure 2: Update Staff Salary
Purpose: The purpose of this procedure is to update the salary of a staff member based on their StaffID and an increment percentage provided as input. It ensures that the provided StaffID follows a specific format and exists in the database. Additionally, it checks if the increment percentage falls within a valid range (0 to 100). If all conditions are met, it calculates the new salary, updates the database accordingly, and outputs a success message along with the new salary. If any errors occur during the process, appropriate error messages are displayed to guide users.
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/94095e8e-747f-42a4-b90f-1ce171781de8)

Figure 4.3.4
Figure 4.3.4 shows that the procedure successfully updated the salary of staff member E09 by 10%, resulting in a new salary of RM1320.74. However, it failed to update the salary for staff member E19, indicating that the staff is not found or has no existing salary. Additionally, it correctly identified an invalid increment percentage (-50%) for staff member E02 and provided an appropriate error message.

4.3.5 Trigger 1: Customer table tracking 
Purpose: The trigger is designed to track changes made to the Customer table, recording details of insertions, updates, and deletions into separate tracking tables: InsertCustomer, UpdateCustomer, and DeleteCustomer. This tracking enables the monitoring of modifications to customer records over time.

4.3.6 Trigger 2: Insert Return Amount 
Purpose: The purpose of this trigger is to calculate and update the return amount in the 	payment table for cash payments before inserting a record into the OrderMenu table. It ensures that the return amount is appropriately computed based on the difference between the payment amount and the finalised total for the corresponding order. If the payment amount or finalised total is zero, an error is raised to prevent invalid data. Also, the payment amount must be greater or equal to the finalised total.

4.3.7 Report 1: Customer Orders Report
Purpose: The purpose of this report is to provide a comprehensive overview of customer orders within a defined time period. It presents details such as customer ID, name, contact, and age, along with individual order information like order ID, date, time, and total spent. By calculating the total spent by all customers and summarising the total order value and customer count, this report enables businesses to analyse customer buying patterns, track sales performance, and make informed decisions to enhance their products or services.

![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/38a1f84c-af2b-4d0e-aac4-b51fb08ec956)
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/74986ae2-bd33-4c6c-8456-efc36ce20390)

Figure 4.3.7
Figure 4.3.7 shows orders of the customer with their grand total and total number of orders between the start date and end date. In the bottom section, the total of all the grand total of customers and the total number of customers are displayed.

4.3.8 Report 2: Delivery Companies Orders Report 
Purpose: The purpose of this report is to provide a comprehensive overview of orders made through different delivery companies within a specified time period. It includes details such as the company ID, name, contact information, address, and email. Additionally, the report lists the orders associated with each company, including order ID, date, time, and total amount spent. It calculates the grand total spent with each delivery company and displays the total number of orders placed. The report concludes with a summary section presenting the overall total value of orders and the total number of delivery companies included in the report, offering insights into the distribution of orders among different delivery services.
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/87ebb87d-60be-42b5-b7d0-b3cea072d665)
![image](https://github.com/Yeeen0822/ChineseFoodHawkerCentreDatabase/assets/103027502/9d6f3a3f-1a1d-42a0-9c48-85e4a6712eb4)

Figure 4.3.8
The figure shows orders made through the delivery companies with their grand total and total number of orders between the start date and end date. In the bottom section, the total of all the grand total of delivery companies and the total number of delivery companies are displayed.


