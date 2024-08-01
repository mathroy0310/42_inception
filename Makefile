# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/30 16:48:55 by maroy             #+#    #+#              #
#    Updated: 2024/07/31 22:55:26 by maroy            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


DOCKER = docker
DOCKER_COMPOSE = docker-compose
YML = srcs/docker-compose.yml

start:
	@$(DOCKER_COMPOSE) -f $(YML) up --build

force:
	@$(DOCKER_COMPOSE) -f $(YML) up -d --force-recreate

stop:
	@$(DOCKER_COMPOSE) -f $(YML) down

re:
	@$(DOCKER_COMPOSE) -f $(YML) down
	@$(DOCKER_COMPOSE) -f $(YML) up -d

clean_images:
	@$(DOCKER) rmi -f $$(docker images --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo "\033[0;32mAll images related to the project have been removed.\033[0m"

clean_containers:
	@$(DOCKER_COMPOSE) -f $(YML) down -v
	@echo "\033[0;32mAll containers and associated volumes have been removed.\033[0m"

clean_volumes:
	@$(DOCKER) volume rm $$(docker volume ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo "\033[0;32mAll volumes related to the project have been removed.\033[0m"

clean_networks:
	@$(DOCKER) network rm $$(docker network ls --filter "label=com.docker.compose.project=$(COMPOSE_PROJECT_NAME)" -q) 2>/dev/null 1>/dev/null || true
	@echo "\033[0;32mAll networks related to the project have been removed.\033[0m"

clean:
	@$(DOCKER_COMPOSE) -f $(YML) down -v
	@$(MAKE) clean_images
	@$(MAKE) clean_volumes
	@$(MAKE) clean_networks
	@echo "\033[0;32mAll resources related to the project have been cleaned.\033[0m"
