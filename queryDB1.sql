/*
Dataset 1: classimodels
*/
use classicmodels;

-- TASK 1.1- Single Table Queries

-- Query 1: Know how many salespeople we have and their roles
select jobTitle, count(employeeNumber) as employeeCount 
from employees 
group by jobTitle 
order by employeeCount asc;


-- Query 2: Find top 5 products with the highest profit margin (MSRP - buyPrice)
select productName, productLine, MSRP - buyPrice as profitMargin, quantityInStock
from products
order by profitMargin desc
limit 5
;


-- Query 3: Show evolution of our Orders and Customers year over year
select year(orderDate) as orderYear, min(orderDate) as firstOrderDate, max(orderDate) as lastOrderDate,
	count(orderNumber) as orderCount, count(distinct customerNumber) as customerCount
from orders
group by orderYear
;

-- Query 4: Show the numbers of orders not Shipped or Resolved
select status as orderStatus, count(orderNumber) as orderCount
from orders
where status not in ('Shipped', 'Resolved', 'In Process')
group by status
;


-- TASK 1.2 - JOINS
-- Query 1: Check the number of orders and customers, by country and grouping by Shipped or not Shipped
select c.country, if(o.status='Shipped', 'Shipped', 'Other status') as shippedStatus,
	count(distinct o.customerNumber) as customerCount, count(o.orderNumber) as orderCount
from orders o
join customers c using(customerNumber)
group by c.country, shippedStatus
order by c.country asc, shippedStatus desc
;

-- Query 2: Find how many customers are asigned to an employee, how many orders have been placed
-- calculate the average regardless if the order was Cancelled
select concat(e.firstName, ' ', e.lastName) as employeeName,
	count(distinct o.customerNumber) as customerCount, count(distinct o.orderNumber) as orderCount,
    round(count(distinct o.orderNumber) / count(distinct o.customerNumber), 1) as ordersPerCustomer
from orders o 
join customers c using(customerNumber)
join employees e on e.employeeNumber = c.salesRepEmployeeNumber
group by employeeName
order by orderCount desc
;

-- TASK 1.3 - SUBQUERIES
-- Query 1: Calculate the average time an order takes to be shipped 
-- and find out if a specific month present significantly more or les delay than other
select month(orderDate) orderMonth,  round(avg(shippmentDelayDays), 1) avgShippmentDelayDays
from (
	select orderNumber, orderDate, shippedDate, status, CONCAT(DATEDIFF(shippedDate, orderDate), ' days') AS shippmentDelayDays
	from orders
	where status = 'Shipped'
) as result1
group by orderMonth
;

-- Query 2: Identify Products Codes that are above the Selling Price average - WHERE clause
select distinct productCode, productName
from orderdetails
join products using(productCode)
where (priceEach * quantityOrdered) < (
	select avg(priceEach * quantityOrdered) as avgSellingPrice
	from orderdetails
)
;

-- Proposals for Task 1.4 - WINDOWS FUNCTIONS
-- Query 1: 
--  quantityOrdered, priceEach,
create view revenueByProduct as 
select productCode, productName, 
	productLine, sum((quantityOrdered * priceEach)) revenueByProduct
from orderdetails
join orders using(orderNumber)
join products using(productCode)
where status = 'Shipped'
group by productCode, productName, productLine;

select productName, productLine, revenueByProduct,
 sum(revenueByProduct) over(partition by productLine) as revenueByProductLine, 
 round((revenueByProduct / sum(revenueByProduct) over(partition by productLine)) * 100, 2) as `% of revenueByProduct `
from revenueByProduct
order by productLine, revenueByProduct desc
;
-- Query 2: Show top performant employees based on Revenue or Orders
select concat(e.firstName, ' ', e.lastName) as employeeName, os.city, os.country,
    round(count(distinct o.orderNumber) / 
				count(distinct o.customerNumber), 2) as ordersPerCustomer,
    rank() over(partition by os.country order by count(distinct o.orderNumber) 
				/ count(distinct o.customerNumber) desc) as officeRank
from orders o 
join customers c using(customerNumber)
join employees e on e.employeeNumber = c.salesRepEmployeeNumber
join offices os on os.officeCode = e.officeCode
group by employeeName, os.city, os.country
;

