#!/bin/bash
set -ex

# This script prepares the customised Keycloak package for deployment
#
# The working directory should be the git root

CONFIG_PATH=./keycloak/configuration
ARTIFACT_PATH=./keycloak/artifacts
PACKAGE_PATH=./keycloak/package

mkdir -p $ARTIFACT_PATH
mkdir -p $PACKAGE_PATH

# Download and unpack Keycloak
curl -Lo $ARTIFACT_PATH/keycloak.tar.gz https://downloads.jboss.org/keycloak/4.3.0.Final/keycloak-4.3.0.Final.tar.gz
tar -xzf $ARTIFACT_PATH/keycloak.tar.gz --directory $PACKAGE_PATH --strip 1


# Download and add PostgreSQL JDBC driver
curl -Lo $ARTIFACT_PATH/postgresql-42.2.5.jar https://jdbc.postgresql.org/download/postgresql-42.2.5.jar

mkdir -p $PACKAGE_PATH/modules/system/layers/keycloak/org/postgresql/main
cp $ARTIFACT_PATH/postgresql-42.2.5.jar $PACKAGE_PATH/modules/system/layers/keycloak/org/postgresql/main/postgresql-42.2.5.jar
cp $CONFIG_PATH/postgresql-module.xml $PACKAGE_PATH/modules/system/layers/keycloak/org/postgresql/main/module.xml


# Copy across the modified configuration files (enabling proxy address forwarding and configuring the PostgreSQL datasource)
cp $CONFIG_PATH/standalone.xml $PACKAGE_PATH/standalone/configuration/standalone.xml
cp $CONFIG_PATH/standalone-ha.xml $PACKAGE_PATH/standalone/configuration/standalone-ha.xml


# Copy across the initial setup configuration file to be imported on first launch
cp $CONFIG_PATH/initial-setup.json $PACKAGE_PATH
