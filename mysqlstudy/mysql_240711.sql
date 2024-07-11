-- Churn Rate(%) 구하기
-- 웹사이트 : 사이트에 오늘 방문 -------> 90일 정도 후 방문 후 --
-- 우리 웹사이트는 1주일 기준, 3일 기준, 1달 기준점은 모두 상이
-- 분석하는 사람, 누가 이탈하는지 해서, 보고서를 상급자에 보고
-- 상급자 회의 소집, 마케팅 플랜, 개발자한테 지시, 각 사용자에게 push 메시지

USE classicmodels;

-- 현재 테이블의 가장 최근 날짜
SELECT MAX(orderdate) MX_order
FROM orders
;

-- 현재 테이블의 가장 오래된 날짜
SELECT MIN(orderdate) MX_order
FROM orders
;

-- 각 고객의 마지막 구매일
SELECT
	customernumber
    , MAX(orderdate) 마지막구매일
FROM orders
GROUP BY 1
;

-- 현재 시점은 2006-06-01
SELECT '2006-06-01';

-- 구하고 싶은 건, 2006-06-01 기준으로 가장 마지막에 구매한 날짜를 빼서 기간 구하기
-- DATEDIFF()
SELECT
	DATEDIFF('customernumber','2005-06-01',MAX(orderdate))
FROM orders
;

SELECT *
	,'2005-06-01' AS 오늘날짜
    ,DATEDIFF('2005-06-01',마지막구매일) DIFF
	FROM (
		SELECT
		customernumber
		, MAX(orderdate) 마지막구매일
	FROM orders
	GROUP BY 1
) A
;

SELECT *
    , CURDATE() AS 오늘날짜
    , DATEDIFF(CURDATE(), 마지막구매일) AS DIFF
FROM (
    SELECT
        customernumber
        , MAX(orderdate) AS 마지막구매일
    FROM orders
    GROUP BY 1
) A
;


-- DIFF를 90일 기준으로 Churn, Non-Churn
--                  이탈발생, 이탈미발생
SELECT *
	,'2005-06-01' AS 오늘날짜
    ,DATEDIFF('2005-06-01',마지막구매일) DIFF
	FROM (
		SELECT
		customernumber
		, MAX(orderdate) 마지막구매일
	FROM orders
	GROUP BY 1
) A
;

SELECT *
	,'2005-06-01' AS 오늘날짜
    , CASE WHEN DATEDIFF('2005-06-01',마지막구매일) < 90 THEN '이탈미발생'
    ELSE '이탈발생' END '이탈현황'
    ,DATEDIFF('2005-06-01',마지막구매일) DIFF
	FROM (
		SELECT
		customernumber
		, MAX(orderdate) 마지막구매일
	FROM orders
	GROUP BY 1
) A
;
-- 위 아래 둘다 같은거지만 인나인뷰를 사용하는거에도 익숙해지자
SELECT
	*
    , CASE WHEN DIFF >= 90 THEN '이탈발생'
    ELSE '이탈미발생' END 이탈우무
FROM (
	SELECT *
		,'2005-06-01' AS 오늘날짜
		,DATEDIFF('2005-06-01',마지막구매일) DIFF
	FROM (
		SELECT
		customernumber
		, MAX(orderdate) 마지막구매일
	FROM orders
	GROUP BY 1
	) A
) A
;

SELECT
	이탈우무
    ,COUNT(DISTINCT customerNumber) N_cus
FROM(
	SELECT
		*
		, CASE WHEN DIFF >= 90 THEN '이탈발생'
		ELSE '이탈미발생' END 이탈우무
	FROM (
		SELECT *
			,'2005-06-01' AS 오늘날짜
			,DATEDIFF('2005-06-01',마지막구매일) DIFF
		FROM (
			SELECT
			customernumber
			, MAX(orderdate) 마지막구매일
		FROM orders
		GROUP BY 1
		) A
	) A
) A
group by 1
;

CREATE TABLE CLASSICMODELS.CHURN_LIST AS
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
CUSTOMERNUMBER
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER,
'2005-06-01' END_POINT,
DATEDIFF('2005-06-01',MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP
BY 1) BASE) BASE
;

-- Churn 고객이 가장 많이 구매한 Productline을 구해보자
SELECT *
FROM churn_list;

SELECT 
	C.productline
	,COUNT(DISTINCT B.customernumber) BU
FROM orderdetails A
LEFT JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT JOIN products C
ON A.productcode = C.productcode
LEFT JOIN CHURN_LIST D
ON B.customernumber = D.customernumber
WHERE D.churn_type = 'CHURN'
GROUP BY 1
;

-- 4장을 이해하면, 6장, 7장도 쉽게 이해할 수 있음
-- 3번 필사
-- 처음은 결과가 동일하게 확인
-- 두번째는 각 메서드, 문법 궁금, 정리
-- 세번째는 살을 좀 더 붙이는 것

USE mydata;
SELECT * FROM dataset2;

-- 쇼핑몰, 리뷰 데이터
-- 댓글 분석, 감정 분석

SELECT
	`Division Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1
;
--
SELECT
	`Department Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1
;

-- Trend의 평규평점이 3.85
-- 세부적으로 내용을 확인해보자!
-- Department Name이 Trend인 것만 조회
SELECT *
from dataset2
    where `Department Name` = 'Trend'
    and rating <= 3
;

-- 연령대를 10세 단위로 그룹핑
-- 10-19세 => 10대
SELECT CASE WHEN AGE BETWEEN 0 AND 9 THEN '0009'
WHEN AGE BETWEEN 10 AND 19 THEN '1019'
WHEN AGE BETWEEN 20 AND 29 THEN '2029'
WHEN AGE BETWEEN 30 AND 39 THEN '3039'
WHEN AGE BETWEEN 40 AND 49 THEN '4049'
WHEN AGE BETWEEN 50 AND 59 THEN '5059'
WHEN AGE BETWEEN 60 AND 69 THEN '6069'
WHEN AGE BETWEEN 70 AND 79 THEN '7079'
WHEN AGE BETWEEN 80 AND 89 THEN '8089'
WHEN AGE BETWEEN 90 AND 99 THEN '9099' END AGEBAND,
AGE

FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend'
AND RATING <= 3
;

-- 쉽게 하는 방법
-- 나눗셈을 이용하자! 절사
SELECT TRUNCATE(Age, -1) AS '연령대'
	, count(*) AS 'CNT'
from dataset2
where rating <= 3 and `DEPARTMENT NAME` = 'Trend'
group by 1
;

-- 쉽게 하는 방법
-- 나눗셈을 이용하자! 절사
SELECT
	FLOOR(AGE/10) * 10 AS 연령대
    ,AGE
FROM dataset2;

-- 연령대별 분포 : 평점이 3 이하 리뷰
SELECT TRUNCATE(Age, -1) AS '연령대'
    ,count(*)  AS 'CNT'
from dataset2
where `DEPARTMENT NAME` = 'Trend'
group by 1
order by 2 desc
;

-- 50대 3점 이하 trend 리뷰만 추출
SELECT 
	`Review Text`
    , Age
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
and rating <= 3
and Age between 50 and 59
;

SELECT `REVIEW TEXT`
FROM dataset2;

SELECT `Review Text`
FROM
dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
	AND RATING <= 3
    AND AGE BETWEEN 50 AND 59
;


-- 평점이 낮은 상품의 주요 컴플레인

SELECT
	`Department Name`
    , clothingID
    , AVG(rating) AVG_RATE
FROM dataset2
group by 1, 2
;


SELECT
	*
    , ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) RNK
FROM(SELECT
	`Department Name`
	, clothingID
	, AVG(rating) AVG_RATE
	FROM dataset2
	group by 1, 2
) A
;
-- 위 결과를 토대로,
-- 1-10위 데이터 조회
CREATE TABLE mydata.stat AS -- 테이블에 저장
SELECT
	*
FROM(
	SELECT
		*
		, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) RNK
	FROM(SELECT
		`Department Name`
		, clothingID
		, AVG(rating) AVG_RATE
		FROM dataset2
		group by 1, 2
	) A
) A
WHERE RNK BETWEEN 1 AND 10
;

SELECT clothingID
FROM stat
WHERE `Department Name` = 'Bottoms' -- 불만족 1-10위인 제품의 불만족 리뷰를 가져오는 것이 포인트
;

SELECT *
FROM dataset2
;
-- 문제 Department에서 Bottoms 불만족 1-10위인 리뷰 텍스트를 가져오세요
-- 해당 ClothingID에 해당하는 리뷰 텍스트 

-- 메인쿼리 : dataset2에서 `Review Text`만 가져오기
SELECT `Review Text`
FROM dataset2
;
-- 서브쿼리 : Department에서 Bottoms 불만족 1-10위
SELECT clothingID
FROM STAT
WHERE `Department Name` = 'Bottoms'
;

-- 합치기
SELECT `Review Text`
FROM dataset2
WHERE clothingID IN
	(SELECT clothingID
	FROM STAT
	WHERE `Department Name` = 'Bottoms'
)
;

-- size가 포함된 리뷰 찾기
SELECT
	`REVIEW TEXT`
	, CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END SIZE_YN
FROM dataset2
;

-- size가 나온 댓글은 총 몇개일까?
SELECT
	sum(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_size
    , count(*) N_TOTAL
    , sum(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END)/count(*) as ratio
FROM dataset2
;

-- 사이즈와 관련된 다른 키워드도 한번 확인하자.
SELECT SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END ) N_SIZE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END ) N_LARGE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END ) N_LOOSE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END ) N_SMALL,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END ) N_TIGHT,
	SUM(1) N_TOTAL
FROM dataset2
;
-- ------------------------------------------
USE titanic;
SELECT * FROM titanic;
-- 중복값 유무 확인
-- 이 테이블은 중복값 존재 하지 않음
SELECT
	COUNT(PassengerId) N_PASS
    , COUNT(DISTINCT PassengerId) N_UNIQUE_PASS
FROM titanic
;

-- 요인별 생존 여부 집계
SELECT survived From titanic; -- 0은 사망 1은 생존

-- 성별에 따른 승객수와 생존자 수 구하기
-- 비율도 같이 구해보기
SELECT sex
	,count(PassengerId) as '승객'
	, SUM(survived) as '생존자'
    , ROUND(SUM(survived) / count(PassengerId), 3 ) as '비율'
FROM titanic
group by 1
;

-- 연령대별 승객수, 생존자수, 비율 구하기
SELECT 
	FLOOR(AGE/10) * 10 AS 연령대
    , count(PassengerId) AS 승객수
    , SUM(survived) as '생존자'
    , ROUND(SUM(survived) / count(*), 3) AS '비율'
FROM titanic
GROUP BY 1
ORDER BY 1
;

-- 연령대별, 성별 승객수, 생존자수, 비율 구하기
SELECT 
	FLOOR(AGE/10) * 10 AS ageband
    , sex
    , count(PassengerId) AS 승객수
    , SUM(survived) as '생존자'
    , ROUND(SUM(survived) / count(*), 3) AS Ratio
FROM titanic
GROUP BY 1, 2
ORDER BY 1
;

-- 인라인뷰에 조인문 만들기
SELECT
	A.AGEBAND
    , A.ratio AS M_RATIO
    , B.ratio AS F_RATIO
    , ROUND(B.ratio - A.ratio, 2) AS DIFF
FROM (
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'male'
	 ORDER BY 1, 2
) A
LEFT JOIN 
(
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1
	 HAVING sex = 'female'
	 ORDER BY 1, 2
) B
ON A.AGEBAND = B.AGEBAND
;

-- 승선 항구별 승객 수 embarked

-- 승선 항구별, 성별 승객 수

-- 승선 항구별, 성별 승객 비중(%) 인라인 뷰 테이블 결합

SELECT
	Embarked
	,COUNT(passengerid) AS 승객수
FROM titanic
group by 1
;

SELECT
	Embarked
    ,sex
	,COUNT(passengerid) AS 승객수
FROM titanic
group by 1
HAVING sex = 'female'
;

SELECT
	A.Embarked
    , A.SEX
    , A.승객수
    , B.SEX
    , B.승객수
    , A.승객수 /(A.승객수 + B.승객수) AS MALE_RATIO
    , B.승객수 /(A.승객수 + B.승객수) AS FEMALE_RATIO
FROM(
	SELECT
		Embarked
		,sex
		,COUNT(passengerid) AS 승객수
	FROM titanic
	group by 1, 2
	HAVING sex = 'male'
) A
LEFT JOIN
(
	SELECT
		Embarked
		,sex
		,COUNT(passengerid) AS 승객수
	FROM titanic
	group by 1, 2
	HAVING sex = 'female'
) B
ON A.Embarked = B.Embarked
;

-- 모범답안 위에는 내 답안
SELECT 
	A.embarked
    , A.sex
    , A.승객수
    , B.승객수
    , ROUND(A.승객수 / B.승객수, 2) AS ratio
FROM (
	SELECT 
		embarked
		, sex
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1, 2
	ORDER BY 1, 2
) A 
LEFT JOIN (
	SELECT 
		embarked
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1
	ORDER BY 1
) B
ON A.embarked = B.embarked
;
