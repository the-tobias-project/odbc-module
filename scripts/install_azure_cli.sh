
#!/usr/bin/env bash

set -eo pipefail

module load python/3.9.0
curl -L https://aka.ms/InstallAzureCli | bash
module unload python/3.9.0