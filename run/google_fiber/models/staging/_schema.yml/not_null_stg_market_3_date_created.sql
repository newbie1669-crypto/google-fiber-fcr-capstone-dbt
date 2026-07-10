
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date_created
from `gbi-test`.`dbt_prod`.`stg_market_3`
where date_created is null



  
  
      
    ) dbt_internal_test