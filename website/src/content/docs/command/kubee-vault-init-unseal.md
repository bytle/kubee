---
title: kubee-vault-init-unseal | Init and unseal and vault
---

[//]: # (% kubee-vault-init-unseal&#40;1&#41; Version Latest | Init and unseal and vault)

## DESCRIPTION

`kubee-vault-init-unseal`  will [init](https://developer.hashicorp.com/vault/docs/commands/operator/init)
a fresh vault installation.

It will execute all needed operations in the pod:

* namespace: `vault`
* pod name: `vault-0`

The script will create 3 files locally:

* `vault_init_output.txt`: the output of the init operations
* `unseal_keys.txt`: the unseal keys
* `root_token.txt`: the root token

You need to put them in your secret store so that you can unseal the vault
manually every time it's restarted.
