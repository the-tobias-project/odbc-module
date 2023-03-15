libsdir <- Sys.getenv("R_LIBS_USER")
dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
install.packages('odbc', repos='http://cran.us.r-project.org', lib=libsdir, type="source")
install.packages(c('DBI', 'dotenv'), repos='http://cran.us.r-project.org', lib=libsdir)