#Q1: Total Credit Amount
use project1;

SELECT SUM(Amount) AS total_credit_amount 
FROM debit_credit
WHERE LOWER(`Transaction Type`) = 'credit';

#Q2: Total Debit Amount
SELECT SUM(Amount) AS total_debit_amount 
FROM debit_credit
WHERE LOWER(`Transaction Type`) = 'debit';

#Q3: Credit to Debit Ratio
SELECT 
    SUM(CASE WHEN LOWER(`Transaction Type`) = 'credit' THEN Amount ELSE 0 END) / 
    SUM(CASE WHEN LOWER(`Transaction Type`) = 'debit' THEN Amount ELSE 0 END) AS 'Credit to Debit Ratio' 
FROM debit_credit;

#Q4: Net Transaction Amount
SELECT 
    SUM(CASE WHEN LOWER(`Transaction Type`) = 'credit' THEN Amount ELSE 0 END) - 
    SUM(CASE WHEN LOWER(`Transaction Type`) = 'debit' THEN Amount ELSE 0 END) AS 'Net Transaction Amount' 
FROM debit_credit;

#Q5: Account Activity Ratio
SELECT 
    `Account Number`, 
    (COUNT(*) / Balance) AS account_activity_ratio 
FROM debit_credit 
GROUP BY `Account Number`, Balance;

#Q6: Transactions per Day/Week/Month
SELECT 
    `Transaction year`, 
    `Transaction Month`, 
    COUNT(*) AS total_transactions
FROM debit_credit
GROUP BY `Transaction year`, `Transaction Month`
ORDER BY `Transaction year` DESC, STR_TO_DATE(`Transaction Month`, '%M') ASC;

#Q7: Total Transaction Amount by Branch
SELECT 
    Branch, 
    SUM(Amount) AS total_transaction_amount
FROM debit_credit
GROUP BY Branch
ORDER BY total_transaction_amount DESC;

#Q8: Transaction Volume by Bank
SELECT 
    `Bank Name`, 
    SUM(Amount) AS total_transaction_volume
FROM debit_credit
GROUP BY `Bank Name`;

#Q9: Transaction Method Distribution
SELECT 
    `Transaction Type`, 
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM debit_credit), 2) AS percentage_distribution
FROM debit_credit
GROUP BY `Transaction Type`;

#Q10: Branch Transaction Growth (Month-over-Month)
SELECT 
    Branch,
    `Transaction Month`,
    SUM(Amount) AS monthly_total,
    LAG(SUM(Amount)) OVER (PARTITION BY Branch ORDER BY STR_TO_DATE(`Transaction Month`, '%M')) AS previous_month_total,
    ROUND(
        (SUM(Amount) - LAG(SUM(Amount)) OVER (PARTITION BY Branch ORDER BY STR_TO_DATE(`Transaction Month`, '%M'))) / 
        LAG(SUM(Amount)) OVER (PARTITION BY Branch ORDER BY STR_TO_DATE(`Transaction Month`, '%M')) * 100, 
    2) AS monthly_growth_percentage
FROM debit_credit
GROUP BY Branch, `Transaction Month`
ORDER BY Branch, STR_TO_DATE(`Transaction Month`, '%M');

#Q11: High-Risk Transaction Flag
SELECT DISTINCT `High Risk` FROM debit_credit;
SELECT 
    `Account Number`,
    `Amount`,
    `Branch`,
    `Transaction Date`,
    `High Risk` AS 'Status'
FROM 
    debit_credit
WHERE 
    `High Risk` = 'High Risk' 
    OR `High Risk` = 'Normal';
    

#Q12: Suspicious Transaction Frequency
SELECT 
    `High Risk` AS Status,
    `Transaction Month`, 
    `Transaction year`,
    COUNT(*) AS suspicious_count
FROM 
    debit_credit
WHERE 
    `High Risk` = 'High Risk'
GROUP BY 
    `High Risk`,
    `Transaction year`, 
    `Transaction Month`
ORDER BY 
    `Transaction year` DESC, 
    STR_TO_DATE(`Transaction Month`, '%M') ASC;