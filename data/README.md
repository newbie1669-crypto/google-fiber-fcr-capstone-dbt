# Data

This folder holds reference data - **not the production source** as production source came from BigQuery

```text
data/
├── raw/                
└── samples/                # small CSV for local previews
```

## `raw/`

**Empty by design.** Raw data lives in `BigQuery` and never be committed to the repo. This follows the ***"data is immutable"*** principle from `Cookiecutter Data Science`.

## `samples/`

Contains a small CSV exported from the mart for use in previews.
