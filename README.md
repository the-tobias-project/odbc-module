# ODBC module - Working on command-line and on-demand sessions

This module is using a custom R package we created with Databricks ODBC driver.

The deb driver includes an md5 sum per file, that was the option in comparison with the rpm file that only has a 256 sum for the whole directory.
Driver from: https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-Debian-64bit.zip


# Installation

## NOTE

- You need to comment out line 21 of the script at scripts/install.sh:

```bash
sha256sum -c shasum | tee /dev/tty | grep "FAILED" && echo "MD5SUM DOES NOT MATCH FOR SimbaSparkODBC" && exit 1
```


The raw odbc module can be downloaded from https://www.databricks.com/spark/odbc-drivers-download, or with

```bash
wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
```

But we got this error: WARNING: sha256 sum does not mach with the provided digest

```bash
echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" | sha256sum --check

SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

## Installation instructions

Run:

```bash
git clone https://github.com/the-tobias-project/odbc-module
cd odbc-module
make
```

Here, fill in the values in the .env file:

```
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=
DATABRICKS_PORT=
```

Then run:

```bash
make install
```

This will stop the install process if the hash of the sha256 sum does not match with the provided for odbc and simbaspark libraries. If you don't want to check the hash of the files (due to the problem mentioned above), use:

```bash
make install check=false
```


This will download the ODBC driver and configure the system for the corresponding cluster/user using tho files at $HOME: .odbc.ini and .odbcinst.ini. The installation process creates a series of directories. The module will first unload R and load module unixodbc/2.3.9. It was observed that with R loaded, the install procedure fails. Then install the deps.

This will also install the loaddatabricks package: https://github.com/the-tobias-project/loaddatabricks



Check that the modules are available now:

```bash
[learoser@sh02-ln01 login ~]$ module spider | grep databricks
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


## Module structure

```bash
├── driver
│   ├── SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
│   ├── unixODBC-2.3.11
│   ├── unixODBC-2.3.11.tar.gz
│   └── unixODBC-2.3.11.tar.gz.md5
├── Makefile
├── README.md
├── scripts
│   ├── configure.sh
│   └── install.sh
└── software
    ├── modules
    └── user
```
       