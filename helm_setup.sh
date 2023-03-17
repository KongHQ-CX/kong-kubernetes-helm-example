# Kong Helm deployment script

# Delete the namespace and helm charts and stop
if [ "$1" == "clean" ]
then
    echo "Starting cleanup =============================="

    echo "Deleting Helm charts -------------------------"
    #Delete kong releases if already there
    ## delete control plane helm
    helm del kongcp -n cp
    ## delete postgres helm
    helm del kongpg -n pg
    ## delete data plane helm
    helm del kongdp -n dp

    echo "Deleting Namespaces -------------------------"
    #Delete k8s namespaces
    ## delete control plane namespaces
    kubectl delete namespace cp
    ## delete data plane namespaces
    kubectl delete namespace dp
    ## delete postgres namespaces
    kubectl delete namespace pg

    echo "Cleanup complete."
    
    exit
elif [ "$1" == "upgrade" ]
then
    echo "Starting upgrade =============================="

    #echo "Upgrade Postgres helm charts -------------------------"
    #helm upgrade kongpg bitnami/postgresql -f ./charts/pg_values.yaml -n pg
    
    echo "Upgrade Control Plane helm charts -------------------------"
    helm upgrade kongcp kong/kong --values=./charts/cp_values.yaml -n cp
    
    echo "Upgrade Data Plane helm charts -------------------------"
    helm upgrade kongdp  kong/kong --values=./charts/dp_values.yaml -n dp

elif [ "$1" == "new" ]
then
    echo "Starting new =============================="
    echo "Creating Namespaces -------------------------"
    #create k8s namespaces
    ## create control plane namespaces
    kubectl create namespace cp
    ## create data plane namespaces
    kubectl create namespace dp
    ## create postgres namespaces
    kubectl create namespace pg

    echo "Creating secrets Control Plane -------------------------"
    ############# create the k8s secrets for CP
    ## Kong enterprise license
    #kubectl create secret generic kong-enterprise-license --from-file=license=./license/kong-license.json -n cp
    ## create postgres password
    kubectl create secret generic kong-enterprise-postgres-password --from-literal=password=kong -n cp
    ##gui and api certificates 
    kubectl create secret tls kong-ssl-cert --cert=./certs/ssl-certs/control-plane-components.crt --key=./certs/ssl-certs/control-plane-components.key -n cp
    ##shared mode cluster certs
    #kubectl create secret tls kong-cluster-cert --cert=./certs/hybrid/cluster.crt --key=./certs/hybrid/cluster.key -n cp
    ##pki mode cluster certs for CA and CP
    kubectl create secret generic kong-ca-cert --from-file=./certs/ca_cert/ca-cert.pem -n cp
    kubectl create secret tls kong-control-plane-cert --cert=./certs/cp_cert/control-plane.crt --key=./certs/cp_cert/control-plane.key -n cp
    ## manager and portal session conf
    kubectl create secret generic kong-session-conf --from-file=./conf/admin_gui_session_conf --from-file=./conf/portal_session_conf -n cp
    ## manager and portal auth conf
    kubectl create secret generic kong-auth-conf --from-file=./conf/admin_gui_auth_conf --from-file=./conf/portal_auth_conf -n cp
    ## Kong super user password
    kubectl create secret generic kong-enterprise-superuser-password --from-literal=password="kalidass" -n cp

    echo "Creating secrets Data Plane -------------------------"
    ############# create the k8s secrets for DP
    ## Kong enterprise license
    #kubectl create secret generic kong-enterprise-license --from-file=license=./license/kong-license.json -n dp
    ## shared mode cluster certs
    # kubectl create secret tls kong-cluster-cert --cert=./certs/hybrid/cluster.crt --key=./certs/hybrid/cluster.key -n dp
    ## pki mode CA and data plabe certs
    kubectl create secret tls kong-ca-cert --cert=./certs/ca_cert/ca-cert.pem --key=./certs/ca_cert/ca-cert.key -n dp
    kubectl create secret tls kong-data-plane-cert --cert=./certs/dp_cert/data-plane.crt --key=./certs/dp_cert/data-plane.key -n dp
    # gui and api
    #kubectl create secret tls kong-ssl-cert --cert=./certs/ssl/server.crt --key=./certs/ssl/server.key -n dp
    kubectl create secret tls kong-ssl-cert --cert=./certs/ssl-certs/control-plane-components.crt --key=./certs/ssl-certs/control-plane-components.key -n dp

    echo "Install Postgres helm charts -------------------------"
    helm install kongpg bitnami/postgresql -f ./charts/pg_values.yaml -n pg

    echo "Install Control Plane helm charts -------------------------"
    helm install kongcp kong/kong --values=./charts/cp_values.yaml -n cp

    echo "Install Data Plane helm charts -------------------------"
    helm install kongdp  kong/kong --values=./charts/dp_values.yaml -n dp

else
    echo "Parameters not provided"
    echo "helm_setup.sh new|upgrade|clean"
    echo "new - fresh install"
    echo "upgrade - only upgrade helm charts"
    echo "clean - clean up"
fi

echo "======== COMPLETE ========="