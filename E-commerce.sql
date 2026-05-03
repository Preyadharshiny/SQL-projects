-- Project: E-commerce Database Analysis
-- Author: Preyadharshiny K
-- Tools: Microsoft SQL Server (SSMS)
-- Description: SQL queries to analyze customer behavior, product performance, and revenue trends
----------------------------------------------------------------------------------------------------------
--Table creation
-- Customer Table
CREATE TABLE customer (cust_id INT,cust_name NVARCHAR(50),country NVARCHAR(50));
-- Order Details Table
CREATE TABLE order_details (order_id INT,product_id INT,quantity INT,price INT);
-- Orders Table
CREATE TABLE orders (order_id INT,order_date DATE,cust_id INT);
-- Products Table
CREATE TABLE products (product_id INT,product_name NVARCHAR(50),category NVARCHAR(50));
----------------------------------------------------------------------------------------------------------
--Data Insertion

INSERT INTO customer VALUES (1, 'Alice', 'India'),(2, 'Bob', 'USA'),(3, 'Charlie', 'UK'),(4, 'David', 'India'),(5, 'Eva', 'Germany'),(6, 'Frank', 'USA'),(7, 'Grace', 'UK'),(8, 'Helen', 'India');
INSERT INTO products VALUES(101, 'Laptop', 'Electronics'),(102, 'Phone', 'Electronics'),(103, 'Headphones', 'Electronics'),(104, 'Chair', 'Furniture'),(105, 'Table', 'Furniture'),(106, 'Pen', 'Stationery'),(107, 'Notebook', 'Stationery');
INSERT INTO orders VALUES(1001, '2024-01-01', 1),(1002, '2024-01-02', 2),(1003, '2024-01-03', 1),(1004, '2024-01-04', 3),(1005, '2024-01-05', 4),(1006, '2024-01-06', 5),(1007, '2024-01-07', 6)(1008, '2024-01-08', 7),(1009, '2024-01-09', 8),(1010, '2024-01-10', 2);
INSERT INTO order_details VALUES(1001, 101, 1, 50000),(1001, 106, 5, 20),(1002, 102, 2, 20000),(1003, 103, 1, 3000),(1004, 104, 2, 1500),(1005, 105, 1, 7000),(1006, 101, 1, 50000),(1007, 107, 3, 100),(1008, 106, 10, 20),(1009, 102, 1, 20000),(1010, 103, 2, 3000),(1010, 105, 1, 7000);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Data Analysis Queries
--Show all orders with customer names
select customer.cust_name,orders.order_id,orders.order_date from customer right join orders on customer.cust_id=orders.cust_id;
--Show product name with order details
select products.product_name,order_details.order_id,order_details.quantity,order_details.price from products right join order_details on products.product_id=order_details.product_id;
--Find total number of orders
select count(order_id) as Total_orders from orders;
--List all customers who placed orders
select distinct customer.cust_name,customer.country from customer left join  orders on customer.cust_id=orders.cust_id;
--Find total revenue
select quantity*price as Revenue from order_details;

--Find total revenue per customer
select customer.cust_name,sum(order_details.price*quantity) as total_revenue_perCustomer from customer join orders on customer.cust_id=orders.cust_id join order_details on orders.order_id= order_details.order_id group by customer.cust_name;
--Find total orders per customer
select customer.cust_name,count(orders.order_id) from customer left join orders on customer.cust_id=orders.cust_id group by customer.cust_name;
--Find revenue per product
select products.product_name, sum(order_details.price*quantity) as Revenue from products left join order_details on products.product_id=order_details.product_id group by products.product_name;
--Find revenue per category
select products.category, sum(order_details.price*quantity) as Revenue from products left join order_details on products.product_id=order_details.product_id group by products.category;
--Find top 5 customers based on revenue
select top 5 customer.cust_name,sum(order_details.price*quantity) as Revenue from customer join  orders on customer.cust_id=orders.cust_id join order_details on orders.order_id=order_details.order_id group by customer.cust_name;

--Find customers who never placed orders
select customer.cust_name,orders.order_id from customer left join orders on customer.cust_id=orders.cust_id where orders.order_id=null;
--Find products that were never sold
select products.product_name from products join order_details on products.product_id=order_details.order_id where order_details.product_id=null;
--Find the most sold products
select products.product_name,count(order_details.quantity) from products join order_details on products.product_id=order_details.product_id group by products.product_name having count(order_details.quantity)>=2;
--Find orders with total value greater than 50000
select orders.cust_id,sum(order_details.price*quantity) as Revenue from orders left join order_details on orders.order_id=order_details.order_id group by orders.cust_id having sum(order_details.price*quantity)>50000; 

--Rank customers based on revenue
select customer.cust_name,sum(order_details.price*quantity),rank() over(order by sum(order_details.price*quantity) desc) as Rankk from customer join orders on customer.cust_id=orders.cust_id join order_details on  orders.order_id=order_details.order_id group by customer.cust_name;
--Find top 3 products in each category
select top 3 products.product_name,products.category,sum(order_details.price*quantity) from products join order_details on products.product_id=order_details.product_id group by products.category,products.product_name;
--Find running total of revenue by date
select orders.order_date,sum(order_details.price*quantity) as Revenue,sum(sum(order_details.price*quantity)) over (order by orders.order_date) as Running_total from orders join order_details on orders.order_id=order_details.order_id group by orders.order_date;
--Find second highest spending customer
select customer.cust_name,sum(order_details.price*quantity) as Revenue from customer join orders on customer.cust_id=orders.cust_id join order_details on orders.order_id=order_details.order_id group by customer.cust_name order by sum(order_details.price*quantity) desc offset 1 row fetch next 1 row only;
--Find top customer in each country
select customer.cust_name,customer.country,sum(order_details.price*quantity) as Revenue,rank() over(order by sum(order_details.price*quantity) desc) from customer join orders on customer.cust_id=orders.cust_id join order_details on orders.order_id=order_details.order_id group by customer.cust_name,customer.country;

