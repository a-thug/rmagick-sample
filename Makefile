TARGET = sample.jpeg

default: build-image extract

.PHONY: build-image
build-image:
	docker-compose build

.PHONY: extract
extract:
	docker-compose run app thor color:extract ${TARGET}