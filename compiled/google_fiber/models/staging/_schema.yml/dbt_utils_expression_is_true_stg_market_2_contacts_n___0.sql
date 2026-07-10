



select
    1
from `gbi-test`.`dbt_prod`.`stg_market_2`

where not(contacts_n >= 0)

