
#!/usr/bin/env bash

set -eo pipefail

module --ignore_cache load python/3
pip install databricks-cli