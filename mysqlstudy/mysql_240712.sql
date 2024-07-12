-- 테이블 생성
USE testdb;

CREATE TABLE vehicles(
	vehicleId int
    , year INT NOT NULL
    , make VARCHAR(100) NOT NULL,
    PRIMARY KEY(vehicleId)
)
;

-- 필드 1개 추가
-- ALTER TABLE 명령어
ALTER TABLE vehicles
ADD model VARCHAR(100) NOT NULL
;

DESCRIBE vehicles;

-- COLOR 필드 추가
ALTER TABLE vehicles
ADD color VARCHAR(100) NOT NULL
;

-- 테이블 생성 시, 테이블 정의서 or 명세서


ALTER TABLE vehicles
ADD NOTE VARCHAR(100)
;

DESC vehicles;

-- ALTER TABLE ~ MODIFY
ALTER TABLE vehicles
MODIFY note VARCHAR(100) NOT NULL;

DESC vehicles;

-- 컬럼명 변경
ALTER TABLE vehicles
CHANGE COLUMN note vehicleCondition VARCHAR(50) NOT NULL;

DESC vehicles;

-- 컬럼만 삭제
ALTER TABLE vehicles
DROP COLUMN vehicleCondition;

DESC vehicles;

-- 테이블명 변경
ALTER TABLE vehicles
RENAME TO cars;

DESC vehicles;
DESC cars;

COMMIT;