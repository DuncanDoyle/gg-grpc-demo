# Gloo Gateway 1.17 - Kubernetes Gateway API

## Installation

Install Gloo Gateway:
```
cd install
./install-gloo-gateway-with-helm.sh
```

> [!NOTE]
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-gloo-edge-enterprise-with-helm.sh` installation script.

Verify that the `GatewayClass` has been created:

```
kubectl get gatewayclasses
```

Inspect the `GatewayClass` like so:

```
kubectl get gatewayclass gloo-gateway -o yaml
```




## Setup Demo

Run the `setup.sh` script to deploy all services, upstreams and routes:

```
cd install
./setup.sh
```

```
kubectl get upstream -n gloo-system default-grpcstore-demo-80
```

```
kubectl get upstream -n gloo-system default-grpcstore-demo-80 -o yaml
```

Get the Proto descriptor:

```
k -n gloo-system get upstream default-grpcstore-demo-80 -o json | jq -r '.spec.kube.serviceSpec.grpcJsonTranscoder.protoDescriptorBin' | base64 -d
```


List gRPC services:

```
grpcurl -plaintext grpc.example.com:80 list
```

Describe a gRPC service:

```
grpcurl -plaintext grpc.example.com:80 describe solo.examples.v1.StoreService
```

Describe gRPC operation:

```
grpcurl -plaintext grpc.example.com:80 describe solo.examples.v1.CreateItemRequest
```

Create an item:

```
grpcurl -plaintext -d '{"item":{"name":"item1"}}' grpc.example.com:80 solo.examples.v1.StoreService/CreateItem
```

List items:

```
grpcurl -plaintext grpc.example.com:80 solo.examples.v1.StoreService/ListItems
```


## Bookstore


### Compile Proto file

```
protoc -I${GOOGLE_PROTOS_HOME} -I${PROTOBUF_HOME} -I. --include_source_info --include_imports --descriptor_set_out=descriptors/proto.pb bookstore.proto
```


### grpcurl

```
grpcurl -plaintext bookstore.example.com:80 list 
```


```
grpcurl -plaintext bookstore.example.com:80 describe
```


### gRpcJsonTranscoder: cURL 

```
 curl http://bookstore.example.com/shelves 
 ```

 ```
 curl http://bookstore.example.com/shelf -d '{"theme": "music"}'
 ```

 ```
 curl http://bookstore.example.com/shelves 
 ```