# Go Web Application

This is a simple website written in Golang. It uses the `net/http` package to serve HTTP requests.

## Running the server

To run the server, execute the following command:

```bash
go run main.go
```

The server will start on port 8080. You can access it by navigating to `http://localhost:8080/courses` in your web browser.

## Looks like this

![Website](static/images/golang-website.png)


## commands used


docker build  -t adeshbode/go-web-app .

docker run -p 8080:8080 -it adeshbode/go-web-app

# Install:  kubectl( primarytool for talking to Kubernetes) and  eksctl (simplifies the process of creating, updating, and managing EKS clusters)- both uses aws cli  config credentials

eksctl create cluster --name demo-cluster --region us-east-1

kubectl apply -f k8s/manifests/deployment.yaml

check: kubectl get pods

kubectl apply -f k8s/manifests/service.yaml

## check whether service working correctly
kubectl get svc 
kubectl edit svc go-web-app // name from above command output 
// edit the ip from ClusterIP to NodePort

// use export KUBE_EDITOR=vim if opening in notepad

kubectl get svc // now copy the port from the record with type nodeport ex. 80:31985/TCP -- will use 31985 further // it means ec2's 80 port mapped to ... port 

kubectl get nodes -o wide // take the any of the externalip from here ( ec2 ip for the node)

hit : <ip>:<port>/courses

kubectl apply -f k8s/manifests/ingress.yaml

check: kubectl get ing 

### now can observe address is empty - cant access resouce directly using ingress as address not assigned

## we need ingress control which will assign address for the ingress resource

## once the address is assigned , will take the ip address and map with the domain name  that we have created in ETC Host


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml


## argocd

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# expose argo cd service so that // Access the Argo CD UI (Loadbalancer service)

kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'


# Get the Loadbalancer service IP
kubectl get svc argocd-server -n argocd

# hit the <nodeip>:<portfromabovecommands> to open argocd ui

## username : admin

## to  get password

kubectl get secrets -n argocd

# than

kubectl edit secret argocd-initial-admin-secret -n argocd

// copy password from here which is bydefault base 64 encode will have to decode it

## decode

echo VEF4NVJ0TFBZRm85ZWVCVg== | base64 --decode

for powershell:[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("VEF4NVJ0TFBZRm85ZWVCVg=="))



################################## 
eksctl delete cluster <cluster-name>

# SHUTTING DOWN RESOUCES --- restart guidance
eksctl create cluster go-web-app-cluster  -- node.type t3.medium ..... other specification here like no. of nodes etc


helm install go-web-app ./helm/go-web-app-chart

// deploy all k8s manifest files --along with its dynamic variable advantages

# now apply ingress aws controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml


# argo cd setup

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'

kubectl get svc argocd-server -n argocd // extract argocd ui port from it and hit on any node ec2 ip ( allow that port in security group with 0.0.0.0)


know the ec2 node ip by below command
kubectl get nodes -o wide

i.e the <ec2-node-ip>:<argo-cd-port-ip>  ### remember to allow security group to argocd port with all public tcp acccess


# now after hitting the url we are able to see the argocd ui

username: admin
password: read-steps-given-above-to--extract password and convert from base64

## now after login create applicatn

apptn name: go-web-app
projectName: default
syncPolicy: Automatic
enable: Self Heal

put the repo url ( makesure its public -- private setup require more step - not covered )

revision: HEAD
Path: helm/go-web-app-chart

In Destinatn Section

Cluster Url: https://kubernetes.default.svc
Namespace: default

Helm
values files: values.yaml

# click on create and afterwards click on the go-web-app tile


### now to check changes have used go-web-app.local as domain name which points to our ELB

for their mapping some steps give somewhere above


kubectl get ing // get the dns for elb from here

nslookup a479d87b451be4d88a35b58d344f3591-6a13ed18758ab4e0.elb.us-east-1.amazonaws.com 

// get the ip from here (any 1 from 2)

now use bash with administor access

vim C:\Windows\System32\drivers\etc\hosts
and put at the end
<ip of the elb > go-web-app.local

use vim :
 to edit first press key i 
 esc + ":wq" to write(save) and quit

now hit : http://go-web-app.local/courses

// try changing to see the first ci in work than cd 