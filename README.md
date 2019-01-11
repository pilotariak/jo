# Pilotariak / Jo

[![License Apache 2][badge-license]](LICENSE)

## Development

### Kubernetes / Minikube

* Install Kubernetes tools (`minikube` and `kubectl` tools):

        $ make init

* Create the Kubernetes development cluster with minikube:

        $ make minikube-start
        $ make minikube-status
        $ make minikube-dashboard

### Database

* Install tools (`migrate` and `schemacrawler`):

        $ make init


## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE](LICENSE) for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>

[badge-license]: https://img.shields.io/badge/license-Apache2-green.svg?style=flat
