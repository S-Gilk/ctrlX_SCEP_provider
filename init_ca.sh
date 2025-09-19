rm -rf ./volumes/step
mkdir ./volumes/step
chmod -R 0777 ./volumes/step
docker compose up -d
sleep 2 # Would be better to monitor the init process in the docker container
MSYS_NO_PATHCONV=1 docker exec step-ca /bin/sh /home/scripts/init_intermediate_ca.sh
sleep 1
docker compose restart
docker exec step-ca step ca provisioner add ctrlx_scep_provisioner --type SCEP --challenge "boschrexroth" --encryption-algorithm-identifier 2
sleep 1
docker compose restart
