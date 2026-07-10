
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        date_created, new_type, new_market
    from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
    group by date_created, new_type, new_market
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test