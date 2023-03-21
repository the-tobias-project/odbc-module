
#!/usr/bin/env bash

set -eo pipefail

module load python/3.6.1
curl -L https://aka.ms/InstallAzureCli | bash
module unload python/3.6.1