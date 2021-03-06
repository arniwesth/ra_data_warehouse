{% if not var("enable_xero_accounting_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

WITH
  source AS
  (
    {{ filter_stitch_table(var('stg_xero_accounting_stitch_schema'),var('stg_xero_accounting_stitch_bank_transactions_table'),'banktransactionid') }}
  ),
renamed as (
  SELECT
      concat('{{ var('stg_xero_accounting_id-prefix') }}',banktransactionid) as transaction_id,
      lineitems.description as transaction_description,
      currencycode as transaction_currency,
      cast(null as numeric) as transaction_exchange_rate,
      lineitems.lineamount as transaction_gross_amount,
      cast(null as numeric) as transaction_fee_amount,
      lineitems.taxamount as transaction_tax_amount,
      lineitems.lineamount - lineitems.taxamount as transaction_net_amount,
      case when isreconciled then 'Reconciled' else 'Unreconciled' end as transaction_status,
      type as transaction_type,
      date as transaction_created_ts,
      cast(null as timestamp) as transaction_last_modified_ts
  FROM
    source i,
         UNNEST(i.lineitems) AS lineitems)
select * from renamed
