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
