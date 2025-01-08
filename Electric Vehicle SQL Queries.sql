 -- Q1 Top 3 Makers

select maker,sum(electric_vehicles_sold) as two_wheelers_sold
from electric_vehicle_sales_by_makers m 
join dim_date d 
on m.date=d.date
where fiscal_year in (2023,2024) and vehicle_category = '2-Wheelers'
group by 1
order by 2 desc
limit 3;

-- Bottom 3 Makers

select maker,sum(electric_vehicles_sold) as two_wheelers_sold
from electric_vehicle_sales_by_makers m 
join dim_date d 
on m.date=d.date
where fiscal_year in (2023,2024) and vehicle_category = '2-Wheelers'
group by 1
order by 2 asc
limit 3;

-- Q2 Top 5 States with Highest Penetration Rate (2-wheelers).

select state,round(sum(electric_vehicles_sold) / sum(total_vehicles_sold)*100,2) as penetration_rate
from electric_vehicle_sales_by_states s 
join dim_date d 
on s.date=d.date 
where vehicle_category = '2-Wheelers' and fiscal_year = 2024 
group by 1 
order by 2 desc
limit 5;

-- Top 5 States with Highest Penetration Rate (4-wheelers)

select state,round(sum(electric_vehicles_sold) / sum(total_vehicles_sold)*100,2) as penetration_rate
from electric_vehicle_sales_by_states s 
join dim_date d 
on s.date=d.date 
where vehicle_category = '4-Wheelers' and fiscal_year = 2024 
group by 1 
order by 2 desc
limit 5;

-- Q3 States with negative penetration (decline) in EV sales from 2022 to 2024?


with pr_22_24 as (
select state, vehicle_category,
sum(case when fiscal_year = 2022 then s.electric_vehicles_sold else 0 end) / 
sum(case when fiscal_year = 2022 then s.total_vehicles_sold else 0 end)*100 as pr_22,
sum(case when fiscal_year = 2024 then s.electric_vehicles_sold else 0 end) / 
sum(case when fiscal_year = 2024 then s.total_vehicles_sold else 0 end)*100 as pr_24
from electric_vehicle_sales_by_states s
join dim_date d 
on s.date = d.date
where vehicle_category in ('2-Wheelers','4-Wheelers')
group by state , vehicle_category)

select * from ( select state,vehicle_category ,round((pr_24-pr_22)/nullif(pr_22,0)*100,2) as change22_24 
from pr_22_24
where vehicle_category = '2-Wheelers'
order by change22_24 asc 
limit 1 ) as subquery_2_wheelers
 
union all 
	
select * from (select state,vehicle_category ,round((pr_24-pr_22)/nullif(pr_22,0)*100,2) as change22_24 
from pr_22_24
where vehicle_category = '4-Wheelers'
order by change22_24 asc 
limit 1) as subquery_4_wheelers

-- Q4 Quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024?

with quarterlysales as (
SELECT maker,quarter,sum(electric_vehicles_sold) as total_EV_sold
from electric_vehicle_sales_by_makers m 
join dim_date d 
on m.date=d.date
where vehicle_category = '4-Wheelers'
Group by 1,2),

rankedcompanies as (
select maker, sum(total_EV_sold) as EV_sold,
       rank() over (order by sum(total_EV_sold) desc ) as comapnyrank
from quarterlysales
group by 1)

select qs.maker,qs.quarter,qs.total_EV_sold
from quarterlysales qs 
join rankedcompanies rc 
on qs.maker=rc.maker
where rc.comapnyrank <= 5 
order by 1 desc,2;

-- Q5 EV sales and penetration rates in Delhi compare to Karnataka for 2024?

select state, sum(electric_vehicles_sold) as EV_sold , 
	   round(sum(electric_vehicles_sold) / sum(total_vehicles_sold)* 100,2) as penetration_rate
from electric_vehicle_sales_by_states s 
join dim_date d 
on s.date=d.date
where state in ('Delhi','Karnataka') and fiscal_year = 2024 
group by 1 

-- Q6 Compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024.
	
with EV_sold_22_24 as (
  select maker,
    sum(case when fiscal_year = 2022 then electric_vehicles_sold end) as EV_sold_2022,
    sum(case when fiscal_year = 2024 then electric_vehicles_sold end) as EV_sold_2024
  from electric_vehicle_sales_by_makers m 
  join dim_date d 
  on m.date = d.date
  where vehicle_category = '4-Wheelers'
  group by 1
),
top_maker as (
select maker
  from electric_vehicle_sales_by_makers 
  where vehicle_category = '4-Wheelers' 
  group by 1
  order by  sum(electric_vehicles_sold)  desc 
  limit 5
)
select e.maker,
	   e.EV_sold_2022,
	   e.EV_sold_2024,
	   case 
	        when EV_sold_2022 > 0 then round((power(EV_sold_2024/EV_sold_2022,0.5)-1)*100,2) 
	        else 0
	   End as CAGR
  from EV_sold_22_24 e 
  join top_maker m 
  on e.maker=m.maker
  order by 4 desc

-- Q7 Top 10 states that had the highest compounded annual growth rate (CAGR) from 2022 to 2024 in total vehicles sold.

with sales_22_24 as (
select state,
	sum(case when fiscal_year = 2022 then total_vehicles_sold end) as Sales_2022,
	sum(case when fiscal_year = 2024 then total_vehicles_sold end) as Sales_2024
from electric_vehicle_sales_by_states s 
join dim_date d 
on s.date=d.date
group by 1 ) 

select state,
	   Sales_2022,
       Sales_2024,  
       case	
       when Sales_2022 > 0 then round((power(Sales_2024/Sales_2022,0.5)-1)*100,2) else 0 
       end as CAGR
from sales_22_24
order by 4 desc 
limit 10;

-- Q8 Peak and low season months for EV sales based on the data from 2022 to 2024?

select To_char(d.date,'Month') as Month_name,sum(electric_vehicles_sold) as EV_sold
from electric_vehicle_sales_by_makers m 
join dim_date d
on m.date=d.date
group by 1
order by EV_sold desc

-- Q9 Projected number of EV sales (including 2-wheelers and 4-wheelers) for the top 10 states by penetration rate in 2030, based on the compounded annual growth rate (CAGR) from previous years?

with top10_PR_state as (
select state, 
       round(sum(electric_vehicles_sold) / sum(total_vehicles_sold)*100,2) as Penetration_rate,
	   sum(case when fiscal_year = 2022 then electric_vehicles_sold end) as EV_sales_2022,
	   sum(case when fiscal_year = 2024 then electric_vehicles_sold end) as EV_sales_2024
from electric_vehicle_sales_by_states s 
join dim_date d 
on s.date=d.date
group by state
order by Penetration_rate desc
limit 10 ),

growth_rate as (
select state,Penetration_rate,EV_sales_2022,EV_sales_2024,
	   case 
			when EV_sales_2022 > 0 then round((power(EV_sales_2024/EV_sales_2022,0.5)-1)*100,2)
	   else 0 end as CAGR
from top10_PR_state ) 

select state,
       round(EV_sales_2024 * power((1+CAGR/100),(2030-2024))/1000000,1) as EV_sales_2030_in_mln   
from growth_rate
order by EV_sales_2030_in_mln desc

-- Q10 Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024,
	
with revenue as (
select vehicle_category,
	   fiscal_year,
	   sum(electric_vehicles_sold * unit_price) as revenue  
from electric_vehicle_sales_by_makers m 
join dim_date d 
on m.date=d.date
group by vehicle_category,fiscal_year ), 

growth as (
select r1.vehicle_category,
       round((r2.revenue-r1.revenue)/r1.revenue * 100,2) as growth_2022_vs_2024,  
	   round((r2.revenue-r3.revenue)/r3.revenue * 100,2) as growth_2023_vs_2024 
from revenue r1
join revenue r2 on r1.vehicle_category = r2.vehicle_category and r2.fiscal_year = 2024
join revenue r3 on r1.vehicle_category = r3.vehicle_category and r3.fiscal_year = 2023
where r1.fiscal_year = 2022 ) 

select vehicle_category,
	   growth_2022_vs_2024,
	   growth_2023_vs_2024
from growth
order by 1




	
	
