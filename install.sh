#!/bin/bash

module use --append $PWD/software/modules/contribs
echo "DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar" >> ~/.Renviron
source ~/.bashrc
echo "Databricks module installed succesfully!"