# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/30 16:48:55 by maroy             #+#    #+#              #
#    Updated: 2024/08/11 15:58:21 by maroy            ###   ########.qc        #
#                                                                              #
# **************************************************************************** #

COMPOSE_PROJECT_NAME = inception
DOCKER = docker
DOCKER_COMPOSE = docker-compose
YML = srcs/docker-compose.yml
VOLUMES_PATH=/home/maroy/data

GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
CYAN = \033[0;36m
NO_COLOR = \033[0m

all: env start

env:
	./srcs/tools/generate_env.sh;
	./srcs/tools/generate_password.sh;
	./srcs/tools/add_hosts.sh;
	

start: 
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) up --build

force: 
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) up -d --force-recreate

stop: 
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) down

re: 
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) down
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) up -d

status : 
	@docker ps

iclean: 
	@$(DOCKER) rmi -f $$(docker images --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "$(GREEN)All images related to the project have been removed.\033[0m"

cclean: 
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) down -v
	@echo -e "$(GREEN)All containers and associated volumes have been removed.\033[0m"

vclean: 
	@$(DOCKER) volume rm $$(docker volume ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "\$(GREEN)All volumes related to the project have been removed.\033[0m"

nclean: 
	@$(DOCKER) network rm $$(docker network ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "$(GREEN)All networks related to the project have been removed.\033[0m"

fclean: iclean vclean nclean
	@$(DOCKER_COMPOSE) -f $(YML) --project-name $(COMPOSE_PROJECT_NAME) down -v
	@echo -e "$(GREEN)All resources related to the project have been cleaned.\033[0m"

.PHONY: all start force stop re status iclean cclean vclean nclean fclean
