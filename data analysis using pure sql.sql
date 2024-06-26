CREATE INDEX accident_index
ON accident(accident_index);
CREATE INDEX accident_index
ON vehicles(accident_index);
select * from accident
-- calculating total number of accident
SELECT vt.vehicle_type as "Vehicle Type", a.accident_severity as "Severity", count(vt.vehicle_type) as "number of accident"
from accident a 
join vehicles v ON v.accident_index=a.accident_index
join vehicle_types vt ON vt.vehicle_code = v.vehicle_type
group by vt.vehicle_type,a.accident_severity
order by vt.vehicle_type,a.accident_severity;
-- calculating average Severity by vehicle type 

SELECT vt.vehicle_type as "Vehicle Type", AVG(CAST(a.accident_severity AS FLOAT)) as " Average Severity", count(vt.vehicle_type) as "number of accident"
from accident a 
join vehicles v ON v.accident_index=a.accident_index
join vehicle_types vt ON vt.vehicle_code = v.vehicle_type
group by vt.vehicle_type
order by " Average Severity", "number of accident";
/* Average Severity and Total Accidents by Motorcyle */
SELECT vt.vehicle_type as "Vehicle Type", AVG(CAST(a.accident_severity AS FLOAT)) as " Average Severity", count(vt.vehicle_type) as "number of accident"
from accident a 
join vehicles v ON v.accident_index=a.accident_index
join vehicle_types vt ON vt.vehicle_code = v.vehicle_type
WHERE vt.vehicle_type LIKE '%torcycle%'
group by vt.vehicle_type
order by " Average Severity", "number of accident"