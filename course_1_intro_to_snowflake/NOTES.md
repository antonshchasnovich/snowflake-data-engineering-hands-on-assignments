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

## 1.5 Tables

- **Similar to Databases/Schemas:** Tables can be **created**, **dropped**, and **undropped** (restored within the Time Travel retention period).
- **Creation:** Programmatically with SQL (`CREATE TABLE`), or via Snowsight (which also requires a table definition — columns, data types, etc. — provided through SQL or a similar structured input).
- **Three types of tables:**
  - **Permanent** – default type; long-term storage; Time Travel up to 90 days; has a 7-day Fail-safe period.
  - **Transient** – persists beyond a session but has limited Time Travel (0–1 day) and **no Fail-safe** — lower storage cost, good for intermediate/non-critical data.
  - **Temporary** – exists only for the duration of the session that created it; not visible to other users; dropped automatically when the session ends; no Fail-safe, minimal Time Travel.
- **Cloning:** Tables can be cloned (ties into the Cloning topic) — `CREATE TABLE ... CLONE ...`.
- **Other notes:**
  - A temporary table can share a name with a permanent/transient table in the same schema — the temporary one takes precedence for that session.
  - Table type affects **storage cost** (Fail-safe and longer Time Travel increase cost).

## 1.6 Views

- **Definition:** A view is a saved SQL query that gets re-executed every time the view is queried (not stored as data itself).
- **Types:**
  - **Standard (non-materialized) view** – default type; results computed on the fly each time it's queried.
  - **Materialized view** – results are pre-computed and physically stored, then automatically refreshed whenever the source table changes.
  - **Secure view** – hides the underlying view definition/query logic from users who only have query access; used to protect sensitive logic or data.
- **Materialized view limitations:**
  - Can only query a **single table** — **joins (including self-joins) are not supported**.
  - No window functions, `GROUP BY GROUPING SETS`/`ROLLUP`/`CUBE`, `ORDER BY`, `LIMIT`, or subqueries.
  - Maintenance (keeping it updated) consumes credits, so costs can be higher than a standard view.
- **Dynamic tables:**
  - Similar concept to materialized views, but **support joins, unions, and more complex queries** across multiple tables.
  - Refresh on a schedule controlled by `TARGET_LAG`, instead of being updated instantly — defines how long the data is allowed to lag behind the source after it changes.
  - Minimum `TARGET_LAG` is **1 minute** (not instantaneous like materialized views).
  - Read-only — no `INSERT`/`UPDATE`/`DELETE`/`TRUNCATE` directly against them.

## 1.7 Semi-structured Data

- **Main types:** `VARIANT`, `OBJECT`, `ARRAY`
  - `VARIANT` – can hold any type of value (including nested `OBJECT`/`ARRAY`), similar to a JSON document; max **16 MB** of compressed data per row.
  - `OBJECT` – key-value pairs (like a JSON object).
  - `ARRAY` – ordered list of values (like a JSON array).
- **Similar to JSON format:** values can be accessed by key, using dot notation (`column:key`) or the `GET` function.
- **Typed elements:** every inner element of a `VARIANT` carries its own data type (e.g. `NUMBER`, `VARCHAR`, `OBJECT`, `ARRAY`) — checkable with `TYPEOF()` — which allows type-specific operations (e.g. math on numbers, string functions on strings).
- **Casting:** values can be explicitly cast to/from `VARIANT` using `CAST`, `TO_VARIANT`, or the `::` operator.
- **`FLATTEN` function:** converts nested semi-structured data (`VARIANT`/`OBJECT`/`ARRAY`) into a relational (row-based) format — commonly used together with `LATERAL` to join flattened values back to the original row.
- **Parsing:** `PARSE_JSON` converts a JSON-formatted string into a `VARIANT`.
- **Performance note:** for frequently queried fields (especially dates/timestamps stored as strings inside a `VARIANT`), it's often better to **flatten them into separate relational columns** for improved performance and lower storage cost.

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

## 2.4 User-Defined Functions (UDFs)

- **Purpose:** Save and reuse custom logic that isn't available via Snowflake's built-in functions.
- **Two return types:**
  - **Scalar UDF** – returns a **single value** per input row.
  - **UDTF (User-Defined Table Function)** – returns a **table** (0, 1, or multiple rows) per input row.
- **Supported languages:** `SQL`, `JavaScript`, `Python`, `Java`, `Scala`
  - **Snowpark** – API (mainly for Python/Java/Scala) that can also be used to define and deploy UDFs.

### Example: Scalar UDF (SQL)
```sql
CREATE FUNCTION add_tax(price NUMBER, tax_rate NUMBER)
RETURNS NUMBER
AS
$$
  price * (1 + tax_rate)
$$;

SELECT add_tax(100, 0.2); -- returns 120
```

### Example: UDTF (SQL)
```sql
CREATE FUNCTION get_expensive_products(min_price NUMBER)
RETURNS TABLE (product_name VARCHAR, price NUMBER)
AS
$$
  SELECT product_name, price
  FROM products
  WHERE price >= min_price
$$;

SELECT * FROM TABLE(get_expensive_products(100));
```

## 2.5 Stored Procedures

- **Definition:** A set of actions (procedural logic) bundled together — vs. a UDF, which represents a single logical operation/value.
- **Comparison to UDF:**
  - A stored procedure is called as an **independent statement**: `CALL my_procedure(...)`
  - A UDF is called **as part of a SQL statement/expression**, e.g. inside a `SELECT`, and multiple UDFs can be combined within a single query.
- **Languages:** `SQL` (Snowflake Scripting), `JavaScript`, `Python`, `Java`, `Scala`.
- **SQL syntax structure:** `DECLARE` (optional variables) → `BEGIN` ... `END`.
- **Capabilities:** Can execute both **DDL** (`CREATE`, `ALTER`, `DROP`, etc.) and **DML** (`INSERT`, `UPDATE`, `DELETE`, etc.) statements — unlike UDFs, which cannot perform database operations.
- **Rights model** (controls whose privileges the procedure runs with):
  - **Owner's rights** (default) – runs with the privileges of the procedure's **owner**, regardless of who calls it.
  - **Caller's rights** – runs with the privileges of the **caller**.
- **Return value:** Can optionally `RETURN` a value (scalar, table, or e.g. a `VARIANT`/JSON), though procedures are mainly used for their side effects (actions performed), not for producing a reusable value like a UDF.

### Example (SQL)
```sql
CREATE OR REPLACE PROCEDURE archive_old_orders(cutoff_date DATE)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  INSERT INTO orders_archive
    SELECT * FROM orders WHERE order_date < :cutoff_date;
  DELETE FROM orders WHERE order_date < :cutoff_date;
  RETURN 'Archiving complete';
END;
$$;

CALL archive_old_orders('2024-01-01');
```

## 2.6 Role-Based Access Control (RBAC)

- **Core components:**
  - **Users** – individual accounts that connect to Snowflake.
  - **Roles** – collections of privileges; assigned to users (not privileges directly).
  - **Privileges** – permissions to perform specific actions on specific objects (e.g. `SELECT` on a table, `USAGE` on a warehouse).
- **How it works:**
  - **Privileges → granted to Roles**
  - **Roles → granted to Users** (or to other roles)
- **Role hierarchy:** Roles can be **nested** — one role can be granted to another, forming a hierarchy where a higher-level role inherits all privileges of the roles below it.
- **Default system roles** (built-in, top of hierarchy down to bottom):
  - `ACCOUNTADMIN` – top-level role, full account access
  - `SECURITYADMIN` – manages grants and security objects (users, roles)
  - `USERADMIN` – manages users and roles
  - `SYSADMIN` – manages warehouses, databases, and other objects
  - `PUBLIC` – default role automatically granted to every user
- **Selecting an active role:**
  - Manually, via **Snowsight** (role switcher in the UI)
  - Programmatically with SQL: `USE ROLE <role_name>`
- **Best practice:** Follow the **principle of least privilege** — grant only the privileges a role actually needs.

### Examples
```sql
-- Create a role
CREATE ROLE analyst;

-- Grant a privilege to a role
GRANT SELECT ON TABLE sales TO ROLE analyst;

-- Grant a role to a user
GRANT ROLE analyst TO USER john_doe;

-- Grant a role to another role (hierarchy)
GRANT ROLE analyst TO ROLE data_team;

-- Switch active role in a session
USE ROLE analyst;
```

## 2.7 Snowpark DataFrames

- **Snowpark:** A way to work with Snowflake data using familiar programming languages — **Python**, Java, or Scala — instead of writing raw SQL.
- **Lazy evaluation:** Operations (filters, transformations, joins) are **not executed immediately**. They're only run when an **action** is triggered, e.g.:
  - `.show()` – displays results
  - `.collect()` – pulls results back as a list of rows
  - `.to_pandas()` – converts to a pandas DataFrame
  - `.count()`, `.take(n)` – also trigger execution
- **Session:** The core object used to connect to and interact with Snowflake via Snowpark.
  - Inside Snowflake (e.g. in a stored procedure/worksheet): `get_active_session()`
  - From an external client: `Session.builder.configs(...).create()`
- **DataFrame:** Represents tabular data (rows + columns), similar to a table — but built lazily as a set of transformations.
- **Chainable operations:** Filtering and transformations can be chained together, e.g.:
```python
df = session.table("sales") \
    .filter(col("amount") > 100) \
    .select(col("customer_id"), col("amount")) \
    .sort(col("amount").desc())

df.show()  # triggers execution
```
- **Saving data:**
  - **Locally:** `.to_pandas()` – converts the DataFrame into a local pandas DataFrame.
  - **Back to Snowflake:** `.write.save_as_table("table_name")` – writes the DataFrame to a new or existing table (with modes like `overwrite`, `append`).
- **Local development/testing:** The **Snowpark Python Local Testing Framework** (part of the `snowflake-snowpark-python` package) lets you create and run DataFrame operations **locally without connecting to a Snowflake account** — useful for unit testing and CI pipelines.
- **Notebooks:** Working with Snowpark and DataFrames is especially easy inside **Notebooks** — Python cells automatically have access to the active Snowpark session, so a DataFrame can be created and used right away without any manual session setup (ties into the Notebooks topic).

## 2.8 Snowflake Extension for Visual Studio Code

- **Purpose:** Lets you connect to Snowflake and work with data directly from **VS Code** — write and run SQL worksheets without leaving the editor.
- **Data catalog / object explorer:** Browse **databases, schemas, and tables** directly in the extension's sidebar, with a search bar to find objects by name.
- **Actively maintained** by the Snowflake team, with regular updates.
- **Productivity features:**
  - **One-click copy** of an object's name from the catalog straight into the worksheet
  - **One-click switch** of database/schema context
  - **One-click role picker** to change the active role
- **Authentication options:** username/password, **key-pair authentication**, **SSO/SAML**, or OAuth (via a `connections.toml` config file).
- **Beyond plain SQL:** The extension also supports running **Snowpark Python** code and using **Snowflake Native App Framework** features.
- **AI assistance:** Also integrates with **Snowflake CoCo** (formerly Cortex Code), Snowflake's AI coding agent, for AI-assisted development inside VS Code.

## 2.9 Snowflake CLI

- **Installation:** `pip install snowflake-cli` (verify with `snow --help`).
- **Purpose:** Another way to work with Snowflake — a command-line tool geared towards developer workflows (in addition to plain SQL/data operations).
- **Managing objects:** Create/update/describe/drop Snowflake objects (databases, schemas, tables, warehouses, etc.) via the `snow object` command group.
```bash
snow object create table my_table --columns "id INT, name STRING"
snow object list table
snow object drop table my_table
```
- **Running SQL:** Execute ad-hoc queries or `.sql` files via `snow sql`.
```bash
snow sql -q "SELECT * FROM my_table LIMIT 10"
snow sql -f my_query.sql
```
- **Notebooks:** Manage and execute notebooks via `snow notebook`.
```bash
snow notebook execute my_notebook
```
- **Cortex (AI):** Access Snowflake's AI features via `snow cortex`, e.g. generating a response from an LLM.
```bash
snow cortex complete "Summarize this text: ..."
```
- **Git:** Manage Git repositories integrated with Snowflake via `snow git`, e.g. executing SQL/scripts stored in a repo.
```bash
snow git execute @my_repo/branches/main/script.sql
```
- **Other supported workloads:** Also manages **Snowpark** procedures/functions, **Streamlit in Snowflake**, **Snowpark Container Services**, and **Native Apps**.
- **Connections/credentials:** Managed either via CLI commands (`snow connection add`) or a **config file** (`config.toml`), supporting multiple named connection profiles.
- **Relation to SnowSQL:** Snowflake CLI is the modern replacement for the legacy **SnowSQL** client — Snowflake recommends migrating to it, since new features only go into Snowflake CLI going forward.