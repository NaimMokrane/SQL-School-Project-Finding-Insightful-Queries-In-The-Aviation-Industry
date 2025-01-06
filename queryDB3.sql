use airbustest;

-- Query 1: Which type of customer travels the most and which ones are more satisfied

select `Range of Age`, satisfaction, sum(SurveyCount) as NumberOfPeople, avg(avgFlightDistance) as avgFlightDistance 
from (
	select Age, satisfaction, 
		count(id) as surveyCount, 
        round(avg(`Flight Distance`), 2) as avgFlightDistance,
		case
		when Age < 13 then 'Kid'
		when Age >= 13 and Age < 18 then 'Teenager'
		when Age >= 18 and Age < 30 then 'Young Adult'
		when Age >= 30 and Age < 60 then 'Adult'
		else 'Senior'
		end as 'Range of Age'
	from airbustest
	group by Age, 'Range of Age', satisfaction
	order by 'Range of Age', satisfaction
	) as SurveyCountFinal
group by `Range of Age`, satisfaction
order by `Range of Age`;

-- Query 2: We want to check the performance of our employees during flights, especially the longer ones
create view airbusgrade as
select Class, `Flight Distance`, Cleanliness, 
	`Inflight service`, `On-board service`, `Food and drink`, `Seat comfort`, 
    `Leg room service`, `Inflight wifi service`, `Inflight entertainment`, satisfaction, 
	(Cleanliness + `Inflight service`+ `On-board service`+ `Food and drink`+
    `Seat comfort` + `Leg room service` + `Inflight wifi service`+ `Inflight entertainment`) as TotalGrade 
from airbustest;
-- query the View
select Class, round(avg(`Flight Distance`), 2) as flightDistanceAvg, 
	round(avg(TotalGrade), 2) as totalGradeAvg, satisfaction 
from airbusgrade
group by Class, satisfaction
order by Class, satisfaction;