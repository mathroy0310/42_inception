# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/30 16:48:55 by maroy             #+#    #+#              #
#    Updated: 2024/08/01 14:11:22 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE = docker-compose
YML = srcs/docker-compose.yml
VOLUMES_PATH=/home/maroy/data

all: start

start:
	@$(DOCKER_COMPOSE) -f $(YML) up --build

force:
	@$(DOCKER_COMPOSE) -f $(YML) up -d --force-recreate

stop:
	@$(DOCKER_COMPOSE) -f $(YML) down

re:
	@$(DOCKER_COMPOSE) -f $(YML) down
	@$(DOCKER_COMPOSE) -f $(YML) up -d

status : 
	@docker ps

iclean:
	@$(DOCKER) rmi -f $$(docker images --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "\033[0;32mAll images related to the project have been removed.\033[0m"

cclean:
	@$(DOCKER_COMPOSE) -f $(YML) down -v
	@echo -e "\033[0;32mAll containers and associated volumes have been removed.\033[0m"

vclean:
	@$(DOCKER) volume rm $$(docker volume ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "\033[0;32mAll volumes related to the project have been removed.\033[0m"

nclean:
	@$(DOCKER) network rm $$(docker network ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo -e "\033[0;32mAll networks related to the project have been removed.\033[0m"

fclean: iclean vclean nclean
	@$(DOCKER_COMPOSE) -f $(YML) down -v
	@echo -e "\033[0;32mAll resources related to the project have been cleaned.\033[0m"


.PHONY: all start force stop re status iclean cclean vclean nclean fclean
