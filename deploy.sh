# Build images with GIT_SHA for versioning
docker build -t nigelfrnds/complex-server-k8s:latest -t nigelfrnds/complex-server-k8s:$GIT_SHA -f ./server/Dockerfile ./server 
docker build -t nigelfrnds/complex-client-k8s:latest -t nigelfrnds/complex-client-k8s:$GIT_SHA -f ./client/Dockerfile ./client 
docker build -t nigelfrnds/complex-worker-k8s:latest -t nigelfrnds/complex-worker-k8s:$GIT_SHA -f ./worker/Dockerfile ./worker 

# Push to DockerHub
docker push nigelfrnds/complex-server-k8s:latest
docker push nigelfrnds/complex-client-k8s:latest
docker push nigelfrnds/complex-worker-k8s:latest

docker push nigelfrnds/complex-server-k8s:$GIT_SHA
docker push nigelfrnds/complex-client-k8s:$GIT_SHA
docker push nigelfrnds/complex-worker-k8s:$GIT_SHA

# Configure cluster
kubectl apply -f k8s
# Imperatively update with newly built images
kubectl set image deployments/server-deployment server=nigelfrnds/complex-server-k8s:$GIT_SHA
kubectl set image deployments/client-deployment client=nigelfrnds/complex-client-k8s:$GIT_SHA
kubectl set image deployments/worker-deployment worker=nigelfrnds/complex-worker-k8s:$GIT_SHA