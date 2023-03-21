
#!/usr/bin/env bash

set -eo pipefail

module load python/3.6.1
pip install databricks-cli
curl -L https://aka.ms/InstallAzureCli | bash