# Modules

This module is using a custom R package we created with the Databricks JDBC driver: https://github.com/the-tobias-project/databricks-jdbc
Driver from: https://www.databricks.com/spark/jdbc-drivers-download

# Installation

The structure of the directory would be the location of the corresponding folders in the cluster. Check it with the "tree" command.


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
