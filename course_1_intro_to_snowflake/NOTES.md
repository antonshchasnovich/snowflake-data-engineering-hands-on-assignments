# 2.1 Snowflake Feature Overview

## 2.1 Time Travel

- **Definition:** Allows querying/restoring data as it existed at a previous point in time.
- **Retention period** (controlled by `DATA_RETENTION_TIME_IN_DAYS`):
  - **Permanent tables:** up to **90 days** (Enterprise Edition+; Standard Edition defaults to 1 day)
  - **Transient / Temporary tables:** up to **1 day**
- **Ways to reference a point in time:**
  - `AT (TIMESTAMP => ...)` – specific timestamp
  - `AT (OFFSET => ...)` – relative offset in seconds from present
  - `BEFORE (STATEMENT => ...)` – state just before a given query ID ran
- **Reusable references:** A timestamp or query ID can be stored in a **variable/session parameter** and reused in queries.
- **Common use cases:**
  - Querying historical data: `SELECT * FROM my_table AT (OFFSET => -3600)`
  - Restoring a dropped object: `UNDROP TABLE my_table`
  - Cloning an object as of a past state (ties into Cloning topic)
- **After Time Travel expires:** Data moves into **Fail-safe** (7 additional days, recovery only via Snowflake support, not user-accessible).

## 2.2 Cloning Objects

- **Definition:** Creating a copy of an object without duplicating the underlying data — known as **Zero-Copy Cloning**.
- **Cloneable objects:** Tables, Schemas, Databases (also supported for some other objects like Streams/Tasks, with limitations).
- **Command:** `CREATE <object> CLONE <source_object>`
- **How it works:**
  - Only **metadata/pointers** to the data are copied, not the actual data itself.
  - Both objects initially point to the same underlying storage.
  - Once either the original or the clone is modified, Snowflake stores only the **changed data** (copy-on-write) — the two objects diverge from that point.
- **Storage cost:** Minimal at creation time — you only pay for extra storage once data starts to diverge.
- **Time Travel cloning:** You can clone an object as it existed in the past using `AT` / `BEFORE`, e.g.:
  - `CREATE TABLE my_table_clone CLONE my_table AT (TIMESTAMP => '...')`
- **Note on permissions:** Grants/privileges are **not** automatically cloned for schemas and databases by default — worth checking access after cloning.

## 2.3 Resource Monitors

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