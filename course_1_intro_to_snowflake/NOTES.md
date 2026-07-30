## 2.7 Resource Monitors (Snowflake)

- **Definition:** Objects used to monitor and control credit/resource usage.
- **Scope levels:** Can be created at the **ACCOUNT** level or the **WAREHOUSE** level.
- **Creation methods:**
  - Via the Snowflake **GUI** (Web Console)
  - Programmatically using SQL: `CREATE RESOURCE MONITOR`
- **Triggered actions** (when a threshold is reached):
  - `NOTIFY` – sends a notification only
  - `NOTIFY AND SUSPEND` – notifies and suspends the warehouse *after* currently running queries complete
  - `NOTIFY AND SUSPEND IMMEDIATELY` – notifies and suspends the warehouse right away, interrupting running queries
- **Frequency (cadence):** Configurable reset intervals — e.g. `DAILY`, `MONTHLY`, etc.
- **Other settings:**
  - List of users/roles to notify
  - Credit quota and threshold percentages for each action