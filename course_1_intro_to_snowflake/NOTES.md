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