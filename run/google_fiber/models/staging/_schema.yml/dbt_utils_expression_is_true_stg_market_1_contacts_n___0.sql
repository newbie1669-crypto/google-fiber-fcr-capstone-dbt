
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `gbi-test`.`dbt_prod`.`stg_market_1`

where not(contacts_n >= 0)


  
  
      
    ) dbt_internal_test