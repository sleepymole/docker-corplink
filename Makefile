.PHONY: build push run

REPO := sleepymole/corplink
DATE := $(shell date +%Y%m%d)
SHA := $(shell git rev-parse --short HEAD)
DIRTY := $(shell git diff --cached --quiet || echo "-dirty")
TAG := v$(DATE)-$(SHA)${DIRTY}

build:
	docker build -t $(REPO):latest .
	docker tag $(REPO):latest $(REPO):$(TAG)

push:
	docker push $(REPO):latest
	docker push $(REPO):$(TAG)

run:
	docker run -d \
		--name=corplink \
		--hostname=ubuntu \
		--device=/dev/net/tun \
		--cap-add=NET_ADMIN \
		--shm-size=512m \
		-p 6901:6901 \
		-p 8888:8118 \
		-p 1088:1080 \
		-e VNC_PW=password \
		$(REPO):$(TAG)
