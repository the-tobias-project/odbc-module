
#!/usr/bin/env bash

set -eo pipefail

module load python/3.6.1
pip install databricks-cli
module unload python/3.6.1