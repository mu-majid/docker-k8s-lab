docker build -t mumajid/multi-client:latest -t mumajid/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mumajid/multi-server:latest -t mumajid/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t mumajid/multi-worker:latest -t mumajid/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push  mumajid/multi-client:latest
docker push  mumajid/multi-client:$SHA

docker push  mumajid/multi-server:latest
docker push  mumajid/multi-server:$SHA

docker push  mumajid/multi-worker:latest
docker push  mumajid/multi-worker:$SHA


kubectl apply -f k8s

kubectl set image deployments/server-deployment server=mumajid/multi-server:$SHA
kubectl set image deployments/client-deployment client=mumajid/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mumajid/multi-worker:$SHA
