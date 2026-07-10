



select
    1
from `gbi-test`.`dbt_prod`.`stg_market_1`

where not(contacts_n >= 0)

