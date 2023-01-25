-- -*- lua -*-
-- -- vim:ft=lua:et:ts=4

local pkg = {}
local app = {}

-- get module name/version and build paths
pkg.name = myModuleName()
pkg.version = myModuleVersion()
pkg.id = pathJoin(pkg.name, pkg.version)

-- open or restricted software
pkg.lic = "open"

-- app paths
app.root  = pathJoin("~/lua-modules/software/user/", pkg.lic, pkg.name, pkg.version)

app.src  = pathJoin(app.root, "src")
app.lib  = pathJoin(app.root, "lib")

-- dependencies
depends_on("spark/3.2.1")
depends_on("R/4.2.0")
depends_on("java/11.0.11")


local db_jar = pathJoin(app.lib, "DatabricksJDBC42.jar")

local r_script = [[
  install.packages(c("DBI", "RJDBC", "remotes"), repos="https://cloud.r-project.org/")
  remotes::install_github("the-tobias-project/loaddatabricks")
]]

os.execute("Rscript -e '" .. r_script .. "'")

-- set paths
--prepend_path("R_LIBS_USER ",            app.bin)
--prepend_path("LIBRARY_PATH",    app.lib)
--prepend_path("LD_LIBRARY_PATH", app.lib)

-- set env
pushenv("DATABRICKS_JAR",  db_jar)


-- module info
whatis("Name:        " .. pkg.name)
whatis("Version:     " .. pkg.version)
whatis("Category:    " .. "")
whatis("URL:         " .. "https://github.com/the-tobias-project/databricks-jdbc")
whatis("Description: " .. "Module to make Databricks JDBC available for R.")

-- module help
help("https://www.sherlock.stanford.edu/docs/software/using/" .. pkg.name)
