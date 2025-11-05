CREATE DATABASE PharmaAnalysis;
use PharmaAnalysis;
SET SQL_SAFE_UPDATES = 0;
create table Doctors(
    physID int primary key,
    name varchar(100),
    address varchar(200),
    phone varchar(20)
);

create table Patients(
     firstname varchar(50),
     lastname varchar(50),
     birthdate date,
     address varchar(100),
     phone varchar(20),
     gender varchar(10),
     insurance varchar(50),
     patientID int primary key);

Create table Suppliers(
    name varchar(100),
    address varchar(200),
    phone varchar(20),
    supID int Primary key
);

create table Drugs(
    brandName varchar(50),
    genericName varchar(50),
    NDC int primary key,
    dosage int,
    expDate date,
	supID int,
    purchasePrice decimal(10,2),
    sellPrice decimal(10,2),
    foreign key (supID) references suppliers(supID)
);

create table Insurance(
     name varchar(50) primary key,
     phone varchar(20),
     coPay varchar(3)
);

create table Prescriptions(
     patientID int,
     physID int,
     NDC INT,
     qty INT,
     days INT,
     refills INT,
     status VARCHAR(20),
     foreign key (patientID) references Patients(patientID),
     foreign key (physID) references Doctors(physID),
     foreign key (NDC) references Drugs(NDC)
);

show tables;
select* from patients;
select* from Drugs;
select* from suppliers;
select* from prescriptions;
select* from Doctors;
-- Exploratory Data analysis 
-- Add indexes 
ALTER TABLE Prescriptions ADD INDEX idx_NDC (NDC);
ALTER TABLE Prescriptions ADD INDEX idx_patientID (patientID);
SELECT * FROM prescriptions;
-- HANDLING MISSING VALUES
UPDATE patients SET gender="Unknown"
WHERE gender='' OR gender IS NULL;
UPDATE patients SET insurance="Unknown"
WHERE insurance='';
SELECT * FROM patients;

SELECT 'Doctors' AS TABLE_NAME,COUNT(*) AS ROW_COUNT FROM Doctors
UNION ALL 
SELECT 'Patients',COUNT(*) FROM patients
UNION ALL 
SELECT 'Suppliers',COUNT(*)  FROM Suppliers
UNION ALL 
SELECT 'Drugs',COUNT(*)  FROM Drugs
UNION ALL 
SELECT 'Insurance',COUNT(*)  FROM Insurance
UNION ALL
SELECT 'Prescriptions',COUNT(*)  FROM Prescriptions;

-- Preview Data
DESCRIBE Drugs;
DESCRIBE patients;

-- check for duplicates
SELECT NDC,COUNT(*)
FROM drugs 
GROUP BY NDC 
HAVING COUNT(*)>1;

-- CHECKING FOR MISSING CRIYTICAL VALUE
SELECT brandName,NDC
FROM drugs
WHERE NDC IS NULL OR brandName IS NULL;

-- check for the pricing
SELECT NDC,sellPrice,purchasePrice
FROM drugs
WHERE sellPrice<=0 OR sellPrice<purchasePrice;

-- CHECK FOR EXPIRY
SELECT NDC,expDate
FROM drugs
WHERE expDate<current_date();

ALTER TABLE patients
ADD COLUMN age INT;
UPDATE patients
SET age=timestampdiff(YEAR,birthdate,CURDATE());
DESCRIBE patients;
SELECT * FROM patients;


-- View Creation for Simplified Querying
CREATE VIEW PrescriptionDetails AS
SELECT
  pr.patientID, pr.physID, pr.NDC, pr.qty, pr.days, pr.refills, pr.status,
  d.brandName, d.genericName, d.dosage, d.expDate, d.purchasePrice, d.sellPrice,
  pat.firstName, pat.lastName, pat.age, pat.gender, pat.insurance,
  doc.name AS doctorName, sup.name AS supplierName
FROM Prescriptions pr
JOIN drugs d ON pr.NDC=d.NDC
JOIN patients pat ON pr.patientID = pat.patientID
JOIN doctors doc ON pr.physID = doc.physID
JOIN Suppliers sup ON d.supID = sup.supID;

SELECT * FROM PrescriptionDetails;

-- Q1: calculating the total revenue and profit
SELECT
   status,
   SUM(qty*sellPrice) AS Total_revenue,
   SUM(qty*(sellPrice - purchasePrice)) AS Total_Profit
FROM PrescriptionDetails
WHERE status IN ('Filled','picked up')
GROUP BY status;
   
-- Q2: Expired Drugs as of november 03, 2025, and Potential Loss
SELECT 
  brandName, genericName,dosage,
  SUM(qty) As total_units_prescribed,
  ROUND(AVG(purchasePrice),2) AS avg_purchase_price,
  ROUND(AVG(qty*purchasePrice),2) AS potential_loss,
  COUNT(DISTINCT patientID) AS effected_patients
FROM PrescriptionDetails
WHERE expDate < CURRENT_DATE()
GROUP BY brandName,genericName, dosage
ORDER BY potential_loss DESC;

-- Q3: TOP PRESCRIBING DOCTORS BY TOTAL COST AND REVENUE
SELECT doctorName,
   COUNT(*) AS prescription_count,
   SUM(qty * sellPrice) AS total_revenue
FROM PrescriptionDetails
GROUP BY doctorName
ORDER BY total_revenue DESC;

-- Q4: Patient Demographics by Insurance and Status
SELECT insurance, gender,
    ROUND(AVG(age),2) AS average_age,
	COUNT(*) AS patient_count
FROM PrescriptionDetails
GROUP BY insurance, gender;

-- Q5: Suppliers by Drug Count and Average Profit Margin
SELECT supplierName,
     COUNT(*) AS drug_count,
     COUNT(DISTINCT NDC) AS unique_drugs, 
     ROUND(AVG((sellPrice - purchasePrice)/purchasePrice * 100),2) AS avg_profit_margin_percent,
     ROUND(AVG(sellPrice * qty),2) AS total_revenue,
     SUM((sellPrice - purchasePrice) * qty) AS total_profit_margin
FROM PrescriptionDetails
GROUP BY  supplierName;

-- Q6: Refill Rate by Drug and Patient Age Group
SELECT
	genericName,
    CASE 
		WHEN age<18 THEN 'Pediatric'
        WHEN age BETWEEN 18 AND 40 THEN 'Adult'
        ELSE 'Senior'
	END AS age_groups,
COUNT(*) AS prescription_count,
ROUND(AVG(refills),2) AS avg_refills,
SUM(refills) AS total_refills,
COUNT(DISTINCT patientID) AS unique_patients
FROM PrescriptionDetails
WHERE refills>0
GROUP BY genericName, age_groups
ORDER BY avg_refills DESC, prescription_count;

-- Q7: Prescriptions Pending vs. Filled by Doctor
SELECT doctorName,
	COUNT(*) AS total_prescriptions,
    SUM(CASE WHEN status = 'fiLled' THEN 1 ELSE 0 END) AS filled_count,
    SUM(CASE WHEN status = 'picked up' THEN 1 ELSE 0 END) AS picked_up_count,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending_count
FROM PrescriptionDetails
GROUP BY doctorName
ORDER BY total_prescriptions DESC;

-- Q8: Drugs with Highest Markup and Prescription Frequency
SELECT 
	brandName,
	genericName,
	ROUND(sellPrice - purchasePrice, 2) AS profit_per_unit,
	COUNT(*) AS times_prescribed,
CASE
	WHEN (sellPrice - purchasePrice) >5 THEN 'High Profit'
	WHEN (sellPrice - purchasePrice) >2 THEN 'Medium Profit'
	ELSE 'Low Profit'
END AS 'Profit Category'
FROM PrescriptionDetails
GROUP BY brandName, genericName,sellPrice, purchasePrice
ORDER BY profit_per_unit DESC;

-- Q9: Most Common Drugs by Generic Name
SELECT
	brandName AS Brand_Name,
    genericName AS Generic_Name,
    COUNT(*) AS prescription_count
FROM PrescriptionDetails
GROUP BY Generic_Name, Brand_Name
ORDER BY prescription_count DESC;

-- Q10: High-Value Patients & Their Drug Patterns
SELECT
	CONCAT(firstName,' ',lastName) AS patient_Name,
    age,
    insurance,
    COUNT(*) AS total_prescriptions,
    SUM(refills) AS total_refills_authorized,
    ROUND(SUM(sellPrice * qty),2) AS total_revenue,
    ROUND(AVG(refills),2) AS avg_refill_rate,
    GROUP_CONCAT(DISTINCT genericName) AS medication_used
FROM PrescriptionDetails
GROUP BY patientID,patient_name,age,insurance
HAVING total_prescriptions >= 2
ORDER BY total_revenue DESC;


