
    
    

with all_values as (

    select
        new_market as value_field,
        count(*) as n_records

    from `gbi-test`.`fiber`.`mart_fiber_fcr`
    group by new_market

)

select *
from all_values
where value_field not in (
    'MARKET_1','MARKET_2','MARKET_3'
)


