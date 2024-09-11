-- GET AVG SLEEP HOURS BY AGE GROUP


SELECT Age, AVG(Sleep_Hours) AS Average_Sleep
FROM MentalHealthSurvey
GROUP BY Age
ORDER BY Age

-- LOOK AT IMPACT OF WORK ENVIRONMENT

SELECT Work_Environment_Impact, AVG(Sleep_Hours), AVG(Screen_Time_Hours)
FROM MentalHealthSurvey
GROUP BY Work_Environment_Impact

-- LOOK AT THE RELATIONSHIP BETWEEN SLEEP & PHYSICAL ACTIVITY

SELECT Physical_Activity_Hours, AVG(Sleep_Hours), AVG(Screen_Time_Hours)
FROM MentalHealthSurvey
GROUP BY physical_activity_hours
ORDER BY physical_activity_hours

-- LOOK AT RELATIONSHIP BETWEEN SLEEP & SELF REPORTED MENTAL HEALTH STATE

SELECT Mental_Health_status, AVG(Sleep_Hours) AS Average_Sleep
FROM MentalHealthSurvey
GROUP BY Mental_health_status

-- IDENTIFYING OUTLIERS IN AVERAGE AMOUNT OF SLEEP

SELECT *
FROM MentalHealthSurvey
WHERE Sleep_Hours > (SELECT AVG(Sleep_Hours) + 2 * STDEV(Sleep_Hours) FROM MentalHealthSurvey)
   OR Sleep_Hours < (SELECT AVG(Sleep_Hours) - 2 * STDEV(Sleep_Hours) FROM MentalHealthSurvey)