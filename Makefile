IMAGE = tex/drive/kafka-manager
REPOSITORY = 847479559358.dkr.ecr.eu-west-1.amazonaws.com

VERSION = $(shell grep KM_VERSION .env  | sed "s/^KM_VERSION=\([1-9,\.]*\)/\1/")
REVISION = $(shell git rev-parse --short HEAD)

IMAGE_VER = $(IMAGE):$(VERSION)
IMAGE_REV = $(IMAGE):rev-$(REVISION)

default: build

build:
	docker build --build-arg KM_VERSION=$(VERSION) -t "$(IMAGE_REV)" .

docker-login:
	eval `aws ecr get-login --region eu-west-1 --no-include-email`

publish-rev: docker-login
	docker tag "$(IMAGE_REV)" "$(REPOSITORY)/$(IMAGE_REV)"
	docker push "$(REPOSITORY)/$(IMAGE_REV)"
	docker rmi "$(REPOSITORY)/$(IMAGE_REV)"

publish: docker-login
	docker tag "$(IMAGE_REV)" "$(REPOSITORY)/$(IMAGE_VER)"
	docker push "$(REPOSITORY)/$(IMAGE_VER)"
	docker rmi "$(REPOSITORY)/$(IMAGE_VER)"
