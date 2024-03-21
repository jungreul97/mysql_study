-- 5장 조인

USE 세계무역;
-- 조인 : 2개 이상의 테이블을 조회하여 하나의 결과를 반환.
-- ANSI SQL 문법을 사용하여, DBMS마다 SQL문의 호환이 가능하다.

-- 크로스 조인 : 테이블A 와 테이블B의 모든 행의 조합
SELECT COUNT(*) -- 4
FROM 부서;
SELECT COUNT(*) -- 10
FROM 사원;
SELECT COUNT(*)  -- 40
FROM 부서
CROSS JOIN 사원;

-- 40 부서와 사원간의 모든조합이 출력됨, 부서번호는 어느테이블에 부서번호인지 꼭 표시를 해줘야됨
SELECT 부서.부서번호, 부서명, 이름, 사원.부서번호  
FROM 부서
CROSS JOIN 사원
WHERE 이름 = '배재용';

-- INNER JOIN : 두 테이블 사이의 공통된 값을 기준으로 결과를 반환
-- 1. 등가조인(이퀴 조인) : = 로 조인한다.
-- 2. 비등가조인(논이퀴 조인) : 등호 외 비교 연산자로 조인한다.

-- '이소미'사원의 사원번호, 직위, 부서번호, 부서명을 출력하시오.
-- 사원테이블, 부서테이블 2개를 조회한다.
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
INNER JOIN 부서
ON 사원.부서번호 = 부서.부서번호
WHERE 이름 = '이소미';

-- 조인 + GROUP BY절
SELECT 고객.고객번호, 담당자명, 고객회사명, COUNT(*) AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
GROUP BY 고객.고객번호,담당자명,고객회사명;

-- 3개의 테이블에서 INNER 등가조인 예)
-- 고객번호별로 주문금액합을 구하자.
SELECT 고객.고객번호, 담당자명, 고객회사명, SUM(주문수량 * 단가) AS 주문금액합
FROM 고객
JOIN 주문
ON 고객.고객번호 = 주문.고객번호
JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 고객.고객번호,담당자명,고객회사명
ORDER BY 1,2,3, 4 DESC;

DESC 고객;
SELECT * FROM 마일리지등급;
-- INNER 조인 : 비등가조인
SELECT 고객번호, 고객회사명, 담당자명, 마일리지, 등급명
FROM 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지;


-- OUTER JOIN : 조건(등가,비등가)에 맞지 않는 행도 결과값으로 나옴.
-- 사원 테이블에서 부서번호가 NULL인 행도 출력한다.
SELECT 부서명,사원.*
FROM 사원
RIGHT OUTER JOIN 부서
ON 사원.부서번호 = 부서.부서번호;
UPDATE 부서 SET 부서번호 = NULL WHERE 부서번호 = '';
-- 부서번호가 NULL인 사원만 출력한다.
SELECT 이름,부서.*
FROM 사원
RIGHT OUTER JOIN 부서
ON 사원.부서번호 = 부서.부서번호
WHERE 부서.부서번호 IS NULL;

-- 셀프 조인 : 한개의 테이블을 대상으로 조인하는 것.
SELECT 사원.사원번호, 사원.이름, 상사.사원번호 AS 상사사원번호, 상사.이름 AS 상사이름
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호 = 상사.사원번호;

-- 연습문제
-- 1.세계무역 데이터베이스의 제품 테이블과 주문 세부 테이블을 조인하여 제품명별로 주문수량합과 주문금액합을 보이시오.
SELECT * FROM 제품;
SELECT * FROM 주문세부;
SELECT A.제품명, SUM(B.주문수량) AS 주문수량합, SUM(B.단가 * B.주문수량) AS 주문금액합
FROM 제품 A
JOIN 주문세부 B
ON A.제품번호 = B.제품번호
GROUP BY A.제품명;

-- 2. 주문, 주문세부, 제품 테이블을 활용하여 '아이스크림'제품에 대해서(주문년도 제품명)별로 주문수량합을 보이시오.
SELECT * FROM 주문;
SELECT * FROM 제품;
SELECT * FROM 주문세부;
SELECT YEAR(주문.주문일) AS 주문년도, 제품.제품명 AS 제품명,SUM(주문세부.주문수량)
FROM 주문
JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
JOIN 제품
ON 제품.제품번호 = 주문세부.제품번호
WHERE 제품.제품명 LIKE "%아이스크림%"
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- 3,제품, 주문세부 테이블을 활용하여 제품명별로 주문수량합을 보이시오.이때 주문이 한 번도 안 된 제품에 대한 정보도 함께 나타내시오.
SELECT * FROM 제품;
SELECT * FROM 주문세부;
SELECT 제품.제품명, IFNULL(SUM(주문세부.주문수량),NULL) AS 주문수량합
FROM 제품
LEFT JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품.제품명;

-- 4.고객 회사 중 마일리지 등급이 'A'인 고객의 정보를 조회하시오.조회할 컬럼은 고객번호, 담당자명, 고객회사명, 등급명, 마일리지입니다.
SELECT * FROM 고객;
SELECT * FROM 마일리지등급;
SELECT 고객번호,고객회사명,담당자명,등급명,FORMAT(마일리지,0)
FROM 고객
JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지;

-- 실전문제
-- 1. 마일리지 등급명별로 고객수를 보이시오.
SELECT 등급명, COUNT(등급명) AS 고객수
FROM 고객
JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
GROUP BY 등급명;
-- 2. 주문번호 ‘H0249’를 주문한 고객의 모든 정보를 보이시오.
SELECT * FROM 주문 ;
SELECT * FROM 고객;
SELECT 주문.주문번호,고객.*
FROM 주문
JOIN 고객
ON 주문.고객번호 = 고객.고객번호
WHERE 주문.주문번호 = 'H0249';
-- 3. 2020년 4월 9일에 주문한 고객의 모든 정보를 보이시오.
SELECT 주문.주문일,고객.*
FROM 주문
JOIN 고객
ON 주문.고객번호 = 고객.고객번호
WHERE 주문.주문일 = '2020-04-09';
-- 4. 도시별로 주문금액합을 보이되 주문금액합이 많은 상위 5개의 도시에 대한 결과만 보이시오.
SELECT * FROM 고객;
SELECT * FROM 주문;
SELECT * FROM 주문세부;
-- FORMAT함수를 쓰면 문자열로 변경되기 때문에 대소비교가 안되어 문자열 정렬순서대로 정렬된다!!!
SELECT 고객.도시, FORMAT(SUM(주문세부.주문수량 * 주문세부.단가),0 ) AS 주문금액합
FROM 고객
JOIN 주문
ON 고객.고객번호 = 주문.고객번호
JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 고객.도시
ORDER BY SUM(주문세부.주문수량 * 주문세부.단가) DESC
LIMIT 5;



























