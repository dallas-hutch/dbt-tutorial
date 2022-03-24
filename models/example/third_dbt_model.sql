
-- Use the `ref` function to select from other models

{{ config(materialized='view') }}

SELECT COUNT(*) AS 'num_records'
FROM dbo.[ups.invoices]
