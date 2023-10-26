
--*******************************************************************************

use Report_Data

----------------------------GROSS SALES REPORT------------------------------------


/* Create User Define Function to Get Fiscal Year */

Create Function 
fiscal_year (@date date)
returns int 
begin
return year(dateadd(month,4,@date))
End
 
/* Write query to Get Fiscal year, Product_code wise Gross_Total */

SELECT dbo.fiscal_year(s.date)as fiscal_year, s.product_code, p.gross_price ,
s.sold_quantity, p.gross_price * s.sold_quantity as [Gross_Total] 
FROM fact_sales_monthly s
JOIN gross_price_total p 
ON s.product_code = p.product_code
and dbo.fiscal_year(s.date)= p.fiscal_year
where s.product_code between 'A0118150102' and 'A0118150140'


--Write Query to get Year Wise Gross_Total 

Select dbo.fiscal_year(S.date) as [Fiscal_Year] , 
S.sold_quantity * P.gross_price as [Gross_Price] 
from  fact_sales_monthly S
join gross_price_total P
on S.product_code = P.product_code and dbo.fiscal_year(s.date) = p.fiscal_year
where S.product_code between 'A0118150102' and 'A0118150122'


-- Create Procedure to get Product_Code Wise Gross_Sales

Create Procedure Total_Sales
as 
Begin
Select S.product_code ,sum(P.gross_price * S.sold_quantity) as [Gross_sales] 
from fact_sales_monthly S
join gross_price_total P
on P.product_code = S.product_code
and dbo.fiscal_year(S.date) =P.fiscal_year
where P.product_code = S.product_code
group by S.product_code 
end

exec dbo.Total_Sales

