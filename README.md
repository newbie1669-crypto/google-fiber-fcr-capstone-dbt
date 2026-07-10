# Google Fiber BI Capstone Project w/ DBT - First Contact Resolution (FCR) Analytics

[![dbt CI — Google Fiber](https://github.com/newbie1669-crypto/google-fiber-fcr-capstone-dbt/actions/workflows/dbt_ci.yml/badge.svg?branch=main&event=push)](https://github.com/newbie1669-crypto/google-fiber-fcr-capstone-dbt/actions/workflows/dbt_ci.yml)

**End-to-end analytics pipeline measuring repeat-caller behavior across three Google Fiber markets.**

**Workflow :** BigQuery -> DBT (data build tool) -> Tableau / Power BI / Data Studio (ex-name: Looker studio)

<img src="docs/images/dbt.png" alt="dbt">

---

## อธิบายก่อนเข้าโปรเจค

"classic = the analysis; this repo = the production pipeline"

เป็นโปรเจคที่ต่อยอดมาจากตัว [classic project](https://github.com/newbie1669-crypto/google-fiber-fcr-capstone-classic) มี logic การเขียน SQL , dataset และ dashboard เหมือนกัน สิ่งที่เพิ่มขึ้นมา คือ การทำ data pipeline ของจริง เป็น ELT ที่มีการ transformation และ test อย่างเป็นระบบ ระบบนี้เป็นแค่ "toy project" แต่สามารถนำมา scale ออกได้จริงด้วยแค่เปลี่ยน data source สามารถ automation การ CI/CD ได้จริง ด้วยเครื่องมือที่เพิ่มเข้ามา คือ DBT (data build tool)

สำหรับ DBT สั้นๆ มันเป็น framework ที่ทำให้การเขียน SQL กลายเป็นเหมือน data engineering จริงๆ - เขียน model เป็น .sql ไฟล์, เขียน config หรือ การตั้งค่าระบบ pipeline เป็น .yaml ไฟล์,  test, document และ run ทีเดียวทั้ง pipeline ศึกษาเพิ่มเติมได้ที่ [getdbt.com](https://www.getdbt.com/) มีคอร์สเรียนฟรีด้วย ถือเป็นเครื่องมือที่ทรงพลังมากเวลาใช้กับพวก modern data stack (ฺGoogle BigQuery, Databricks, Snowflake, Amazon Redshift, etc.) เพื่อทำงาน Business intelligence หรือ Analytics engineering

---

## Background

Google Fiber's customer service team wants to **reduce repeat calls** and improve first-contact resolution. The business question:

> **"How often are customers repeatedly contacting customer service after their first call - and what problem types or markets drive that behavior ?"**

Source: Google Business Intelligence Professional Certificate - Case Study 2 (Google Fiber).

## Project Delivers

1. **Data transformation layer** that turns three raw call-center tables (for 3 markets) into a single, tested FCR mart
2. **Data quality tests** (12+ assertions covering nulls, ranges, accepted values, uniqueness) wired into CI
3. **Three dashboards** (Tableau, Power BI, Data Studio) connected to BigQuery by the same data pipeline
4. **Documentation** of the project including :

        - Stakeholder requirement
        - Project requirement
        - Strategy doc
        - ROCCC data quility assessment doc

---

## Architecture

```text
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   ┌──────────────────┐         ┌──────────────────┐                 │
│   │  BigQuery (raw)  │         │   dbt staging    │                 │
│   │                  │   ──►   │                  │                 │
│   │  fiber.market_1  │         │  stg_market_1    │                 │
│   │  fiber.market_2  │         │  stg_market_2    │   (views,       │
│   │  fiber.market_3  │         │  stg_market_3    │    type-cast)   │
│   └──────────────────┘         └────────┬─────────┘                 │
│                                         │                           │
│                                         ▼                           │
│                                ┌──────────────────┐                 │
│                                │    dbt marts     │                 │
│                                │                  │                 │
│                                │  mart_fiber_fcr  │   (table,       │
│                                │   + DQ tests     │    7-day FCR    │
│                                │                  │    + decay)     │
│                                └────────┬─────────┘                 │
│                                         │                           │
│              ┌──────────────────────────┼──────────────────────────┐│
│              ▼                          ▼                          ▼│
│      ┌──────────────┐           ┌──────────────┐          ┌─────────┴──┐
│      │   Tableau    │           │   Power BI   │          │    Data    │
│      │  Dashboard   │           │  Dashboard   │          │   Studio   │
│      └──────────────┘           └──────────────┘          └────────────┘
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  ▲
                                  │
                          GitHub Actions CI
                       (dbt run + dbt test on push)
```

See [`docs/architecture.md`](docs/architecture.md) for the full diagram and rationale.

---

## Repository Layout

```text
google-fiber-fcr-capstone/
├── .github/workflows/      CI: auto-run dbt on push to main
├── docs/                   Requirements, ROCCC, architecture, data dictionary
├── data/samples/           Reference CSV (sanitized)
├── sql/                    Legacy raw SQL (pre-dbt, kept for reference)
├── dbt/                    Production transformation layer
│   ├── models/staging/         3 staging views (one per market)
│   ├── models/marts/           mart_fiber_fcr (final table)
│   ├── macros/                 generate_dq_summary
│   └── analyses/               ad-hoc DQ summary
├── dashboards/             3 BI versions on the same mart
│   ├── tableau/
│   ├── powerbi/
│   ├── data_studio/
│   └── mockups/                lo-fi mockups from design phase
└── README.md               You are here
```

Every choice maps to an established standard (dbt Labs structure guide, Twelve-Factor App, Cookiecutter Data Science).

---

## Key Metrics Built by the Pipeline

The `mart_fiber_fcr` table exposes these columns for any BI tool:

| Column                      | Type   | Meaning                                                                       |
|-----------------------------|--------|-------------------------------------------------------------------------------|
| `date_created`              | DATE   | First-contact date                                                            |
| `new_market`                | STRING | `MARKET_1` / `MARKET_2` / `MARKET_3`                                          |
| `new_type`                  | STRING | Problem type (technician, internet/wifi, phone, cable, charges)               |
| `contacts_n`                | INT    | First contacts on `date_created`                                              |
| `contacts_n_1` … `_n_7`     | INT    | Repeat contacts 1-7 days later                                                |
| **`fcr_day1_rate`**         | FLOAT  | **% of customers not calling back the next day** (primary KPI)                |
| **`fcr_7day_rate`**         | FLOAT  | **% of customers not calling back within 7 days** (secondary KPI)             |
| `repeat_rate_day1` … `_7`   | FLOAT  | Repeat rate at each day-lag (for decay curves)(*optional I didn't use it either)                      |

Full schema: [`docs/data_dictionary.md`](docs/data_dictionary.md).

---

## Data Quality Testing

Twelve+ tests run on every push via GitHub Actions. They map to the seven CHECKs of the original analysis:

| NO. | Coverage                                | dbt test                                   |
|-------|-----------------------------------------|--------------------------------------------|
| 1     | Row counts by market                    | `dbt run` + BigQuery review                |
| 2     | NULL checks on key columns              | `not_null`                                 |
| 3     | Composite uniqueness `(date, type, mkt)`| `dbt_utils.unique_combination_of_columns`  |
| 4     | Date range sanity                       | `dbt_expectations.expect_column_values_to_be_between` |
| 5     | No negative contact counts              | `dbt_utils.expression_is_true: ">= 0"`     |
| 6     | Categorical values match enum           | `accepted_values`                          |
| 7     | Aggregate DQ summary                    | `analyses/dq_summary_report.sql`           |

---

## Dashboards

Three independent dashboards backed by the same `mart_fiber_fcr` table - pick the BI tool of your choice.

| BI Tool             | Status                | Folder                                    |
|---------------------|-----------------------|-------------------------------------------|
| **Tableau**         | ✅ Built (.twbx)      | [`dashboards/tableau/`](dashboards/tableau/)             |
| **Power BI**        | ✅ Built (.pbix)      | [`dashboards/powerbi/`](dashboards/powerbi/)             |
| **Data Studio**   | ✅ Built (Data Studio)      | [`dashboards/data_studio/`](dashboards/data_studio/) |

Lo-fidelity mockups from the design phase: [`dashboards/mockups/`](dashboards/mockups/).

---

## Project Phases

This project follows the three phases BI project lifecycle from the Google Business Intelligence Certificate :

| Phase    | What was done | Folder |
|--------------|-----------------------------------------------------------------|----------------------------------------|
| **01 Capture**  | Stakeholder requirements, project requirements, strategy doc, ROCCC data quality assessment doc | `docs/` |
| **02 Analyze**  | SQL exploration -> dbt models -> DQ tests | `sql/` + `dbt/` |
| **03 Monitor**  | Dashboards + lo-fi mockups | `dashboards/` |

For full detail : [`docs/phase_mapping.md`](docs/phase_mapping.md).

---

## Tools Used in The Project

| Layer        | Tool                                              | Description |
|--------------|---------------------------------------------------| ------------------------------------------- |
| Warehouse    | Google BigQuery                                   | Serverless, SQL-first, integrates with GCP |
| Transform    | dbt-bigquery 1.8.x                                  | SQL-native, version-controlled, testable |
| DQ Tests     | dbt-utils, dbt-expectations                       | Great-Expectations-style assertions in dbt |
| CI/CD        | GitHub Actions                                    | Auto-test on every PR / push to main |
| BI           | Tableau / Power BI / Data Studio                  | Same mart, three dashboards |
| Docs         | Markdown + .docx originals                        | GitHub-rendered + Word for delivery to stakeholder |

---

### Deliverables documentation (for stakeholder)

- [`docs/01_stakeholder_requirements.md`](docs/01_stakeholder_requirements.md) - what the business asked for
- [`docs/02_project_requirements.md`](docs/02_project_requirements.md) - scoped & prioritized requirements
- [`docs/03_strategy_document.md`](docs/03_strategy_document.md) - dashboard spec: the four charts to build
- [`docs/04_roccc_data_assessment.md`](docs/04_roccc_data_assessment.md) - data quality evaluation

### Reference documentation (for detail)

- [`docs/data_dictionary.md`](docs/data_dictionary.md) - every column explained
- [`docs/architecture.md`](docs/architecture.md) - pipeline & structure rationale
- [`docs/phase_mapping.md`](docs/phase_mapping.md) - GBI phase <-> folder mapping
- [`dbt/README.md`](dbt/README.md) - dbt project usage guide

---

## What's Next ?

### 1. dbt นอกจากพื้นฐานแล้วต่อยอดอะไรได้อีก ?

เมื่อเชี่ยวชาญ concept พื้นฐานแล้ว สามารถขยับไปใช้ feature ขั้นสูงได้อีก :

- **Snapshots** — ติดตามการเปลี่ยนแปลงของข้อมูลตามเวลา (Slowly Changing Dimensions)
- **Macros & Jinja** — เขียน logic ซ้ำ ๆ ตามหลักการ **modularity** ทำครั้งเดียวแล้วเรียกใช้ได้ทั่วทั้ง project ไม่ต้องมาเขียนซ้ำทุกการสร้าง data model (ในคอร์สมีการสอนพื้นฐานไปบ้างแล้ว)
- **Packages** — ติดตั้ง library สำเร็จรูปจาก dbt Hub เช่น `dbt_utils`, `dbt_expectations` เพื่อเพิ่ม test และ helper ให้ทันที ไม่ต้องมาเขียน data test from scratch
- **Incremental Models** — build เฉพาะข้อมูลใหม่ ไม่ต้อง rebuild ทั้งตาราง ลด cost และเวลาได้มากสำหรับการทำ project ที่ข้อมูลมีการไหลเข้าตลอดเวลา
- **Exposures** — ประกาศว่าโมเดลไหนถูกใช้ใน dashboard หรือ report ไหน เพื่อ track downstream dependency เวลาจะทำการแก้งายปลายน้ำบางงานจะได้ไม่ต้องไปรบกวน pipeline งานอื่น
- **Semantic Layer** — นิยาม metric (เช่น revenue, churn rate) ในที่เดียว ไม่ต้องเขียนใหม่ทุกครั้ง แล้วเรียกใช้ได้จากทุก BI tool
- **dbt Cloud + CI/CD** — รัน dbt อัตโนมัติตาม schedule หรือเมื่อมี trigger พร้อม Slim CI ที่ test เฉพาะโมเดลที่เปลี่ยน
- **dbt Explorer** — visualize lineage graph ทั้ง pipeline ตั้งแต่ source ไปถึง mart ได้ใน UI ช่วยมาก เพราะสามารถดูแผนผังได้ด้วยตาแทนการอ่าน code

### 2. dbt ในงานจริง ?

ในงานจริง dbt ถูกใช้เป็น **backbone ของ data transformation layer** ใน data stack ขององค์กร ไม่ใช่แค่เครื่องมือเขียน SQL สร้างตารางธรรมดา

ทีม **Data/Analytics Engineering** ใช้ dbt เพื่อ **จัดการ pipeline ที่ซับซ้อน** ที่มีโมเดลเป็นร้อยเป็นพัน โดยที่ทุกคนในทีมทำงานบน codebase เดียวกันผ่าน Git — มี version control, code review, และ CI/CD เหมือนทีม Software Engineer แถมยัง scale out ออกได้เยอะมาก

**Case Study :** หากสนใจสามารถอ่าน case studies ได้ที่ [www.getdbt.com/case-studies](https://www.getdbt.com/case-studies) อยากให้อ่าน แล้วจะรู้ว่าเครื่องมือนี้มัน powerful มาก ๆๆๆๆๆๆๆๆๆ ( หนึ่งในบริษัทที่ใช้มี McDonald’s Nordics กับ Nasdaq (ตลาดหลักทรัพย์อิเล็กทรอนิกส์ที่ใหญ่เป็นอันดับ 2 ของสหรัฐฯ) )

## แหล่งเรียนรู้เพิ่มเติม

| SOURCE | LINK |
| --- | --- |
| dbt Fundamentals (คอร์สฟรี) | [courses.getdbt.com](https://courses.getdbt.com/courses/fundamentals) |
| เอกสาร dbt อย่างเป็นทางการ | [docs.getdbt.com](https://docs.getdbt.com/docs/introduction) |
| Best Practices Guide | [docs.getdbt.com/guides/best-practices](https://docs.getdbt.com/guides/best-practices) |
| Jaffle Shop reference repo | [github.com/dbt-labs/jaffle_shop](https://github.com/dbt-labs/jaffle_shop) |

---

## Author

**Pluemprach Dangdee** — Google Business Intelligence Capstone, 2025–2026
