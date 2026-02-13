# create database Bank_Project;

use Bank_project;

select * from loan_data;

# 1. Total Loan Amount Funded
select concat(round(sum(`Funded Amount`)/1000000),"M")as Total_Funded_Ammount from loan_data;

# 2. Total Loans
select concat(round(count(*)/1000), "K")as Total_Loans from loan_data;

# 3. Total Collection
select 
concat(round(sum(`Total Rec Prncp` + `Total Fees` + `Total Rrec int` + `Collection Recovery fee`)/1000000,2),"M") 
as Total_Collection
from loan_data;

# 4. Total Interest
select concat(round(sum(`Total Rrec int`)/1000000,1),"M") as Total_interest from loan_data;

# 5. Branch-Wise Performance
select `Branch Name`,round(sum(revenue),1) as Revenue 
from loan_data group by `branch name` order by revenue desc;

# 6. State-Wise Loan
select `State Name`, sum(`loan amount`) as Loan 
from loan_data group by `state name` order by loan desc;

# 7. Religion-Wise Loan
select Religion, sum(`loan amount`) as Loan 
from loan_data group by Religion order by loan desc;

# 8. Product Group-Wise Loan
select `Product Code`, sum(`loan amount`) as Loan 
from loan_data group by `Product Code` order by loan desc;

# 9. Disbursement Trend need to check again
select `Disbursement Year`, sum(`loan amount`) as Loan 
from loan_data group by `Disbursement Year` order by loan desc;

# 10. Grade-Wise Loan
select Grrade, sum(`loan amount`) as Loan 
from loan_data group by Grrade order by loan desc;

# 11. Default Loan Count
select `Is Default Loan` as `Default Loan Status`, 
count(`Is Default Loan`) as `Default Loan Count` 
from loan_data where `Is Default Loan` = "Y";

# 12. Count of Delinquent Clients
select `Is Delinquent Loan` as `Delinquent Loan Status`, 
count(`Is Delinquent Loan`) as `Count of Delinquent Clients` 
from loan_data where `Is Delinquent Loan` = "Y";

# 13. Delinquent Loans Rate
select `Is Delinquent Loan` as `Delinquent Loan Status`, 
concat(round((count(`Is Delinquent Loan`)/(select count('Account Id') from loan_data))*100),"%") as `Delinquent Loans Rate` 
from loan_data 
where `Is Delinquent Loan` = "Y";

# 14. Default Loan Rate
select `Is Default Loan` as `Default Loan Status`, 
concat(round((count(`Is Default Loan`)/(select count('Account Id') from loan_data))*100),"%") as `Default Loan Rate` 
from loan_data 
where `Is Default Loan` = "Y";

# 15. Loan Status-Wise Loan
select `Loan Status`, sum(`loan amount`) as Loan 
from loan_data group by `Loan Status` order by loan desc;

# 16. Age Group-Wise Loan
select Age as Age_Group , sum(`loan amount`) as Loan 
from loan_data group by Age_Group order by loan desc;

# 17. Number of Non Verified Loan 
select `Verification Status`, 
concat(round(((count(`Verification Status`)/(select count('Account Id') from loan_data))*100), 1), "%") as "% of Non Verified Loans"
from loan_data where `Verification Status` = "Not Verified";

# 18. Loan Maturity - need to check
select 
	`Account ID`,
    concat(round(cast(replace(Term, ' months', '') as unsigned) / 12), " Years") as maturity_years
from loan_data;

