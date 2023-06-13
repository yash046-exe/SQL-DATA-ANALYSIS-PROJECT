use mydb;
select * from mydb.dataset1;
select * from mydb.dataset2;

-- What are the totoal number of rows in the dataset?
select count(*) from dataset1;
select count(*) from dataset2;

-- Carryout the totatl dataset from bihar and jharkhand
select * from dataset1 where state in ('Jharkhand', 'bihar');

-- total population of india
select sum(population) from dataset2;

/* Since the dataset I used have the population saperated by comma values,
   I had to first convert the data values in comma into non-comma saperated numbers */

use mydb;
update dataset2 
set population = replace(upper(population), ',' , ' ');

--  Again processing the same query for precised results

-- total population of india
select sum(population) from dataset2;

-- The growth of india in the previous years
select avg(growth) from dataset1;

-- The growth of indian in the previous year in accordance with the state
select state, avg(growth) avg_growth from dataset1 group by state order by state;

-- Avg sex ratio in india
select state, round(avg(sex_ratio),0) avg_growth from dataset1 group by state order by state;

-- Avg literacy rate in india
select state, round(avg(literacy),0) avg_literacy_rate from dataset1
group by state having round(avg(literacy),0)>90 order by state;

-- Top states with the high Avg growth
select  state,avg(growth) avg_growth from dataset1 group by state order by state desc limit 3;

-- Bottom 3 states showing the lowest sex ratio
select state, round(avg(sex_ratio),0) avg_sex_ratio from dataset1 group by state order by avg_sex_ratio asc limit 3; 

-- Top and bottom 3 states in literacy rate
drop table if exists topstates;
create table topstates
( state varchar(100), 
topstates float 

);

insert into topstates
select state, round(avg(literacy),0) avg_literacy_rate from dataset1 group by state order by avg_literacy_rate desc limit 3;
select * from topstates;

-- FOR THE BOTTOM STATES

drop table if exists bottomstates;
create table bottomstates
( state varchar(100), 
bottomstates float 

);

insert into bottomstates
select state, round(avg(literacy),0) avg_literacy_rate from dataset1 group by state order by avg_literacy_rate asc limit 3;
select * from bottomstates;

-- COMBINED TABLE FOR BOTH THE RESULT

select * from  (select * from topstates) a

union

select * from (select * from bottomstates) b ;


-- STATES STARTING WITH LETTER 'A'

select state from dataset1 where state like 'a%';

--  STATE STARTING WITH 'A' OR 'B'
select distinct(state) from dataset1 where state like 'a%' or 'b%';

-- TOTAL NUMBER OF MALES AND FEMALES (DISTRICT)

/* SINCE THE ONLY AVAILABLE COLUMNS ARE THE POPULATION AND SEX_RATIO,
   SO WE HAVE TO FIND THE TOTAL NUMBER OF MALES AND FEMALES USING THESE COLUMNS
   THE FORMULAS USED IN MY DATA ANALYSIS PROJECT WILL BE ATTACHED IN A NOTEPAD FILE*/
   
select c.district,c.state,round(c.population/ (c.sex_ratio+1),0) as males, round((c.population*c.sex_ratio)/ (c.sex_ratio+1),0) as females from
(select a.District,a.state,a.sex_ratio/1000 sex_ratio,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) c
;

-- TOTAL NUMBER OF MALES NAD FEMALES (STATE)
select d.state,sum(d.males) as total_males, sum(d.females) as total_females from
(select c.district,c.state,round(c.population/ (c.sex_ratio+1),0) as males, round((c.population*c.sex_ratio)/ (c.sex_ratio+1),0) as females from
(select a.District,a.state,a.sex_ratio/1000 sex_ratio,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) c) d
group by d.state;


-- TOTAL LITERACY RATIO

select d.district,d.state,round(d.literacy_ratio*d.population,0) as literate_people, round((1-d.literacy_ratio)* d.population,0) as illeterate_people from
(select a.District,a.state,a.literacy/100 as literacy_ratio,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) d
;


-- TOTAL LITERACY RATIO (STATE)
 select c.state,sum(literate_people), sum(illeterate_people) from
 (select d.district,d.state,round(d.literacy_ratio*d.population,0) as literate_people, round((1-d.literacy_ratio)* d.population,0) as illeterate_people from
(select a.District,a.state,a.literacy/100 as literacy_ratio,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) d) c
group by c.state
;

-- POPULATION IN PREVIOUS YEAR CENSUS

select d.state,d.district,round(d.population/ (1+d.growth),0) as previous_census_population, d.population as current_census_population from
(select a.District,a.state,a.growth growth ,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) d;

-- POPULATION IN PREVIOUS YEAR CENSUS (STATE)


select e.state,sum(e.previous_census_population) as previous_census_population, sum(e.current_census_population) as current_census_population from
(select d.state,d.district,round(d.population/ (1+d.growth),0) as previous_census_population, d.population as current_census_population from
(select a.District,a.state,a.growth growth ,b.population from dataset1 as a inner join dataset2 as b on a.District=b.District) d) e
group by e.state;


-- TOP 3DISTRICT FROM EACH STATE WITH HIGHEST LITERACY RATE

select a. * from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from dataset1) a
where a.rnk in (1,2,3) order by state




