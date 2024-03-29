USER=nikeda
NAME=datascience-base
VERSION=0.0.0

build:
	docker build -t $(USER)/$(NAME):$(VERSION) .

build-no-cache:
	docker build --no-cache=true -t $(USER)/$(NAME):$(VERSION) .

restart: stop start

start:
	docker run -itd --rm \
		-p 10000:8888 \
		-p 54321:54321 \
		-v $$PWD/jovyan:/home/jovyan \
		--name $(NAME) \
		$(USER)/$(NAME):$(VERSION)

start-allow-root:
	docker run -itd --rm \
		-p 10000:8888 \
		-p 54321:54321 \
		-v $$PWD/jovyan:/home/jovyan \
		--name $(NAME) \
		-e GRANT_SUDO=yes \
		--user root \
		$(USER)/$(NAME):$(VERSION)

stop:
	docker stop $(NAME)
