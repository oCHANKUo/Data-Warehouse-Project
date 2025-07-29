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
