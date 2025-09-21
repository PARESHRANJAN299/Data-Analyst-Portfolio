CREATE DATABASE CAR
USE CAR;

SELECT c. [Car_ID]
      ,[Brand]
      ,[Model]
      ,[Year]
      ,[Fuel_Type]
      ,[Transmission]
      ,[Color]
      ,[Owner_Type]
      ,[Mileage_kmpl]
      ,[Price_Lakh]
      ,[Provider]
      ,[Policy_Number]
      ,[Expiry_Date]
      ,[Status]
      ,[Owner_Name]
      ,[Contact]
      ,[City]
      ,[Purchase_Year]
      ,[Sale_Price_Lakh]
      ,[Sale_Date]
      ,[Buyer_Name]
      ,[Service_Type]
      ,[Service_Date]
      ,[Service_Cost]
      ,[Service_Center] INTO MASTER_CAR_DATA
     from Car c
LEFT JOIN Insurance i 
ON c.Car_ID = i.Car_ID
LEFT JOIN Owners o
ON o.Car_ID = c.Car_ID
LEFT JOIN Sales s
ON s.Car_ID = c.Car_ID
LEFT JOIN ServiceHistory sh
ON sh.Car_ID = c.Car_ID;


SELECT * FROM MASTER_CAR_DATA; 

/*To add one more useful column (for both present use and future analysis), I’d suggest:
Recommended Column
👉 Car_Status (or Current_Status)

Values could be:
"Active" → if the car is still with the owner
"Sold" → if it has a sale date and buyer
"Scrapped" or "Expired Insurance" → if policy expired and not renewed
"In Service" → if undergoing service */

ALTER TABLE MASTER_CAR_DATA
ADD Car_Status VARCHAR(50);

UPDATE MASTER_CAR_DATA
SET Car_Status = 
    CASE 
        WHEN Sale_Date IS NOT NULL THEN 'Sold'
        WHEN Expiry_Date < GETDATE() THEN 'Expired Insurance'
        WHEN Service_Date IS NOT NULL 
             AND Service_Date >= DATEADD(DAY, -30, GETDATE()) THEN 'In Service'
        ELSE 'Active'
    END;

ALTER TABLE MASTER_CAR_DATA
ADD Car_Age INT;

UPDATE MASTER_CAR_DATA
SET Car_Age = YEAR(GETDATE()) - [Year];

select * from MASTER_CAR_DATA