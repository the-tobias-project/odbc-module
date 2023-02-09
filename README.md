# ODBC module

This module is using a custom R package we created with Databricks ODBC driver.

The deb driver includes an md5 sum per file, that was the option in comparison with the rpm file that only has a 256 sum for the whole directory.
Driver from: https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-Debian-64bit.zip


# Installation

Run:

```bash
git clone https://github.com/the-tobias-project/odbc-module
cd odbc-module
make configure
```

Here, fill in the values in the .env file, then:

```bash
make install
```

## NOTE:
The raw odbc module can be downloaded from https://www.databricks.com/spark/odbc-drivers-download, or with

```bash
wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
```

- WARNING: sha256 sum does not mach with the provided digest

```bash
echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" | sha256sum --check

SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

This will download the ODBC driver and configure the system for the corresponding cluster/user using tho files at $HOME: .odbc.ini and .odbcinst.ini. The installation process creates a series of directories. 


## Problems in on demand sessions

This is visible oafter loading the odbc driver in the terminal session:

```bash
[learoser@sh03-ln02 login ~]$ whereis libodbc.so.2
libodbc.so: /usr/lib64/libodbc.so /usr/lib64/libodbc.so.2
```

However this is not visible in the on demand session. With the unixodbc library loaded. 


This package includes the unixodbc library and is setting this variable:

```bash
export LD_LIBRARY_PATH=/home/users/learoser/odbc-module/driver/unixODBC-2.3.11/DriverManager/.libs
```

However this does not appears to modify the above result. 


## Module structure (pre-install)

```bash
├── get_databricks_driver.sh
├── install.sh
├── README.md
└── software
    ├── modules
    │   └── contribs
    │       ├── databricks-jdbc
    │       │   └── 4.2.0.lua
    │       └── databricks-odbc
    │           └── 4.2.0.lua
    └── user
        └── open
            ├── databricks-jdbc
            │   └── 4.2.0
            │       └── lib
            │           └── DatabricksJDBC42.jar
            └── databricks-odbc
                └── 4.2.0
                    ├── conf
                    │   ├── odbc.ini
                    │   └── odbcinst.ini
                    └── lib
                        └── 64
                        
```


## Post install

```bash
├── driver
│   ├── DatabricksJDBC42-2.6.32.1054.zip
│   └── SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
├── get_databricks_driver.sh
├── install.sh
├── README.md
└── software
    ├── modules
    │   └── contribs
    │       ├── databricks-jdbc
    │       │   └── 4.2.0.lua
    │       └── databricks-odbc
    │           └── 4.2.0.lua
    └── user
        └── open
            ├── databricks-jdbc
            │   └── 4.2.0
            │       └── lib
            │           └── DatabricksJDBC42.jar
            └── databricks-odbc
                └── 4.2.0
                    ├── conf
                    │   ├── odbc.ini
                    │   └── odbcinst.ini
                    └── simba
                        └── spark
                            ├── ErrorMessages
                            │   └── en-US
                            │       ├── DSMessages.xml
                            │       ├── DSOAuthMessages.xml
                            │       ├── ODBCMessages.xml
                            │       ├── SparkODBCMessages.xml
                            │       ├── SQLEngineMessages.xml
                            │       └── ThriftExtensionMessages.xml
                            ├── EULA.txt
                            ├── lib
                            │   └── 64
                            │       ├── cacerts.pem
                            │       ├── libsparkodbc_sb64.so
                            │       ├── simba.sparkodbc.ini
                            │       └── SparkODBC.did
                            ├── release-notes.txt
                            ├── Setup
                            │   ├── odbc.ini
                            │   └── odbcinst.ini
                            ├── Simba\ Apache\ Spark\ ODBC\ Connector\ Install\ and\ Configuration\ Guide.pdf
                            └── third-party-licenses.txt
```

## Usage


In the .env, fill in the parameters:

```
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=
DATABRICKS_PORT=
```

Then activate direnv:

```bash
source .bashrc
direnv allow
```

The module will unload R and load module unixodbc/2.3.9. It was observed that with R loaded, the install procedure fails.

Check that the modules are available now:

```bash
[learoser@sh02-ln01 login ~]$ module spider | grep databricks
contribs/databricks-jdbc: contribs/databricks-jdbc/4.2.0
contribs/databricks-odbc: contribs/databricks-odbc/4.2.0
```

Then in R:

```r
library(loaddatabricks)
con <- connect_cluster()
```

```r
dbListTables(con)
```