Effort aggregation by quarter tags (SQL / BigQuery-style)

This query demonstrates how to aggregate effort (hours) by product/module for a given quarter, using a Jira-like dataset with issue labels.

It:

- Joins an issue facts table with an issue labels table
- Flags issues that belong to a target quarter (and late-scope additions)
- Filters by workflow completion statuses and accepted resolutions
- Requires that two specific tags are present (example: TAG_A + TAG_B)
- Sums the original estimates (seconds → hours) per module
- Compares performed effort against goal and capacity targets
