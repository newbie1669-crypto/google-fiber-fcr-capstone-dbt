
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`

where not(fcr_day1_rate IS NULL OR (fcr_day1_rate >= 0 AND fcr_day1_rate <= 1))


  
  
      
    ) dbt_internal_test