
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select new_market
from `gbi-test`.`dbt_prod`.`stg_market_3`
where new_market is null



  
  
      
    ) dbt_internal_test