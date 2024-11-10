name = mytools

.PHONY: all
all:
	@make image

.PHONY: image
image:
	sudo docker image build -t local/$(name) .

.PHONY: bash
bash:
	sudo -E docker run -it --rm --net host -w /workdir -v .:/workdir -u `id -u`:`id -g` local/mytools bash

.PHONY: format
format:
	prettier -w **/*.md

.PHONY: lint
lint:
	prettier -c **/*.md
	hadolint Dockerfile
