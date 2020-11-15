TARGET_IMAGE = sample.jpeg
TARGET_DIRECTORY = sample

default: build extract_from_image

.PHONY: build
build:
	docker-compose build

.PHONY: extract_from_image
extract_from_image:
	docker-compose run app thor color:extract_from_image ${TARGET_IMAGE}

.PHONY: extract_from_directory
extract_from_directory:
	docker-compose run app thor color:extract_from_directory ${TARGET_DIRECTORY}

.PHONY: rubocop
rubocop:
	docker-compose run app bundle exec rubocop 

.PHONY: rubocop-a
rubocop-a:
	docker-compose run app bundle exec rubocop -a

.PHONY: rspec
rspec:
	docker-compose run app rspec ./spec

