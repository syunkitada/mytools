name = mytools

.PHONY: all
all:
	@make image

.PHONY: image
image:
	sudo docker image build -t local/$(name) .


.PHONY: bash
bash:
	sudo docker run -it --rm --net host local/$(name) bash
