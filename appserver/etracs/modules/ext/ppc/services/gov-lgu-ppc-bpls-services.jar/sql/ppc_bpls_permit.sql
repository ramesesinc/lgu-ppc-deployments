[findReleaseLog]
select * 
from business_application_task 
where refid = $P{applicationid} 
	and state = 'release'
	and startdate is not null 
order by startdate desc 
