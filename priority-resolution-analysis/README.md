# SQL-Portfolio

# Priority Resolution Effectiveness Analysis

## Business Question
Are high-priority issues consistently resolved faster than low-priority ones?

## Objective
Evaluate whether issue prioritization policies effectively translate into faster execution,
using cycle time metrics across different priority levels.

## Why This Matters
In delivery, operations, and PMO environments, priority labels (P0–P3) are expected to drive
execution urgency. When high-priority items are not resolved significantly faster, it indicates governance gaps, process inefficiencies, or resource misalignment.

## Dataset
This project uses a **synthetic dataset** designed to replicate a real-world issue tracking system (Jira-like), including realistic timelines, priorities, and resolution behaviors.

Synthetic data was intentionally used to ensure reproducibility and avoid proprietary or NDA-restricted information.

## Key Metric
**Cycle Time (days)** = resolved_at − created_at

Metrics are evaluated using:
- Median (p50)
- 75th percentile (p75)

Averages are avoided due to skew from long-running outliers.

## How to run the analysis

This project uses **DuckDB** to execute analytical SQL directly on CSV files
(no database setup required).

### Prerequisites
- DuckDB installed locally

### Install DuckDB

**macOS**
```bash
brew install duckdb

Author: Daniel Longman
Last Update: 2025-12-26 [2026-01-02]
