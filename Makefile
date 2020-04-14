# bypass proxy for localhost operation (necessary as docker-compose runs against localhost for docker operations)
export no_proxy=localhost,myharbor
export NO_PROXY=localhost,myharbor
export INTERNAL_DOMAIN=.com
export REGISTRY_HOSTNAME=myharbor
export APP_NAME=nginxhello
export DOCKER_INTERNAL_REGISTRY=${REGISTRY_HOSTNAME}.${INTERNAL_DOMAIN}:9999
# read version file on root project directory
VERSION=$(shell cat VERSION)

help: ## display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

########################################################################
######################### APPLICATIONS BUILDING ########################
########################################################################

build: ## build image
	docker build \
	-t ${APP_NAME}:latest \
	-t ${APP_NAME}:${VERSION} \
	-t ${DOCKER_INTERNAL_REGISTRY}/${APP_NAME}:${VERSION} \
	-t ${DOCKER_INTERNAL_REGISTRY}/${APP_NAME}:latest \
	helloapp

########################################################################
######################### APPLICATIONS PUBLISHING ######################
########################################################################

publish: ## publish image to docker registry
	docker push ${DOCKER_INTERNAL_REGISTRY}/${APP_NAME}:${VERSION}
	docker push ${DOCKER_INTERNAL_REGISTRY}/${APP_NAME}:latest

######################################################################
######################### APPLICATION RUNNING ########################
######################################################################

up: ## run docker-compose up, creating containers if not exists
	#docker-compose pull
	sed -ie 's/VERSION=.*/VERSION=${VERSION}/' .env
	sed -ie 's/REGISTRY=.*/REGISTRY=${DOCKER_INTERNAL_REGISTRY}/' .env
	docker-compose up -d

down: ## remove the running containers
	docker-compose down

stop: ## stop the running containers
	docker-compose stop

status: ## get stack status
	docker-compose ps

# tag the project on gitlab
# read VERSION file, tag project on gitlab with provided version




