{{ config(materialized='table') }}

SELECT customername as Customer, servicetype as ServiceType, round(sum(TransportationChargeAmount),2) as TransportationChargeAmount,
round(sum(NetChargeAmount), 2) as NetChargeAmount,
round(sum(TransportationChargeAmount+netchargeamount), 2) as TotalAmount
FROM [dbo].[fedex.invoices.archive] f
inner join [dbo].customers c
on f.customerid = c.customerid
group by customername, servicetype