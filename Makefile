SHELL := /bin/bash

APP_DIR := ./data/domains/app
INFRA_DIR := ./data/domains/infrastructure


generate-data:
	@echo "Generating data for the mesh"
	docker run -it --rm mingrammer/flog -f json -n 3000000 > $(APP_DIR)/app_data.json
	docker run -it --rm mingrammer/flog -f apache_combined -n 3000000 > $(INFRA_DIR)/access.log

pre-requisites:
	@echo
	@echo "----------------------------------------------"
	@echo "Verifying if Docker is available"
	@echo "----------------------------------------------"
	docker version
	@echo
	@echo "----------------------------------------------"
	@echo "Verifying if local k8s cluster is running"
	@echo "----------------------------------------------"
	kubectl cluster-info
	@echo
	@echo "----------------------------------------------"
	@echo "Creating k8s namespaces"
	@echo "----------------------------------------------"
	kubectl apply -f ./k8s/namespaces/kafka-namespace.yml

zookeeper:
	@echo
	@echo "----------------------------------------------"
	@echo "Creating Zookeeper on k8s local cluster"
	@echo "----------------------------------------------"
	kubectl apply -f ./k8s/zookeeper/service.yml
	kubectl apply -f ./k8s/zookeeper/statefulSet.yml

clean:
	@echo
	@echo "----------------------------------------------"
	@echo "Removing data"
	@echo "----------------------------------------------"
	rm -f $(APP_DIR)/*.json $(INFRA_DIR)/*.log
	
	@echo
	@echo "----------------------------------------------"
	@echo "Cleaning local k8s resources"
	@echo "----------------------------------------------"
	kubectl delete -f ./k8s/namespaces/kafka-namespace.yml 

configure: pre-requisites zookeeper

