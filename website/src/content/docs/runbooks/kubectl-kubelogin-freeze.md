---
title: kubectl freeze with kubelogin 
---

## Problem

When trying to login with [kubelogin](config-kubelogin.md)

```bash
kubectl --user=oidc  cluster-info
```

`kubectl` may freeze.

## Solution

kubelogin needs the local port `8000` or `18000`
to [start a server](https://github.com/int128/kubelogin/blob/master/docs/usage.md#authorization-code-flow) to get back
the authorization code.

If the ports are used, the application may freeze.

* Check that the ports are not already used and kills the process.
* We can't change the port because they are registered and mandatory for the oauth flow.

