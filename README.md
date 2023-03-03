# ODBC module - Working on command line and on-demand sessions


This module is using unixODBC, SimbaSpark ODBC driver (provided by Databricks as RPM package) and a custom R package that allows to connect R to databricks via ODBC. 

## Changelog

Please visit https://github.com/the-tobias-project/odbc-module/wiki 



## Repository structure


### Repository home: https://github.com/the-tobias-project/odbc-module 


├── driver
│   ├── SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
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



The install process will generate:

.Renviron in $HOME  (created if it does not exist, RLIB set up if exists)

.env file with environmental variables. These are loaded via lines of code added to ~/.bashrc. The install process is reversible running: make clean. 

The “software” directory will be fill in. The structure will correspond to the structure of modules for Sherlock. At higher level, this is the structure:



 ├── modules 
   │   └── contribs 
   │       └── databricks-odbc 
   │           └── 4.2.0.lua 
   └── user 
       └── open 
           └── databricks-odbc 
               └── 4.2.0 
                   ├── conf 
                   │   ├── odbc.ini 
                   │   └── odbcinst.ini 
                   └── simba



Note that during configuration, this variable is set: 

MODULEPATH=$MODULEPATH:${THISPATH}/software/modules/

So, this is allowing to make the module visible to the system.



### Dependencies:

R/4.2.0

system

unixodbc/2.3.9

spark/3.2.1



As included in the module lua file itself: https://github.com/the-tobias-project/odbc-module/blob/main/software/modules/contribs/databricks-odbc/4.2.0.lua 

## Installation



In your $HOME in Sherlock run:

```bash
git clone https://github.com/the-tobias-project/odbc-module
cd odbc-module
make
```

Here, fill in the values in the .env file at $HOME:

```bash
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=
DATABRICKS_PORT=
```

Then run:

```bash
make install check=false
```

This will configure the system for the corresponding cluster/user using tho files at $HOME: .odbc.ini and .odbcinst.ini. No special permissions needed. The installation process creates a series of directories. The module will first unload R and load module unixodbc/2.3.9. It was observed that with R loaded, the install procedure fails. Then install the deps.

This will also install the loaddatabricks package: https://github.com/the-tobias-project/loaddatabricks 

Check that the modules are available now:

```bash
[learoser@sh02-ln01 login ~]$ module spider | grep databricks
contribs/databricks-odbc: contribs/databricks-odbc/4.2.0
```


Load the module:

```bash
[learoser@sh02-ln01 login ~]$ module load contribs/databricks-odbc/4.2.0
[learoser@sh02-ln01 login ~]$ cd $HOME # here loading .Renviron
```


Then in R:

```bash
library(loaddatabricks)
con <- connect_cluster()

dbListTables(con)
```

Problems in on demand sessions for previous versions of this package

This was visible after loading the odbc driver in the terminal session:

```bash
[learoser@sh03-ln02 login ~]$ whereis libodbc.so.2
libodbc.so: /usr/lib64/libodbc.so /usr/lib64/libodbc.so.2
```

However this is not visible in the on demand session. With the unixodbc library loaded. 

This package includes the unixodbc library and is setting this variable:

export LD_LIBRARY_PATH=/home/users/learoser/odbc-module/driver/unixODBC-2.3.11/DriverManager/.libs

However this does not appears to modify the above result. 

The solution I found was to add to the R code the following:

```bash
    dyn.load(paste0(odbc_module_path, "/odbc-module/driver/unixODBC-2.3.11/odbcinst/.libs/libodbcinst.so"),
             now=TRUE)
    dyn.load(paste0(odbc_module_path, "/odbc-module/driver/unixODBC-2.3.11/DriverManager/.libs/libodbc.so.2"),
             now=TRUE)
  }
```

The code is here: https://github.com/the-tobias-project/loaddatabricks/blob/main/R/connect_databricks.R 

This is hardcoded and might not be ideal. But it is a solution that works in the on-demand sessions. 



## NOTES FOR ON-DEMAND SESSIONS

Use R 4.2.0 and contribs/databricks-odbc/4.2.0. The solutions is currently hardcoded to this R version. Future versions might need to take into account versioning of the odbc R package (I tested other versions and the package had major changes from version 1.2.2 https://cran.r-project.org/src/contrib/Archive/odbc/), etc.  



## ADDITIONAL NOTES

The raw odbc module can be downloaded from https://www.databricks.com/spark/odbc-drivers-download,  or with

```bash
wget <https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip>
```

But we got this error: WARNING: sha256 sum does not mach with the provided digest

```bash
echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" | sha256sum --check

SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

So the sha256sum does not match. See below the options 'make install check=false' to not take into account this during install.


During install, running:

```bash
make install
```

without check=false, will stop the install process if the hash of the sha256 sum does not match with the provided for odbc and simbaspark libraries. That is the current case, and is a problem with the driver provide
