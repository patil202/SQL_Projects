select * from billionaires;

#Q1. Find the top 5 persons name and the networth?
select personName, finalWorth from billionaires
limit 5

#Q2 Find the all the unique countries from above Q1?
select personName, finalWorth, count(distinct country)  from billionaires
limit 5

#Q3 How may unique people are in the networth list?
select count(distinct personName)  from billionaires

#Q4 What is the average networth of the list?
select avg(finalWorth) from billionaires

#Q5 Find the richest people from the france but not from the paris?
select * from billionaires
where country = 'France' and city <>'Paris' 

#Q6 Find the richest people from the france, italy or spain not from the paris?
select * from billionaires
where country IN ('France', 'Paris', 'Spain')

#Q7 How many people are selfmade?
select count(personName) from billionaires
where selfMade = 'true'

#Q8 Find the number of billioners buy the industry of top 10 people only?
select industries, count(personName) as billioners_name from billionaires
group by industries
order by billioners_name  desc
limit 10

#Q9 Order thye number of billioners by the birth month on asending order?
select birthMonth, count(personName) from billionaires
group by birthMonth
order by birthMonth asc

#Q10 Find the total net worth of billionaires in each country, listing the countries with the highest total net worth at the top.
SELECT country, SUM(finalWorth) AS total_net_worth
FROM billionaires
GROUP BY country
ORDER BY total_net_worth DESC;


