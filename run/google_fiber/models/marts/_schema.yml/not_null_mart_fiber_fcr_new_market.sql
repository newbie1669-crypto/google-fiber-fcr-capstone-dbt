
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select new_market
from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
where new_market is null



  
  
      
    ) dbt_internal_test