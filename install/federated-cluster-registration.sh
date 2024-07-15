#!/bin/sh

####################################################################################
#
# Registers the Gloo Edge cluster for federation
#
# Requires an existing Gloo Edge 1.15+ setup with ExtAuth and RateLimiting.
# Requires the glooctl CLI to be installed.
#
####################################################################################

export KUBECTL_CONTEXT=$(kubectl config current-context)

# Name of the kubectl context should be equal to the name of the current minikube profile if we only run a single minikube at this time.
export MINIKUBE_PROFILE=$KUBECTL_CONTEXT
export MINIKUBE_IP=$(minikube -p $MINIKUBE_PROFILE ip)

echo "Kubectl context: $KUBECTL_CONTEXT"
echo "Minikube profile: $MINIKUBE_PROFILE"
echo "Minikube IP: $MINIKUBE_IP"

echo "Registering local cluster for federation."
glooctl cluster register --cluster-name local --remote-context $KUBECTL_CONTEXT --local-cluster-domain-override $MINIKUBE_IP:8443
