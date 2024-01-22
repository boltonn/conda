NAME=conda
TODAY=$(shell date +%Y%m%d)
VERSION=latest

build:
	docker build -t $(NAME):$(VERSION) .

build-gpu:
	docker build -t $(NAME)-gpu:$(VERSION) -f Dockerfile.cuda .

run:
	docker run -it --rm $(NAME):$(VERSION) /bin/bash