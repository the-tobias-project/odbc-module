libsdir <- Sys.getenv("R_LIBS_USER")
dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
install.packages("devtools")
package_manager <- "https://packagemanager.rstudio.com/cran/__linux__/centos7/latest"
devtools::install(c('DBI', 'odbc', 'dotenv'), repos=package_manager, lib=libsdir)