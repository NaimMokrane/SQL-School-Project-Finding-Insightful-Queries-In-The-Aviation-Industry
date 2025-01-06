USE teamproject;

-- Query 1: Understand if countries with higher populations have less carbon emission an enrgy transition
select  ce.country_id, ce.carbon_emissions, et.renewable_energy, pi.population_rank
from carbon_emissions ce
join energy_transition et on ce.country_id = et.country_id
join population_index pi on pi.country = ce.country_id
;

select populationGroupRank, round(avg(carbon_emissions),2) avgCarbonEmissions, round(avg(renewable_energy),2) as avgRenewableEnergy
from (
	select  
		case 
		when  pi.population_rank between 1 and 20 then 'A. Top 20'
		when  pi.population_rank between 21 and 50 then 'B. Top 21 - 50'
		when  pi.population_rank between 51 and 100 then 'C. Top 51 - 100'
		else 'D. Top 101+' 
        end as populationGroupRank,
		ce.country_id, 
        ce.carbon_emissions, 
        et.renewable_energy
	from carbon_emissions ce
	join energy_transition et on ce.country_id = et.country_id
	join population_index pi on pi.country = ce.country_id
	order by populationGroupRank asc
	) as topGroup
group by populationGroupRank
;


-- Query 2: Group by Top
select cl.continent, pi.country, ce.carbon_emissions, et.renewable_energy, 
case 
	when  pi.population_rank between 1 and 20 then 'A. Top 20'
	when  pi.population_rank between 21 and 50 then 'B. Top 21 - 50'
	when  pi.population_rank between 51 and 100 then 'C. Top 51 - 100'
	else 'D. Top 101+' end as populationGroupRank
from carbon_emissions ce
join energy_transition et on ce.country_id = et.country_id
join population_index pi on pi.country = ce.country_id
join continent_list cl on cl.country_id = ce.country_id
where cl.continent = 'Europe'
order by carbon_emissions
;


-- Query 3: Germany
-- What could contribute to the low renewable energy?
select *
from clean_innovation
join energy_transition using(country_id)
where country_id = 'Germany'
;
-- the growth production of renewable energy doesn't equal the usage share of renewable energy
-- we could think it is obvious that high growth in renewable production would lead to a high usage of it 


-- Query 4:
select 
	ci.country_id as Country, 
	concat(energy_investment, ' / ', 
	round((select avg(energy_investment)
	from clean_innovation ci
	join energy_transition using(country_id)
	join green_society gs using(country_id)
	where ci.country_id != 'Germany'), 2)
    ) as `Germany / Europe - energy investment`,
 	concat(recycling_efforts, ' / ', 	round((select avg(recycling_efforts)
	from clean_innovation ci
	join energy_transition using(country_id)
	join green_society gs using(country_id)
	where ci.country_id != 'Germany'), 2)) as `Germany / Europe - recycling_efforts`,
	concat(renewable_energy, ' / ', 	round((select avg(renewable_energy)
	from clean_innovation ci
	join energy_transition using(country_id)
	join green_society gs using(country_id)
	where ci.country_id != 'Germany'), 2)) as `Germany / Europe - renewable_energy`
from clean_innovation ci
join energy_transition using(country_id)
join green_society gs using(country_id)
where ci.country_id = 'Germany'
