# Kong Kubernetes Helm Example

This is example helm chart for Kong Kubernetes deployment.

## Steps to follow

1. Generate the keys
2. Run the charts

## 1. Generate the keys

### 1.1 Certs for WSS
Command 
`certs/generateCPDPwssCerts.sh`

Generate
- CA cert
- CP cert for WSS
- DP cert for WSS

### 1.2 Certs for TLS
Command `certs/generateCPendpointCerts.sh`

Generate the * cert for all the https enpo
The same * cert is used to keep the example simple for control plane and data plane.

## 2. Run the charts
View the script `helm_setup.sh` to check how to deploy kong.

### NOTE
Include the charts
```
helm repo add kong https://charts.konghq.com
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 2.1 First Install
Command
`helm_setup.sh new` 

Install helm chart for first time.

### 2.2 Upgrade
Command
`helm_setup.sh upgrade`

Upgrade existing helm deployment. After first install

### 2.3 Clean up only
Command
`helm_setup.sh clean`

Delete all the charts and namespaces.

## Default certs

The certs that are included by default in the repo are
```
cp_cert/cp_cert/control-plane.crt = controlplane.example.com
dp_cert/data-plane.crt = dp_cert/dp1.example.com
ca_cert/ca-cert.pem = kong-cx.com
ssl-certs/control-plane-components.crt = *.example.com
```

## Access Kong URLS
The default urls that are configured are
Kong Manager https://manager.example.com:8445
Kong Portal https://portal.example.com:8446
Kong Admin API https://adminapi.example.com:8444
Kong Portal API https://portalapi.example.com:8447

### NOTE: 
- You might be able to access via locahost but the due to TLS mismatch UI might not work
- Can possibly use DNSmask to point the above urls to localhost to get it working

## Default kong manager login password

- The default user is always `kong_admin`
- The default password in loaded as secret and was loaded while running the `helm_setup.sh`
- To update the password change this value `CHANGETHIS` in `helm_setup.sh` file
```
kubectl create secret generic kong-enterprise-superuser-password --from-literal=password="CHANGETHIS" -n cp
```
- If you have already run the script and want to change the password, easiest is to run `./helm_setup.sh clean` and new install with `./helm_setup.sh new`

## Folder structure
1. certs
Certificates are stored here
2. charts
All the helm chart values are stored here
3. conf
Sample dummy configuration for Kong is stored here
