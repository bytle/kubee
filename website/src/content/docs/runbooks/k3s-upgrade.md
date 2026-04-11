---
title: How to upgrade K3s
---

## About

This page shows you how to upgrade [k3s](../k3s/index.md) on your cluster.

## Steps

### Take a backup of your cluster datastore

Below is with a [sqlite datastore](../k3s/datastore-sqlite.md)
(For other datastore, see [datastore backup](../k3s/backup.md#backup))

* Check the db files

```bash
du -sh /var/lib/rancher/k3s/server/db/*
```

The three files together form a single logical database:

* state.db — the main database (maybe behind the WAL)
* state.db-wal — committed transactions not yet checkpointed back into the main file
* state.db-shm — shared memory index for the WAL (can be reconstructed, but include it anyway)

* Stop k3s

```bash
systemctl stop k3s
```

* Check that no running process uses the db, no output

```bash
lsof /var/lib/rancher/k3s/server/db/state.db
``` 

* Checkpoint to integrate the wal in the db

```bash
sqlite3 state.db "PRAGMA wal_checkpoint(TRUNCATE);"
# only one file now
du -sh /var/lib/rancher/k3s/server/db/*
```

* backup

```bash
cp /var/lib/rancher/k3s/server/db/state.db /var/lib/rancher/k3s/server/db/state.$(date +%Y%m%d_%H%M%S).db
```

* restart

```bash
systemctl start k3s
systemctl status k3s
```

### Choose the next minor version

#### Check the actual version

The one in:

* In your [cluster file](../cluster/cluster-values.md)

```yaml
k3s_ansible:
  # https://github.com/k3s-io/k3s/releases
  version: 'v1.34.6+k3s1'
  token: '${KUBEE_INFRA_K3S_TOKEN}'
```

* should be the same on the server

```bash
k3s --version
```

#### Version

Kubernetes versions are expressed as x.y.z, where

* x is the major version,
* y is the minor version,
* and z is the patch version.

In Kubernetes versioning v1.32.2:

* 1 = major version
* 32 = minor version
* 2 = patch version

#### Don't mess with the Skew Policy

K3s follows
the [Kubernetes version skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order),
which requires that you not skip intermediate minor versions when upgrading K3s.
The policy for all Kubernetes distributions is to take single steps between minor versions - no skipping minors.

Skipping MINOR versions when upgrading is unsupported.
Ensure that your plan does not skip intermediate minor versions when upgrading.
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

The "don't skip intermediate minor versions" rule means:

* ❌ Don't go from 1.32.x → 1.34.x (skipping 1.33)
* ✅ Do go from 1.32.x → 1.33.x → 1.34.x (one minor version at a time)

### Go check the next minor version

https://github.com/k3s-io/k3s/releases

### Set the version in your cluster file

Set the version in your [cluster file](../cluster/cluster-values.md)

Example:

```yaml
k3s_ansible:
  # https://github.com/k3s-io/k3s/releases
  version: 'v1.35.3+k3s1'
  token: '${KUBEE_INFRA_K3S_TOKEN}'
```

### Execute the cluster upgrade

Execute the cluster upgrade with the default [cluster chart](../helmet/cluster-chart.md)

```bash
kubee --cluster clusterName cluster upgrade
# same as
# kubee --cluster clusterName --cluster-chart k3s-ansible cluster upgrade
```

### Check the connection

```bash
kubee kubectl cluster-info
```

## Support

### Downgrade not supported, only rollback

`k3s` does [not support any downgrade](https://docs.k3s.io/upgrades/automated#downgrade-prevention),
but you [can roll back](https://docs.k3s.io/upgrades/roll-back)

If you cannot restore the database, you cannot roll back to a previous minor version.

See [k3s-backup](../k3s/backup.md)
