{{ config(materialized='table') }}


select CustomerName, ResellerName, i.InvoiceNumber, LeadShipmentNumber, ChargeClassificationCode,
case
when ChargeClassificationCode in ('ACC', 'MSC') then 'Accessorial & Miscellaneous'
when ChargeClassificationCode = 'FSC' then 'Fuel surcharge'
when ChargeClassificationCode = 'FRT' then 'Freight'
when ChargeClassificationCode in ('BRK', 'GOV', 'INF') then 'Other'
end as ChargeCategory,
sum(IncentiveAmount) as IncentiveAmount, sum(NetAmount) as NetAmount, sum(IncentiveAmount + NetAmount) as TotalAmount,
case
when sum(IncentiveAmount) > 0 and sum(IncentiveAmount + NetAmount) > 0 then
concat(round((sum(IncentiveAmount) / sum(IncentiveAmount+NetAmount) ) * 100 , 2), '%') 
end as 'Incentive%'
from dbt_dummy.[dbo].[ups.invoices] i
inner join dbt_dummy.[dbo].[customers] c
on i.CustomerID = c.CustomerID
where LeadShipmentNumber is not null
group by CustomerName, ResellerName, i.InvoiceNumber, LeadShipmentNumber, ChargeClassificationCode