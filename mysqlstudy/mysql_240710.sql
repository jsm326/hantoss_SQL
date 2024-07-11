-- Ch04. 자동차 매출 데이터를 이용한 리포트 작성
-- 일별 매출액 조회
USE classicmodels;
SELECT
	A.Orderdate
    , priceeach * quantityordered AS 매출액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
;


-- GROUP BY 절을 활용해서
-- 일별 매출액을 구하세요

SELECT
	A.Orderdate
	, SUM(priceeach * quantityordered) AS 일별매출액
    FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- SUBSTR : Pyton에서 말하는 슬라이싱 개념
-- 인덱스 번호가 1번부터 시작
--
SELECT SUBSTR("ABCDE", 1, 2);
SELECT SUBSTR('2003-01-06', 1, 7);

-- 월별 매출액
SELECT
	SUBSTR(A.Orderdate, 1, 7) AS 월별
	, SUM(priceeach * quantityordered) AS 매출액
    FROM orders A
	LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
-- 연도별 매출액
SELECT
	SUBSTR(A.Orderdate, 1, 4) AS 연도별
	, SUM(priceeach * quantityordered) AS 매출액
    FROM orders A
	LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 91p
-- 일자별, 월별, 연도별 구매자 수
SELECT
	COUNT(ordernumber) N_ORDERS
    , COUNT(DISTINCT ordernumber) N_ORDERS_DISTINCT
FROM
	ORDERS
;

SELECT
	orderdate
    ,COUNT(DISTINCT customernumber) 구매고객수
    ,COUNT(ordernumber) 주문건수
FROM
	orders
GROUP BY 1
ORDER BY 1
;

-- 출력 필드명 : 연도, 구매고객수, 매출액
-- 테이블 : orders, oderdetails
SELECT
	SUBSTR(A.Orderdate, 1, 4) AS 연도별
    , COUNT(DISTINCT customernumber) 구매고객수
	, SUM(priceeach * quantityordered) AS 매출액
    FROM orders A
	LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
SELECT *
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN products C
ON B.productCode = C.productCode
LEFT JOIN productlines D
ON C.productLine = D.productLine
;
-- 출력 필드명 : 연도, 구매고객수, 매출액
-- 테이블 : orders, oderdetails
SELECT COUNT(*)
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT JOIN products C 
ON B.productcode = C.productcode
LEFT JOIN productlines D 
ON C.productline = D.productline
;

SELECT COUNT(*)
FROM products A
LEFT JOIN productlines B
ON A.productline = B.productline
LEFT JOIN orderdetails C 
ON A.productcode = C.productcode
LEFT JOIN orders D
ON C.ordernumber = D.ordernumber
;
-- 기준 테이블이 어디냐에 따라 달라진다

-- 연도별 매출액과 구매자 수

-- 인당 구매금액
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    ,COUNT(DISTINCT A.customernumber) 구매고객수
    ,SUM(B.priceeach * B.quantityordered) AS 매출
    ,SUM(B.priceeach * B.quantityordered) / COUNT(DISTINCT A.customernumber) AS AMV
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 건당 구매금액
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    ,COUNT(DISTINCT A.orderNumber) 건수
    ,SUM(B.priceeach * B.quantityordered) AS 매출
    ,SUM(B.priceeach * B.quantityordered) / COUNT(DISTINCT A.orderNumber) AS 건당구매금액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 국가별, 도시별 매출액을 구하고 싶음
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    ,COUNT(DISTINCT A.orderNumber) 건수
    ,SUM(B.priceeach * B.quantityordered) AS 매출
    ,SUM(B.priceeach * B.quantityordered) / COUNT(DISTINCT A.orderNumber) AS 건당구매금액
FROM orderdetails A
LEFT JOIN orders B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;
-- 국가별, 도시별 매출액을 구하고 싶음
SELECT 
	C.country
    ,C.city
    ,SUM(B.priceeach * B.quantityordered) AS 매출
FROM orders A
LEFT JOIN orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN customers C 
ON A.customerNumber = C.customerNumber
GROUP BY 1, 2
ORDER BY 3
;

-- CASE WHEN
-- 조건문, IF-ELSE를 대신함
-- 북미 VS 비북미 매출액 비교
SELECT
	CASE WHEN country IN ('USA', 'Canada') THEN 'North America'
    ELSE 'Others' END country_grp
FROM customers
;
SELECT 
	CASE WHEN C.country IN ('USA', 'Canada') THEN '북미'
    ELSE '비북미' END country_grp
    ,SUM(B.priceeach * B.quantityordered) AS 매출
FROM orders A
LEFT JOIN orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN customers C 
ON A.customerNumber = C.customerNumber
GROUP BY 1
ORDER BY 1
;

-- p103. 매출 top5 국가 및 매출
-- row_number, rank, dense_rank

CREATE TABLE CLASSICMODELS.STAT AS
SELECT C.COUNTRY,
	SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1
ORDER
BY 2 DESC
;

SELECT * FROM stat;

SELECT 
	country,
	sales,
	DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM stat
;
-- QUERY 실행하는 순서
-- FROM ==> WHERE ==> GROUP BY ==> HAVING ==> SELECT

CREATE TABLE stat_rnk AS
SELECT
	country
    , sales
    , DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM stat
;

SELECT *
FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5
;

-- 서브쿼리
SELECT * FROM employees;
SELECT * FROM offices;

-- USA에 거주하는 직원의 이름을 출력하세요
SELECT lastName, firstName, country
FROM employees A
LEFT JOIN offices B
ON A.officeCode = B.officeCode
Where country = 'USA'
;
-- 서브쿼리
SELECT
	lastName, firstName
FROM employees
WHERE officeCode IN(
	SELECT officeCode
    FROM offices
    WHERE country = 'USA'
)
;

-- 문제, amount가 최대값인 것을 조회하세요
-- 조회해야할 필드명 : checkNumber, customerNumber, amount
-- 메인쿼리 : checkNumber, customerNumber, amount 조회
-- 서브쿼리 : amount가 최대값

-- 메인쿼리
SELECT checkNumber, customerNumber, amount
FROM payments;

-- 서브쿼리
SELECT MAX(amount) FROM payments;

-- 합치기
SELECT checkNumber, customerNumber, amount
FROM payments
WHERE amount = (SELECT MAX(amount) FROM payments)
;

-- 메인쿼리
SELECT checkNumber, customerNumber, amount
FROM payments;
-- 서브쿼리
SELECT avg(amount) FROM payments;

SELECT checkNumber, customerNumber, amount
FROM payments
WHERE amount >= (SELECT avg(amount) FROM payments)
;

-- 테이블 : customers, orders 테이플
-- 문제, 전체 고객 중에서 주문을 하지 않은 고객을 찾으세요!
-- 조회해야 할 필드명 : customerName

-- 메인 쿼리
SELECT customerName
FROM customers;

-- 서브쿼리 : 주문한 고객
SELECT DISTINCT customerNumber
FROM orders;

-- 결합
SELECT DISTINCT customerName
FROM customers
WHERE customerNumber NOT IN (
	SELECT DISTINCT customerNumber FROM orders
)
;

-- 인라인 뷰 : FROM
SELECT
	MIN(items)
    ,MAX(items)
    ,AVG(items)
FROM(
	SELECT
		ordernumber
		, COUNT(ordernumber) AS items
	FROM orderdetails
	GROUP BY 1
) A
;

-- 각 주문건당 최소, 최대, 평균을 구하고 싶습니다.

-- stat 테이블 저장
-- stat_rnk 저장
SELECT *
FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5
;

-- 위 쿼리와 결과는 동일
-- 인라인 뷰 서브쿼리가 2번 사용됨
SELECT *
FROM
(SELECT COUNTRY,
SALES,
DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY,
SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1) A) A
WHERE RNK <= 5
;

SELECT C.COUNTRY,
SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) BU_1,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU_2,
COUNT(DISTINCT B.CUSTOMERNUMBER)/COUNT(DISTINCT A.CUSTOMERNUMBER)
RETENTION_RATE
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER AND SUBSTR(A.ORDERDATE,1,4)
= SUBSTR(B.ORDERDATE,1,4)-1
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
;

-- 셀프 조인
SELECT *
FROM orders A
LEFT JOIN orders B
ON A.customerNumber = B.customernumber
	AND substr(A.orderdate, 1, 4) = substr(B.orderdate, 1, 4) - 1
;

-- BEST SELLER
-- 미국 고객의 Retention Rate가 제일 높음 확인
-- 미국에 집중
-- 미국의 Top5 차량 모델 추출을 부탁
-- 차량 모델별로 매출액 구하기
SELECT
	*
FROM
    (
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY Sales DESC) RNK
	FROM (
		SELECT
			D.productName
			, SUM(C.priceEach * C.quantityOrdered) AS sales
		FROM orders A
		LEFT JOIN customers B
		ON A.customerNumber = B.customerNumber
		LEFT JOIN orderdetails C
		ON A.orderNumber = C.orderNumber
		LEFT JOIN products D
		ON C.productCode = D.productCode
		WHERE B.country = 'USA'
		Group by 1
	) A
) A
WHERE RNK BETWEEN 1 AND 5
;

SELECT
	C.productScale
	, SUM(B.priceEach * B.quantityOrdered) AS sales
FROM orders A
LEFT JOIN orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN products C
ON B.productCode = C.productCode
LEFT JOIN customers D
ON A.customerNumber = D.customerNumber
WHERE country = 'USA'
Group by 1
;