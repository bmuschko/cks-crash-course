# Solution

## Setting up the Namespace

Start by creating the namespace.

```
$ kubectl create ns d31
namespace/d31 created
```

## Creating the Secret

To create the Secret with an imperative command, use the `--type` CLI option.

```
$ kubectl create secret generic api-basic-auth --type=kubernetes.io/basic-auth --from-literal=username=api-creds --from-literal=password=bhj123as -n d31
secret/api-basic-auth created
```

To create the Secret declaratively, start by defining a YAML manifest defined in the file `secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: api-basic-auth
  namespace: d31
type: kubernetes.io/basic-auth
stringData:
  username: api-creds
  password: bhj123as
```

Execute the following command to create the Secret:

```
$ kubectl apply -f secret.yaml
secret/api-basic-auth created
```

Upon creation, the Secret automatically base64-encoded the values. Rendering the YAML representation of the live object reveals the behavior.

```
$ kubectl get secret api-basic-auth -o yaml -n d31
...
data:
  password: YmhqMTIzYXM=
  username: YXBpLWNyZWRz
...
```

## Creating the Pod

Create the YAML manifest of the Pod in the namespace with the following imperative command:

```
$ kubectl run server-app --image=nginx --restart=Never -n d31 --dry-run=client -o yaml > pod.yaml
```

Edit the `pod.yaml` file and add the references to the environment variables. Make sure to turn the Secret keys into environment variable keys that follow the typical conventions. The final YAML manifest should look similar to the one below:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: server-app
  namespace: d31
spec:
  containers:
  - image: nginx:1.18.0
    name: nginx
    env:
    - name: USERNAME
      valueFrom:
        secretKeyRef:
          name: api-basic-auth
          key: username
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          name: api-basic-auth
          key: password
  restartPolicy: Never
```

Execute the following command to create the Pod:

```
$ kubectl apply -f pod.yaml
pod/server-app created
```

## Verifying the Environment Variables

Verify that the environment variables have been created correctly by printing them:

```
$ kubectl exec server-app -n d31 -- env
...
USERNAME=api-creds
PASSWORD=bhj123as
...
```

Among the rendered environment variables, you should find the ones you defined. All values are available in plain-text.