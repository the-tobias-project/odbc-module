#!/bin/bash

git clone https://github.com/the-tobias-project/lua-modules
cd lua-modules 
module use --append $PWD/software/modules/contribs
export DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar