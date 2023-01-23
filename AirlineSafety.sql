
SELECT *
FROM [Portfolio Project]..AirlineSafety

-- Let's get the separate years columns added up so we can see totals

SELECT *, (incidents_85_99 + incidents_00_14) AS TotalIncidents, (fatal_accidents_85_99 + fatal_accidents_00_14) AS TotalFatalAccidents, (fatalities_85_99 + fatalities_00_14) AS TotalFatalities
FROM [Portfolio Project]..AirlineSafety

-- Now we'll have a more consolidated table to query from. Let's turn it into a Temp Table

CREATE TABLE #AirlineStats
(
Airline nvarchar (255),
SeatKMperWeek numeric,
TotalIncidents numeric,
TotalFatalAccidents numeric,
TotalFatalities numeric,
)

INSERT INTO #AirlineStats
SELECT airline, avail_seat_km_per_week, (incidents_85_99 + incidents_00_14) AS TotalIncidents, (fatal_accidents_85_99 + fatal_accidents_00_14) AS TotalFatalAccidents, (fatalities_85_99 + fatalities_00_14) AS TotalFatalities
FROM [Portfolio Project]..AirlineSafety

-- Let's test it out

SELECT Airline, SeatKMperWeek, TotalIncidents, TotalFatalAccidents, TotalFatalities
FROM #AirlineStats
ORDER BY TotalIncidents DESC

SELECT Airline, SeatKMperWeek, TotalIncidents, TotalFatalAccidents, TotalFatalities
FROM #AirlineStats
ORDER BY TotalFatalAccidents DESC

SELECT Airline, SeatKMperWeek, TotalIncidents, TotalFatalAccidents, TotalFatalities
FROM #AirlineStats
ORDER BY TotalFatalities DESC

-- We could simply rank them by incident numbers and statistics, but the amount flown (some airlines are much bigger and fly more miles) should be taken into account as well

SELECT Airline, SeatKMperWeek, TotalIncidents, TotalFatalAccidents, TotalFatalities
FROM #AirlineStats
ORDER BY SeatKMperWeek DESC

-- This already shows that despite flying the most, United performs better safety-wise than American and Delta
-- And somehow Southwest, despite being the 5th busiest airline (and low cost), has managed to avoid killing anybody...

-- Let's do some calculations to get rates

SELECT Airline, (TotalIncidents/SeatKMperWeek) AS IncidentRate
FROM #AirlineStats
ORDER BY IncidentRate DESC

-- Aeroflot comes out the worst in incident rates with none of the large US carriers even cracking the top 20
-- Their measure of available seat kilometers is interesting, because it doesn't actually say how many kilometers are flown, just how many are available,
-- but this is good as it represents the perspective of a single flyer as to what their chances are by taking a flight

SELECT Airline, (TotalFatalAccidents/SeatKMperWeek) AS FatalAccidentRate
FROM #AirlineStats
ORDER BY FatalAccidentRate DESC

-- Pakistan International leads the way in fatal accident rates followed closely by Ethiopian Airlines. Again no large US carriers in top 20, with carriers such as
-- Southwest having virtually zero

SELECT Airline, (TotalFatalities/SeatKMperWeek) AS FatalityRate
FROM #AirlineStats
ORDER BY FatalityRate DESC

-- Similar to the last one in terms of airlines with virtually zero, but here Kenya Airways and China Airlines take the lead, meaning they must have had fewer,
-- but larger accidents. Kenya Airways, Gulf Air, and Avianca are not looking good here: the only airlines in the 10 smallest with triple digit fatalities. Meanwhile
-- Lufthansa, despite being quite large and flying about half as much as the big American carriers, has almost zero.

-- But Southwest has to take the cake here: the fifth busiest airline, but the first in the top 5 to have no fatal accidents, followed closely by British Airways