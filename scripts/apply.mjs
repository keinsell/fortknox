#!/usr/bin/env zx

import "zx/globals";

await $`terraform -chdir=./terraform apply `;
