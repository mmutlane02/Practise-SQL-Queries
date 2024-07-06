
-- 1.	Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS `Year`
FROM patients
ORDER BY `year` ASC;


-- 2.	Show unique first names from the patients table which only occurs once in the list.
--  For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list.
--  If only 1 person is named 'Leo' then include them in the output.
SELECT first_name
FROM patients
GROUP  BY  first_name
HAVING COUNT(first_name) = 1;


-- 3.	Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE's____%s';


-- 4.	Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'.
--  Primary diagnosis is stored in the admissions table.
SELECT admissions.patient_id, patients.first_name, patients.last_name
FROM admissions, patients
WHERE diagnosis = 'Dementia'
AND admissions.patient_id = patients.patient_id;


SELECT pat.patient_id, first_name, last_name
FROM admissions AS adm
INNER JOIN patients AS pat
	ON pat.patient_id = adm.patient_id
WHERE diagnosis = 'Dementia';


-- 5.	Display every patient's first_name. Order the list by the length of each name and then by alphabetically.
SELECT first_name
FROM patients
ORDER BY length(first_name), first_name ASC;


-- 6.	Show the total amount of male patients and the total amount of female patients in the patients table.
--  Display the two results in the same row.
SELECT (
		SELECT COUNT(gender)
		FROM patients
		WHERE gender = 'M') AS Male,
COUNT(gender) AS Female
FROM patients
WHERE gender = 'F';


-- 7.	Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
--  Show results ordered ascending by allergies then by first_name then by last_name.
SELECT CONCAT(first_name, ' ', last_name) AS full_name, allergies
FROM patients
WHERE allergies = 'Penicillin'
OR    allergies = 'Morphine'
ORDER BY allergies ASC, first_name, last_name;


-- 8.	Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT patient_id, COUNT(*) AS number_of_admissions, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;


-- 9.	Show the city and the total number of patients in the city.
--  Order from most to least patients and then by city name ascending.
SELECT city, COUNT(*) AS number_of_patients
FROM patients
GROUP BY city
ORDER BY number_of_patients DESC, city ASC;


-- 10.	Show first name, last name and role of every person that is either patient or doctor.
--  The roles are either "Patient" or "Doctor”.
SELECT first_name, last_name, 'Patient' AS `role`
FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS `role`
FROM doctors
GROUP BY first_name, last_name, `role`
ORDER BY first_name, last_name
;

-- 11.	Show all allergies ordered by popularity. Remove NULL values from query.
SELECT allergies, COUNT(*) AS people_affected
FROM patients
WHERE allergies <> ''
GROUP BY allergies
ORDER BY people_affected DESC;


-- 12.	Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
--  Sort the list starting from the earliest birth_date.
SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date LIKE '197%'
ORDER BY birth_date ASC;


-- 13.	We want to display each patient's full name in a single column.
--  Their last_name in all upper letters must appear first, then first_name in all lower-case letters.
--  Separate the last_name and first_name with a comma.
--  Order the list by the first_name in descending order EX: SMITH, Jane

SELECT CONCAT(UPPER(last_name),', ', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;


-- 14.	Show the province_id(s), sum of height, where the total sum of its patient's height is greater than or equal to 7,000.
SELECT province_id, SUM(height)
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;


-- 15.	Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni’.
SELECT MAX(weight), MIN(weight), MAX(weight) - MIN(weight) AS difference
FROM patients
WHERE last_name = 'Maroni';


-- 16.	Show all the days of the month (1-31) and how many admission_dates occurred on that day.
--      Sort by the day with most admissions to least admissions.
SELECT DAYOFMONTH(admission_date) AS day_number, COUNT(DAYOFMONTH(admission_date)) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;


-- 17.	Show all columns for patient_id 542's most recent admission_date.
SELECT *
FROM admissions
WHERE patient_id = '542'
ORDER BY admission_date DESC
LIMIT 1;


-- 18.	Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
	-- a) patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE MOD(patient_id, 2) != 0
AND	  attending_doctor_id IN (1, 5, 19);

	-- b) attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE attending_doctor_id LIKE "%2%"
AND LENGTH(patient_id) =3;


-- 19.	Show first_name, last_name, and the total number of admissions attended for each doctor.
--  Every admission has been attended by a doctor.
SELECT first_name, last_name, count(adm.admission_date) AS admissions_attended
FROM doctors AS doc
INNER JOIN admissions AS adm
	ON doc.doctor_id = adm.attending_doctor_id
GROUP BY first_name, last_name
;

-- 20.	For each doctor, display their id, full name, and the first and last admission date they attended.
SELECT CONCAT(first_name, " ", last_name) AS full_name,
		min(adm.admission_date) AS first_admission,
        max(adm.admission_date) AS last_admission
FROM doctors AS doc
JOIN admissions AS adm
	ON doc.doctor_id = adm.attending_doctor_id
    GROUP BY full_name;


-- 21.	Display the total amount of patients for each province. Order by descending.
SELECT province_name, count(patient_id) AS number_of_patients
FROM patients, province_names
WHERE patients.province_id = province_names.province_id
GROUP BY province_name
ORDER BY number_of_patients DESC;


-- 22.	For every admission, display the patient's full name, their admission diagnosis,
-- and their doctor's full name who diagnosed their problem.
SELECT concat(pat.first_name, " ", pat.last_name) AS patient_name, 
		adm.diagnosis,
        concat(doc.first_name, " ", doc.Last_name) AS doctor_name
FROM  patients AS pat
INNER JOIN admissions AS adm
	ON pat.patient_id = adm.patient_id
INNER JOIN doctors AS doc
	ON adm.attending_doctor_id = doc.doctor_id
;

-- 23.	display the first name, last name and number of duplicate patients based on their first name and last name.
--  Ex: A patient with an identical name can be considered a duplicate.
SELECT concat(first_name, ' ', last_name) full_name, count(*) duplicate_name
FROM patients
GROUP BY first_name, last_name
order by count(*) desc
;

