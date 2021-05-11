#install traefik

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -f ./traefik-values.yaml


#install nginx
helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx nginx/ingress-nginx -f nginx-values.yaml

#install cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --set installCRDs=true


#kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml

#create the issuer
kubectl apply -f issuer-dev.yaml
kubectl apply -f issuer-prod.yaml


#grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana  -f ./grafana-values.yaml

#prometheus
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus/prometheus  -f ./prometheus-values.yaml


kubectl create secret generic logzio-secret \
--from-literal=logzio-token=$LOGZ_TOKEN \
--from-literal=logzio-listener='https://listener.logz.io' \
-n default

kubectl apply -f logconfig.yaml
kubectl apply -f logzio-daemonset.yaml

#metrics api
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
