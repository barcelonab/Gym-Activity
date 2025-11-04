--GET THE AGE GROUP
USE [24HF]
GO
WITH getAge AS
(
	SELECT
		MemberID,
		Name,
		Gender,
		Marital_Status,
		--Accurate age down to the day
		DATEDIFF(YEAR, Birth_Date, GETDATE()) 
        - CASE 
            WHEN (MONTH(Birth_Date) > MONTH(GETDATE())) 
              OR (MONTH(Birth_Date) = MONTH(GETDATE()) AND DAY(Birth_Date) > DAY(GETDATE()))
            THEN 1 
            ELSE 0 
          END AS Age
	FROM
		tblMember
),
groupAge AS
(
	SELECT
		MemberID,
		Name,
		Gender,
		Marital_Status,
		Age,
		CASE
			WHEN Age >= 16 AND Age <= 19 THEN
				'16-19'
			WHEN Age >= 20 AND Age <= 35 THEN
				'20-35'
			WHEN Age >= 36 AND Age <= 49 THEN
				'36-49'
			WHEN Age >= 50 AND Age <= 65 THEN
				'50-65'
			ELSE
				'66 Above'
			END AS AgeGroup
	FROM
		getAge
)
SELECT
	*
FROM 
	groupAge
GO

--GET THE HOUR GROUP
WITH getHour AS
(
	SELECT 
		MemberID,
		LocationID,
		DATEPART(HOUR, workout_date_time) as htime
	FROM
		tblWorkout
),
groupHour AS
(
	SELECT
		MemberID,
		LocationID,
		htime,
		CASE	
			WHEN htime >= 5 AND htime <= 9 THEN
				'5am-9am'
			WHEN htime >= 10 AND htime <= 13 THEN
				'10am-1pm'
			WHEN htime >= 14 AND htime <= 17 THEN
				'2pm-5pm'
			WHEN htime >= 18 AND htime <= 21 THEN
				'6pmm-9pm'
		END AS hourGroup
	FROM
		getHour
)

SELECT
	*
FROM
	groupHour
GO


