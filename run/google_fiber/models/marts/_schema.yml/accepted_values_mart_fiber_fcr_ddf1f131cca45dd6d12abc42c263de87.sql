
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        new_type as value_field,
        count(*) as n_records

    from `gbi-test`.`dbt_prod`.`mart_fiber_fcr`
    group by new_type

)

select *
from all_values
where value_field not in (
    'TYPE_1','TYPE_2','TYPE_3','TYPE_4','TYPE_5'
)



  
  
      
    ) dbt_internal_test