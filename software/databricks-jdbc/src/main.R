databricks_factory <- function(location) {
  force(location)
  function(adress, port, organization, cluster, token) {
    driver <- RJDBC::JDBC(driverClass = "com.databricks.client.jdbc.Driver",
                          classPath = sprintf("%s/DatabricksJDBC42.jar", location))
    conn <- DBI::dbConnect(driver,sprintf("jdbc:databricks://%s:%s/default;transportMode=http;ssl=1;httpPath=sql/protocolv1/o/%s/%s;AuthMech=3;UID=token;PWD=%s",
                                          adress, port, organization, cluster, token))
    con
  }
}