-- Create the database
Create DATABASE MovieRental;

-- Table Creation

CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE DECIMAL(8,2)
);
-- Insert Sample Data

INSERT INTO rental_data VALUES
(101, 1, 'Action', '2025-07-01', '2025-07-03', 4.99),
(102, 2, 'Drama', '2025-06-25', '2025-06-28', 3.99),
(103, 3, 'Comedy', '2025-07-05', '2025-07-06', 2.99),
(104, 1, 'Action', '2025-06-15', '2025-06-17', 4.49),
(105, 4, 'Horror', '2025-05-20', '2025-05-22', 3.49),
(106, 5, 'Action', '2025-04-10', '2025-04-12', 5.49),
(107, 2, 'Drama', '2025-07-10', '2025-07-12', 4.29),
(108, 3, 'Comedy', '2025-06-10', '2025-06-11', 2.49),
(109, 6, 'Thriller', '2025-03-15', '2025-03-17', 3.99),
(110, 1, 'Drama', '2025-05-05', '2025-05-06', 3.75),
(111, 4, 'Action', '2025-07-12', '2025-07-14', 5.25),
(112, 5, 'Comedy', '2025-07-13', '2025-07-14', 3.15),
(113, 6, 'Horror', '2025-06-20', '2025-06-22', 3.99),
(114, 3, 'Drama', '2025-04-15', '2025-04-16', 3.25),
(115, 2, 'Action', '2025-07-14', '2025-07-16', 5.49);

-- a) 📉 Drill Down: Genre → Individual Movie

SELECT GENRE, MOVIE_ID, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_REVENUE
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- b)  Rollup: Total rental fees by genre, then overall total

SELECT 
    IFNULL(GENRE, 'Total') AS GENRE,
    SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data
GROUP BY GENRE WITH ROLLUP;


-- c)  Cube (emulated): Total rental fees by combinations of GENRE, RENTAL_DATE, and CUSTOMER_ID
-- MySQL doesn't support CUBE() natively,but we can simulate it using GROUP BY GROUPING SETS logic manually.

-- Total by all 3 dimensions
SELECT GENRE, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEE
FROM rental_data
GROUP BY GENRE, RENTAL_DATE, CUSTOMER_ID

UNION

-- By GENRE and RENTAL_DATE
SELECT GENRE, RENTAL_DATE, NULL, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE, RENTAL_DATE

UNION

-- By GENRE and CUSTOMER_ID
SELECT GENRE, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE, CUSTOMER_ID

UNION

-- By RENTAL_DATE and CUSTOMER_ID
SELECT NULL, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY RENTAL_DATE, CUSTOMER_ID

UNION

-- By GENRE only
SELECT GENRE, NULL, NULL, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE

UNION

-- By RENTAL_DATE only
SELECT NULL, RENTAL_DATE, NULL, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY RENTAL_DATE

UNION

-- By CUSTOMER_ID only
SELECT NULL, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY CUSTOMER_ID

UNION

-- Overall total
SELECT NULL, NULL, NULL, SUM(RENTAL_FEE)
FROM rental_data;

-- d) Slice: Rentals from the 'Action' genre

SELECT * FROM rental_data
WHERE GENRE = 'Action';
-- e)  Dice: Rentals where genre = 'Action' or 'Drama' AND rental date in last 3 months

SELECT * FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= CURDATE() - INTERVAL 3 MONTH;