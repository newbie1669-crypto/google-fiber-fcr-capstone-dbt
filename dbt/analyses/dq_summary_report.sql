-- dbt compile --select dq_summary_report
-- copy compiled SQL -> run on BigQuery Console

{{ generate_dq_summary('mart_fiber_fcr') }}