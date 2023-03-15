libsdir <- Sys.getenv("R_LIBS_USER")
package_manager <- Sys.getenv("PACKAGE_MANAGER")
dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
install.packages(c('DBI', 'odbc', 'dotenv'), repos=package_manager, lib=libsdir)