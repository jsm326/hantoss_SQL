USE classicmodels; -- 해당 Database를 사용하겠음
SHOW databases;

SELECT * FROM classicmodels.customers; -- 이렇게 하기 귀찮음
USE classicmodels; -- 사용

SHOW tables;


-- 현재 사용중인 스키마를 확인
SELECT DATABASE();

USE sakila;
SELECT * FROM CUSTOMERS; -- 간결하게

--
DESC customers;

-- SELECT : 선택하다 필드를
SELECT * FROM customers;
SELECT customerNumber, customerName, phone, addressLine1 FROM customers;
SELECT -- 보기쉽게
	customerNumber
    ,customerName
    ,phone
    ,city
FROM
	customers
;
-- WHERE 조건 : 필터링
SELECT *
FROM
	customers
WHERE country = 'USA'
;

SELECT *
FROM
	customers
WHERE
	customerNumber = 112
;

SELECT *
FROM
	customers
WHERE
	customerNumber = 112
;

-- 문자열과 부등호 연산자
SELECT *
FROM 
	customers
WHERE
	state <= 'C'
;


-- WHERE LIKE 연산자
SELECT *
FROM 
	customers
WHERE
	customerName LIKE '%Gifts%'
;

-- 문자열 검색할 때 가장 유용한 것 : 정규표현식을 활용한 검색
-- 매우 어려움, 근데 무조건 필요함

SELECT *
FROM
	customers
WHERE customerName REGEXP 'aa+'
;

-- AND
-- counrty가 USA이면서 city NYC인 고객을 조회하세요
-- 필드는 전체 조회
SELECT *
FROM
	customers
WHERE country = 'USA' AND city = 'NYC'
;

-- OR 조건
SELECT *
FROM
	customers
WHERE country = 'USA' OR contactLastName = 'Lee'
;

-- 테이블 Payments
SELECT * FROM payments;

-- BETWEEN 연산자
SELECT *
FROM
	payments
WHERE 
	amount BETWEEN 10000 AND 50000
;

SELECT *
FROM
	payments
WHERE 
	paymentDate BETWEEN '2003-06-05' AND '2003-12-31' 
	AND customerNumber <= 120 
    AND checkNumber LIKE '%JM%'
;

-- IN 연산자
SELECT *
FROM
	offices
WHERE country IN ('USA', 'France', 'UK')
;

SELECT *
FROM
	offices
WHERE country NOT IN ('USA', 'France', 'UK')
;

/*
SELECT 필드명
FROM 테이블명
WHERE 필드명에 관한 여러 조건식
*/

-- ORDER BY 절, sort_values(), 정렬
SELECT *
FROM orders
ORDER BY orderNumber ASC -- 오름차순
;

SELECT customerNumber, orderNumber
FROM orders
ORDER BY orderNumber ASC -- 오름차순
;

SELECT customerNumber, orderNumber
FROM orders
ORDER BY 1 ASC, 2 DESC -- 오름차순, 내림차순 -- 1이 의미하는 것은 첫번째 필드 2가 의미하는 것은 두번째 필드
;

/*
SELECT 필드명
FROM 테이블명
WHERE 필드명에 관한 여러 조건식
ORDER BY 필드값 기준 정렬
*/

-- GROUP BY와 HAVING
SELECT *
FROM orders;
SELECT
	DISTINCT status -- 중복값 제거
FROM orders
;

SELECT
	status
    , COUNT(*) AS "갯수"
FROM
	orders
-- WHERE 조건절 생략
group by
	status
HAVING COUNT(*) >= 5  -- HAVING은 group by 와 함께함
ORDER BY 2 DESC
;

SELECT
	country
    , city
    ,COUNT(*) AS "갯수"
FROM
	customers
GROUP BY country, city
;
USE classicmodels;
SHOW databases;
SHOW tables;
SELECT database();
DESC customers;

SELECT *
FROM
	customers
WHERE country = 'USA'
;

SELECT *
FROM
	customers
WHERE phone IN (555)
;

SELECT city, state
FROM
	customers
;