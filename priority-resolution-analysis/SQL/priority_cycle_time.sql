WITH base AS (
    SELECT
        issue_id,
        priority,
        CAST(resolved_at AS DATE) - CAST(created_at AS DATE) AS cycle_time_days
    FROM read_csv_auto('data/issues.csv')
    WHERE resolved_at IS NOT NULL
)

SELECT
    priority,
    COUNT(*) AS total_issues,
    ROUND(MEDIAN(cycle_time_days), 1) AS median_cycle_time_days,
    ROUND(QUANTILE_CONT(cycle_time_days, 0.75), 1) AS p75_cycle_time_days
FROM base
GROUP BY priority
ORDER BY priority;