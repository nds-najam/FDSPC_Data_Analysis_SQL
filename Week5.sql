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

