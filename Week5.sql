create database competitor_analysis;
use competitor_analysis;
create table vendors (company_id varchar(5) primary_key, name char(255), website varchar(255), num_users int, num_cities int);

INSERT INTO competitor_analysis.vendors (company_id, Name, website, num_users, num_cities)
VALUES
('C1','FoodBae','https://www.foodbae.com',8540,15),
('C2','Yumzo','https://www.yumzo.com',9670,18);
