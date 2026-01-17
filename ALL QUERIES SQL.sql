-- CREATE DATABASE airline_db;
-- USE airline_db;

SHOW TABLES;
SELECT * FROM maindata;

-- KPI 1 (DATE)

SELECT
    STR_TO_DATE(
        CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
        '%Y-%m-%d'
    ) AS Flight_Date
FROM maindata;

-- Year

SELECT
    YEAR(Flight_Date) AS Year
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Month no

SELECT
    MONTH(Flight_Date) AS MonthNo
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Month Full Name

SELECT
    MONTHNAME(Flight_Date) AS MonthFullName
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Quarter(Q1-Q4)

SELECT
    CONCAT('Q', QUARTER(Flight_Date)) AS Quarter
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Year-Month

SELECT
    DATE_FORMAT(Flight_Date, '%Y-%b') AS YearMonth
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- WeekDay No

SELECT
    WEEKDAY(Flight_Date) + 1 AS WeekdayNo
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Weekday Name

SELECT
    DAYNAME(Flight_Date) AS WeekdayName
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Financial Month (India: April–March)

SELECT
    CASE
        WHEN MONTH(Flight_Date) >= 4 THEN MONTH(Flight_Date) - 3
        ELSE MONTH(Flight_Date) + 9
    END AS FinancialMonth
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- Financial Quarter

SELECT
    CASE
        WHEN MONTH(Flight_Date) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Flight_Date) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(Flight_Date) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter
FROM (
    SELECT STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t;

-- KPI 2

SHOW TABLES;
SELECT * FROM maindata;

-- KPI 2

select (SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100 From maindata;

-- Yearly Load Factor

SELECT
    Year,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS LoadFactorPct
FROM (
    SELECT
        `Year`,
        `# Transported Passengers`,
        `# Available Seats`
    FROM maindata
) t
GROUP BY Year;


-- QUARTERLY Load Factor

SELECT
    Quarter,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS LoadFactorPct
FROM (
    SELECT
        CONCAT('Q', QUARTER(
            STR_TO_DATE(
                CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
                '%Y-%m-%d'
            )
        )) AS Quarter,
        `# Transported Passengers`,
        `# Available Seats`
    FROM maindata
) t
GROUP BY Quarter;

-- Monthly Load Factor

SELECT
    YearMonth,
    ROUND(
        SUM(`# Transported Passengers`) /
        SUM(`# Available Seats`) * 100,
        2
    ) AS LoadFactorPct
FROM (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(
                CONCAT(`Year`, '-', `Month (#)`, '-', `Day`),
                '%Y-%m-%d'
            ),
            '%Y-%b'
        ) AS YearMonth,
        `# Transported Passengers`,
        `# Available Seats`
    FROM maindata
) t
GROUP BY YearMonth;

-- KPI 3

-- Load Factor % by Carrier Name

SELECT
    `Carrier Name`,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPct
FROM maindata
GROUP BY `Carrier Name`
order by LoadFactorPct desc
limit 10;

-- KPI 4

-- Top 10 Carriers by Passenger Preference

SELECT
    `Carrier Name`,
    SUM(`# Transported Passengers`) AS TotalPassengers
FROM maindata
GROUP BY `Carrier Name`
ORDER BY TotalPassengers DESC
LIMIT 10;

-- KPI 5

-- Top Routes (From → To City) by Number of Flights

SELECT
    `From - To City` AS Route,
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY `From - To City`
ORDER BY NumberOfFlights DESC
limit 10;

-- KPI 6

-- Load Factor: Weekend vs Weekday

SELECT
    CASE
        WHEN WEEKDAY(Flight_Date) >= 5 THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2) AS LoadFactorPct
FROM (
    SELECT *,
           STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Flight_Date
    FROM maindata
) t
GROUP BY DayType;

-- KPI 7

-- Number of Flights by Distance Group

SELECT
    `%Distance Group ID` AS DistanceGroup,
    COUNT(*) AS NumberOfFlights
FROM maindata
GROUP BY `%Distance Group ID`
ORDER BY NumberOfFlights DESC;
