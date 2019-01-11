# Pilotariak / Jo

[![License Apache 2][badge-license]](LICENSE)

## Kubernetes / Minikube

* Install Kubernetes tools (`minikube` and `kubectl` tools):

        $ cd  make init

* Create the Kubernetes development cluster with minikube:

        $ make minikube-start
        $ make minikube-status
        $ make minikube-dashboard

* Create the namespace in minikube:

        $ KUBECONFIG=./minikube/kube-config kubectl apply -f ./local-namespace.yaml
        namespace/pilotariak-dev created

        $ KUBECONFIG=./minikube/kube-config kubectl get namespaces
        NAME             STATUS   AGE
        default          Active   51m
        kube-public      Active   51m
        kube-system      Active   51m
        pilotariak-dev   Active   25s

## Database tools

* Install tools (`migrate` and `schemacrawler`):

        $ cd sql && make init

## Services

Configure your `/etc/hosts` to access services :

        $ echo $(KUBECONFIG=./k8s/minikube/kube-config minikube ip -p pilotariak) cockroachdb.pilotariak.minikube | sudo tee -a /etc/hosts

* [CockroachDB](cockroachdb)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE](LICENSE) for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>

[badge-license]: https://img.shields.io/badge/license-Apache2-green.svg?style=flat
