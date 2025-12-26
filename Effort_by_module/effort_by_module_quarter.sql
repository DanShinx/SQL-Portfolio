-- [Portfolio] Example: effort aggregation by product/module for a given quarter + tag criteria
-- Notes:
-- - Source tables and identifiers are anonymized
-- - Labels and project identifiers are generalized

WITH engineering_data_qtr AS (
  SELECT
    lbl.issue_id,
    iss.module_name AS product_module,
    iss.workflow_status AS status,
    iss.resolution AS resolution,
    MAX(CASE WHEN lbl.label = 'QTR_TARGET'      THEN 1 ELSE 0 END) AS is_qtr_target,
    MAX(CASE WHEN lbl.label = 'QTR_LATE_SCOPE'  THEN 1 ELSE 0 END) AS is_qtr_late_scope,
    MAX(CASE WHEN lbl.label = 'TAG_A'           THEN 1 ELSE 0 END) AS has_tag_a,
    MAX(CASE WHEN lbl.label = 'TAG_B'           THEN 1 ELSE 0 END) AS has_tag_b,
    CAST(iss.original_estimate_seconds AS FLOAT64) / 3600.0 AS original_estimate_hrs
  FROM
    `analytics_dataset.issue_labels` AS lbl
  INNER JOIN
    `analytics_dataset.issue_facts` AS iss
      ON lbl.issue_id = iss.issue_id
  WHERE
    iss.project_code = 'PROJECT_X'
    AND lbl.label IN ('TAG_A', 'TAG_B', 'QTR_TARGET', 'QTR_LATE_SCOPE')
    AND iss.issue_type NOT IN ('Sub-task', 'Sub-New Work')
  GROUP BY
    lbl.issue_id,
    product_module,
    iss.original_estimate_seconds,
    status,
    resolution
),

effort_by_module AS (
  SELECT
    product_module,
    ROUND(SUM(original_estimate_hrs), 2) AS performed_hours
  FROM engineering_data_qtr
  WHERE
    status IN ('Closed', 'Done')
    AND (is_qtr_target = 1 OR is_qtr_late_scope = 1)
    AND (has_tag_a = 1 AND has_tag_b = 1)
    AND resolution IN ('Completed', 'Verified', 'Fixed', 'Done')
  GROUP BY
    product_module
)

SELECT
  e.product_module,
  e.performed_hours,
  t.goal_hours,
  t.capacity_hours,
  CASE
    WHEN t.goal_hours <> 0 THEN (e.performed_hours / t.goal_hours)
    ELSE 1
  END AS goal_compliance_rate,
  CASE
    WHEN t.capacity_hours <> 0 THEN (e.performed_hours / t.capacity_hours)
    ELSE 1
  END AS capacity_compliance_rate
FROM
  effort_by_module AS e
LEFT JOIN
  `analytics_dataset.quarter_targets` AS t
    ON e.product_module = t.module_name;

