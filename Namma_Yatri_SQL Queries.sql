use ola;

select * from trips;



select * from trips_details;

select * from loc;

select * from duration;

select * from payment;

//-- total trips--//
select count(distinct tripid) as "Total trips" from trips;

//-- total drivers--//
select count(distinct driverid) as "Count of Drivers" from trips;

//-- total earnings--//
select sum(fare) as "Total Earnings" from trips;

//-- total Completed trips --//
select sum(end_ride) as "Total Completed trips" from trips_details;

//-- total searches --//
select * from trips_details;
select sum(searches) from trips_details;

//-- --total searches which got estimate --//
select sum(searches_got_estimate) from trips_details;

-- total searches for quotes quotes means drivers
select sum(searches_for_quotes) from trips_details;

-- total searches which got quotes
select sum(searches_got_quotes) from trips_details;

-- cancelled bookings by driver
select sum(customer_not_cancelled) from trips_details;

-- cancelled bookings by customer
select sum(driver_not_cancelled) from trips_details;

-- total otp entered
select sum(otp_entered) from trips_details;

-- total end ride
select sum(end_ride) from trips_details;

-- average distance per trip
select * from trips;
select round(sum(distance)/count(tripid)) from trips;
select round(avg(distance)) from trips;

-- average fare per trip
select round(avg(fare)) from trips;
select round(sum(fare)/count(*)) from trips;

-- which is the most used payment method 
select p.method from payment  p join 
(select  faremethod, count(t.faremethod) from trips t 
group by t.faremethod
order by t.faremethod desc limit 1) m
on p.id=m.faremethod;

select  p.method as "Payment Method", count(t.faremethod) as "Total Count of Transaction" from trips t join payment p
on p.id= t.faremethod 
group by t.faremethod
order by t.faremethod desc limit 1;

-- the highest payment was made through which instrument
select  p.method as "Payment Method", max(t.fare) as "Highest Transaction" from trips t join payment p
on p.id= t.faremethod ;

-- which two locations had the most trips
select * from loc;

select * from
(select *, dense_rank() over(order by trip desc) rnk
from
(select loc_from,loc_to, count(distinct tripid) trip from trips  
group by loc_from,loc_to )a)b where b.rnk=1 ;


-- top 5 earning drivers
select * from(
select *, dense_rank() over(order by fare desc) rnk from
(select driverid, sum(fare) fare from trips
group by driverid)a)b  where rnk<6  ;

-- which duration had more trips
select * from
(select *, dense_rank() over(order by tripid desc) rnk from
(select duration , count(distinct tripid) tripid  from trips
group by duration)a)b where rnk=1;

-- which driver , customer pair had more orders
select * from (
select * , dense_rank() over(order by trip desc) rnk from
(select custid, driverid,count(distinct tripid) trip from trips
group by custid,driverid)a)b where rnk=1;

-- search to estimate rate
select * from trips_details;
select (sum(searches_got_estimate)/sum(searches)*100)  as "search to estimate %" 
from trips_details;

-- estimate to search for quote rates
select (sum(searches_for_quotes)/sum(searches_got_estimate)*100)  as "estimate to search for quote rates %" 
from trips_details;

-- quote acceptance rate
select (sum(searches_got_quotes)/sum(searches_for_quotes)*100)  as "quote acceptance rate %" 
from trips_details;

-- quote to booking rate
select (sum(customer_not_cancelled)/sum(searches_got_quotes)*100)  as "quote to booking rate %" 
from trips_details;

-- booking cancellation rate
select (sum(driver_not_cancelled)/sum(searches)*100)  as "quote to booking rate %" 
from trips_details;

-- conversion rate
select (sum(end_ride)/sum(searches)*100)  as "conversion rate %" 
from trips_details;

-- which area got highest trips in which duration
select * from 
(select * , rank() over(partition by duration order by cnt desc) rnk from
(select duration, loc_from,count(distinct tripid) cnt from trips
group by duration, loc_from)a) b where rnk=1 ;

-- which area got the highest fares, cancellations,trips
select * from
(select *, rank() over(order by  fare desc) rnk from
(select loc_from,sum(fare) fare from trips
group by loc_from)a)b where rnk=1;

-- which area got the cancellations by customer
select * from
(select *, rank() over(order by  cust desc) rnk from
(select loc_from, (count(*)-sum(driver_not_cancelled)) cust from trips_details
group by loc_from)a)b where rnk=1;
-- which area got the cancellations by driver
select * from
(select *, rank() over(order by  cust desc) rnk from
(select loc_from, (count(*)-sum(customer_not_cancelled)) cust from trips_details
group by loc_from)a)b where rnk=1;

-- which duration got the highest fares
select * from
(select *, rank() over(order by  fare desc) rnk from
(select duration, sum(fare) fare from trips
group by duration)a)b where rnk=1;

-- which duration got the highest trips
select * from
(select *, rank() over(order by  tripid desc) rnk from
(select duration, count(distinct tripid) tripid from trips
group by duration)a)b where rnk=1;