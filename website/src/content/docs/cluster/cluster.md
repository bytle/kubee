---
title: Kubee Cluster
---


A cluster is a directory that contains the following files:

* `.envrc`: the env file
* `values.yaml`: the [cluster values file](cluster-values.md)
  * Note: environment defined in `.envrc` can be referenced with the `${MY_ENV}` literal.

## How to

### Create a cluster

See [cluster creation](cluster-creation.md)

### Upgrade the cluster distribution

See [k3s upgrade](../k3s/upgrade.md)

## Dev Contribution

The implementation of kubernetes distribution command is done with a [cluster chart](../helmet/cluster-chart.md)