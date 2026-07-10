
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        new_market as value_field,
        count(*) as n_records

    from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
    group by new_market

)

select *
from all_values
where value_field not in (
    'MARKET_1','MARKET_2','MARKET_3'
)



  
  
      
    ) dbt_internal_test