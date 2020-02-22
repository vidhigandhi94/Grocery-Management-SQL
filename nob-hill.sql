CREATE TABLE Customer
(
CustID CHAR(11) NOT NULL,
Cust_Type VARCHAR(20) NOT NULL,
CONSTRAINT PKCustID PRIMARY KEY (CustID)
);

select * from customer;


CREATE TABLE Employees
(
EmpID CHAR(11) NOT NULL,
CONSTRAINT PKEmpID PRIMARY KEY (EmpID)
);

select * from employees;






CREATE TABLE Product
(
ItemID CHAR(11) NOT NULL,
Item_Name VARCHAR(20) NOT NULL,
Price DECIMAL(5,2) NOT NULL,
Brand VARCHAR(20) NOT Null,
CONSTRAINT PKItemID PRIMARY KEY (ItemID)
);
Select * From Product;




CREATE TABLE Checkout
(
Transaction_ID CHAR(11) NOT NULL,
Quantity CHAR(11) NOT NULL,
Total DECIMAL(5,2) NOT NULL,
Checkout_Date VARCHAR(10) NOT NULL,
Checkout_Time VARCHAR(10) NOT NULL,
ItemID CHAR(11) NOT NULL,
EmpID CHAR(11) NOT NULL,
CustID CHAR(11) NOT NULL,
Checkout_Type VARCHAR(20) NOT NULL,
Mode_of_payment VARCHAR(20) NOT NULL,
CONSTRAINT FK1 FOREIGN KEY (ItemID) References Product (ItemID),
CONSTRAINT FK2 FOREIGN KEY (CustID) References Customer (CustID), 
CONSTRAINT FK3 FOREIGN KEY (EmpID) References Employees (EmpID) 
);

use `Nob-hill`;
Select * From Checkout;

create table CustomerTableBeforeUpdate
(
custid int,
cust_type_old char(20),
cust_type_new char(20)
);
DELIMITER $$
create trigger CUSTOMER_UPDATE
Before update
ON customer for each row
		Begin
			declare oldval char(20);
            set oldval = old.cust_type;
            if old.cust_type != new.cust_type then
				insert into CustomerTableBeforeUpdate (custid,cust_type_old,cust_type_new)
					values(old.custid,old.cust_type,new.cust_type);
			end if;
		end$$


  update customer
  set cust_type = 'M'
  where custid = 52;
 

  select * from CustomerTableBeforeUpdate;
  
  select * from ordersummary1;

CREATE TRIGGER ordersummary1_trg
after update ON ordersummary1
FOR EACH ROW
BEGIN
UPDATE checkout
SET total=:new.total
WHERE transaction_id=:old.transaction_id;
END;


BEGIN
UPDATE ordersummary1 SET total=15 WHERE transaction_id=32; 
COMMIT;
END;

CREATE TABLE Inventory
(
Inventory_Quantity CHAR(11) NOT NULL,
FK1ItemID CHAR(11) NOT NULL,
CONSTRAINT PKFK1ItemID PRIMARY KEY (FK1ItemID)
);

select * from inventory;



CREATE TABLE Main
(
Transaction_ID CHAR(11) NOT NULL,
Quantity CHAR(11) NOT NULL,
Total DECIMAL(5,2) NOT NULL,
Checkout_Date VARCHAR(10) NOT NULL,
Checkout_Time VARCHAR(10) NOT NULL,
ItemID CHAR(11) NOT NULL,
EmpID CHAR(11) NOT NULL,
CustID CHAR(11) NOT NULL,
Checkout_Type VARCHAR(20) NOT NULL,
Mode_of_payment VARCHAR(20) NOT NULL,
Inventory_Quantity CHAR(11) NOT NULL,
Item_Name VARCHAR(20) NOT NULL,
Price DECIMAL(5,2) NOT NULL,
Cust_Type VARCHAR(20) NOT NULL,
Brand VARCHAR(20) NOT NULL
);

Select * from main;



CREATE TABLE Checkout
(
Transaction_ID CHAR(11) NOT NULL,
Quantity CHAR(11) NOT NULL,
Total DECIMAL(5,2) NOT NULL,
Checkout_Date VARCHAR(10) NOT NULL,
Checkout_Time VARCHAR(10) NOT NULL,
ItemID CHAR(11) NOT NULL,
EmpID CHAR(11) NOT NULL,
CustID CHAR(11) NOT NULL,
Checkout_Type VARCHAR(20) NOT NULL,
Mode_of_payment VARCHAR(20) NOT NULL,
CONSTRAINT PKTransaction_ID PRIMARY KEY (Transaction_ID),
CONSTRAINT FK1 FOREIGN KEY (ItemID) References Product (ItemID),
CONSTRAINT FK2 FOREIGN KEY (CustID) References Customer (CustID), 
CONSTRAINT FK3 FOREIGN KEY (EmpID) References Employees (EmpID) 
);

Select * from checkout;

SELECT MAX(total) FROM checkout;

select count(total) FROM checkout;




--  a view that shows for each order the salesman id and customer id alongwith transaction id and total.
CREATE VIEW ordersummary1
AS SELECT Transaction_ID,a.CustID, total, a.empid
FROM checkout a, customer c, employees e
WHERE a.custid = c.custid
AND a.empid = e.empid;

Select * from ordersummary1;





-- a view that finds the employee who has the customer with the highest order of a day.
CREATE VIEW topemploye
AS SELECT b.checkout_date, a.empid,b.custid,b.total
FROM employees a, checkout b
WHERE a.empid = b.empid
AND b.total =
    (SELECT MAX (total)
       FROM checkout c
       WHERE c.checkout_date = b.checkout_date);
Select * from topemploye;







-- a view that shows the number of orders in each day.
CREATE VIEW dateord(checkout_date, odcount)
AS SELECT checkout_date, COUNT (*)
FROM checkout 
GROUP BY checkout_date;
select * from dateord;


-- count of normal and self checkout
Select Count(transaction_id) AS NormalCheckout
From checkout
where Checkout_Type = 'N';

Select Count(transaction_id) AS SelfCheckout
From checkout
where Checkout_Type = 'S';




-- transaction preference- cash or card
Select Count(transaction_id) AS Card
From checkout
where Mode_of_payment = 'Card';

Select Count(transaction_id) AS Cash
From checkout
where Mode_of_payment = 'Cash';


-- query to check if there are more member or non-member transactions

Select customer.cust_type,Count(checkout.custid) AS Members
from checkout, customer
where checkout.custid = customer.custid
Group by customer.cust_type
having customer.Cust_Type = 'M';

Select customer.cust_type,Count(checkout.custid) AS NonMembers
from checkout, customer
where checkout.custid = customer.custid
Group by customer.cust_type
having customer.Cust_Type = 'NM';




-- query to find highest purchase amount ordered by the each customer with their ID and highest purchase amount.
SELECT custid,MAX(total) 
FROM checkout 
GROUP BY custid;


-- What is the count of customer having maximum purchase of 20$?
SELECT custid,sum(total) AS TotalPurachase
FROM checkout 
where total >= 20
Group by custid;


-- query to find the highest purchase amount ordered by the each customer on a particular date with their ID, order date and highest purchase amount.
SELECT custid,checkout_date,sum(total) 
FROM checkout 
GROUP BY custid,checkout_date;


-- query to calculate the average price of all the products.
SELECT item_name,AVG(price) AS "Average Price" 
FROM product
Group by item_name;


-- query to find the number of products with a price more than or equal to 2$.
SELECT COUNT(*) AS "Number of Products" 
  FROM product 
    WHERE price >= 2;








-- query to display the average price of each company's products, along with their name.
SELECT AVG(price) AS "Average Price", brand AS "Brand Name"
    FROM product
GROUP BY brand;

-- query to display all orders where purchase amount greater than 20 or exclude those orders which order date is on or greater than 6th Sep,2019 and customer id is below 100.
SELECT * 
FROM  checkout 
WHERE(total>20 OR 
NOT(checkout_date>='6/9/19' 
AND custid<100));




-- What is the product which is least sold?

Select itemid,max(quantity) AS QuantitySold
from checkout
Group by itemid
Order by max(quantity) ;


-- What is the product which is most sold?
Select itemid,max(quantity) AS QuantitySold
from checkout
Group by itemid
Order by max(quantity) desc;


-- which day was the highest sale
Select sum(total) AS TotalSale,checkout_date
from checkout
group by checkout_date
order by sum(total) desc;


select checkout_time,checkout_date,count(transaction_id) AS NumberOfTransactions
from checkout
group by checkout_time,checkout_date
order by count(transaction_id) desc;



-- Write a query to display all the orders from the orders table issued by the salesman '2'.

SELECT *
FROM checkout
WHERE empid =
    (SELECT empid 
     FROM employees 
     WHERE empid='2');



-- Write a query to find all the orders issued against the salesman who may works for customer whose id is 50.

SELECT *
FROM checkout
WHERE empid =
    (SELECT DISTINCT empid 
     FROM checkout 
     WHERE custid =50);


-- Write a query to display all the orders which values are greater than the average order value for 6th September 2019.

SELECT *
FROM checkout
WHERE total >
    (SELECT  AVG(total) 
     FROM checkout 
     WHERE checkout_date ='6/9/19');


-- Write a query to display all the customers with orders issued on date 6th August, 2019.
SELECT b.*, a.custid
FROM checkout b, customer a
WHERE a.custid=b.custid
AND b.checkout_date='6/8/19';


-- Write a query to find the name and numbers of all salesmen who had more than one customer.
SELECT empid
FROM employees e 
WHERE 1 < 
    (SELECT COUNT(*) 
     FROM checkout 
     WHERE empid=e.empid);

-- Write a query to display all the customers with orders issued on date 6th September, 2019.
SELECT *
FROM checkout
WHERE checkout_date='6/9/19';


-- Write a query to find all orders with order amounts which are above-average amounts for their customers.
SELECT * 
FROM checkout c
WHERE total >=
    (SELECT AVG(total) FROM checkout ch 
     WHERE c.custid = ch.custid);




-- Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 10.00 above the maximum amount for that date.

SELECT checkout_date, SUM (total)
FROM checkout c
GROUP BY checkout_date
HAVING SUM (total) >
    (SELECT 10.00 + MAX(total) 
     FROM checkout ch 
     WHERE c.checkout_date = ch.checkout_date);



-- Write a query to display all the orders that had amounts that were greater than at least one of the orders from September 6th 2019.
SELECT *
FROM checkout
WHERE total > ANY
   (SELECT total
	FROM checkout
	WHERE  checkout_date='6/9/19');



-- a query with transaction id, purchase amount, customer type and their type for those orders which order amount between 10 and 20.
SELECT  a.transaction_id,a.total,
b.cust_type,b.custid 
FROM checkout a,customer b 
WHERE a.custid=b.custid 
AND a.total BETWEEN 10 AND 20;



-- a SQL statement to make a join on the tables employee, customer and checkout in such a form that the same column of each table will appear once and only the relational rows will come.
SELECT * 
FROM checkout 
NATURAL JOIN customer  
NATURAL JOIN employees;






-- a SQL statement to make a report with customer id, type, order number, order date, and order amount in ascending order according to the order date to find that either any of the existing customers have placed no order or placed one or more orders.
SELECT a.custid,a.cust_type, b.transaction_id,
b.checkout_date,b.total AS "Order Amount" 
FROM customer a 
LEFT OUTER JOIN checkout b 
ON a.custid=b.custid 
order by b.checkout_date;


SELECT * 
FROM employees a 
CROSS JOIN customer b;


-- query to show for each product inventory details
SELECT *
   FROM product 
   INNER JOIN inventory
   ON product.itemid= inventory.FK1ITEMID; 






-- sale for particular month
select empid ,SUM(total) AS TotalPayment
 from checkout
 where month(checkout_date) = 11 and year(checkout_date) = 2019
 group by 1;

-- total sales, number of payments for store by month.
SELECT MONTHNAME(checkout_date) AS Months, COUNT(transaction_id) AS # of payments,SUM(total) AS Total Sales
From checkout
group by 1; 

Select transaction_id,custid,checkout_date,total,
CASE
	WHEN total > 8 THEN 'High Purchases'
    ELSE 'Low Purchases'
END AS Category
FROM checkout
Order By 4 DESC, 1; 
  
  
  -- find the number of item IDs for all the orders that have Item_Name = ‘Cookies’
SELECT distinct count(o.itemid) as NumOfOrderIds From checkout o
where exists
(select * from  product where itemid = o.itemid and item_name = 'Cookies');

  
  
  
  
  
-- all customers who have placed an order.
SELECT custid,cust_type from  customer  where custid in
(select distinct custid from checkout);

  
-- minimum and maximum quantity of purchases made by customers.

select c1.custid, quantity,'Max Quantity' as Description
from customer c1,checkout ol
where c1.custid = ol.custid
and quantity = (select max(quantity) from checkout)
UNION
select c1.custid, quantity,'Min Quantity' as Description
from customer c1,checkout ol
where c1.custid = ol.custid
and quantity = (select min(quantity) from checkout)
order by 2;

-- Procedure to insert new rows into CHECKOUT was created
CREATE OR REPLACE
PROCEDURE "InsertCheckout" (Quantity CHAR,Total NUMBER,Checkout_Date VARCHAR,Checkout_Time VARCHAR,
						    ItemID CHAR,EmpID CHAR,CustID CHAR, Checkout_Type VARCHAR,Mode_of_payment 								    VARCHAR)
AS
BEGIN
 
INSERT INTO CHECKOUT VALUES ('111',QUANTITY, TOTAL, CHECKOUT_DATE, CHECKOUT_TIME, ITEMID, EMPID, CUSTID, CHECKOUT_TYPE, MODE_OF_PAYMENT);
END;

CALL InsertCheckout('10','35','6/2/2020','6:38:00','84854','6','201','N','Card');
select * from checkout;

-- A stored procedure was created to delete a customer’s orders history. This can be used when a customer
-- is requesting a return. 
CREATE OR REPLACE
PROCEDURE DeleteCheckout (pri_key IN NUMBER)
AS
BEGIN
 DELETE CHECKOUT WHERE Transaction_id=pri_key;
END;
call DeleteCheckout(201);
select * from checkout
where Transaction_id = '201';


-- Trigger
-- Trigger to update customer’s total. This can be used when a customer decides against buying some goods or there is a change in the total.

CREATE TRIGGER ordersummary1_trg
INSTEAD OF UPDATE
ON ordersummary1
FOR EACH ROW
BEGIN
UPDATE checkout
SET total=:new.total
WHERE transaction_id=:old.transaction_id;
END;


BEGIN
UPDATE ordersummary1 SET total=15 WHERE transaction_id=32; 
COMMIT;
END;

SELECT * FROM ordersummary1;

-- If a customer converts from non-member to member, trigger to update the same:

CREATE TABLE Customer
(
CustID CHAR(11) NOT NULL,
Cust_Type VARCHAR(20) NOT NULL,
CONSTRAINT PKCustID PRIMARY KEY (CustID)
);

create table CustomerTableBeforeUpdate
(
custid int,
cust_type_old char(20),
cust_type_new char(20)
);

create trigger CUSTOMER_UPDATE
Before update
ON customer for each row
		Begin
			declare oldval char(20);
            set oldval = old.cust_type;
            if old.cust_type != new.cust_type then
				insert into CustomerTableBeforeUpdate (custid,cust_type_old,cust_type_new)
					values(old.custid,old.cust_type,new.cust_type);
			end if;
		end$$

  update customer
  set cust_type = 'M'
  where custid = 52;
 

  select * from CustomerTableBeforeUpdate;
  
  select * from customer;

-- Trigger to keep an audit table of the checkout table. To see the new and old values. Also, to update the checkout table for change in quantity and total.

CREATE TABLE orders
( transaction_id number(5),
  itemid number(5),
  quantity_before number(4),
  quantity_after number(4),
  total_before number(8,2),
  total_after number(8,2)
);


CREATE OR REPLACE TRIGGER orders_after_update
AFTER UPDATE
   ON Checkout
   FOR EACH ROW

BEGIN

   -- Insert record into audit table
   INSERT INTO orders
   ( transaction_id,
     itemid,
     quantity_before,
     quantity_after,
     total_before,
     total_after
      )
   VALUES
   ( :new.transaction_id,
     :new.itemid,
     :old.quantity,
     :new.quantity,
     :old.total,
     :new.total
      );

END;


Update Checkout set quantity = 8,total = 15.92 where transaction_id = 2147;

select * from orders;
select * from checkout;
