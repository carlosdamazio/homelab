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

mysql: pre-requisites
	@echo
	@echo "----------------------------------------------"
	@echo "Creating MySQL database on k8s local cluster"
	@echo "----------------------------------------------"
	kubectl apply -f ./k8s/namespaces/mysql-namespace.yml
	kubectl apply -f ./k8s/mysql/configmap.yml
	kubectl apply -f ./k8s/mysql/service.yml
	kubectl apply -f ./k8s/mysql/statefulSet.yml

mysql-clean: pre-requisites
	@echo
	@echo "----------------------------------------------"
	@echo "Deleting MySQL database from k8s local cluster"
	@echo "----------------------------------------------"
	kubectl delete -f ./k8s/namespaces/mysql-namespace.yml

kafka:
	@echo
	@echo "----------------------------------------------"
	@echo "Creating Zookeeper on k8s local cluster"
	@echo "----------------------------------------------"
	kubectl apply -f ./k8s/namespaces/kafka-namespace.yml
	kubectl apply -f ./k8s/zookeeper/service.yml
	kubectl apply -f ./k8s/zookeeper/statefulSet.yml

clean:
	@echo
	@echo "----------------------------------------------"
	@echo "Cleaning local k8s resources"
	@echo "----------------------------------------------"
	kubectl delete -f ./k8s/namespaces/kafka-namespace.yml 
	kubectl delete -f ./k8s/namespaces/mysql-namespace.yml

configure: pre-requisites zookeeper

