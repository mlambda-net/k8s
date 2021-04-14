
#install nginx
helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx nginx/ingress-nginx --set controller.publishService.enabled=true

#install cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml

#create the issuer
kubectl apply -f issuer-dev.yaml
kubectl apply -f issuer-prod.yaml


#grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki  -f ./grafana-values.yaml

#prometheus
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus/prometheus  -f ./prometheus-values.yaml


kubectl create secret generic logzio-secret \
--from-literal=logzio-token='$LOGZ_TOKEN' \
--from-literal=logzio-listener='https://listener.logz.io:8071' \
-n default

kubectl create -f logconfig.yaml
kubectl create -f logzio-daemonset.yaml
