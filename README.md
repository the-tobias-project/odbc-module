

ODBC module - Working on command line and on-demand sessions
============================================================

This module is using unixODBC, SimbaSpark ODBC driver (provided by Databricks as RPM package) and a custom R package that allows to connect R to databricks via ODBC.


*   1 [Installation](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Installation)
    *   1.1 [Individual users](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Individualusers)
    *   1.2 [Groups](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Groups)
        *   1.2.1 [Group level steps](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Grouplevelsteps)
        *   1.2.2 [User level steps](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Userlevelsteps)
*   2 [Uninstall](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Uninstall)
    *   2.1 [Individual users](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Individualusers.1)
    *   2.2 [Groups](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Groups.1)
        *   2.2.1 [Group level steps](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Grouplevelsteps.1)
        *   2.2.2 [User level steps](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Userlevelsteps.1)
*   3 [Repository structure](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Repositorystructure)
*   4 [Dependencies](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Dependencies)
*   5 [Notes](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Notes)
    *   5.1 [Problems in on demand sessions for previous versions of this package](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Problemsinondemandsessionsforpreviousversionsofthispackage)
    *   5.2 [Problems related to hash sum checking](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Problemsrelatedtohashsumchecking)
    *   5.3 [Package limitations](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Packagelimitations)
*   6 [Changelog](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Changelog)
*   7 [Troubleshoot](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Troubleshoot)

Installation
============

Individual users
----------------

1.  In your $HOME in Sherlock run:
    

`git clone https:``//github``.com``/the-tobias-project/odbc-module`

`cd` `odbc-module`

`make` `install` `check=``false`

The command will configure the system for the corresponding cluster/user using tho files at `~/odbc-module`: odbc.ini and odbcinst.ini. No special permissions needed. It also compiles the drivers among other tasks. The module will first unload R and load module unixodbc/2.3.9. It was observed that with R loaded, the install procedure fails. Then install the deps.

This will also install the loaddatabricks package: [https://github.com/the-tobias-project/loaddatabricks](https://github.com/the-tobias-project/loaddatabricks)

Check that the modules are available now:

`module spider |` `grep` `databricks`

`contribs``/databricks-odbc``: contribs``/databricks-odbc/4``.2.0`

2\. Then configure the Databricks credentials:

`make` `configure group=``false`

`source` `~/.bashrc`

If this worked, the following command should not return an empty result:

`echo $R_LIBS_USER`

For example:

`[learoser@sh02-ln01 login ~/odbc-module]$ echo $R_LIBS_USER`  
`/home/users/learoser/odbc-module/R/x86_64-pc-linux-gnu-library/4.2`  

Here, fill in the values in the .env file at $HOME (eg, run: nano ~/.env)

`DATABRICKS_HOSTNAME=`

`DATABRICKS_TOKEN=`

`DATABRICKS_HTTP_PATH=`

`DATABRICKS_PORT=`

And finally generate the ~/.odbc.ini and ~/.odbcinst.ini files:

`make setenv group=``false`

3\. Load the module and start an R session:

`[learoser@sh02-ln01 login ~]$ module load contribs``/databricks-odbc/4``.2.0`

`[learoser@sh02-ln01 login ~]$ R`

Then in R:

`library(loaddatabricks)`

`con <- connect_cluster(``"~/.env"``)`

`library(DBI)`

`dbListTables(con) # your tables should be visible` `if` `properly configured`

Groups
------

### Group level steps

1.  In your groups folder in Sherlock, i.e., /home/groups/$(id -ng), run:
    

`git clone https:``//github``.com``/the-tobias-project/odbc-module`

`cd` `odbc-module`

`make` `install` `check=``false`

Check that the modules are available now:

`[learoser@sh02-ln01 login ~]$ module spider |` `grep` `databricks`

`contribs``/databricks-odbc``: contribs``/databricks-odbc/4``.2.0`

### User level steps

2\. Then, each $USER should configure the module with their credentials. For this, the user should run in his $HOME in Sherlock:

`git clone https:``//github``.com``/the-tobias-project/odbc-module`

`cd` `odbc-module`

`make` `configure group=``true`

`source` `~/.bashrc`

If this worked, the following command should not return an empty result:

`echo $R_LIBS_USER`

For example:

`[learoser@sh02-ln01 login ~/odbc-module]$ echo $R_LIBS_USER`  
`/home/users/learoser/odbc-module/R/x86_64-pc-linux-gnu-library/4.2`

Here, the $USER should fill in the values in the .env file at $HOME (eg, run: nano ~/.env)

`DATABRICKS_HOSTNAME=`

`DATABRICKS_TOKEN=`

`DATABRICKS_HTTP_PATH=`

`DATABRICKS_PORT=`

And finally generate the ~/.odbc.ini and ~/.odbcinst.ini files:

`make setenv group=``true`

3\. Load the module and start an R session:

`[learoser@sh02-ln01 login ~]$ module load contribs``/databricks-odbc/4``.2.0`

`[learoser@sh02-ln01 login ~]$ R`

Then in R:

`library(loaddatabricks)`

`con <- connect_cluster(``"~/.env"``)`

`library(DBI)`

`dbListTables(con) # your tables should be visible` `if` `properly configured`

Uninstall
=========

Individual users
----------------

In the folder, run:

`make clean`

`source ~/.bashrc`

`cd .. && rm -rf odbc-module`

Groups
------

### Group level steps

Remove the odbc-module folder:

`rm -rf odbc-module`

### User level steps

In the $HOME folder of the $USER, run:

`make clean`

`source ~/.bashrc`

`cd .. && rm -rf odbc-module`

Repository structure
====================

Repository home: [https://github.com/the-tobias-project/odbc-module](https://github.com/the-tobias-project/odbc-module)

`├── driver`

`│   ├── SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip`

`│   ├── unixODBC-2.3.11.``tar``.gz`

`│   └── unixODBC-2.3.11.``tar``.gz.md5`

`├── Makefile`

`├── README.md`

`├── scripts`

`│   ├── configure.sh`

`│   └──` `install``.sh`

`└── software`

`├── modules`

`└── user`

The install process will generate:

1.  .env file with environmental variables. These are loaded via lines of code added to ~/.bashrc. The install process is reversible running: make clean.
    
2.  The “software” directory will be fill in. Two libraries are compiled:
    
    1.  **unixODBC** and **Simba Spark** (the databricks driver). There is an explanation here [https://cancerdataplatform.atlassian.net/wiki/spaces/DSI/pages/17006634/ODBC+module+-+Working+on+command+line+and+on-demand+sessions#Problems-in-on-demand-sessions-for-previous-versions-of-this-package](ODBC-module---Working-on-command-line-and-on-demand-sessions.17006634.html#ODBCmodule-Workingoncommandlineandon-demandsessions-Problems-in-on-demand-sessions-for-previous-versions-of-this-package) regarding the need of unixODBC.
        
    2.  In addition, a custom R package (**loaddatabricks)** is installed along its dependencies: [https://github.com/the-tobias-project/loaddatabricks](https://github.com/the-tobias-project/loaddatabricks). This packages includes a connector to databricks using the different components of this module.
        

The structure of the folders in “software” corresponds to the canonical structure of modules for Sherlock. At higher level, this is the structure:

 `├── modules`  
   `│   └── contribs`  
   `│       └── databricks-odbc`  
   `│           └── 4.2.0.lua`  
   `└── user`  
       `└── open`  
           `└── databricks-odbc`  
               `└── 4.2.0`  
                   `├── conf`  
                   `│   ├── odbc.ini`  
                   `│   └── odbcinst.ini`  
                   `└── simba`

Note that during configuration, this variable is set:

`MODULEPATH=$MODULEPATH:${THISPATH}/software/modules/`

So, this is allowing to make the module visible to the system.

Dependencies
============

*   R/4.2.0
    
*   system
    
*   unixodbc/2.3.9
    
*   spark/3.2.1
    

As included in the module lua file itself: [https://github.com/the-tobias-project/odbc-module/blob/main/software/modules/contribs/databricks-odbc/4.2.0.lua](https://github.com/the-tobias-project/odbc-module/blob/main/software/modules/contribs/databricks-odbc/4.2.0.lua)

For the loaddatabricks package [https://github.com/the-tobias-project/loaddatabricks](https://github.com/the-tobias-project/loaddatabricks), dependencies are the R packages DBI, odbc and dotenv.

Notes
=====

A summary of different issues that were solved during the generation of this library.

Problems in on demand sessions for previous versions of this package
--------------------------------------------------------------------

This was visible after loading the odbc driver in the terminal session:

`[learoser@sh03-ln02 login ~]$` `whereis` `libodbc.so.2`

`libodbc.so:` `/usr/lib64/libodbc``.so` `/usr/lib64/libodbc``.so.2`

However this is not visible in the on demand session with the unixodbc module loaded, but visible on a command line session (maybe a bug?) .

This package includes the unixodbc library and is setting this variable:

`export` `LD_LIBRARY_PATH=``/home/users/learoser/odbc-module/driver/unixODBC-2``.3.11``/DriverManager/``.libs`

However this does not appears to modify the above result.

The solution I found was to add to the R code the following:

`dyn.load(paste0(odbc_module_path,` `"/odbc-module/driver/unixODBC-2.3.11/odbcinst/.libs/libodbcinst.so"``),`

`now=TRUE)`

`dyn.load(paste0(odbc_module_path,` `"/odbc-module/driver/unixODBC-2.3.11/DriverManager/.libs/libodbc.so.2"``),`

`now=TRUE)`

`}`

The code is here: [https://github.com/the-tobias-project/loaddatabricks/blob/main/R/connect\_databricks.R](https://github.com/the-tobias-project/loaddatabricks/blob/main/R/connect_databricks.R)

This is hardcoded and might not be ideal. But it is a solution that works in the on-demand sessions.

Problems related to hash sum checking
-------------------------------------

The raw odbc module can be downloaded from [https://www.databricks.com/spark/odbc-drivers-download,](https://www.databricks.com/spark/odbc-drivers-download,) or with

`wget <https:``//databricks-bi-artifacts``.s3.us-east-2.amazonaws.com``/simbaspark-drivers/odbc/2``.6.29``/SimbaSparkODBC-2``.6.29.1049-LinuxRPM-64bit.zip>`

But we got this error: WARNING: sha256 sum does not mach with the provided digest

`echo` `"ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2 SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip"` `| sha256sum --check`

`SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip: FAILED`

`sha256sum: WARNING: 1 computed checksum did NOT match`

So the sha256sum does not match. See below the options 'make install check=false' to not take into account this during install.

* * *

During install, running:

`make` `install`

without check=false, will stop the install process if the hash of the sha256 sum does not match with the provided for odbc and simbaspark libraries. That is the current case, and is a problem with the driver provider.

Package limitations
-------------------

→ Currently the installation is available at the user level

→ Use R 4.2.0 and the module: contribs/databricks-odbc/4.2.0. The solutions is currently hardcoded to this R version. This provides a stable solution that can be sequentially improved/extended. Future versions might need to take into account versioning of the odbc R package (tested other versions and the package had major changes from version 1.2.2 [https://cran.r-project.org/src/contrib/Archive/odbc/)](https://cran.r-project.org/src/contrib/Archive/odbc/),). So there would be at least two stable releases (pre and post 1.2.2), and other edge cases probably to take into account.

Changelog
=========

Please visit [https://github.com/the-tobias-project/odbc-module/wiki/Changelog](https://github.com/the-tobias-project/odbc-module/wiki/Changelog)

Troubleshoot
============

1.  Running this step in R (installlation step #6) Results in an error message:
    
    `library(loaddatabricks)`
    
    `con <- connect_cluster(``"~/.env"``)`
    

`Error: nanodbc/nanodbc.cpp:1118: 00000: [Simba][ThriftExtension] (14) Unexpected response from server during a HTTP connection: Could not resolve host for client socket..`

**Solution**: check that the values in ~/.env for the following variables are correct. They should look like this:

`DATABRICKS_HOSTNAME=adb-xxxxxxx.x.azuredatabricks.net`

`DATABRICKS_TOKEN=dapixxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

`DATABRICKS_HTTP_PATH=sql/protocolv1/o/xxxxxxxxxxx/xxxx-xxxxx-xxxxxxx`

`DATABRICKS_PORT=``443`

Where xx… should be replaced for the actual values of your environment.

The information can be extracted in databricks from: compute > <your cluster> > Advanced options > JDBC/ODBC

If make install was run, you can reconfigure the driver with:

`make setenv`

2\. I need to reinstall the module

**Solution**: If downloaded, you can run:

`make uninstall`

This will revert the module folder to the initial state. Then proceed again with the installation
