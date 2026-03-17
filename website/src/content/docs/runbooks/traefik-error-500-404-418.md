---
title: Traefik Error
---

## Error 500

500 are really difficult to debug.

Possible solutions

* Restart the auth proxy.
  If you get a 500 on a Ingress that has an auth middleware such as Oauth2, it may be caused by a
  bad certificate. The certificate is renewed but if the Oauth2 is not restarted, the old cert is still active.

## Why a 404?

* Check the traefik dashboard for any middleware problem

## Why a 418?

The `noop@internal` returns a 418 per default.

It happens when your middlewares on your route does not apply.

