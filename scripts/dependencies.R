libsdir <- Sys.getenv("R_LIBS_USER")
Sys.setenv(TZ="America/Los_Angeles")
#dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
package_manager <- "https://cloud.r-project.org/"
install.packages(c('DBI', 'dotenv'), repos=package_manager, lib=libsdir, dependencies=TRUE)