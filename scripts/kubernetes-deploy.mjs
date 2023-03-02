#!/usr/bin/env zx

import "zx/globals";

await $`kubectl apply -f ./kubernetes/1_kubesphere-installer.yaml`;
await $`kubectl apply -f ./kubernetes/2_cluster-configuration.yaml`;
await $`kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f`;
