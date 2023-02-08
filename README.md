# Modules

This module is using a custom R package we created with Databricks JDBC and ODBC drivers: https://github.com/the-tobias-project/databricks-jdbc
Driver from: https://www.databricks.com/spark/jdbc-drivers-download


# Installation

Run:


```bash
bash install.sh
```

This will download the ODBC driver and configure the folders. There will be a software folder at $HOME in addition to tho files: .odbc.ini and .odbcinst.ini. 


## Module structure

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


## Usage

This module requires five parameters: address, port, organization, cluster and token. These could be extracted from the databricks url as follows:

Go to compute > cluster in databricks, and select the cluster, then collect the following field:

https://adb-12345.azuredatabricks.net/?o=6789#setting/clusters/abcd/configuration


```
address: adb-12345.azuredatabricks.net
port: 443
organization: 6789
cluster: abcd
```

Excepting the port (443), the other values were set randomly just to show an example.

Then with this module loaded, use the following function in your R session:


```r
library(loaddatabricks)
connection <- databricks_jdbc(address="adb-xxxx.azuredatabricks.net", port = "443", organization = "xxxx", cluster = "xxxx", token="xxxx")
```

```r
dbReadTable(connection, "tobias.shinyapp_input")
```


```