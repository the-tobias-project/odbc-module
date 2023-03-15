libsdir <- Sys.getenv("R_LIBS_USER")
dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
install.packages(c('DBI', 'odbc', 'dotenv'), repos='http://cran.us.r-project.org', lib=libsdir)