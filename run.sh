
#install nginx
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install my nginx-stable/nginx-ingress

#install cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml

#create the issuer
kubectl apply -f issuer-dev.yaml
kubectl apply -f issuer-prod.yaml


#prometheus

kubectl create namespace metrics

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus  -f ./prometheus-values.yaml

#eks

#https://logz.io/blog/deploying-the-elk-stack-on-kubernetes-with-helm/

helm repo add elastic https://Helm.elastic.co
kubectl create namespace logs
kubectl apply -f volume.yaml
helm install elasticsearch elastic/elasticsearch -f ./elastic-values.yaml

