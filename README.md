kubernetes-for-botella
======================

This is a plugin for [botella](https://agonzalezro.github.io/botella/), it's a POC to show how to interact with a Kubernetes cluster with botella.

Usage
-----

If the only thing you want to do is running this with botella, you can use something like this yaml:

    $ cat botella.yaml
    adapters:
      - name: slack
        environment:
          key: xoxb-xxx

    plugins:
      - image: agonzalezro/kubernetes-for-botella
        environment:
          TOKEN:
          APISERVER:

As you can see I am not writing the secrets directly in the yaml, botella supports setting them with environment variables:

    $ export AGONZALEZRO_KUBERNETES_FOR_BOTELLA_APISERVER=xxx
    $ export AGONZALEZRO_KUBERNETES_FOR_BOTELLA_TOKEN=yyy

Take a look to the official documentation to know what should be the value for those variables: [Directly accesing the REST API](https://kubernetes.io/docs/user-guide/accessing-the-cluster/#directly-accessing-the-rest-api).

TL;DR for minikube:

    $ export AGONZALEZRO_KUBERNETES_FOR_BOTELLA_APISERVER=https://`minikube ip`:8443
    $ export AGONZALEZRO_KUBERNETES_FOR_BOTELLA_TOKEN=$(kubectl describe secret $(kubectl get secrets | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t')

Developing
----------

You need to download some dependencies:

    $ mix deps.get
    
And then you are able to run the task:

    $ mix bot.run

Testing
-------

Testing is pretty straight forward, but be aware that I am using an stub for the Kubernetes client:

    $ mix test
