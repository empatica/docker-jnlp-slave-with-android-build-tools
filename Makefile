IMAGE = empatica/jnlp-slave-with-android-build-tools
VERSION = 25-1

.PHONY: build push release

default: release

build:
	docker build -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)

release: build push
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest
