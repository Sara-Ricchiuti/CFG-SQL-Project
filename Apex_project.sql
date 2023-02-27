CREATE DATABASE Apex;
#Table 1
CREATE TABLE Customers(Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
First_Name VARCHAR(20) NOT NULL,
Last_Name VARCHAR(20) NOT NULL,
Phone CHAR(20) NOT NULL,
Email VARCHAR(50),
Street VARCHAR(50),
Post_code CHAR(20),
City VARCHAR(20),
Country VARCHAR(20));
ALTER TABLE customers
ADD Birthday_date DATE;
INSERT INTO Customers(Customer_ID,First_Name, Last_Name, Phone, Email, Street, Post_code, City, Country, Birthday_date)
VALUES 
(110,'Sara', 'Ricchiuti', '07413046717', 'Sara.Ricchiuti@gmail.com','20 Alphabet Square','E3 3RD','London','United Kingdom','1993-01-24'),
(120,'Rosa', 'Fasan', '+393287121456', 'Rosa.Fasan@gmail.com','5 Viale Francia','720121','Brindisi','Italy','1968-06-10'),
(130,'Mary', 'Ricchiuti', '07413078908', 'Mary.Ricchiuti@gmail.com','2 London Street','SE23 4DC','Sevenoks','United Kingdom','1986-07-10'),
(140,'Andrea','Pisa', '+393297121443', 'Andrea.Pisa@gmail.com','3 Via Oria','72039','Taranto','Italy','1983-03-19'),
(150,'Nico', 'Corte', '+393292221443', 'Nico.Corte@gmail.com','3 Via Carbonara','71789','Bari','Italy','1972-05-03');

UPDATE customers
SET last_name = 'Rossi', email = 'Mary.rossi@gmail.com' 
WHERE customer_ID = 130;

#Table 2
CREATE TABLE Stores(Store_ID INT AUTO_INCREMENT PRIMARY KEY,
Store_Name VARCHAR(20) NOT NULL,
Phone CHAR(20),
Email VARCHAR(20) NOT NULL,
Street VARCHAR(20) NOT NULL,
Post_code CHAR(20),
City VARCHAR(20) NOT NULL,
Country VARCHAR(20) NOT NULL);
ALTER TABLE Stores
DROP COLUMN Phone;
INSERT INTO Stores(Store_ID,Store_Name, Email, Street, Post_code, City, Country)
VALUES 
(210,'Apex London','Apex.London@Apex.com', '10 Chiltern Street','W1D 5NP','London','United Kingdom'),
(220,'Apex Milan','Apex.Milan@Apex.com', '2 Porta Garibaldi','45671','Milan','Italy'),
(230,'Apex Rome','Apex.Rome@Apex.com', '2 Via Trastevere','78965','Rome','Italy');

#Table 3
CREATE TABLE Products(Product_ID INT AUTO_INCREMENT PRIMARY KEY,
Product_Name VARCHAR(20) NOT NULL,
Product_Price DECIMAL(6,2),
SKU INT NOT NULL);

INSERT INTO Products(Product_Name, Product_Price,SKU)
VALUES 
('Cleanser','19.90','28319525'),
('Exfoliator', '35.50','64144003'),
('Chemical Peel', '47.50','52225325'),
('Serum', '49.90','52609165'),
('Face Oil', '29.90','52609165'),
('Sunscreen', '50.00','21334698'),
('Moisturizer', '37.90','21334698'),
('Toner', '32.50','09246613'),
('Face Mask', '45.90','84474627'),
('Eye Cream', '30.00','43922077');

#Table 4
CREATE TABLE Orders(Order_ID INT AUTO_INCREMENT UNIQUE PRIMARY KEY, 
Quantity INT NOT NULL,
Order_Status VARCHAR(10) NOT NULL,
Order_Date TIMESTAMP NOT NULL,
Shipping_Date TIMESTAMP NOT NULL,
Product_ID INT NOT NULL,
Customer_ID INT NOT NULL,
Customer_last_name VARCHAR(10) NOT NULL,
Store_ID INT NOT NULL);

INSERT INTO Orders(Quantity,Order_Status,Order_Date,Shipping_Date,product_ID,Customer_ID,Customer_last_name,store_ID)
VALUES 
('2','PAID', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,2,110,'Ricchiuti',210),
('1','PAID', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,2,120,'Fasan',220),
('3','PAID', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,130,'Rossi',230),
('4','PAID', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,3,140,'Pisa',210),
('2','PAID', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,2,150,'Corte',210);

ALTER TABLE orders
ADD CONSTRAINT fk_store_ID
FOREIGN KEY (Store_ID) REFERENCES Stores(store_ID);
ALTER TABLE orders
ADD CONSTRAINT fk_customer_ID
FOREIGN KEY (customer_ID) REFERENCES customers(customer_ID);
ALTER TABLE orders
ADD CONSTRAINT fk_product_ID
FOREIGN KEY (product_ID) REFERENCES products(product_ID);
ALTER TABLE orders
ADD CONSTRAINT fk_customer_last_name
FOREIGN KEY (Customer_last_name) REFERENCES Customers(last_name);

#Table 5
CREATE TABLE Employees(Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
First_Name VARCHAR(20) NOT NULL,
Last_Name VARCHAR(20) NOT NULL,
Phone CHAR(20) NOT NULL,
Email VARCHAR(50),
Street VARCHAR(50),
Post_code CHAR(20),
City VARCHAR(20),
Country VARCHAR(20),
Birthday_date DATE,
Position VARCHAR(20),
Store_Location VARCHAR(20),
Store_ID INT NOT NULL);

INSERT INTO Employees(Employee_ID,First_Name, Last_Name, Phone, Email, Street, Post_code, City, Country, Birthday_date, Position, Store_Location,Store_ID)
VALUES 
(9110,'Jack', 'Mclaren', '07628183227', 'Jack.Mclaren@gmail.com','9746 Church Street','SW10 7JO','London','United Kingdom','1988-01-13','Manager','London','210'),
(9120,'Nick', 'Circle', '07622283227', 'Nick.Circle@gmail.com','12 Manor Road','EC12 9KH','London','United Kingdom','1992-06-18','Assistant','London','210'),
(9130,'Andrew', 'Rombo', '+3928183222', 'Andrew.Rombo@gmail.com','2 Via rossa','71024','Taranto','Italy','1993-07-27','Manager','Milan','220'),
(9140,'Emily','Hills', '+3928183234', 'Emily.Hills@gmail.com','3 Via Verde','72039','Taranto','Italy','2000-03-30','Assistant','Milan','220'),
(9150,'Marie', 'Grape', '+3928183555', 'Marie.Grape@gmail.com','3 Via Blu','71789','Bari','Italy','1999-05-03','Manager','Rome','230'),
(9160,'Joseph', 'Moon', '+3928183676', 'Joseph.Moon@gmail.com','3 Via Gialla','71789','Bari','Italy','1999-05-03','Assistant','Rome','230');

ALTER TABLE employees
ADD CONSTRAINT fk_store_location
FOREIGN KEY (Store_ID) REFERENCES Stores(store_ID);

#CREATION OF VIEW + JOINS 
    #View that shows ID number and last name of customers, along with
    #products id and name purchased plus their quantity ordered in a descendent way.
CREATE VIEW Orders_quantity AS
SELECT O.Customer_ID,  C.Last_name, p.Product_id, P.Product_name, sum(quantity) AS Order_Qty
	FROM
	customers C
	INNER JOIN
	orders O 
	on C.customer_ID= O.customer_ID
    INNER JOIN 
    Products P
	on P.product_ID= O.product_ID
	GROUP BY C.Customer_ID
	ORDER BY AVG(quantity) desc;
    
    #STORED FUNCTION
    #create a quick shortcut to find name and surname of customers in an alphabetical order 

DELIMITER //
CREATE FUNCTION
C_full_name(first_name VARCHAR(20), last_name VARCHAR(20)) 		
RETURNS VARCHAR(40)
DETERMINISTIC		
BEGIN
DECLARE C_full_name VARCHAR(40);
SET C_full_name = CONCAT(first_name, ' ', last_name);
RETURN C_full_name;
END;
//	

SHOW FUNCTION STATUS WHERE db = 'APEX';

SELECT C_full_name(first_name, last_name) AS FULL_NAME 
FROM customers
ORDER BY C_full_name(first_name, last_name) ASC;

#SUBQUERY 1
#Find the number of employee in each store
SELECT store_id, number_of_employees
FROM (SELECT count(DISTINCT employee_id) AS "number_of_employees", store_id
FROM employees GROUP BY store_id) AS employee_summary
ORDER BY number_of_employees;

#SUBQUERY 2
#find the oldest customer and the youngest - To target the customers-
SELECT *FROM Customers 
WHERE birthday_date = (SELECT MIN(birthday_date)
  FROM Customers);
  
  #stored procedure - to quick add values into the customer table 
Drop procedure InsertValueCustomer;

DELIMITER //
CREATE PROCEDURE InsertValueCustomer
(
IN Customer_ID INT, 
IN First_name VARCHAR(20),
IN Last_name VARCHAR(20),
IN Phone CHAR(20),
IN Email VARCHAR(50),
IN Street VARCHAR(50),
IN Post_code CHAR(20),
IN City VARCHAR(20),
IN Country VARCHAR(20),
IN Birthday_date DATE,
IN Store_location VARCHAR(20))
BEGIN
INSERT INTO Customers(Customer_ID,First_Name, Last_Name, Phone, Email, Street, 
Post_code, City, Country, Birthday_date, Store_Location)
VALUES (Customer_ID,First_Name, Last_Name, Phone, Email, Street, 
Post_code, City, Country, Birthday_date, Store_Location);
END//
​
DELIMITER ;

SHOW PROCEDURE STATUS WHERE db = 'APEX';

CALL InsertValueCustomer('160','Jordan', 'Beige', '07654534213', 
'Jordan.Beige@gmail.com','8 high street','E14 5ST','London','United Kingdom','1998-04-03','');

#triggers TR_IN_FCUS  -trigger_insert_firstcustomers- and TR_IN_LCUS  -trigger_insert_lastcustomers-
#trigger to change the first letter of the character to upper case on full name 
#everytime the customers table is updated

CREATE TRIGGER tr_in_Fcus 
BEFORE INSERT ON customers
FOR EACH ROW
SET NEW.first_name = CONCAT(UCASE(LEFT(NEW.first_name, 1)), 
                             LCASE(SUBSTRING(NEW.first_name, 2)));

CREATE TRIGGER tr_in_Lcus 
BEFORE INSERT ON customers
FOR EACH ROW
SET NEW.last_name = CONCAT(UPPER(LEFT(NEW.last_name, 1)), 
                             LOWER(SUBSTRING(NEW.last_name, 2)));
                             
show triggers from apex;

CALL InsertValueCustomer('170','JONNY', 'VIOLA', '07654511113', 
'Jonny.Viola@gmail.com','12 high street','E12 5ST','London','United Kingdom','1993-12-03','');
