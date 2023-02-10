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

app.conf = pathJoin(app.root, "conf")
app.lib  = pathJoin(app.root, "simba/spark/lib")


-- dependencies
depends_on("R/4.2.0")
depends_on("system")
depends_on("unixodbc/2.3.9")
depends_on("spark/3.2.1")


-- module info
whatis("Name:        " .. pkg.name)
whatis("Version:     " .. pkg.version)
whatis("Category:    " .. "")
whatis("URL:         " .. "https://github.com/the-tobias-project/databricks-connector")
whatis("Description: " .. "Module to make Databricks ODBC available for R.")

-- module help
help("https://www.sherlock.stanford.edu/docs/software/using/" .. pkg.name)
