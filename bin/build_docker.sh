#!/bin/bash
set -e -x
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd $SCRIPT_DIR/..

#if [[ $( git status --porcelain . | wc -l) != "0" ]]; then
#    echo "This checkout is dirty refusing to build"
#    exit 1
#fi

CurrentRevision=$(git rev-parse --short HEAD)

DockerRepository="184065244952.dkr.ecr.eu-west-1.amazonaws.com/reference_implementation"
SecretKey="snowflake-db20241021074242203800000001"

SecretValue=$(aws secretsmanager get-secret-value --secret-id $SecretKey| jq -r '.SecretString')

SnowflakeAccount=$(echo $SecretValue | jq -r .account)
SnowflakeDatabase=$(echo $SecretValue | jq -r .database)
SnowflakeUser=$(echo $SecretValue | jq -r .user)
SnowflakePassword=$(echo $SecretValue | jq -r .password)
SnowflakeWarehouse=$(echo $SecretValue | jq -r .warehouse)

pwd
echo "Building ${DockerRepository}:${CurrentRevision}"
docker build \
    -t ${DockerRepository}:${CurrentRevision} \
    --build-arg SNOWFLAKE_ACCOUNT=$SnowflakeAccount \
    --build-arg DBT_SNOWFLAKE_DATABASE=$SnowflakeDatabase \
    --build-arg DBT_SNOWFLAKE_SCHEMA=test \
    --build-arg SNOWFLAKE_USER=$SnowflakeUser \
    --build-arg SNOWFLAKE_PASSWORD=$SnowflakePassword \
    --build-arg SNOWFLAKE_WAREHOUSE=$SnowflakeWarehouse \
    .
popd
