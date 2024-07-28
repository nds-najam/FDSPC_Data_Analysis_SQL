create database competitor_analysis;
use competitor_analysis;
CREATE table vendors (company_id varchar(5) primary_key, name char(255), website varchar(255), num_users int, num_cities int);

INSERT INTO competitor_analysis.vendors (company_id, Name, website, num_users, num_cities)
VALUES
('C1','FoodBae','https://www.foodbae.com',8540,15),
('C2','Yumzo','https://www.yumzo.com',9670,18);

CREATE table vendors_metrics
(
id int auto_increment primary key,
company_id varchar(5),
month int,
num_orders int,
num_sales float,
foreign key(company_id) references vendors(company_id));

INSERT into vendors
values
('C5','FoodHunter','https://www.foodhunter.com',10000,17);

UPDATE vendors_metrics SET num_sales=num_sales*100000 where company_id='C4';

ALTER TABLE competitor_analysis.vendors
ADD COLUMN num_of_res INT;

ALTER TABLE competitor_analysis.vendors
MODIFY COLUMN num_of_res INT; -- to modify the table

UPDATE competitor_analysis
SET num_of_res = CASE
    WHEN company_id = 'C1' then 120
    WHEN company_id = 'C2' then 140
    WHEN company_id = 'C3' then 160
    WHEN company_id = 'C4' then 180
    WHEN company_id = 'C5' then 140
    ELSE NULL -- Set a default value or use NULL if there's no matching company id
END;

select
t2.name,
t1.num_sales,
(
(t1.num_sales - lag(t1.num_sales) OVER (partition by t1.company_id order by t1.month)) 
/ lag(t1.num_sales) over (partition by t1.company_id order by t1.month)
) * 100 AS percentage_change
FROM vendors_metrics t1
INNER JOIN vendors t2 ON t1.company_id = t2.company_id;

DELETE FROM table_name
WHERE condition;

DROP TABLE table_name;
TRUNCATE TABLE table_name;

select min(Pos_Date),max(Pos_Date) from pos_data;
select year(pos_date) as date_year,
	sum(revenue) as total_revenue
    from pos_data group by date_year;

-- Segment-wise revenue
select year(pos_date) as date_year,
	sum(revenue) as total_revenue,
    sum(case when segment='Hair Care' then revenue else 0 end) as hair_care_revenue,
    sum(case when segment='Makeup' then revenue else 0 end) as makeup_revenue,
    sum(case when segment='skincare' then revenue else 0 end) as skincare_revenue
    FROM pos_data group by date_year;
    
    
-- Segment-wise % increase
select
	date_year,
    total_revenue,
    (total_revenue - lag(total_revenue) over (order by date_year)) / lag(total_revenue) over (order by date_year) * 100 as total_percentage_change,
    hair_care_revenue,
    (hair_care_revenue - lag(hair_care_revenue) over (order by date_year)) / lag(hair_care_revenue) over (order by date_year) * 100 as hair_care_percentage_change,
    makeup_revenue,
    (makeup_revenue - lag(makeup_revenue) over (order by date_year)) / lag(makeup_revenue) over (order by date_year) * 100 as makeup_percentage_change,
    skincare_revenue,
    (skincare_revenue - lag(skincare_revenue) over (order by date_year)) / lag(skincare_revenue) over (order by date_year) * 100 as skincare_revenue_percentage_change
FROM (
    select year(pos_date) as date_year,
	sum(revenue) as total_revenue,
    sum(case when segment='Hair Care' then revenue else 0 end) as hair_care_revenue,
    sum(case when segment='Makeup' then revenue else 0 end) as makeup_revenue,
    sum(case when segment='skincare' then revenue else 0 end) as skincare_revenue
    FROM pos_data group by date_year
    ) t1;
    
select * from prod_data;
select * from pos_data;
select count(distinct SKU_ID) from prod_data;
select 
	sku_id,
	sum(`Revenue`) as total_revenue,
    sum(`page_traffic`) as total_traffic
from pos_data
group by sku_id
order by total_revenue asc;

-- By product type
select
sku_id,total_revenue,total_traffic,
case
when total_revenue != 0 and total_traffic != 0 then 'A'
when total_revenue = 0 and total_traffic = 0 then 'B'
when total_revenue != 0 and total_traffic = 0 then 'C'
when total_revenue = 0 and total_traffic != 0 then 'D'
end as 'prod_type'
from
(
select 
	sku_id,
	sum(`Revenue`) as total_revenue,
    sum(`page_traffic`) as total_traffic
from pos_data
group by sku_id
order by total_revenue asc
) T1;

-- Summation by prod type
select prod_type, sum(total_traffic) as Total_Traffic, sum(total_revenue) as Total_Revenue, count(prod_type) as Total_Products
from
(
select
sku_id,total_revenue,total_traffic,
case
when total_revenue != 0 and total_traffic != 0 then 'A'
when total_revenue = 0 and total_traffic = 0 then 'B'
when total_revenue != 0 and total_traffic = 0 then 'C'
when total_revenue = 0 and total_traffic != 0 then 'D'
end as 'prod_type'
from
(
select 
	sku_id,
	sum(`Revenue`) as total_revenue,
    sum(`page_traffic`) as total_traffic
from pos_data
group by sku_id
order by total_revenue asc
) T1
) T2
group by prod_type
order by prod_type;

-- To understand the correlation between the different products based on
-- campaigns, total revenue and total traffic from the dataset
select t2.sku_id, total_revenue, total_traffic, total_campaigns from
(select sku_id, sum(num_unique_campaigns) as total_campaigns from online_data group by sku_id) t0
right join
(
select
sku_id,total_revenue,total_traffic,
case
when total_revenue != 0 and total_traffic != 0 then 'A'
when total_revenue = 0 and total_traffic = 0 then 'B'
when total_revenue != 0 and total_traffic = 0 then 'C'
when total_revenue = 0 and total_traffic != 0 then 'D'
end as 'prod_type'
from
(
select 
	sku_id,
	sum(`Revenue`) as total_revenue,
    sum(`page_traffic`) as total_traffic
from pos_data
group by sku_id
order by total_revenue asc
) t1
) t2
ON t0.sku_id = t2.sku_id;


-- To understand the correlation between the different product types A,B,C
-- and D based on campaigns, total revenue and total traffic from the dataset
SELECT prod_type, sum(total_campaigns) AS Total_Campaigns,
SUM(total_traffic) AS Total_Traffic,
SUM(total_revenue) AS Total_Revenue,
COUNT(prod_type) AS Total_Products
FROM
(
SELECT t2.sku_id, prod_type, total_revenue, total_traffic, Total_Campaigns
FROM
(SELECT sku_id, sum(num_unique_campaigns) AS Total_Campaigns FROM
online_data group by sku_id) t0
RIGHT JOIN
(
SELECT sku_id, total_revenue, total_traffic,
CASE
when total_revenue!=0 and total_traffic!=0 then 'A'
when total_revenue=0 and total_traffic=0 then 'B'
when total_revenue!=0 and total_traffic=0 then 'C'
when total_revenue=0 and total_traffic!=0 then 'D'
END AS 'prod_type'
FROM
(
SELECT SKU_ID, SUM(`Revenue`) AS Total_Revenue, SUM(`Page_traffic`) AS
Total_Traffic
FROM pos_data
GROUP BY SKU_ID
) t1
) t2
on
t0.sku_id = t2.sku_id
) t3
GROUP BY prod_type
ORDER BY Total_Campaigns desc;

-- To find the the ratio of total traffic to total campaigns for each product type
-- A,B,C and D from the dataset:
SELECT prod_type, sum(total_campaigns) AS Total_Campaigns,
SUM(total_traffic) AS Total_Traffic,
SUM(total_revenue) AS Total_Revenue,
count(prod_type) AS Total_Products,
SUM(total_traffic)/SUM(total_campaigns) AS Campaign_Ratio
FROM
(
SELECT t2.sku_id, prod_type, total_revenue, total_traffic, Total_Campaigns
FROM
(SELECT sku_id, sum(num_unique_campaigns) AS Total_Campaigns from
online_data group by sku_id) t0
RIGHT JOIN
(
SELECT sku_id, total_revenue, total_traffic,
CASE
when total_revenue!=0 and total_traffic!=0 then 'A'
when total_revenue=0 and total_traffic=0 then 'B'
when total_revenue!=0 and total_traffic=0 then 'C'
when total_revenue=0 and total_traffic!=0 then 'D'
END AS 'prod_type'
FROM
(
SELECT SKU_ID, SUM(`Revenue`) AS Total_Revenue, SUM(`Page_traffic`) AS
Total_Traffic
FROM pos_data
GROUP BY SKU_ID
) t1
) t2
on
t0.sku_id = t2.sku_id
) t3
GROUP BY prod_type
ORDER BY Total_Campaigns desc;

--
-- Quiz Week-5
--
-- 1. Which SKU_ID has the maximum number of campaigns launched for it? Use the online_data table for this.
select sku_id, sum(num_unique_campaigns) as maxCampaigns
from online_data
group by sku_id
order by maxCampaigns desc;

--
-- 2. Which segment has the lowest revenue overall?
select * from pos_data;
select segment, sum(`Revenue`) as segRev from pos_data
group by segment
order by segRev desc;

--
-- 3. Which is the correct query to find the number of product ids that have had zero page traffic so far?
select * from pos_data;
select count(distinct sku_id)
from pos_data
where page_traffic = 0;

--
-- 4. Which month saw the highest spend on promotion of products? Use vpc_data table for this.
select * from vpc_data;
select month(vpc_date) as vpcMonth,sum(sum_of_spend) as MonthlySpend
from vpc_data
group by vpcMonth
order by MonthlySpend desc;

--
-- 5.Which segment has the maximum number of average search terms?
select * from search_rank_data;
select * from pos_data;
select segment, avg(search_terms) avgSearch
from search_rank_data srd 
inner join pos_data pos on srd.sku_id = pos.sku_id
group by segment
order by avgSearch desc;

--
-- 6. How many sku_ids are there in pos_data whose unit_price is the minimum?
select * from pos_data;
select count(distinct sku_id) from pos_data
where unit_price=0;

--
-- 7. Fill in the following query to find the latest 5_star_rating for each product from the product attribute table.
select * from prod_data;
select * from (
select sku_id, 5_Star_Rating, row_number()
over(partition by sku_id order by prod_date desc) as prod_order
from prod_data) t1
where prod_order=1;

--
