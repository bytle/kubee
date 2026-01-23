---
title: Helmet
---

`Helmet` is the chart manager of Kubee. It's wrapper around [helm](https://helm.sh/) ([v3 only](#helmet-v4-support)) that:

* adds support for the following configuration language:
  * [jsonnet](jsonnet-project.md)
  * and [kustomize](kustomize-project.md)
* drives the cluster command with a [cluster chart](cluster-chart.md)

## Kubee/Helmet Chart Definition

See [Helmet chart](helmet-chart.md)

## Dev Contrib - How it works?

### how to develop a helmet chart

See [helmet-chart-dev](helmet-chart-dev.md)

### how is the command implemented?

`Helmet` is implemented via the [kubee-helmet command](../command/kubee-helmet.md)

* that writes a `helm` command
* that calls the [kubee-helm-post-renderer](../command/kubee-helm-post-renderer.md)
* that supports [jsonnet](jsonnet-project.md) and [kustomize](kustomize-project.md)

## Support

### Helmet v4 support?

v3 is for now only supported
as [post-render are implemented as plugin in v4](https://helm.sh/docs/overview#post-renderers-implemented-as-plugins)