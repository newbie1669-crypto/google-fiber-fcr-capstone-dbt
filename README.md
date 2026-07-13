# Google Fiber BI Project w/ DBT - First Contact Resolution (FCR) Analytics

![dbt CI — Google Fiber](https://github.com/newbie1669-crypto/google-fiber-fcr-capstone-dbt/actions/workflows/dbt_ci.yml/badge.svg?branch=main&event=push)

[dbt docs](https://img.shields.io/badge/dbt%20docs-live-FF694B?logo=dbt&logoColor=white)

**Very first**, the “—” and “→” symbol often appear because I write my markdown in `Notion` mostly, not because the whole thing is **“AI generated”**.

---

## **Note** : Before going into this project

This project is an extension of `the original capstone project` I completed after finishing `Google Business Intelligence Professional Certificate`. The issue with the original one was it only focused on documentation, scope definition, and dashboard creation — mostly leaning toward the business side than overall BI stuff.

**What was lack** was an actual deployed `data pipeline`. The original project approach simply loaded CSVs, used SQL `UNION ALL` plus data quality checks, then import the results into a dashboard — **no data pipeline at all. Even data quality testing wasn't a part of the original project’s scope**. What you see in the project is something I added myself.

This project builds on that original work to make it complete, as a real BI project should be.

- **Google Fiber Classic** = the original capstone project
- **This project** = the original, plus production with a (real) pipeline

If you wonder what original capstone project look like. You can view my original project at `this link` , or just search `Google Business Intelligence Professional Certificate Case Study Google Fiber` on Google — plenty of people have done this same project already.

---

## **Prerequisites**

1. Basic data analytics knowledge
2. Understanding of BI concepts
3. Basic SQL and a few more advanced concepts like `CTEs` and `data manipulation`
4. Concept of these things — `Data pipeline`, `ETL`, `ELT`, `Staging vs Mart`, `OLAP vs OLTP`, `Database`, `Data warehouse`
5. **dbt Fundamentals course** ( **highly recommended !!!** — it covers every basic you need so you'll automatically understand everything written in this project )

---

## Workflow (in a nutshell)

`BigQuery`→ `dbt`→`BI tools` ——— ( very simple, a whole project is basically working with these three things!!!)

---

## DBT ?

`dbt` or `data build tool` is the industry-standard framework for the transformation step in an `ELT` process — this project assumes we're working on a `modern data platform` (`Snowflake`, `BigQuery`, `S3`, `Databricks`) or an `OLAP database` like `DuckDB`, where data has already been extracted and loaded into our data warehouse or database.

As `BI Analyst` or `BI engineer` or `Analytics Engineers`, our job is to **take this raw data, transform it, and turn it into deliverables** for business users.

**In this case here**, this means

> **using dbt to build the pipeline that feeds into dashboards** for stakeholders.

---

## Background

**Google Fiber** operates a fiber optic internet service business. In this type of business, customers periodically report issues through phone calls, either to report problems or ask for guidance.

**Google Fiber's customer service team** wants to reduce repeat calls and improve first-contact resolution. To achieve this, they first need to understand the repeat call rate and identify the most common issues customers call about — so they can address problems proactively, prepare for on-the-spot troubleshooting, and improve Google Fiber's overall service quality.

The business question:

> **“ How often are customers repeatedly contacting customer service after their first call - and what problem types or markets drive that behavior ? ”**

## Dataset

use `this` dataset — See `here` for full detail if you have some question like

- Does this project have new data refresh ?
- Why no customer personal info ?
- why does data ... ???

## Project Delivers

1. **Data transformation layer** that turns three raw call-center tables (for 3 markets) into a single, tested mart table ready to be used
2. **Data quality tests** (12+ assertions covering nulls, ranges, accepted values, uniqueness)
3. **Three dashboards** (Tableau, Power BI, Data Studio) connected to BigQuery by the same data pipeline — show metrics and how is going on customer call
4. **Documentation** of the project including :

    ```plain text
    - Stakeholder requirement
    - Project requirement
    - Strategy doc
    - ROCCC data quility assessment doc
    ```

---

## Result and Recommendation

- We have a data pipeline with the `lineage` shown below, connected from source data on Google BigQuery
- Data has been validated and quality-checked, ready for use
- Deployed via `GitHub Actions` with a **status badge** confirming the pipeline runs successfully — proof that the code isn't broken and can be worked on collaboratively with others in the same codebase, not just run locally in my computer
- Hosted `dbt docs site` where you can view model and pipeline descriptions
- A dashboard connected to real data on the warehouse ( this repo only includes Data Studio, which connects live to BigQuery — other dashboard tools would require uploading files to the repo, forcing a switch to import mode with embedded data; otherwise anyone wouldn't be able to view it )
- Summary deck for stakeholders with few recommentdation and some valuation — `link`

---

## **How I Did It (simplified)**

- Installed `dbt`,  `dbt VS Code extension` (since I worked in VS Code), `dbt BigQuery plug-in`, and a few `dbt packages`. (note: I already had a BigQuery account set up with Google Fiber data — if you don't, set this up first.)
- Connected `dbt` to `BigQuery` via a `service account` and set up the profile (don't worry, just ask AI or check the documentation for this).
- Created a dbt project → built models and tests... blah blah... as you can see in this repo → built the models into BigQuery (AI can help a lot).
- At this point, you'll have `mart table` in BigQuery, which you can then connect to a BI tool → build the dashboard.

---

## Architecture

```plain text
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

```plain text
google-fiber-fcr-capstone/
├── .github/workflows/      CI: auto-run dbt on push to main and hosting dbt docs site
├── docs/                   Requirements, ROCCC doc, architecture, data dictionary
├── data/samples/           Reference CSV
├── sql/                    Legacy raw SQL (pre-dbt, kept for reference)
├── dbt/                    Production transformation layer
│   ├── models/staging/         3 staging views (one per market)
│   ├── models/marts/           mart_fiber_fcr (final table)
│   ├── macros/                 generate data quality summary
│   └── analyses/               ad-hoc data quality summary
├── dashboards/             3 BI versions on the same mart
│   ├── tableau/
│   ├── powerbi/
│   ├── data_studio/
│   └── mockups/            lo-fi mockups from design phase
└── README.md
```

Every choice maps to an established standard (dbt Labs structure guide, Twelve-Factor App, Cookiecutter Data Science).

---

## Tools Used in The Project

| Layer | Tool | Description |
| --- | --- | --- |
| Warehouse | Google BigQuery | Serverless, SQL-first, integrates with GCP |
| Transform | dbt-bigquery 1.8.x | SQL-native, version-controlled, testable |
| Data quality tests | dbt-utils, dbt-expectations | Great-Expectations-style assertions in dbt |
| CI/CD | GitHub Actions | Auto-test on every PR / push to main |
| BI | Tableau / Power BI / Data Studio | Same mart, three dashboards |
| Docs | Markdown + .docx originals | GitHub-rendered + Word for delivery to stakeholder |

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

## **What's Next?**

### **1. Beyond the basics, what else can dbt do?**

Once you've mastered the core concepts, you can move on to more advanced features:

- **Macros & Jinja** — write reusable logic following modularity principles; write it once and call it anywhere in the project, instead of rewriting the same logic for every model
- **Packages** — install ready-made libraries from `dbt Hub`, such as `dbt_utils` and `dbt_expectations`, to instantly add tests and helpers without writing data tests from scratch — **this project use these packages too !!!**
- **Incremental Models** — build only new data instead of rebuilding the entire table, significantly reducing cost and runtime for projects with **continuously flowing data**
- **Exposures** — declare which models feed into which dashboards or reports, to track downstream dependencies — so when making changes downstream, you won't accidentally disrupt other pipelines — **this project has this feature**
- **Snapshots** — track how data changes over time (Slowly Changing Dimensions)
- **Semantic Layer** — define metrics (e.g., revenue, churn rate) once in a single place instead of rewriting them repeatedly, then reuse them across any BI tool — **it unnecessary for such a small project like this project but once you scale out you’ll need it**
- **dbt Cloud + CI/CD** — run dbt automatically on a schedule or via triggers, with Slim CI that only tests models that have changed — this project use `GitHub Action` to fill this role. It trigger by every `push` to GitHub

### **2. How is dbt used in real-world work?**

In practice, `dbt` is industry gold standard, serves as the backbone of the data transformation layer ( E L " **T** ") within an organization's data stack — far more than just a tool for writing SQL to create tables — every thing about transformation done by dbt.

Data/Analytics Engineering and BI teams use dbt to manage complex pipelines with hundreds or even thousands of models, with everyone on the team working from the same codebase via `Git` — complete with version control, code review, and CI/CD, just like a software engineering team. This allows the pipeline to scale.

### **Case Study**

If you're interested, you can read case studies at [www.getdbt.com/case-studies](https://www.getdbt.com/case-studies). I highly recommend to reading them — see how powerful the tool really is. Companies using dbt include **McDonald's Nordics** and **Nasdaq** (the second-largest electronic stock exchange in the US).

## **Additional Resources**

| SOURCE | LINK |
| --- | --- |
| dbt Fundamentals (free course) | [courses.getdbt.com](https://courses.getdbt.com/courses/fundamentals) |
| official dbt document | [docs.getdbt.com](https://docs.getdbt.com/docs/introduction) |
| Best Practices Guide | [docs.getdbt.com/guides/best-practices](https://docs.getdbt.com/guides/best-practices) |

---

## Author

**Pluemprach Dangdee** - 2026

**License** : [`LICENSE`](LICENSE)