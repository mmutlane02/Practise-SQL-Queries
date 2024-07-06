
-- 1. Show all of the patients grouped into weight groups. 
--    Show the total amount of patients in each weight group. 
--    Order the list by the weight group descending. 
--    For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT count(weight),
	CASE
		WHEN weight BETWEEN 0 AND 10 THEN '10'
        WHEN weight BETWEEN 11 AND 20 THEN '20'
        WHEN weight BETWEEN 21 AND 30 THEN '30'
        WHEN weight BETWEEN 31 AND 40 THEN '40'
        WHEN weight BETWEEN 41 AND 50 THEN '50'
        WHEN weight BETWEEN 51 AND 60 THEN '60'
        WHEN weight BETWEEN 61 AND 70 THEN '70'
        WHEN weight BETWEEN 71 AND 80 THEN '80'
        WHEN weight BETWEEN 81 AND 90 THEN '90'
        WHEN weight BETWEEN 91 AND 100 THEN '100'
        WHEN weight BETWEEN 101 AND 110 THEN '110'
        WHEN weight BETWEEN 111 AND 120 THEN '120'
        WHEN weight BETWEEN 121 AND 130 THEN '130'
        WHEN weight BETWEEN 131 AND 140 THEN '140'
        WHEN weight BETWEEN 141 AND 150 THEN '150'
        ELSE 'Overweight'
	END as weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;


-- 2. Show patient_id, weight, height, isObese from the patients table. 
--    Display isObese as a boolean 0 or 1. 
--    Obese is defined as weight(kg)/(height(m)2) >= 30. 
--    Weight is in units kg. height is in units cm.

SELECT patient_id, weight, height, 
CASE 
	WHEN weight*10000/power(height, 2) >= 30 THEN '1'
    ELSE '0'
END as isObese
FROM patients
;


-- 3. Show patient_id, first_name, last_name, and attending doctor's specialty. 
--    Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
--    Check patients, admissions, and doctors’ tables for required information.

SELECT pat.patient_id, pat.first_name, pat.last_name, doc.specialty
FROM patients AS pat
JOIN admissions AS adm
	ON adm.patient_id = pat.patient_id
JOIN doctors AS doc
	ON doc.doctor_id = adm.attending_doctor_id
WHERE diagnosis = 'Epilepsy'
AND doc.first_name = 'Lisa'
;

-- 4. All patients who have gone through admissions, can see their medical documents on our site. 
--    Those patients are given a temporary password after their first admission. 
--    Show the patient_id and temp_password. 
--    The password must be the following, in order: 
-- 			1. patient_id 
-- 			2. the numerical length of patient's last_name 
-- 			3. year of patient's birth_date

SELECT distinct pa.patient_id, concat(pa.patient_id, length(last_name), year(birth_date)) as temp_password
FROM patients pa
JOIN admissions ad
	ON pa.patient_id = ad.patient_id
;


-- 5. Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
--    All patients with an even patient_id have insurance. 
--    Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
--    Add up the admission_total cost for each has_insurance group.

SELECT 
	CASE 
		WHEN mod(patient_id,2) =0 THEN 'Yes'
		ELSE 'No'
	END as Insured,
	sum( CASE 
			WHEN mod(patient_id,2) =0 THEN 10
			ELSE 50
		 END) AS cost

FROM admissions
GROUP BY Insured;


-- 6. Show the provinces that has more patients identified as 'M' than 'F'. 
--    Must only show full province_name.

SELECT province_name
FROM  (
SELECT 
	province_name, sum(gender= 'M') AS male, sum(gender = 'F') AS female
    FROM patients pat
    
JOIN province_names pro
	ON pro.province_id = pat.province_id
GROUP BY province_name
) as inner_query
WHERE male>female
;

