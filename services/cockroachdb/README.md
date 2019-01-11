# CockroachDB

Deploy CockroachDB:

        $ ./k8s/scripts/kube-infra.sh -c minikube -e local -a create -s cockroachdb
        KUBECONFIG=./k8s/minikube/kube-config kubectl get svc -n pilotariak-dev
        NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
        cockroachdb          ClusterIP   None            <none>        26257/TCP,8080/TCP   3m57s
        cockroachdb-public   ClusterIP   10.109.84.236   <none>        26257/TCP,8080/TCP   3m57s

        $ KUBECONFIG=./k8s/minikube/kube-config kubectl get pod -n pilotariak-dev
        NAME                 READY   STATUS      RESTARTS   AGE
        cluster-init-4dvbk   0/1     Completed   0          3m8s
        cockroachdb-0        1/1     Running     0          4m9s
        cockroachdb-1        1/1     Running     0          4m9s
        cockroachdb-2        1/1     Running     0          4m9s

Check Admin UI with port-forward to one of the pods:

        $ KUBECONFIG=./k8s/minikube/kube-config kubectl port-forward cockroachdb-0 8080 -n pilotariak-dev

Then go to http://localhost:8080

A service is provided to expose CockroachDB outside minikube cluster :

        $ export MINIKUBE_IP=$(KUBECONFIG=./k8s/minikube/kube-config minikube ip -p pilotariak)
        $ ./sql/cockroach sql --insecure --host ${MINIKUBE_IP}:30257
        # Welcome to the cockroach SQL interface.
        # All statements must be terminated by a semicolon.
        # To exit: CTRL + D.
        #
        # Server version: CockroachDB CCL v2.1.3 (x86_64-unknown-linux-gnu, built 2018/12/17 19:15:31, go1.10.3) (same version as client)
        # Cluster ID: 74350f7f-35f5-4789-aa65-7fde11afa696
        No entry for terminal type "xterm-256color";
        using dumb terminal settings.
        #
        # Enter \? for a brief introduction.
        #

Create database and user :

        root@192.168.99.101:30257/defaultdb> CREATE DATABASE IF NOT EXISTS pilotariak;
        CREATE DATABASE

        Time: 2.197243ms

        root@192.168.99.101:30257/defaultdb> SHOW DATABASES;
        database_name
        +---------------+
        defaultdb
        pilotariak
        postgres
        system
        (4 rows)

        Time: 3.352304ms

        root@192.168.99.101:30257/defaultdb> CREATE USER IF NOT EXISTS trinquet WITH PASSWORD 'trinquet';
        pq: cluster in insecure mode; user cannot use password authentication
        root@192.168.99.101:30257/defaultdb> CREATE USER IF NOT EXISTS trinquet ;
        CREATE USER 1

        Time: 7.52018ms

        root@192.168.99.101:30257/defaultdb> GRANT CREATE ON DATABASE pilotariak TO trinquet;
        GRANT

        Time: 16.082208ms

        root@192.168.99.101:30257/defaultdb> SHOW GRANTS ON DATABASE pilotariak;
        database_name |    schema_name     | grantee  | privilege_type
        +---------------+--------------------+----------+----------------+
        pilotariak    | crdb_internal      | admin    | ALL
        pilotariak    | crdb_internal      | root     | ALL
        pilotariak    | crdb_internal      | trinquet | CREATE
        pilotariak    | information_schema | admin    | ALL
        pilotariak    | information_schema | root     | ALL
        pilotariak    | information_schema | trinquet | CREATE
        pilotariak    | pg_catalog         | admin    | ALL
        pilotariak    | pg_catalog         | root     | ALL
        pilotariak    | pg_catalog         | trinquet | CREATE
        pilotariak    | public             | admin    | ALL
        pilotariak    | public             | root     | ALL
        pilotariak    | public             | trinquet | CREATE
        (12 rows)

        Time: 5.996625ms

