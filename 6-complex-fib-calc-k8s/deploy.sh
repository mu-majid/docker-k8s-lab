docker build -t mumajid/multi-client -f ./client/Dockerfile ./client
docker build -t mumajid/multi-server -f ./server/Dockerfile ./server
docker build -t mumajid/multi-worker -f ./worker/Dockerfile ./worker

docker push  mumajid/multi-client
docker push  mumajid/multi-server
docker push  mumajid/multi-worker

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=mumajid/multi-server