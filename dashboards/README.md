# Dashboards

Three dashboards built on the **same** `mart_fiber_fcr` table. They answer the same business question with the same metrics; the differences are purely interface and platform.

```plain text
dashboards/
├── tableau/            original capstone project dashboard
├── powerbi/
├── data_studio/
└── mockups/            lo-fi designs from the planning phase
```

## Three versions of dasboard description


| BI Tool          | Description                      | Output format        |
|------------------|-------------------------------------------------|----------------------|
| **Tableau**      | Original version         | `.twbx`|
| **Power BI**     | Alternative version, interactive        | `.pbix`|
| **Data Studio**| Alternative version, browser-shareable, GCP-native             | URL                  |

In my computer three dashboards connect to **the same `mart_fiber_fcr` table** in BigQuery - meaning DQ tests, schema changes, and metric definitions are managed in **one** place (dbt), and the three dashboards stay in sync automatically.

But please note that in this repository, **only the Data Studio dashboard connects directly to BigQuery.** So it's the only one that get auto-refresh.

**The other two dashboards use import mode (not direct query) with embedded data** so everyone can view. If I kept them as direct connections, they would only work with my personal BigQuery account and my PC.

## Mockups

Lo-fi mockups (`mockups/`) were produced in the planning phase before any chart was built. They served as alignment artifacts with stakeholders. It doesn't look exactly like the final one, just for reference and idea.
