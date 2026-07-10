



select
    1
from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`

where not(fcr_day1_rate IS NULL OR (fcr_day1_rate >= 0 AND fcr_day1_rate <= 1))

