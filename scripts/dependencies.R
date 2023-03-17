libsdir <- Sys.getenv("R_LIBS_USER")
#dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
package_manager <- "https://cloud.r-project.org/"
install.packages(c('DBI', 'dotenv'), repos=package_manager, lib=libsdir, dep = TRUE)