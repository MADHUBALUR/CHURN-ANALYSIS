-- SELECT * FROM capstone.customer;

-- 1.Identify the total number of customers and the churn rate --

select count(customer_id) as total_customers
   from customer_churn;

select churn_status,
case 
when churn_status = 'yes' then count(1)
when churn_status = 'no' then count(0)
end as churn_rate
from customer_churn group by churn_status;
select count(churn_status) from customer_churn where churn_status = 'yes';

-- 2.	Find the average age of churned customers --

select avg(age)
from customer_churn
where churn_status = 'yes';

-- 3.	Discover the most common contract types among churned customers --

select contract_type,count(contract_type)
from customer_churn
where churn_status = 'yes' group by contract_type;

-- 4.	Analyze the distribution of monthly charges among churned customers --

select max(monthly_charges),min(monthly_charges),round(avg(monthly_charges),2),stddev(monthly_charges)
from customer_churn
where churn_status = 'yes';

-- 5. Create a query to identify the contract types that are most prone to churn --
select contract_type,churn_status,
case  when contract_type = 'yearly' then count(1) 
when contract_type = 'monthly' then count(2)
else null end as contract
from customer_churn group by contract_type,churn_status;

-- 6.	Identify customers with high total charges who have churned --
select customer_id,total_charges
from customer_churn
where churn_status ='yes' order by total_charges desc;

-- 7.	Calculate the total charges distribution for churned and non-churned customers *********
select customer_id,total_charges,churn_status
from customer_churn
order by churn_status ;
select customer_id,total_charges
from customer_churn where churn_status= 'no';

-- 8.	Calculate the average monthly charges for different contract types among churned customers --
select avg(monthly_charges),churn_status,contract_type
from customer_churn
where churn_status= 'yes'
group by contract_type;

-- 9.	Identify customers who have both online security and online backup services and have not churned --
select customer_id,online_security,online_backup,churn_status
from customer_churn
where churn_status ='no'and online_security = 'yes' and online_backup = 'yes'
group by customer_id;

-- 10.	Determine the most common combinations of services among churned customers ************
SELECT internet_service,phone_service,multiple_lines,online_security,online_backup,
device_protection,tech_support,streaming_movies,streaming_tv,
       COUNT(customer_id) AS combination_count
FROM customer_churn
WHERE churn_status = 'yes' group by internet_service,phone_service,multiple_lines,online_security,online_backup,
device_protection,tech_support,streaming_movies,streaming_tv
ORDER BY combination_count DESC ;

-- 11.	Identify the average total charges for customers grouped by gender and marital status --

select gender,marital_status,round(avg(total_charges),2)
from customer_churn
group by gender,marital_status;

-- 12.	Calculate the average monthly charges for different age groups among churned customers --
select avg(monthly_charges) as avg_monthly_chages,
case
when age between 18 and 20 then '18-20' when age between 21 and 30 then '21-30'
when age between 31 and 40 then '31-40' when age between 41 and 50 then '41-50'
when age between 51 and 60 then '51-60' when age between 61 and 70 then '61-70'
when age between 71 and 80 then '71-80'
else 'null' end as age_group
from customer_churn where churn_status ='yes' group by age_group;

-- 13.	Determine the average age and total charges for customers with multiple lines and online backup **********
select avg(age),sum(total_charges)
from customer_churn
where multiple_lines = 'yes' and online_backup = 'yes';

-- 14.	Identify the contract types with the highest churn rate among senior citizens (age 65 and over) --
select distinct contract_type,age
from customer_churn
where churn_status = 'yes' and age >64;

-- 15.	Calculate the average monthly charges for customers who have multiple lines and streaming TV --
select customer_id,avg(monthly_charges)
from customer_churn
where multiple_lines ='yes' and streaming_tv = 'yes'
group by customer_id;

-- 16.	Identify the customers who have churned and used the most online services  *******
select customer_id,online_security,online_backup,streaming_tv,streaming_movies
from customer_churn
 where churn_status = 'yes';


-- 17.	Calculate the average age and total charges for customers with different combinations of streaming services
 select avg(age),sum(total_charges),streaming_tv,streaming_movies,count(customer_id)
 from customer_churn group by streaming_tv,streaming_movies;


-- 18.	Identify the gender distribution among customers who have churned and are on yearly contracts
select gender,
case when gender = 'male' then count(1)when gender = 'female' then count(2)else null end as gender_distribution
from customer_churn where churn_status ='yes'and contract_type = 'yearly'group by gender;

-- 19.	Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type
select avg(monthly_charges),avg(total_charges),contract_type,internet_service
from customer_churn where churn_status = 'yes' group by contract_type,internet_service;

-- 20.	Find the customers who have churned and are not using online services, and their average total charges
select customer_id,avg(total_charges),online_security,online_backup
from customer_churn where churn_status = 'yes' and online_backup = 'no' and online_security = 'no' 
group by customer_id,online_security,online_backup;

-- 21.	Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents
select avg(monthly_charges),sum(total_charges),dependents
from customer_churn where churn_status = 'yes'
group by dependents;

-- 22.	Identify the customers who have churned, and their contract duration in months (for monthly contracts) ****************
select customer_id,contract_type from customer_churn
where churn_status = 'yes' and contract_type = 'monthly';

-- 23.	Determine the average age and total charges for customers who have churned, grouped by internet service and phone service *************

select avg(age),sum(total_charges),internet_service,phone_service
from customer_churn where churn_status = 'yes'
group by internet_service,phone_service;

-- 24.	Create a view to find the customers with the highest monthly charges in each contract type ***********
create view a1 as
select max(monthly_charges) as highest_monthly_charges,contract_type
from customer_churn group by contract_type;

select * from a1;
-- 25.	Create a view to identify customers who have churned and the average monthly charges compared to the overall average *********

create view churn_cust_avg_monthly_charges as
select avg(monthly_charges),'total' as entire_customers from customer_churn
union
select avg(monthly_charges),'churned' as entire_customers from customer_churn where churn_status ='yes';

select * from churn_cust_avg_monthly_charges;

-- 26.	Create a view to find the customers who have churned and their cumulative total charges over time
  create view a2 as select customer_id,sum(total_charges) from customer_churn
  group by customer_id;
 
 
-- 27.	Stored Procedure to Calculate Churn Rate

create procedure churnrate()
select count(churn_status),(churn_status) from customer_churn
group by churn_status;

-- 28.	Stored Procedure to Identify High-Value Customers at Risk of Churning
create procedure risk()
select customer_id,monthly_charges,total_charges
from customer_churn where churn_status = 'no'  and 
device_protection = 'no' and 
online_security = 'no' and online_backup = 'no' and tech_support = 'no'
order by monthly_charges desc,total_charges;

call risk ();
































