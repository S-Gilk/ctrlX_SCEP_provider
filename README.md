# ctrlX_SCEP_provider
Simple preconfigured SCEP provider for CtrlX OS demonstration

# How-To
1. Install docker engine
2. Run init_ca.sh (New system)
	- WARNING: This will overwrite any existing CA
	- This calls docker compose and also sets up the intermediate CA and SCEP provider in the container. 
	- It was desinged to run in Windows Git-Bash, so there may be issues in other shells.
3. Run restart.sh (Existing system)
	- This restarts an existing ca
	
# Commands
-- Server initialization

    docker run --name step-ca -d -v step:/home/step \
    -p 9000:9000 \
    -e "DOCKER_STEPCA_INIT_NAME=Smallstep" \
    -e "DOCKER_STEPCA_INIT_DNS_NAMES=localhost,$(hostname)" \
    smallstep/step-ca
	
-- SCEP Provisioning (Run in docker exec)

	step ca provisioner add ctrlX_SCEP_provisioner \
  	--type SCEP --challenge "boschrexroth" \
  	--encryption-algorithm-identifier 2


-- Client-side bootstrap and certificate installation. Not necessary on CtrlX devices. Run this while step-ca container is running.

  	{
		ROOT_CA_FINGERPRINT=$(docker exec step-ca step certificate fingerprint certs/root_ca.crt)
		step ca bootstrap --ca-url https://server_ip:9000 --fingerprint $ROOT_CA_FINGERPRINT --install
  	}

# CtrlX OS Enrollment
- Endpoint = https://scep_server_ip:9000/scep/ctrlX_scep_provisioner
- Challenge = boschrexroth

# Resources
https://smallstep.com/docs/step-ca/provisioners/#scep
	
