FROM 184065244952.dkr.ecr.eu-west-1.amazonaws.com/transformation-base:latest

# These build arguments are needed for dbt compile
ARG SNOWFLAKE_ACCOUNT
ARG DBT_SNOWFLAKE_DATABASE
ARG DBT_SNOWFLAKE_SCHEMA
ARG DBT_SNOWFLAKE_ROLE
ARG SNOWFLAKE_WAREHOUSE
ARG SNOWFLAKE_USER
ARG SNOWFLAKE_PASSWORD

RUN pip install --upgrade snowflake-connector-python # Hack to upgrade to a later version 3.12.2

# Copy in dbt-project
RUN mkdir -p /opt/dagster/app/dbt
COPY models /opt/dagster/app/dbt/models
COPY tests /opt/dagster/app/dbt/tests
COPY macros /opt/dagster/app/dbt/macros
COPY seeds /opt/dagster/app/dbt/seeds
COPY snapshots /opt/dagster/app/dbt/snapshots
COPY dbt_project.yml /opt/dagster/app/dbt/

WORKDIR /opt/dagster/app/dbt
#RUN dbt clean && dbt deps && dbt compile
WORKDIR /opt/dagster/app
