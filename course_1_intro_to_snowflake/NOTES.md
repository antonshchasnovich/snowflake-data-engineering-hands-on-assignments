# 1 Intro to Snowflake

## 1.1 Worksheets

- **Definition:** One of the main ways to interact with data through the Snowsight GUI.
- **Purpose:** Write, edit, and run **SQL queries** directly in the browser.
- **Other features:**
  - Support for **Python** (via Snowpark) in addition to SQL, depending on worksheet type
  - Results are displayed in a grid, with options to view **query details**, **execution time**, and **query profile** (visual breakdown of how the query ran)
  - Can be **organized into folders** and shared with other users/roles
  - Support for **variables** (e.g. session variables) within a worksheet
  - Ability to **import a `.sql` file** or create a worksheet from an existing one
  - Charting/visualization option to turn query results into simple charts
  - Can be tied to a specific **role, warehouse, and database/schema context**, selectable from the worksheet UI

## 1.2 Virtual Warehouses

- **Definition:** An abstraction/representation of compute resources used to execute queries and load/unload data.
- **Underlying structure:** Every warehouse runs on a **cluster** of compute nodes (servers).
- **Creation/management:** Via the **web interface (Snowsight)** or programmatically with SQL: `CREATE WAREHOUSE` / `ALTER WAREHOUSE`.
- **Scaling:**
  - **Vertical scaling:** Resize the warehouse to a bigger/smaller **size** (`X-Small` → `6X-Large`) to change the power of a single cluster.
  - **Horizontal scaling:** Use a **multi-cluster warehouse** to add more clusters running in parallel, handling more concurrent queries/users.
- **Selecting a warehouse for use:**
  - Manually, by picking it in the UI context selector
  - Programmatically with `USE WAREHOUSE <name>`
- **Other settings:**
  - **Auto-suspend:** automatically pauses the warehouse after a period of inactivity to save credits
  - **Auto-resume:** automatically starts the warehouse when a new query is submitted
  - **Scaling policy** (for multi-cluster): `STANDARD` vs `ECONOMY` — controls how aggressively extra clusters are spun up/down
  - **Billing:** credits consumed **per second**, with a **60-second minimum** each time the warehouse starts/resumes

## 1.3 Stages and Basic Ingestion

- **Definition:** An intermediate storage location between an external data source and Snowflake internal storage, used to stage files before loading (or after unloading) data.
- **Common use case:** Ingesting data from cloud blob storage such as **Amazon S3**, Azure Blob Storage, or Google Cloud Storage.
- **Creation:** Via the web interface (Snowsight) or programmatically with SQL: `CREATE STAGE`.
- **Types of stages:**
  - **User stage** (`@~`) – automatically created for each user; private, personal storage; can't be altered or dropped.
  - **Table stage** (`@%table_name`) – automatically created for each table; used to load/unload data only for that specific table.
  - **Named stage** – manually created database object (internal or external); most flexible option, can be shared across multiple users/tables and referenced by name.
- **Internal vs. external:**
  - **Internal stage:** files stored within Snowflake-managed storage.
  - **External stage:** references files stored outside Snowflake (e.g. S3 bucket), typically set up via a **storage integration**.
- **Loading data:** Use `PUT` to upload local files to an internal stage, then `COPY INTO <table>` to load staged files into a table.
- **Unloading data:** `COPY INTO <stage>` to export table data out to a stage.
- **File management commands:** `LIST` (view files in a stage), `REMOVE` (delete files from a stage).

## 1.4 Databases and Schemas

- **Hierarchy:** A **database** contains **schemas**, and a **schema** contains objects such as **tables**, views, stages, etc.
- **Creation:** Both can be created via **Snowsight** or programmatically with SQL: `CREATE DATABASE` / `CREATE SCHEMA`.
- **Naming objects:** Objects are referenced using a fully qualified **three-part name**: `database.schema.object`.
- **`USE` statement:** Sets a default context so the three-part name isn't required each time:
  - `USE DATABASE <name>`
  - `USE SCHEMA <name>`
- **Default schemas:** Every database automatically includes:
  - `PUBLIC` – default schema for user-created objects
  - `INFORMATION_SCHEMA` – read-only system views/metadata about the database's objects
- **Other options:**
  - `CREATE OR REPLACE` – recreate an object, replacing it if it already exists
  - `DROP` / `UNDROP` – delete an object or restore it within the Time Travel retention period
  - Databases/schemas can also be **transient** (no Fail-safe period, lower storage cost)
  - Databases and schemas can also be **cloned** (ties into the Cloning topic)

# 2 Snowflake Feature Overview

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