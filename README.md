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

## Folder structure
1. certs
Certificates are stored here
2. charts
All the helm chart values are stored here
3. conf
Sample dummy configuration for Kong is stored here
