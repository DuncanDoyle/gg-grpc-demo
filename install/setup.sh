#!/bin/sh

pushd ..

#----------------------------------------- Reference Grant -----------------------------------------

kubectl apply -f referencegrant/gloo-system-ns/upstream-reference-grant.yaml

#----------------------------------------- gRPC App -----------------------------------------

# Create httpbin namespace if it does not exist yet
kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

printf "\nDeploy gRPC service ...\n"
kubectl apply -f apis/grpc/grpcstore-deployment.yaml
kubectl apply -f apis/grpc/grpcstore-service.yaml

#----------------------------------------- Bookstore App -----------------------------------------

kubectl apply -f apis/bookstore/bookstore.yaml

#----------------------------------------- Upstreams -----------------------------------------

kubectl apply -f upstreams/grpcstore-demo.yaml
kubectl apply -f upstreams/bookstore-upstream.yaml


#----------------------------------------- ExtAuth -----------------------------------------


#----------------------------------------- grpc.example.com HttpRoute -----------------------------------------

# Label the default namespace, so the gateway will accept the HTTPRoute from that namespace.
printf "\nLabel default namespace ...\n"
kubectl label namespaces default --overwrite shared-gateway-access="true"

printf "\nDeploy the HTTPRoute ...\n"
kubectl apply -f routes/grpc-example-com-httproute.yaml
kubectl apply -f routes/bookstore-example-com-httproute.yaml

#----------------------------------------- grpc.example.com VirtualService -----------------------------------------

printf "\nDeploy the HTTPRoute ...\n"
kubectl apply -f virtualservices/grpc-example-com-vs.yaml


#----------------------------- Configure Function Discovery on the generated Upstreams -------------------------------

kubectl label upstream -n gloo-system default-grpcstore-demo-80 discovery.solo.io/function_discovery=enabled

kubectl label upstream -n gloo-system default-bookstore-8080 discovery.solo.io/function_discovery=enabled



popd

