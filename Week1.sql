-- Week 1
use foodhunter;
select * from orders;
select order_id from orders;
select * from orders limit 20000 offset 10000;
select count(order_id) from orders;
select count(distinct order_id) from orders;
