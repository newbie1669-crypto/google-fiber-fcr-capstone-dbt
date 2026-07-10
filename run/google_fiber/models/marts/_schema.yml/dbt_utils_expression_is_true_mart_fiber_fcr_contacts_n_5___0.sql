
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`

where not(contacts_n_5 >= 0)


  
  
      
    ) dbt_internal_test