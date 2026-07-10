
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select contacts_n
from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
where contacts_n is null



  
  
      
    ) dbt_internal_test