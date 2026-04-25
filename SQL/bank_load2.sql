
DROP DATABASE IF EXISTS loan_bank2;
GO


CREATE DATABASE loan_bank2;
USE loan_bank2;



-- Drop tables if they exist (order due to FK dependencies)
IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions;
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;


-- Customers Table
CREATE TABLE Customers (
    CustomerID     INT PRIMARY KEY,
    Name           NVARCHAR(100),
    Gender         VARCHAR(10) NULL,
    DateOfBirth    VARCHAR(20),          -- to allow mixed formats
    Address        NVARCHAR(200) NULL,
    Email          NVARCHAR(100) NULL,
    Phone          VARCHAR(20),
    AccountID      INT                   -- Not a true FK: dirty data test
);

-- Accounts Table
CREATE TABLE Accounts (
    AccountID   INT PRIMARY KEY,
    CustomerID  INT,                     -- Not a strict FK: allow mismatches
    Type        NVARCHAR(20),
    OpenDate    VARCHAR(20),             -- for mixed formats
    Balance     DECIMAL(18,2)
);


-- Transactions Table
CREATE TABLE Transactions (
    TransactionID    INT,
    AccountID        INT,                -- Can be mismatched for demo
    TransactionDate  VARCHAR(20),        -- Allow mixed formats
    Type             VARCHAR(20),
    Amount           DECIMAL(18,2),
    Description      NVARCHAR(200) NULL,
    Currency         VARCHAR(10),

      -- Not enforcing PJ to allow duplicates
      );
 
 -- I will no create a unique index on TransactionID + AccountID for allow duplicates and clean after.

 -------------------------------------

 INSERT INTO Customers (CustomerID, Name, Gender, DateOfBirth, Address, Email, Phone, AccountID) VALUES
(1, 'Ajay Sharma', 'M', '1980-11-04', '123 Main St', NULL, '9891000001', 101),
(2, 'priya singh', NULL, '21-07-1975', '22B Park Road', 'priya@sample.com', '9891000002', 102),
(3, 'Sarah Khan', 'F', '1989/02/20', '', 'sarahkhan@email.com', '9891000003', 103),
(4, 'Mark Lee', 'M', '1995-05-14', '456 North Rd', 'markl@email.com', '9891000004', 104),
(5, 'NAdea KUmar', 'F', '04-12-1982', NULL, NULL, '9891000005', 105);


-- Accounts (outlier balances, inconsistent type case, mixed date formats, invalid CustomerID)
INSERT INTO Accounts (AccountID, CustomerID, Type, OpenDate, Balance) VALUES
(101, 1, 'SAVINGS',    '03/14/2013',      10000.00),
(102, 2, 'current',    '2011-06-20',    -157874.40),
(103, 3, 'Savings',    '2019/11/02',      0.00),
(104, 4, 'CURRENT',    '21-07-2018',        50.00),
(105, 99, 'Savings',   '07-05-2016',       14.75);      -- CustomerID 99 doesn't exist


-------------------------------------------

-- Example: Generate 10,000 synthetic transactions with data issues
;WITH NumberedRows AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM
        sys.all_objects a
        CROSS JOIN sys.all_columns c
)
INSERT INTO Transactions (
    TransactionID, AccountID, TransactionDate, Type, Amount, Description, Currency
)
SELECT
    100000 + rn AS TransactionID,
    -- Some non-matching AccountIDs for referential issues
    CASE WHEN rn % 20 = 0 THEN 9999 ELSE 101 + (rn % 100) END AS AccountID,
    -- Mixed date formats
    CASE 
        WHEN rn % 3 = 0 THEN FORMAT(GETDATE() - (rn % 365), 'yyyy/MM/dd')
        ELSE CONVERT(VARCHAR(10), GETDATE() - (rn % 365), 105)
    END AS TransactionDate,
    -- Inconsistent Type capitalization
    CASE WHEN rn % 2 = 0 THEN 'Credit' ELSE 'DEBIT' END AS Type,
    -- Amount with negatives and outliers
    CASE 
        WHEN rn % 1000 = 0 THEN -99999.99       -- negative outlier
        WHEN rn % 250 = 0 THEN 1000000.99       -- positive outlier
        ELSE (ABS(CHECKSUM(NEWID())) % 5000) *
             CASE WHEN rn % 2 = 0 THEN 1 ELSE -1 END 
    END AS Amount,
    -- NULLs for descriptions, inconsistent case
    CASE 
        WHEN rn % 50 = 0 THEN NULL
        ELSE CASE WHEN rn % 2 = 0 THEN 'payment' ELSE 'Salary Credit' END
    END AS Description,
    -- Mixed currency cases
    CASE 
        WHEN rn % 3 = 0 THEN 'usd'
        WHEN rn % 5 = 0 THEN 'INR'
        ELSE 'USD'
    END AS Currency
FROM NumberedRows
WHERE rn <= 10000;

---overview Transactions how look
select * from customers

----------------------/////////-------------//////////////--------------

---- first I'm going to add more data because just have 5 account ID and 5 cusotmerID,and I want more customers and accounts  
---- everthing would be RawData because , I'm going to clean everthing 

----add 1000 customer (RawData)

;WITH Numbers AS (
    SELECT TOP 1000 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),
MaxID AS (
    SELECT ISNULL(MAX(CustomerID), 0) AS max_id
    FROM Customers
)

INSERT INTO Customers (
    CustomerID, Name, Gender, DateOfBirth, Address, Email, Phone, AccountID
)
SELECT
    n + max_id AS CustomerID,

    CONCAT(
        CASE WHEN n % 2 = 0 THEN 'Juan' ELSE 'Maria' END,
        ' ',
        CASE WHEN n % 3 = 0 THEN 'Lopez' ELSE 'Garcia' END
    ) AS Name,

    CASE 
        WHEN n % 5 = 0 THEN NULL
        WHEN n % 2 = 0 THEN 'M'
        ELSE 'F'
    END AS Gender,

    CASE 
        WHEN n % 3 = 0 THEN FORMAT(DATEADD(YEAR, -20 - (n % 40), GETDATE()), 'yyyy/MM/dd')
        WHEN n % 3 = 1 THEN FORMAT(DATEADD(YEAR, -20 - (n % 40), GETDATE()), 'dd-MM-yyyy')
        ELSE FORMAT(DATEADD(YEAR, -20 - (n % 40), GETDATE()), 'MM/dd/yyyy')
    END AS DateOfBirth,

    CASE 
        WHEN n % 7 = 0 THEN NULL
        WHEN n % 6 = 0 THEN ''
        ELSE CONCAT('Street ', n)
    END AS Address,

    CASE 
        WHEN n % 10 = 0 THEN NULL
        ELSE CONCAT('user', n, '@mail.com')
    END AS Email,

    CONCAT('55', RIGHT('00000000' + CAST(n AS VARCHAR), 8)) AS Phone,

    CASE 
        WHEN n % 20 = 0 THEN 9999
        ELSE n
    END AS AccountID

FROM Numbers
CROSS JOIN MaxID;

---- now we are going to add more RawData for the table " Account" 


;WITH Numbers AS (
    SELECT TOP 1000 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),

MaxID AS (
    SELECT ISNULL(MAX(AccountID), 0) AS max_id
    FROM Accounts
)

INSERT INTO Accounts (
    AccountID, CustomerID, Type, OpenDate, Balance
)
SELECT
    n + max_id AS AccountID,

    -- Some invalid CustomerIDs
    CASE 
        WHEN n % 25 = 0 THEN 9999
        ELSE n
    END AS CustomerID,

    -- Inconsistent type
    CASE 
        WHEN n % 3 = 0 THEN 'SAVINGS'
        WHEN n % 3 = 1 THEN 'current'
        ELSE 'Savings'
    END AS Type,

    -- Mixed date formats
    CASE 
        WHEN n % 3 = 0 THEN FORMAT(GETDATE() - (n % 1000), 'yyyy/MM/dd')
        WHEN n % 3 = 1 THEN FORMAT(GETDATE() - (n % 1000), 'dd-MM-yyyy')
        ELSE FORMAT(GETDATE() - (n % 1000), 'MM/dd/yyyy')
    END AS OpenDate,

    -- Balance with anomalies
    CASE 
        WHEN n % 100 = 0 THEN -50000   -- negative
        WHEN n % 200 = 0 THEN 1000000  -- outlier
        ELSE (ABS(CHECKSUM(NEWID())) % 10000)
    END AS Balance
    
FROM Numbers
CROSS JOIN MaxID;

----------------------------------------/////////////////-------////////
--Phase Clean Data Table per Table 
--First Account Column

SELECT 
    AccountID,
    CustomerID,

    --1.Clean Type
    UPPER (Type) AS Type,
    
    --2 Clean Date 
    
    COALESCE(
    TRY_CONVERT (date, OpenDate, 101), --MM/DD/YYYY
    TRY_CONVERT (date, OpenDate, 103), --DD/MM/YYYY
    TRY_CONVERT (date, OpenDate,111), -- YYYY/MM/DD
    TRY_CONVERT (date,Opendate, 23)   -- YYYY-MM-DD
) AS OpenDate_Clean,

---3. Balance (Keep Original)
    Balance

    INTO accounts_Clean
    FROM Accounts;

    -----Validate data (I will found problems)
    Select * FROM accounts_Clean a
    LEFT JOIN Customers c
            ON a.CustomerID = c.CustomerID
    WHERE c.CustomerID IS NULL; 

    ----Check bates
    select * from accounts_Clean
    where OpenDate_Clean IS NULL; 

    --Negative balance (debt/risk)
    select * FROM  accounts_Clean
    where Balance < 0;

    -- I'm going to do a bussiness logic for check and make a BalanceCategory
    SELECT
    *,
    CASE 
        WHEN Balance < 0 THEN 'Debt'
        WHEN Balance BETWEEN 0 AND 1000 THEN 'Low'
        WHEN Balance BETWEEN 1000 AND 10000 THEN 'Medium'
        ELSE 'High'
    END AS BalanceCategory
FROM Accounts_Clean;


   ----I'm going to add risk flag for a better visualization and analysis 

   SELECT *, 
    CASE 
        WHEN balance < 0 THEN 'Debt'
        when balance BETWEEN 0 AND 1000 then 'Low Risk'
        when balance between 1000 AND 10000 then 'Medium Risk'
        ELSE 'High'
        end as BalanceCategory 
        from accounts_Clean;

-------Finnaly I'm goin go clean the table 

SELECT
    a.AccountID,
    a.CustomerID,
    UPPER(a.Type) AS Type,

    COALESCE(
        TRY_CONVERT(date, a.OpenDate, 101),
        TRY_CONVERT(date, a.OpenDate, 103),
        TRY_CONVERT(date, a.OpenDate, 111),
        TRY_CONVERT(date, a.OpenDate, 23)
    ) AS OpenDate_Clean,

    a.Balance,

    CASE 
        WHEN a.Balance < 0 THEN 'High Risk'
        WHEN a.Balance > 500000 THEN 'Outlier'
        ELSE 'Normal'
    END AS RiskFlag

INTO Accounts_Final

FROM Accounts a;

select * from accounts_Clean

----I cleaned the Accounts table by standardizing text fields, converting inconsistent date formats into a DATE type, validating customer relationships, and applying business rules to classify account risk.

------------///////------------//////////------------

--CLEAN Customers Table , first, I'm goin go create Customer_Clean 

SELECT
    CustomerID,

    -- 1. Clean Name
    UPPER(Name) AS Name,

    -- 2. Clean Gender
    CASE 
        WHEN Gender IN ('M','F') THEN Gender
        ELSE 'Unknown'
    END AS Gender,

    -- 3. Clean Date of Birth
    COALESCE(
        TRY_CONVERT(date, DateOfBirth, 101),
        TRY_CONVERT(date, DateOfBirth, 103),
        TRY_CONVERT(date, DateOfBirth, 111),
        TRY_CONVERT(date, DateOfBirth, 23)
    ) AS DateOfBirth_Clean,

    -- 4. Clean Address
    case 
        WHEN Address IS NULL OR Address = '' THEN 'Unknown'
        ELSE Address
    END AS Address,

    -- 5. Clean Email
    CASE 
        WHEN Email IS NULL OR Email NOT LIKE '%@%.%' 
            THEN 'noemail@unknown.com'
        ELSE Email
    END AS Email,

    -- 6. Phone (keep as is)
    Phone,

    -- 7. AccountID (we validate later)
    AccountID

INTO Customers_Clean
FROM Customers;


----second step , I'm going to validate data , fist found customers with invalid account 

SELECT *
FROM Customers_Clean c
LEFT JOIN Accounts_Clean a
    ON c.AccountID = a.AccountID
WHERE a.AccountID IS NULL;


-- Invalid dates 
SELECT *
FROM Customers_Clean
WHERE DateOfBirth_Clean IS NULL;

--fake emails
SELECT *
FROM Customers_Clean
WHERE Email = 'noemail@unknown.com';

--customer age 
SELECT
    *,
    DATEDIFF(YEAR, DateOfBirth_Clean, GETDATE()) AS Age
FROM Customers_Clean;

--customer segmentation
SELECT
    *,
    DATEDIFF(YEAR, DateOfBirth_Clean, GETDATE()) AS Age
FROM Customers_Clean;


----final version for clean all "Customers" tables 

SELECT
    CustomerID,
    UPPER(Name) AS Name,

    CASE 
        WHEN Gender IN ('M','F') THEN Gender
        ELSE 'Unknown'
    END AS Gender,

    COALESCE(
        TRY_CONVERT(date, DateOfBirth, 101),
        TRY_CONVERT(date, DateOfBirth, 103),
        TRY_CONVERT(date, DateOfBirth, 111),
        TRY_CONVERT(date, DateOfBirth, 23)
    ) AS DateOfBirth_Clean,

    CASE 
        WHEN Address IS NULL OR Address = '' THEN 'Unknown'
        ELSE Address
    END AS Address,

    CASE 
        WHEN Email IS NULL OR Email NOT LIKE '%@%.%' 
            THEN 'noemail@unknown.com'
        ELSE Email
    END AS Email,

    Phone,
    AccountID,

    -- Business logic
    DATEDIFF(YEAR,
        COALESCE(
            TRY_CONVERT(date, DateOfBirth, 101),
            TRY_CONVERT(date, DateOfBirth, 103),
            TRY_CONVERT(date, DateOfBirth, 111),
            TRY_CONVERT(date, DateOfBirth, 23)
        ),
        GETDATE()
    ) AS Age

INTO Customers_Final
FROM Customers;

--verification of Customer Table 
select * from Customers_Clean

-- a explanation : I cleaned customer data by standardizing names, handling null values, validating emails, converting date formats, and deriving customer age for segmentation.

-----------------//////////////--------
--clean transactions table,first create "Transaction_Clean"

SELECT
    TransactionID,
    AccountID,

    -- 1. Clean Type
    UPPER(Type) AS Type,

    -- 2. Clean Date
    COALESCE(
        TRY_CONVERT(date, TransactionDate, 101),
        TRY_CONVERT(date, TransactionDate, 103),
        TRY_CONVERT(date, TransactionDate, 111),
        TRY_CONVERT(date, TransactionDate, 23)
    ) AS TransactionDate_Clean,

    -- 3. Clean Amount (keep as is)
    Amount,

    -- 4. Clean Description
    CASE 
        WHEN Description IS NULL THEN 'No Description'
        ELSE Description
    END AS Description,

    -- 5. Clean Currency
    UPPER(Currency) AS Currency

INTO Transactions_Clean
FROM Transactions;

--------- remove duplicates (for have just 1 transaction per ID)
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY TransactionID, AccountID
               ORDER BY TransactionDate_Clean
           ) AS rn
    FROM Transactions_Clean
)
SELECT *
INTO Transactions_NoDuplicates
FROM CTE
WHERE rn = 1;

---validation data (transactions with no valid account first )

SELECT *
FROM Transactions_NoDuplicates t
LEFT JOIN Accounts_Clean a
    ON t.AccountID = a.AccountID
WHERE a.AccountID IS NULL;


---check if are possible fraud or errors 
SELECT *
FROM Transactions_NoDuplicates
WHERE Amount > 500000 
   OR Amount < -50000;

   --check if are null or bad dates 
   SELECT *
FROM Transactions_NoDuplicates
WHERE TransactionDate_Clean IS NULL;

--I'm going to do a bussiness logic (if is debit or credit )
SELECT
    *,
    CASE 
        WHEN Type = 'DEBIT' THEN 'Money Out'
        WHEN Type = 'CREDIT' THEN 'Money In'
        ELSE 'Unknown'
    END AS TransactionFlow
FROM Transactions_NoDuplicates;

-- I'm going to check if are risks detections 
SELECT
    *,
    CASE 
        WHEN Type = 'DEBIT' THEN 'Money Out'
        WHEN Type = 'CREDIT' THEN 'Money In'
        ELSE 'Unknown'
    END AS TransactionFlow
FROM Transactions_NoDuplicates;

--- final Transactions Table Clean 
SELECT
    t.TransactionID,
    t.AccountID,
    UPPER(t.Type) AS Type,

    COALESCE(
        TRY_CONVERT(date, t.TransactionDate, 101),
        TRY_CONVERT(date, t.TransactionDate, 103),
        TRY_CONVERT(date, t.TransactionDate, 111),
        TRY_CONVERT(date, t.TransactionDate, 23)
    ) AS TransactionDate_Clean,

    t.Amount,

    CASE 
        WHEN t.Description IS NULL THEN 'No Description'
        ELSE t.Description
    END AS Description,

    UPPER(t.Currency) AS Currency,

    CASE 
        WHEN t.Amount < -50000 THEN 'High Risk'
        WHEN t.Amount > 500000 THEN 'Outlier'
        ELSE 'Normal'
    END AS RiskFlag

INTO Transactions_Final

FROM Transactions t;

-- verification of Transactions Table 
select * from Transactions_Clean


-- Explanation: "I cleaned transaction data by standardizing formats, removing duplicates using window functions, validating account relationships, and applying business rules to detect anomalies and risk."

-------***/////***////join tables ready for use for Power Bi 

use loan_bank2

DROP TABLE IF EXISTS Bank_Final;

SELECT
    -- Accounts
    a.AccountID,
    a.CustomerID,
    a.[Type] AS AccountType,   -- usar corchetes (importante)
    a.OpenDate_Clean,
    a.Balance,

    -- Customers
    c.Name,
    c.Gender,
    c.DateOfBirth_Clean,
    c.Email,
    c.Phone,
    c.Address,

    -- Transactions
    t.TransactionID,
    t.AccountID AS Transaction_AccountID,
    t.[Type] AS TransactionType,
    t.TransactionDate_Clean,
    t.Amount,
    t.Currency,
    t.Description

INTO Bank_Final

FROM Accounts_Clean a
LEFT JOIN Customers_Clean c
    ON a.CustomerID = c.CustomerID
LEFT JOIN Transactions_Clean t
    ON a.AccountID = t.AccountID;
    
