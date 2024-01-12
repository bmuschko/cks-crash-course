# Solution

## Setting up the Objects

Start by creating the objects from the existing YAML manifest.

```
$ kubectl apply -f setup.yaml
namespace/t75 created
deployment.apps/nginx-deployment created
service/accounting-service created
```

The objects created can be queried for. We created a Deployment named `nginx-deployment` with three replicas, and a Service named `accounting-service` of type `ClusterIP`.

```
$ kubectl get all -n t75
NAME                                   READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-9456bbbf9-nlv6g   1/1     Running   0          18s
pod/nginx-deployment-9456bbbf9-wc2r4   1/1     Running   0          18s
pod/nginx-deployment-9456bbbf9-zq5zc   1/1     Running   0          18s

NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/accounting-service   ClusterIP   10.106.136.234   <none>        80/TCP    18s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           18s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-9456bbbf9   3         3         3       18s
```

## Creating the Secret

Run the OpenSSL command to generate the TLS certificate and key.

```
$ openssl req -nodes -new -x509 -keyout accounting.key -out accounting.crt -subj "/CN=accounting.internal.acme.com"
Generating a 2048 bit RSA private key
...........................+++
..........................+++
writing new private key to 'accounting.key'
-----
```

The easiest way to create a Secret is with the help of an imperative command. This method of creation doesn't require base64-encoding the certificate and key values. It happens automatically.

```
$ kubectl create secret tls accounting-secret --cert=accounting.crt --key=accounting.key -n t75
secret/accounting-secret created
```

The YAML manifest of the Secret could look as shown below.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: accounting-secret
  namespace: t75
type: kubernetes.io/tls
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNyakNDQVpZQ0NRQzF2OXFYQkRTU3p6QU5CZ2txaGtpRzl3MEJBUXNGQURBWk1SY3dGUVlEVlFRRERBNWgKWTJOdmRXNTBhVzVuTG5Sc2N6QWVGdzB5TWpBMU1qTXhOVE0xTURaYUZ3MHlNakEyTWpJeE5UTTFNRFphTUJreApGekFWQmdOVkJBTU1EbUZqWTI5MWJuUnBibWN1ZEd4ek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQThkWGw5T0hLM2FPSzFSdlZ0Z1JhR3lmK1Z5eGNkTkxMV0R5SDEyY2JPL2FSTkdZeGt0OWYKQ2xkYWVPR3kvb2VCVVExNmNjcTVuem5CSTQwamttd0p0Zk1UQm1SSDhjSS94WVlMZDh3SDA0Z3grZ3FEZmZYagpsRExGam04dTFVRE9ENEczdjBSZmd3OE1GM1hGbVlYczVYcG15bXNlcEcrc0dmL1RjZzNUb2lpejlSamJTQWtXCkRPMi9NNDJIZUVVWVNZdjdXeDFaTE5SVzZmbXpIMWlFTTlMam1OcCt3UkluTVMreHRGbUtqamtPeU1qamNzb2wKbkptTElJS3NibThPWVBQT3dleGJ0Qnd2cXVRL2g4UEZhWkREbGpCSGd1M3orekw4c1QyTUZsSWhFTlRxMFU4ZApRV0g3RzEyd3dvRVdod2F3MUZwQW9kYnJFTnZ5UTZQUjRRSURBUUFCTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCCkFRQ3MzTTdVUW5uRFRQMWlMQytON05FbHZ1UEJoVEhpYVEvZ3RldEtGSXpHSUkzTGFrV0JSMTBVWmdZaDdYMVQKWDhEM0xHa1pvSDlkQUQyL2ZTN2FnbE1VYWd2U1pVOVE1SWJUdlViRk9PamNmVmlSK1B6MlNKT20yWk8yVHBWUgpFSmpTdGJCMnFJeGJnRGt2ZjdnVWNtYi92Y1JwWWFpdlNHanpsTEhuTjhvaHN3OTFnSmVhSWdUTkM2RCtzQzFLCklydlVyYVB6b1hzZkFqOHkwZWlZTkdseHRzeiszZ2dFS3pTSFZLY1BqaHdSQ2ZhcU1QcllvcnZWSCtTSXlnVHIKdTFFbjBTUVNhaFhtMHZmWUJWVjAwQ0N3dDV1UDFSN3l2SG1weS9sMFk5NEpGY2xzQmgyb1RHNXVHWUROMzU1dApRTGkyR2tKbkRURkh0QVlRS0dMR3VEZmoKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRRHgxZVgwNGNyZG80clYKRzlXMkJGb2JKLzVYTEZ4MDBzdFlQSWZYWnhzNzlwRTBaakdTMzE4S1YxcDQ0YkwraDRGUkRYcHh5cm1mT2NFagpqU09TYkFtMTh4TUdaRWZ4d2ovRmhndDN6QWZUaURINkNvTjk5ZU9VTXNXT2J5N1ZRTTRQZ2JlL1JGK0REd3dYCmRjV1poZXpsZW1iS2F4NmtiNndaLzlOeURkT2lLTFAxR050SUNSWU03Yjh6allkNFJSaEppL3RiSFZrczFGYnAKK2JNZldJUXowdU9ZMm43QkVpY3hMN0cwV1lxT09RN0l5T055eWlXY21Zc2dncXh1Ync1Zzg4N0I3RnUwSEMrcQo1RCtIdzhWcGtNT1dNRWVDN2ZQN012eXhQWXdXVWlFUTFPclJUeDFCWWZzYlhiRENnUmFIQnJEVVdrQ2gxdXNRCjIvSkRvOUhoQWdNQkFBRUNnZ0VCQUpSU2J6WnhJWjRzUnVNTHJsaHpkTnhBL0RKMUI4T3k0WHFkcldjRVd1UzkKQmpQUUZjbVI3RldJVy9uVjI1VldnSTY0cUllUUlhYXhvbTV1aXdtcjc0ekRwOEI4MHM5Skp4bTdhOTh1cVFJbwoveFh2U3RSL2NmUWI2NlMvTmtjZTl3TDF1VCs2N0tXU0hnVnBleWI4eDkyNjQ3NTBVcGZoMGZra09ZZ3pTTUNqCjZ2bEJBWEEvMGhzRDNlYVhBeGtaQXZGWlJuRWhvSFd2Tm5mRUVOQ2ZjK1hqZjljL0xtVnRmRnlrcFdPSzJmamMKRjFqa2NlOER2Z1VGaG93b3VkMjNJbE5OZEYwL3NEdW43WGxRWXZZVEdoZ3R4ZjdSMXM0K2RLZTF6TWYvcVBTdgpScGs5QmkvenJuRXdiZG9pTVA0UWVrTStwY3V3UEI4bjZzbVNKWGp6MHdFQ2dZRUErMDgvdGh2RmJza0wrQmI0CjBhL1ZKbUxyUUZEdGhIcjdtaGJHRURVankrK0Y0UVgrUDEvTG1DcnZjbmRLUGpZMWV4SEpaMHVJTXUzRDFiTzAKb1pWU2taanpQK1JRQWFQS1pocndJKy81Mzh3TzFreDdQbFlZbUViRnR0VU1pbFlWT0RMZnduY1l4RGY3RktDUQpYcXRUTE83QVh2RXloaTRDMzlQYzRCUEhXZkVDZ1lFQTlsbGgra3VtR0pPRFc4MzlGSUJWYktKNDZjeE1ud0NoCjlSQWZxb0NVMy9tY0RveUY2WStVSWtSek9WSVFJcmw3NTMrZGFyNTc2djlEeXRvb2N4RVp5V2RBdWpWUk50ZGMKWmE3UmdPYWhKMWRQVGl6TXI2Y1NNRS9qMm0reGk1a3JWNTZyK2NVZzg3VWcrYTlUbFc4b05DMVFxYXpBWElpTgplRXdOa1FZa2h2RUNnWUVBc1BiRU1YTnEyckZkNlV3YjJHUk4zeU1HNzVwTk50MzNNREZiTld5R0VZUlFMUDJ3ClpHWUxrdEtoSEdTZDlpTHNGQWFaWVZDUnp2TVkxUElmZnkwTUlKU29yZFFTOXFTazBMT2xhRmtEQnJIRnZPZk0KWFQvNVA3bU9Ya20xOCsvY0wxKzdxMDk4TkNnTGVTSDdwMzVUS3EvUTdNcEJ2clRGdDJHVUJvSkcvYkVDZ1lCaQpyQWFNaElSd3o1VUx6b1FTRkIwak9DaUtMT1I3dzNzYmQydlhsVTBNTVNTS3gwcFQ5TWgydVVnVnE0TC9CYUJWClowNGNGVlA1R21tQzlNTEM1QlNhRVJ0aCtqMGZaRCtFRXZPalY3MHd6czNiR0NLY01LVWVhTUZ4R3MvWWhHOVIKMXlJM0Z2aE41VHppQlpITEJ3enBhVVVuMFNQemJGYU4ycGlNZ0JOZFlRS0JnSHBmNTcrSTk0YWowZEw4Qy9qbgpudnBobkMrWmpFenJRTkJaTmRibTlJKzIzVXdaaGlsSWNXUEtTMHpJdGVMMXhYMFNQRGY3OHhkaVVHZklMNlV1Cmp0VlJZNTc2YTRGSVhEVjVadlFQSkVId1d2eVZ0Q1Y2SGV1clZRcTRxRnljWXJwUHgzQlVmcE9MVmQ0UWpHd3oKYzJrZGtYbFNnOStEUUVyVjJXT3d4R1JtCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
```

## Creating the Ingress

Use the imperative method to create the Ingress with the help of a one-liner.

```
$ kubectl create ingress accounting-ingress --rule="accounting.internal.acme.com/accounting*=accounting-service:80,tls=accounting-secret" -n t75
ingress.networking.k8s.io/accounting-ingress created
```

The resulting YAML manifest looks as such:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: accounting-ingress
  namespace: t75
spec:
  tls:
  - hosts:
    - accounting.internal.acme.com
    secretName: accounting-secret
  rules:
  - host: accounting.internal.acme.com
    http:
      paths:
      - path: /accounting
        pathType: Prefix
        backend:
          service:
            name: accounting-service
            port:
              number: 80
```

The resulting Ingress object should be available in the namespace.

```
$ kubectl get ingress -n t75
NAME                 CLASS    HOSTS                          ADDRESS   PORTS     AGE
accounting-ingress   <none>   accounting.internal.acme.com             80, 443   2m1s
```
