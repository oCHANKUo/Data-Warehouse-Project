"""
Airflow DAG to run SQL Server stored procedures for the Bronze, Silver, and Gold layers.

Overview:
---------
This DAG executes three SQL Server stored procedures in sequence:
    1. load_bronze      - Loads data into the Bronze layer.
    2. silver.load_silver - Transforms and loads data into the Silver layer.
    3. gold.load_gold     - Final transformation and load into the Gold layer.

Prerequisites:
--------------
1. **Install Apache Airflow**  
   You must have Airflow installed, using a virtual environment, in your Python environment. For example:
       pip install apache-airflow
       pip install apache-airflow-providers-microsoft-mssql

2. **Airflow Project Setup**
   - Initialize Airflow: `airflow db init`
   - Create a directory called `dags` inside your Airflow home (default home directory is created as `~/airflow`)
   - Save this file in the `dags/` directory with a `.py` extension.

3. **Connections**
   - Define a connection in the Airflow UI or CLI named `mssql_default` for your SQL Server database.
   - Go to Airflow UI > Admin > Connections > Add Connection.
     Use connection type: `Microsoft SQL Server` and provide your DB credentials.

4. **Running the DAG**
   - Start the webserver and scheduler:
       airflow webserver
       airflow scheduler
   - Access the UI at `http://localhost:8080` and trigger the DAG manually (unless you set a schedule).
   - If using a new version of Airflow (3), use airflow standalone, instead of airflow webserver and scheduler

"""

from airflow import DAG
from airflow.providers.microsoft.mssql.hooks.mssql import MsSqlHook
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'chanuka',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=2),
}

with DAG(
    dag_id='run_sql_server_stored_procedures',
    default_args=default_args,
    description='Run SQL Server stored procedures: load_bronze, silver.load_silver, gold.load_gold',
    start_date=datetime(2025, 7, 26),
    schedule_interval=None,  # Run on demand or specify cron here
    catchup=False,
    tags=['example', 'mssql', 'stored_procedure'],
) as dag:

    run_load_bronze = MsSqlOperator(
        task_id='run_load_bronze',
        mssql_conn_id='mssql_default',
        sql="EXEC load_bronze;",
        autocommit=True,  
    )

    run_load_silver = MsSqlOperator(
        task_id='run_load_silver',
        mssql_conn_id='mssql_default',
        sql="EXEC silver.load_silver;",
        autocommit=True,  
    )

    run_load_gold = MsSqlOperator(
        task_id='run_load_gold',
        mssql_conn_id='mssql_default',
        sql="EXEC gold.load_gold;",
        autocommit=True,  
    )

    run_load_bronze >> run_load_silver >> run_load_gold
