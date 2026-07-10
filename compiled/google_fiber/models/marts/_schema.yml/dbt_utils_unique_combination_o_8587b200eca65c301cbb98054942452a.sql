





with validation_errors as (

    select
        date_created, new_type, new_market
    from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
    group by date_created, new_type, new_market
    having count(*) > 1

)

select *
from validation_errors


